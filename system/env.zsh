if (( $+commands[subl] )); then
  export EDITOR='subl --new-window --wait'
fi

# zoxide is a smarter cd command, inspired by z and autojump.
# https://github.com/ajeetdsouza/zoxide
if (( $+commands[zoxide] )); then
  export _ZO_ECHO=1
fi

# A cat(1) clone with wings.
# https://github.com/sharkdp/bat
if (( $+commands[bat] )); then
  # Bash scripts that integrate bat with various command-line tools (includes the batman command)
  # https://github.com/eth-p/bat-extras
  if (( $+commands[batman] )); then
    # Export MANPAGER and MANROFFOPT from batman integration
    # (sets up bat as the manpager automatically)
    eval "$(batman --export-env)"
  else
    # Fallback: manually configure bat as the manpager
    # https://github.com/sharkdp/bat#man
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  fi
fi
