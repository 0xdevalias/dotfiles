# zoxide is a smarter cd command, inspired by z and autojump.
# https://github.com/ajeetdsouza/zoxide
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi
