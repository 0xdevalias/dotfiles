## Markdown Code Block Fence Handling

When providing copy-pasteable Markdown that may contain embedded fenced code blocks, use an outer fence longer than any inner fence. For Markdown snippets that contain normal three-backtick code fences, wrap the outer block in four backticks and use `md` as the language when appropriate.

Use this in chat output and skill templates so copied Markdown preserves the embedded code fences.

## Delegated Thread Renames

When an inline side conversation or temporary delegation is clearly operating on behalf of a parent/source Codex thread, interpret ambiguous requests to rename "this thread", "this chat", "this conversation", or similar as referring to the parent/source thread by default. Do not treat every normal Codex thread with delegation or source-thread history as a side thread; if the user says "current thread" or clarifies they mean the thread they are chatting in, rename the current thread.

For thread management actions, preserve clarity around parent vs side thread names and use explicit thread ids when available.

## Git Commit Markdown

When providing copy-pasteable git commit subjects/titles or commit descriptions/bodies, do not hard-wrap the commit text, including inside Markdown fenced blocks.

When providing both a commit title and description/body, put them in separate code blocks.
