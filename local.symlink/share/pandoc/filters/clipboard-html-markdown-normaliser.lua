-- Filter to customize markdown output
--
-- Configurable via metadata options:
--   emphasis-marker: character to use for emphasis ('_' or '*')
--
-- Configuration can be provided via:
--   YAML metadata in the document
--   Command line: --metadata emphasis-marker='_'
--   Metadata file: --metadata-file config.yaml
--
-- Example:
--   osascript -e 'the clipboard as «class HTML»' \
--   | sed -e 's/^«data HTML//' -e 's/»$//' \
--   | xxd -r -p \
--   | sed 's/\xc2\xa0/ /g' \
--   | pandoc -f html -t gfm --wrap=none --lua-filter=clipboard-html-markdown-normaliser.lua --metadata debug=true --metadata emphasis-marker='_' 2>&1 \
--   | subl
--
-- Ref:
--   https://gist.github.com/0xdevalias/794d1aa03c357425c4c9583d9edc0303#poc-pandoc---lua-filter-for-customizing-markdown-output
--   https://pandoc.org/lua-filters.html

-- Default values if not specified in metadata
local debug_mode = false
local emphasis_marker = '_'

-- GitHub Docs renders Markdown alerts as color-specific ghd-alert divs.
-- Map those presentation classes back to their semantic GFM alert types.
local github_alert_types = {
  danger = 'CAUTION',
  attention = 'WARNING',
  done = 'IMPORTANT',
  accent = 'NOTE',
  success = 'TIP',
}

-- Helper function for debug logging
local function debug(msg, ...)
    if debug_mode then
        io.stderr:write(string.format("[DEBUG] " .. msg .. "\n", ...))
    end
end

-- Helper function to safely extract values from Pandoc's metadata
-- Handles boolean values directly and converts other types appropriately
--
-- @param meta: The metadata table from Pandoc
-- @param key: The key to look up in the metadata
-- @param default: Value to return if key is not found
-- @return: Value from metadata (preserving boolean type) or default
function get_metadata_value(meta, key, default)
    local value = meta[key]
    if value == nil then
        return default
    end

    if type(value) == "boolean" then
        return value
    end

    if type(value) == "table" and value.text ~= nil then
        return value.text
    end

    return tostring(value)
end

-- Processes document metadata to configure the filter
--
-- @see https://pandoc.org/lua-filters.html#type-meta
-- @see https://pandoc.org/lua-filters.html#pandoc.Meta
function Meta(meta)
    -- Read configuration from metadata, falling back to defaults if not specified
    debug_mode = get_metadata_value(meta, 'debug', debug_mode) == true
    emphasis_marker = get_metadata_value(meta, 'emphasis-marker', emphasis_marker)

    debug("Initialized with FORMAT: %s", FORMAT)
    debug("emphasis-marker: %s", emphasis_marker)
    debug("debug-mode: %s", debug_mode)

    return meta
end

-- Return the GFM alert type represented by a GitHub Docs alert div.
local function github_alert_type(div)
  if not div.classes:includes('ghd-alert') then
    return nil
  end

  for color, alert_type in pairs(github_alert_types) do
    if div.classes:includes('ghd-alert-' .. color) then
      return alert_type
    end
  end

  return nil
end

-- GitHub Docs includes a decorative Octicon before each localized alert title.
local function is_octicon_image(inline)
  return inline and inline.t == 'Image' and inline.classes:includes('octicon')
end

-- Remove the rendered icon and title while preserving the alert body.
--
-- Structured page HTML gives Pandoc a standalone title paragraph. Clipboard
-- HTML may instead combine the title and body in one Plain block separated by
-- a soft break, so both shapes need to be handled.
local function strip_github_alert_title(blocks)
  local first_block = blocks:at(1)
  if not first_block or (first_block.t ~= 'Para' and first_block.t ~= 'Plain') then
    return blocks
  end

  local inlines = first_block.content
  if not is_octicon_image(inlines:at(1)) then
    return blocks
  end

  local title_break
  for index, inline in ipairs(inlines) do
    if inline.t == 'SoftBreak' or inline.t == 'LineBreak' then
      title_break = index
      break
    end
  end

  if not title_break then
    blocks:remove(1)
    return blocks
  end

  for _ = 1, title_break do
    inlines:remove(1)
  end
  while inlines:at(1) and inlines:at(1).t == 'Space' do
    inlines:remove(1)
  end

  if #inlines == 0 then
    blocks:remove(1)
  end

  return blocks
end

-- Read the displayed language from GitHub Docs' generated code header.
-- Pandoc drops the nested code element's language-* class when the clipboard
-- adds attributes to the enclosing pre element.
-- Ref: https://github.com/jgm/pandoc/issues/11701
local function github_code_language_label(header)
  if not header or header.t ~= 'Div' then
    return nil
  end

  for _, block in ipairs(header.content) do
    if block.t == 'Para' or block.t == 'Plain' then
      for _, inline in ipairs(block.content) do
        if inline.t == 'Span' and inline.classes:includes('flex-1') then
          return pandoc.utils.stringify(inline)
        end
      end
    end
  end

  return nil
end

-- Convert GitHub Docs' rendered code-example wrapper back into a fenced block.
-- The header may contain a hidden copy buffer, so use the last direct code
-- block and prefer its original language-* class when Pandoc preserves it.
local function github_code_example(div)
  if not div.classes:includes('code-example') then
    return nil
  end

  local code_block
  for index = #div.content, 1, -1 do
    local block = div.content:at(index)
    if block.t == 'CodeBlock' then
      code_block = block
      break
    end
  end
  if not code_block then
    return nil
  end

  local language
  for _, class in ipairs(code_block.classes) do
    language = class:match('^language%-(.+)$')
    if language then
      break
    end
  end

  if not language then
    local label = github_code_language_label(div.content:at(1))
    if label then
      language = label:lower():match('^%s*(.-)%s*$'):gsub('%s+', '-')
    end
  end

  if language then
    -- Pandoc's GFM writer emits a space before the language, so render the
    -- conventional compact fence directly while avoiding fence collisions.
    -- Ref: https://github.com/jgm/pandoc/issues/11702
    local fence_length = 3
    for backticks in code_block.text:gmatch('`+') do
      fence_length = math.max(fence_length, #backticks + 1)
    end

    local fence = string.rep('`', fence_length)
    local markdown = string.format('%s%s\n%s\n%s', fence, language, code_block.text, fence)
    return pandoc.RawBlock('markdown', markdown)
  end

  return code_block
end

-- @see https://pandoc.org/lua-filters.html#type-div
-- @see https://pandoc.org/lua-filters.html#pandoc.Div
function Div(div)
  debug("Div: content: %s, classes: %s, identifier: %s", div.content, div.classes, div.identifier)
  local firstContent = div.content:at(1)
  debug("pandoc.utils.type(div.content) %s, [1] %s %s", pandoc.utils.type(div.content), firstContent and firstContent.t or "nil", firstContent or "nil")

  local alert_type = github_alert_type(div)
  if alert_type then
    local content = strip_github_alert_title(div.content)
    -- Raw Markdown keeps Pandoc's GFM writer from escaping the alert marker.
    content:insert(1, pandoc.Para({pandoc.RawInline('markdown', '[!' .. alert_type .. ']')}))
    return pandoc.BlockQuote(content)
  end

  local code_example = github_code_example(div)
  if code_example then
    return code_example
  end

  -- If the div has a class markdown-heading, then we want to extract only the heading from it, and drop the wrapper div/inner link/etc
  if (div.classes:includes("markdown-heading")) then
    if (firstContent and firstContent.t == "Header") then
      return div.content:filter(function (elem)
        debug("[div.content:filter] elem: %s (%s), elem.content: %s, elem.content: %s", pandoc.utils.type(elem), elem.t, pandoc.utils.type(elem.content), elem.content)

        -- This should match against the link image shown on hover when copying GitHub Gist heading links/etc
        if (elem.t == "Plain" and
            elem.content:at(1).t == "Link" and
            elem.content:at(1).content:at(1).t == "Image" and
            elem.content:at(1).content:at(1).classes:includes('octicon-link')) then
          debug(" REMOVING: %s", elem)
          return false
        end

        return true
      end)
    end
  end

  return div
end

-- @see https://pandoc.org/lua-filters.html#type-span
-- @see https://pandoc.org/lua-filters.html#pandoc.Span
function Span(span)
  return span.content
end

-- @see https://pandoc.org/lua-filters.html#type-link
-- @see https://pandoc.org/lua-filters.html#pandoc.Link
function Link(link)
  debug("Link: target: %s, title: %s, content: %s", link.target, link.title, link.content)
  debug("pandoc.utils.type(link.content) %s, [1] %s", pandoc.utils.type(link.content), link.content:at(1))

  local filteredContent = link.content:filter(function (elem)
    -- This should match against the link image shown on hover when copying GitHub Gist heading links/etc
    if (elem.t == "Image" and elem.classes:includes('octicon-link')) then
      debug(" REMOVING IMAGE: %s, classes: %s", elem, elem.classes)
      return false
    end

    return true
  end)

  local filteredContentString = pandoc.utils.stringify(filteredContent)

  debug("#filteredContent: %d %s", #filteredContent, filteredContent)
  debug("filteredContentString: %s", #filteredContent, filteredContent)

  if #filteredContent == 0 or filteredContentString == link.target then
    -- If there is no content, or the content is just the link, then render the link by itself (this avoids it being wrapped in <>)
    return pandoc.RawInline("markdown", link.target)
  else
    return pandoc.Link(filteredContent, link.target, link.title)
  end
end

-- Processes emphasis elements (italic text) to customize the emphasis_marker character
--
-- @see https://pandoc.org/lua-filters.html#type-emph
-- @see https://pandoc.org/lua-filters.html#pandoc.Emph
function Emph(el)
  -- Convert the inline content to a plain string
  local text = pandoc.utils.stringify(el)

  -- Build the new string, wrapping content with the custom marker
  local wrapped = emphasis_marker .. text .. emphasis_marker

  -- Return as raw Markdown (or another format if you prefer)
  return pandoc.RawInline("markdown", wrapped)
end

-- Note: this seems to be required to ensure Meta is processed first (for setting our options from CLI args/etc)
return {
    {Meta = Meta},
    {Div = Div},
    {Span = Span},
    {Link = Link},
    {Emph = Emph},
}
