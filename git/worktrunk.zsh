# worktrunk: CLI for Git worktree management, designed for parallel AI agent workflows: https://worktrunk.dev
#   wt config shell -h
#   wt config shell init -h
if (( $+commands[wt] ))
then
  _wt_shell=${ZSH_VERSION:+zsh}
  _wt_shell=${_wt_shell:-${BASH_VERSION:+bash}}

  if [ -n "$_wt_shell" ]; then
    echo "Loading worktrunk.."
    eval "$(wt config shell init "$_wt_shell")"
  fi

  unset _wt_shell
fi
