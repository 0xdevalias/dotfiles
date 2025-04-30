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
