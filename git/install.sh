#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[git::install]"

check_installed brew

require_installed_brew gh                          # https://github.com/cli/cli
require_installed_brew git-delete-merged-branches  # https://github.com/hartwork/git-delete-merged-branches

if (( $+commands[npm] )); then
  npm install -g @githubnext/github-copilot-cli  # https://www.npmjs.com/package/@githubnext/github-copilot-cli
else
  echo "  npm not found, skipping installation of packages"
fi

# Authenticate the GitHub CLI + set up SSH key
if (( $+commands[gh] )); then
  if ! gh auth status >/dev/null 2>&1; then
    echo "  GitHub CLI (gh) not authenticated.. please login now"
    gh auth login
  fi
fi
