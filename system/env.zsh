export EDITOR='subl'

# zoxide is a smarter cd command, inspired by z and autojump.
# https://github.com/ajeetdsouza/zoxide
if (( $+commands[zoxide] )); then
  export _ZO_ECHO=1
fi

# A cat(1) clone with wings.
# https://github.com/sharkdp/bat
if (( $+commands[bat] )); then
  # https://github.com/sharkdp/bat#man
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi
