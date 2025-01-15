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

-- @see https://pandoc.org/lua-filters.html#type-div
-- @see https://pandoc.org/lua-filters.html#pandoc.Div
function Div(div)
  debug("Div: content: %s, classes: %s, identifier: %s", div.content, div.classes, div.identifier)
  debug("pandoc.utils.type(div.content) %s, [1] %s %s", pandoc.utils.type(div.content), div.content:at(1).t, div.content:at(1))

  -- If the div has a class markdown-heading, then we want to extract only the heading from it, and drop the wrapper div/inner link/etc
  if (div.classes:includes("markdown-heading")) then
    local firstContent = div.content:at(1)
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
