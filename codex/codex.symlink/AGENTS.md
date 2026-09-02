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

## User Questions Must Not Auto-Resolve

When asking the user a question, especially via `request_user_input`, never set or use an automatic timeout or auto-resolution unless the user explicitly requests one. Otherwise, keep the question open indefinitely until the user answers or explicitly redirects or cancels it.

## Git Commit Markdown

When providing copy-pasteable git commit subjects/titles or commit descriptions/bodies, do not hard-wrap the commit text, including inside Markdown fenced blocks.

When providing both a commit title and description/body, put them in separate code blocks.

## Task and Chat References

Whenever presenting a reference to another Codex task or ChatGPT conversation, include its exact title, its raw technical ID in a plainly visible and copyable form, and a clickable link that opens the intended task or conversation. The layout may vary to suit the context: the ID may appear after an em dash, in parentheses, or alongside separate links, and does not need to be literally labelled `UUID`. If a platform label such as `ChatGPT:` is useful, keep it outside the title unless it is part of the verified title.

For a local Codex task, use `codex://threads/<thread-id>`.

For a private ChatGPT conversation, normally provide both a clickable `chatgpt-conversation://<conversation-id>` reference for opening it inside Codex and the full `https://chatgpt.com/c/<conversation-id>` URL as visible, clickable link text for opening or copying it outside Codex.

If a verified ChatGPT shared link is also available and relevant, include its full `https://chatgpt.com/share/<share-id>` URL as visible, clickable link text, optionally distinguished with a short parenthetical such as `(shared)`. A shared link is a separate access surface and may use an ID different from the private conversation ID. Never construct, infer, or create a shared link merely from the private conversation ID.

Only omit one of the ordinary private ChatGPT destinations when the user explicitly requests a single destination or there is another clear context-specific reason. Do not substitute one task type's link scheme for another. Verify the title, raw ID, and link destination before presenting the reference; if any element cannot be verified, state that rather than guessing.

## Thread Title Conventions

When creating a new Codex thread, handling a thread rename request, or explicitly suggesting a thread title, check whether the thread matches an existing title pattern. If the thread appears related to a reusable pattern but its title does not match, suggest a better title and ask the user whether they want it renamed before changing it. Prefer concise, reusable prefixes that make related work easy to scan in the thread list.

Title shapes:
- `<Area>: <Action> <Specific Subject>` for the default pattern.
- `<Area>: <Category> - <Action> <Specific Subject>` when a category prefix is useful. The category should not replace the action verb.

Reusable title patterns:
- `Codex AGENTS.md: Add <Guidance Name> Guidance` for persistent global guidance additions.
- `<Product>: Bug - Investigate <Issue Area> Issues` for bug-investigation threads where the category improves scanning while preserving the action verb.

Codex skills title patterns:
- `Codex Skills: Create <Skill Name> Skill` for new skills, including extraction from existing notes, prompts, or workflows.
- `Codex Skills: Refine <Skill Name> to <Outcome>` for behavioral, routing, workflow, or instruction improvements where the outcome adds scan value.
- `Codex Skills: Refactor <Skill Name> [Qualifier]` for larger structural reshaping, not ordinary edits.
- `Codex Skills: Split <New Skill Name> from <Original Skill Name>` for extracting one new skill while the original remains.
- `Codex Skills: Split <Original Skill Name> into <Skill A> / <Skill B>` for decomposing one skill into multiple resulting skills.
- `Codex Skills: Evaluate <Domain> Skill Options` for comparing, searching, reviewing, grouping, and recommending skill options in a domain.
- `Codex Skills: Assess <Source> Skills` for reviewing a repo, bundle, collection, or other source of existing skills.

For other Codex-skill work, use `Codex Skills: <Verb> <Specific Subject>`. For less common cases, avoid adding new standard verbs too early: treat `Validate`, `Extract`, `Package`, `Port`, and generic `Improve` as descriptions inside the patterns above unless a recurring pattern clearly emerges. Use `Workflow` only when the main topic is sequencing, modes, routing, states, or what the agent should do next.
