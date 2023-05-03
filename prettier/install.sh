#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[prettier::install]"

require_installed_brew "prettier"
