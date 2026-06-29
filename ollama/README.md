# Ollama

Local Ollama shell helpers and tracking notes.

## Helpers

`ollama-nohistory` runs the Ollama CLI with `OLLAMA_NOHISTORY=1`:

```sh
ollama-nohistory run llama3.2
```

This matches the installed `ollama run --help` description for `OLLAMA_NOHISTORY`: it disables Ollama readline history.

For ephemeral prompts, prefer starting an interactive session and typing prompts inside it. Passing prompts as command arguments can still leave those prompts in shell history.

## Local State

Observed local Ollama paths on this machine:

| Path | Contents | Tracking decision |
| --- | --- | --- |
| `~/.ollama/id_ed25519` | Ollama private identity key | Do not track. Secret material. |
| `~/.ollama/id_ed25519.pub` | Ollama public identity key | Not tracked. Low value on its own. |
| `~/.ollama/history` | Ollama readline prompt history | Do not track. This is the state `OLLAMA_NOHISTORY` is meant to avoid preserving. |
| `~/.ollama/logs/` | Runtime app/server logs | Do not track. Generated runtime data. |
| `~/.ollama/cache/` | Generated cache data, including model recommendations | Do not track. Generated runtime data. |
| `~/.ollama/models/` | Model blobs and manifests | Do not track. Large runtime data; manage with `ollama pull`, `ollama list`, and `ollama rm`. |
| `~/Library/Application Support/Ollama/db.sqlite` | Ollama app database containing chats, messages, tool calls, attachments, settings, and user cache tables | Do not track. Contains chat/app state and may contain private content. |
| `~/Library/Application Support/Ollama/ollama.pid` | Running app process id | Do not track. Ephemeral process state. |
| `~/Library/Preferences/com.electron.ollama.plist` | Small macOS/Electron GUI preferences | Not tracked. Low value and machine-specific. |
| `~/Library/Caches/ollama/` | App update/cache data | Do not track. Generated cache data. |
| `~/Library/Caches/com.electron.ollama/` | WebKit/Electron cache data | Do not track. Generated cache data. |

We intentionally did not add an `ollama.symlink` directory. The current local Ollama files are secrets, history, app databases, logs, caches, or model data rather than stable hand-authored configuration.
