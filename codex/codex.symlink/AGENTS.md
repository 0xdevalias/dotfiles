## Markdown Code Block Fence Handling

When providing copy-pasteable Markdown that may contain embedded fenced code blocks, use an outer fence longer than any inner fence. For Markdown snippets that contain normal three-backtick code fences, wrap the outer block in four backticks and use `md` as the language when appropriate.

Use this in chat output and skill templates so copied Markdown preserves the embedded code fences.

## Zsh Script Style

When editing `.zsh` files or zsh functions, follow these style and safety preferences.

For zsh local assignment, keep `local`/`typeset` declarations on the same line as their assignment when assigning a value:

```zsh
local var="$(some_command)"
```

Do not split local assignment into a separate declaration and later assignment unless there is a real reason:

```zsh
local var
var="$(some_command)"
```

This zsh local preference is intentional: `local`/`typeset` behavior, including cases involving `TYPESET_SILENT`, can interact badly with existing values/output unless handled carefully. Prefer the same-line assignment form so agents do not split zsh locals from assignments by default.

## Delegated Thread Renames

A `<codex_delegation>` block or `source_thread_id` in delegated task metadata is provenance, not the automatic target for ambiguous rename requests. If there is no explicit side-conversation boundary and the user is chatting in a visible delegated working thread, interpret "this thread", "this chat", "this conversation", or similar as the current visible working thread unless they explicitly ask to rename the upstream/source/delegating thread.

A harness-injected side-conversation boundary is an explicit indicator that the assistant is in a side conversation. In that case, ambiguous requests to rename "this thread", "this chat", "this conversation", or similar should default to the parent/main visible thread, unless the user says "current side thread" or otherwise clarifies they mean the side conversation.

If the intended target thread id is unavailable, inaccessible, or cannot be found confidently, do not rename a different thread as a fallback. Report the blocker and ask whether the user wants to retarget the rename.

For thread management actions, preserve clarity around parent vs side thread names and use explicit thread ids when available.

## Git Commit Markdown

When providing copy-pasteable git commit subjects/titles or commit descriptions/bodies, do not hard-wrap the commit text, including inside Markdown fenced blocks.

When providing both a commit title and description/body, put them in separate code blocks.

## Thread Title Conventions

When creating a new Codex thread, handling a thread rename request, or explicitly suggesting a thread title, check whether the thread matches an existing title pattern. If the thread appears related to a reusable pattern but its title does not match, suggest a better title and ask the user whether they want it renamed before changing it. Prefer concise, reusable prefixes that make related work easy to scan in the thread list.

Title shapes:
- `<Area>: <Action> <Specific Subject>` for the default pattern.
- `<Area>: <Category> - <Action> <Specific Subject>` when a category prefix is useful. The category should not replace the action verb.

Reusable title patterns:
- `Codex AGENTS.md: Add <Guidance Name> Guidance` for persistent global guidance additions.
- `Codex Skills: Evaluate <Domain> Skill Options` for comparing, searching, reviewing, grouping, and recommending agent skills for a domain.
- `<Product>: Bug - Investigate <Issue Area> Issues` for bug-investigation threads where the category improves scanning while preserving the action verb.
