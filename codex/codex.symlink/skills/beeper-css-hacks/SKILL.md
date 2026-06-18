---
name: beeper-css-hacks
description: Maintain 0xdevalias' Beeper Custom Theme Styles gist across the local Beeper custom.css file, the gist CSS files, and the beeper/themes GitHub issue used as the per-hack changelog. Use when Codex needs to inspect, propose, add, verify, or style updates for Beeper Desktop custom CSS snippets, gist index entries, gist CSS files, or linked beeper/themes issue comments.
---

# Beeper CSS Hacks

## Overview

Use this skill to keep Beeper Desktop custom CSS changes consistent across three surfaces:

- Local working CSS: `$HOME/Library/Application Support/BeeperTexts/custom.css`
- Gist: `0xdevalias/3d2f5a861335cc1277b21a29d1285cfe` (`0xdevalias' Beeper Custom Theme Styles gist`)
- Issue thread: `beeper/themes#6`

Prefer read-only inspection and proposals unless the user explicitly asks to edit or publish.

## Source Order

1. Read the local `custom.css` when the user refers to their current Beeper CSS.
2. Use `gh gist view`, not web search, for `0xdevalias' Beeper Custom Theme Styles gist` content:
   ```sh
   gh gist view 3d2f5a861335cc1277b21a29d1285cfe --filename beeper-custom-theme-styles.md
   gh gist view 3d2f5a861335cc1277b21a29d1285cfe --filename devalias-beeper-css-hacks-v4.css
   gh gist view 3d2f5a861335cc1277b21a29d1285cfe --filename devalias-beeper-css-hacks.css
   ```
3. Use `gh issue view 6 -R beeper/themes --comments` or `--json comments --jq ...` for issue comments.
4. Use exact raw Markdown/CSS from `gh` as authoritative over rendered GitHub pages.

## Markdown Fence Handling

When providing copy-pasteable Markdown that may contain embedded fenced code blocks, use an outer fence longer than any inner fence. For issue comment drafts or gist Markdown snippets that contain normal three-backtick code fences, wrap the outer block in four backticks and use `md` as the language when appropriate.

Use this in chat output and skill templates so copied Markdown preserves the embedded code fences.

## Workflow

### Inspect A New CSS Hack

Compare the local block against the gist CSS file that matches the Beeper version:

- Modern Beeper Desktop v4: `devalias-beeper-css-hacks-v4.css`
- Legacy Beeper Desktop v3: `devalias-beeper-css-hacks.css`

Check whether the local block is already present, whether selectors differ, and whether comments mention the Beeper version or app surface clearly enough.

### Prepare The Issue Comment

Use `beeper/themes#6` as the per-hack changelog. New CSS hacks should normally become new issue comments, not silent edits to old comments, unless the user is only updating an existing hack.

Mirror the user's existing issue-comment structure when useful:

````md
# Title matching the gist index link text

## Background Context

Brief reason for the hack and what surface it affects.

## Beeper Support Report

Raised this issue as `DESK-xxxxx`

## CSS Hacks

```css
/* snippet */
```

## Caveats

Selector fragility, app-version assumptions, or state-specific limitations.
````

If there is no support ticket, use `N/A`. Do not invent `DES-` or `DESK-` IDs.

### Update The Gist CSS

Add the CSS block to the appropriate gist CSS file in the same section style as nearby blocks:

```css
/*********************************/
/* Human Readable Section Title */
/*********************************/

/* Surface - as of vX.Y.Z */
.selector {
  property: value;
}
```

Keep local exploratory comments only when they are intentionally useful in the reusable CSS file. Issue comments can be cleaner than the local CSS.

### Update The Gist Index

Update `beeper-custom-theme-styles.md` under:

```md
You'll also find a number of hacks/techniques on my theme issue:
```

Use the existing style exactly:

- Use `-` as the Markdown list marker. Never use `*`.
- Preserve rough chronological ordering. New issue comments usually go near the bottom before `- etc`.
- Use link text that matches the issue/comment title.
- Put metadata in separate `<sup>` tags after the link:
  ```md
  - [Comment title](https://github.com/beeper/themes/issues/6#issuecomment-...) <sup>`DESK-xxxxx`</sup>
  ```
- Use `<sup>` metadata for support IDs and request/contribution labels such as `DES-xxxxx`, `DESK-xxxxx`, `Community Request`, or `Community Contribution`.
- Do not put Beeper version strings in `<sup>` unless existing nearby entries establish that exact pattern. Prefer the title or body for version details.

## Verification Checklist

Before saying the workflow is done, check:

- The local CSS, gist CSS, issue comment, and gist index are all in sync for the intended public/private surfaces.
- The issue comment URL in the gist index is the final permalink.
- The gist index entry uses `-`, chronological placement, matching link text, and correct `<sup>` metadata.
- The support ID in the gist index matches the issue comment body exactly.
- Any deliberate differences between local CSS, gist CSS, and the issue comment are called out explicitly.

## Editing Notes

When asked to make live changes, prefer narrow edits:

- Use `gh gist clone` or `gh gist edit` for gists when available.
- Preserve unrelated gist content.
- Do not reorder existing index entries unless the user asks.
- Do not edit older issue comments just to improve discoverability unless the user asks for cross-links.
