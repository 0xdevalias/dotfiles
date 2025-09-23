# List all binaries provided by the Homebrew binutils keg
binutils-list() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: binutils-list"
    echo "List all binaries provided by the Homebrew binutils keg."
    return 0
  fi

  local binutils_prefix="$(brew --prefix binutils 2>/dev/null)/bin"
  if [[ -d "$binutils_prefix" ]]; then
    ls -1 "$binutils_prefix"
  else
    echo "❌ binutils not installed. Install with: brew install binutils"
    return 1
  fi
}

# Check if one or more tools exist in the Homebrew binutils keg
binutils-has() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: binutils-has <tool> [tool...]"
    echo "Check if one or more tools exist in the Homebrew binutils keg."
    return 0
  fi

  local binutils_prefix="$(brew --prefix binutils 2>/dev/null)/bin"
  local tool
  if [[ ! -d "$binutils_prefix" ]]; then
    echo "❌ binutils not installed. Install with: brew install binutils"
    return 2
  fi
  for tool in "$@"; do
    if [[ -x "$binutils_prefix/$tool" ]]; then
      echo "✅ $tool is available at: $binutils_prefix/$tool"
    else
      echo "⚠️ $tool not found in binutils install."
    fi
  done
}

# Execute a tool from the Homebrew binutils keg
# Handles cases where the tool is missing or binutils is not installed
binutils-exec() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: binutils-exec <tool> [args...]"
    echo "Execute a tool from the Homebrew binutils keg."
    echo "Examples:"
    echo "  binutils-exec gstrings file"
    return 0
  fi

  local tool=$1; shift
  local binutils_prefix="$(brew --prefix binutils 2>/dev/null)/bin"
  if [[ -x "$binutils_prefix/$tool" ]]; then
    "$binutils_prefix/$tool" "$@"
  elif [[ -d "$binutils_prefix" ]]; then
    echo "⚠️ $tool not found in binutils install." >&2
    return 1
  else
    echo "❌ binutils not installed. Install with: brew install binutils" >&2
    return 2
  fi
}

# Define aliases for selected binutils tools.
# Delegates each alias to binutils-exec, but only if binutils is installed.
# Otherwise, commands remain unaliased so the command-not-found handler runs.
_binutils-setup-aliases() {
  local binutils_prefix="$(brew --prefix binutils 2>/dev/null)/bin"

  if [[ -d "$binutils_prefix" ]]; then
    local tool
    for tool in "$@"; do
      alias $tool="binutils-exec $tool"
    done
  fi
}

# Configure default binutils aliases (extend this list as needed)
_binutils-setup-aliases gstrings

# Install a custom command-not-found handler that adds binutils-specific hints.
#
# Behavior:
# - Preserves any existing handler (e.g. Homebrew’s command-not-found).
# - Runs the previous handler first, so its messages aren’t lost.
# - Then checks whether the missing command is part of the `binutils` formula:
#   - If installed but not linked, suggests running via `binutils-exec`.
#   - If not installed, suggests installing with `brew install binutils`.
#
# This ensures users get actionable guidance for `binutils` tools without
# interfering with the normal fallback hints for other commands.
_binutils-register-command-not-found-handler() {
  # Save any existing handler (so we can chain)
  if (( $+functions[command_not_found_handler] )); then
    functions[_prev_command_not_found_handler]=$functions[command_not_found_handler]
  fi

  _binutils_command_not_found_handler() {
    local cmd=$1
    local binutils_prefix="$(brew --prefix binutils 2>/dev/null)/bin"

    # Style vars (dim / reset)
    local dim=$'\e[2m'    # dim=$(tput dim 2>/dev/null)
    local reset=$'\e[0m'  # reset=$(tput sgr0 2>/dev/null)

    # Run the previous handler first if one exists (e.g., Homebrew’s command-not-found)
    local prev_output=""
    if (( $+functions[_prev_command_not_found_handler] )); then
      # _prev_command_not_found_handler "$cmd"
      prev_output=$(HOMEBREW_COMMAND_NOT_FOUND_CI=1 _prev_command_not_found_handler "$cmd" 2>&1)
      [[ -n "$prev_output" ]] && print -r -- "$prev_output" >&2
    else
      echo "zsh: command not found: $cmd"
    fi

    # Then, if binutils is installed and provides the tool, print a dimmed usage hint
    if [[ -d "$binutils_prefix" ]]; then
      if [[ -x "$binutils_prefix/$cmd" ]]; then
        echo
        echo "${dim}ℹ️ '$cmd' is provided by the 'binutils' formula (installed via Homebrew), but is not linked by default."
        echo "   Run with: binutils-exec $*${reset}"
      fi
    elif [[ "$prev_output" != *"brew install binutils"* ]]; then
      local -a binutils_known_tools=(addr2line ar c++filt coffdump dlltool dllwrap elfedit nm objcopy objdump ranlib readelf size srconv strings strip sysdump windmc windres gaddr2line gar gc++filt gcoffdump gdlltool gdllwrap gelfedit gnm gobjcopy gobjdump granlib greadelf gsize gsrconv gstrings gstrip gsysdump gwindmc gwindres)
      if (( ${binutils_known_tools[(Ie)$cmd]} )); then
        echo
        echo "${dim}ℹ️ '$cmd' is available in the 'binutils' formula."
        echo "   Install with: brew install binutils${reset}"
      fi
    fi

    return 127
  }

  # Point the shell’s hook at our real function
  command_not_found_handler() {
    _binutils_command_not_found_handler "$@"
  }
}

# Enable the custom binutils command-not-found handler.
_binutils-register-command-not-found-handler

# grc overrides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
#
# Notes:
# - We prefer GNU `ls` (gls) because it has richer flags than BSD/macOS `ls`.
# - `--color=auto` means:
#     - Show colours when writing to a terminal.
#     - Suppress colours when piped/redirected (avoids polluting output).
# - `-F` appends a symbol to entries: `/` for dirs, `*` for executables, etc.
# - `-l` long format (permissions, owner, size, date).
# - `-A` show all except `.` and `..` (like `-a` but cleaner).
# - `-h` human-readable sizes (e.g. 1K, 234M).
#
# Aliases:
#   ls   → normal with classify (-F) and colour
#   l    → long, almost-all, human-readable
#   ll   → long format only
#   la   → almost-all
if (( $+commands[gls] )); then
  alias ls="gls --color=auto"
  # alias ls="gls -F --color=auto"
  alias l="gls -lAh --color=auto"
  alias ll="gls -l --color=auto"
  alias la="gls -A --color=auto"
fi

# zoxide is a smarter cd command, inspired by z and autojump.
# https://github.com/ajeetdsouza/zoxide
if (( $+commands[zoxide] )); then
  alias zoxide-list="zoxide query --list --score"
  alias zoxide-list-interactive="zoxide query --interactive"
  alias z-list="zoxide-list"
  alias zi-list="zoxide-list-interactive"

  alias z-help="zoxide -h"
  alias zi-help="zoxide -h"
fi

# Diff that understands syntax
# https://github.com/Wilfred/difftastic
if (( $+commands[difft] )); then
  alias difftastic="difft"
fi

# A simple, fast and user-friendly alternative to 'find'
# https://github.com/sharkdp/fd
if (( $+commands[fd] )); then
  alias find-fd="fd --hidden --no-ignore --exclude .git"
fi

# ripgrep recursively searches directories for a regex pattern while respecting your gitignore
# https://github.com/BurntSushi/ripgrep
if (( $+commands[rg] )); then
  alias ripgrep="rg"
  alias find-ripgrep="rg"
fi

# rga: ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc
# https://github.com/phiresky/ripgrep-all
if (( $+commands[rga] )); then
  alias ripgrep-all="rga"
  alias find-ripgrep-all="rga"
fi

# Lightweight and flexible command-line JSON processor
# https://stedolan.github.io/jq/
if (( $+commands[jq] )); then
  alias json-jq="jq"
fi

# Json Incremental Digger. You can drill down JSON interactively by using filtering queries like jq
# https://github.com/simeji/jid
if (( $+commands[jid] )); then
  alias json-jid="jid"
  alias jq-jid="jid"
fi

# Terminal JSON viewer
# https://fx.wtf
if (( $+commands[fx] )); then
  alias json-fx="fx"
  alias jq-fx="fx"
fi

# Make JSON greppable
# https://github.com/tomnomnom/gron
if (( $+commands[gron] )); then
  alias json-gron="gron"
  alias jq-gron="gron"
  alias grep-gron="gron"
fi

# JSON, YAML, TOML, XML, and CSV query and modification tool
# https://github.com/TomWright/dasel
if (( $+commands[dasel] )); then
  alias json-dasel="dasel"
  alias jq-dasel="dasel"

  alias yaml-dasel="dasel"
  alias toml-dasel="dasel"
  alias xml-dasel="dasel"
  alias csv-dasel="dasel"
fi

# Blazing-fast Data-Wrangling toolkit
# https://github.com/dathere/qsv
if (( $+commands[qsv] )); then
  alias csv-qsv="qsv"
fi

# Command-line XML and HTML beautifier and content extractor
# https://github.com/sibprogrammer/xq
if (( $+commands[xq] )); then
  alias xml-xq="xq"
  alias html-xq="xq"
fi

# Parsing HTML at the command line
# https://github.com/ericchiang/pup
if (( $+commands[pup] )); then
  alias html-pup="pup"
fi

# Go cascadia package command line CSS selector
# https://github.com/suntong/cascadia
if (( $+commands[cascadia] )); then
  alias xml-cascadia="cascadia"
  alias html-cascadia="cascadia"
fi

# A cat(1) clone with wings.
# https://github.com/sharkdp/bat
if (( $+commands[bat] )); then
  # A command-line fuzzy finder
  # https://github.com/junegunn/fzf
  if (( $+commands[fzf] )); then
    alias fzf-preview='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}" "$@"'
  fi
fi

# A command-line benchmarking tool
# https://github.com/sharkdp/hyperfine
# if (( $+commands[hyperfine] )); then
alias benchmark="hyperfine"
# fi
