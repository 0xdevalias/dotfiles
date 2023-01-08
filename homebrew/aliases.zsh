# Homebrew
alias brew-dir="cd $(brew --prefix) && pwd"
alias brew-cellardir="cd $(brew --cellar) && pwd"
alias brew-cachedir="cd $(brew --cache) && pwd"
alias brew-new-cask="echo brew create --help\nbrew-caskdir\nbrew style --fix CASK\nbrew audit --cask --online CASK\nbrew audit --new-cask CASK\nTODO: add more/better instructions/automations here.. See also this PR I created, and might be usable as a reference: https://github.com/Homebrew/homebrew-cask/pull/138933"
alias brew-tapsdir-cask="cd $(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks && pwd"
alias brew-commands="brew commands"
