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
