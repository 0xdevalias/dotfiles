# A command-line fuzzy finder
# https://github.com/junegunn/fzf
#
# See also:
#   https://github.com/junegunn/fzf/blob/master/man/man1/fzf.1
#   https://github.com/junegunn/fzf/blob/master/ADVANCED.md
#   https://github.com/junegunn/fzf/wiki/Examples
if (( $+commands[fzf] )); then
  FZF_PATH="$(brew --prefix)/opt/fzf"

  # Auto-completion and Key bindings
  if [[ -n "$ZSH_VERSION" ]]; then
    # Zsh
    [[ -f "$FZF_PATH/shell/completion.zsh" ]] && source "$FZF_PATH/shell/completion.zsh" 2> /dev/null
    [[ -f "$FZF_PATH/shell/key-bindings.zsh" ]] && source "$FZF_PATH/shell/key-bindings.zsh"
  elif [[ -n "$BASH_VERSION" ]]; then
    # Bash
    [[ -f "$FZF_PATH/shell/completion.bash" ]] && source "$FZF_PATH/shell/completion.bash" 2> /dev/null
    [[ -f "$FZF_PATH/shell/key-bindings.bash" ]] && source "$FZF_PATH/shell/key-bindings.bash"
  fi
fi
