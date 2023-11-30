#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[git::install]"

check_installed brew

require_installed_brew gh                          # GitHub’s official command line tool: https://github.com/cli/cli
require_installed_brew git-recent                  # See your latest local git branches, formatted real fancy: https://github.com/paulirish/git-recent
require_installed_brew git-delete-merged-branches  # Command-line tool to delete merged Git branches: https://github.com/hartwork/git-delete-merged-branches

# Authenticate the GitHub CLI + set up SSH key
if (( $+commands[gh] )); then
  if ! gh auth status >/dev/null 2>&1; then
    echo "  GitHub CLI (gh) not authenticated.. please login now"
    gh auth login
  fi

  # https://github.com/github/gh-copilot
  if ! gh extension list | grep -q 'github/gh-copilot'; then
    gh extension install github/gh-copilot
  fi
fi
