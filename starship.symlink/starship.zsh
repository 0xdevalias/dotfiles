if (( $+commands[starship] )); then
  echo "Loading starship.."
  export STARSHIP_CONFIG="$HOME/.starship/starship.toml"
  eval "$(starship init zsh)"

  # https://starship.rs/advanced-config/#change-window-title
  function set_win_title() {
    echo -ne "\033]0; $(basename "$PWD") \007"
  }
  precmd_functions+=(set_win_title)
fi
