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

Treat these as the canonical configured targets. If read-only inspection reveals that a target, filename, section marker, or recurring convention has drifted, call it out and suggest the smallest self-healing update to this skill before publishing. Ask which source should be canonical when the answer is ambiguous.

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

### Publish A New Hack

Use the detailed sections below in this order:

1. `Inspect A New CSS Hack`.
2. `Handle A Related Support Request` when one exists.
3. `Prepare The Issue Comment`, applying `Describe Version Provenance Accurately`.
4. After the user authorizes publication, post the prepared issue comment and capture its final permalink.
5. Following `Editing Notes`, complete `Update The Gist CSS` and then `Update The Gist Index`; commit the two gist files together when they form one cohesive update.
6. Complete the `Verification Checklist`.

Do not publish, edit an issue comment, update the gist, or send support email without authorization for that external mutation.

### Inspect A New CSS Hack

Compare the local block against the gist CSS file that matches the Beeper version:

- Modern Beeper Desktop v4: `devalias-beeper-css-hacks-v4.css`
- Legacy Beeper Desktop v3: `devalias-beeper-css-hacks.css`

Check whether the local block is already present, whether selectors differ, and whether comments mention the Beeper version or app surface clearly enough.

Confirm that the local behavior has been checked. Accept the user's manual confirmation; only perform visual verification when requested or otherwise necessary, using Beeper's custom-CSS reload path.

### Handle A Related Support Request

When a support ID or report text is available:

- Start with one narrow Gmail search for the exact support ID in the most likely account. Only broaden to a distinctive phrase or another account if the first search does not find it.
- Prefer the Beeper receipt as the source for the original user-authored report.
- Propose including the report description in the public issue comment as a blockquote by default, but inspect it for PII, private chat content, or other details unsuitable for a public issue and obtain the user's confirmation before publishing it.
- Quote only the user's report text, not Beeper's automated acknowledgement.
- Retain the Gmail message or thread link so the user can open the conversation directly.

After publication, draft a short support-thread follow-up in chat by default. Link the final issue comment and gist CSS section, and include an immutable gist revision when durable provenance matters; current-file line anchors can drift as the gist changes. Include the Gmail link and ask whether the user wants the agent to add or send the reply, or prefers to do so manually.

Never send the reply without explicit authorization. If the user says they sent it and asks for verification, read the existing Gmail thread without mutation and confirm that the latest message:

- Has the `SENT` label.
- Is addressed to the intended support thread.
- Contains the intended links.

### Prepare The Issue Comment

Use `beeper/themes#6` as the per-hack changelog. New CSS hacks should normally become new issue comments, not silent edits to old comments, unless the user is only updating an existing hack.

Treat the template below as the intended canonical default. Before drafting, inspect one or two representative raw comments written by the gist owner, preferring relevant and reasonably recent examples linked from the gist index. Historical or manually written comments may be incomplete or inconsistent, so do not treat history alone as canonical. If meaningful drift exists between the skill template and the user's own recurring structure, call it out, ask which form they prefer before publishing, and suggest updating the skill when appropriate.

````md
# Title matching the gist index link text

## Background Context

Brief reason for the hack and what surface it affects.

### Beeper Support Report

Raised this issue as `DESK-xxxxx`:

> Exact user-authored support report text, when approved for public inclusion.

## Caveats

Selector fragility, app-version assumptions, uninvestigated behavior, or state-specific limitations.

## CSS Hacks

```css
/* snippet */
```

## Screenshots

### Before

### After
````

If there is no support ticket, use `N/A`. Do not invent `DES-` or `DESK-` IDs.

Omit `Screenshots` until images exist; when present, keep it after `CSS Hacks`. `Before` and `After` are usually sufficient, but use more specific labels when multiple states or ambiguity require them. Prefer consistent framing and check screenshots for private messages, names, avatars, account details, or other sensitive content before public upload. Leave GitHub image upload as a manual user step unless they explicitly ask otherwise.

### Describe Version Provenance Accurately

Inspect the local CSS, gist CSS, and relevant issue comments for the existing wording convention before drafting new provenance. Distinguish carefully between:

- `First noticed on vX.Y.Z` when that is the earliest observed version, but introduction is unverified.
- `Tested on vX.Y.Z` when compatibility was verified on that version.
- `Introduced in vX.Y.Z` only when the introduction point is confirmed.

Do not normalize historical entries merely for consistency unless the user asks. Preserve existing local provenance comments unless the user wants them changed.

Avoid unsupported limitation claims. When behavior was not investigated, say that the CSS "does not attempt" to change it rather than claiming it "cannot" be changed.

### Editing Notes

When asked to make live changes, prefer narrow edits:

- Use `gh gist clone` or `gh gist edit` for gists when available.
- Preserve unrelated gist content.
- Do not reorder existing index entries unless the user asks.
- Do not edit older issue comments just to improve discoverability unless the user asks for cross-links.

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
- The live issue comment follows the intended section order: background context, support report, caveats, CSS, and screenshots when present.
- Any included support-report blockquote matches the approved user-authored text and excludes automated acknowledgement content.
- Screenshots are present only when available, appear after the CSS, and use labels that distinguish the states clearly enough.
- The published gist commit contains only intended files, is pushed, and its working tree is clean.
- Any deliberate differences between local CSS, gist CSS, and the issue comment are called out explicitly.
- The completion report links the issue comment, current gist, and immutable gist revision when one was created.
