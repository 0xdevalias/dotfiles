#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[keybase::install]"

check_installed brew

require_installed_brew_cask keybase  # https://keybase.io/
