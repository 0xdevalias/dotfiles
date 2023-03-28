#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

check_installed brew

# brew install hub                        # https://hub.github.com
brew install gh                         # https://github.com/cli/cli
brew install git-delete-merged-branches # https://github.com/hartwork/git-delete-merged-branches

npm install -g @githubnext/github-copilot-cli  # https://www.npmjs.com/package/@githubnext/github-copilot-cli
