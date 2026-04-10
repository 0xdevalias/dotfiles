alias reload!='. ~/.zshrc'

_dotfiles-search-commits() {
  if [[ $# -eq 0 ]]; then
    echo "No search term provided. Showing recent commits." >&2
    git -C $ZSH log --oneline
  else
    git -C $ZSH log --oneline --grep "$@"
  fi
}
alias dotfiles-search-commits='_dotfiles-search-commits'
alias dotfiles-history='_dotfiles-search-commits'

