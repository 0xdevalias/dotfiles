## Markdown Code Block Fence Handling

When providing copy-pasteable Markdown that may contain embedded fenced code blocks, use an outer fence longer than any inner fence. For Markdown snippets that contain normal three-backtick code fences, wrap the outer block in four backticks and use `md` as the language when appropriate.

Use this in chat output and skill templates so copied Markdown preserves the embedded code fences.

## Side Chat Thread Renames

When a side conversation was created from, delegated by, or is clearly about a parent/source Codex thread, interpret ambiguous requests to rename "this thread", "this chat", "this conversation", or similar as referring to the parent/source thread by default. Rename the current side thread only when the user explicitly says side thread, current side chat, or otherwise identifies the side conversation.

For thread management actions, preserve clarity around parent vs side thread names and use explicit thread ids when available.

## Git Commit Markdown

When providing copy-pasteable git commit subjects/titles or commit descriptions/bodies, do not hard-wrap the commit text, including inside Markdown fenced blocks.

When providing both a commit title and description/body, put them in separate code blocks.
