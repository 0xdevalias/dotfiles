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

# Internal setup: define aliases for selected binutils tools
_binutils-setup-aliases() {
  local binutils_prefix tool
  binutils_prefix="$(brew --prefix binutils 2>/dev/null)/bin"

  if [[ -d "$binutils_prefix" ]]; then
    for tool in "$@"; do
      if [[ -x "$binutils_prefix/$tool" ]]; then
        alias $tool="$binutils_prefix/$tool"
      else
        alias $tool="echo \"⚠️ $tool not found in binutils install.\" >&2"
      fi
    done
  else
    for tool in "$@"; do
      alias $tool="echo \"❌ binutils not installed. Install with: brew install binutils\" >&2"
    done
  fi
}

# Configure default binutils aliases (extend this list as needed)
_binutils-setup-aliases gstrings

# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
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
