#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[keybase::install]"

check_installed brew

require_installed_brew_cask keybase  # https://keybase.io/

# Temporarily add the keybase app bin to our path so the commands below can run
PATH="$PATH:/Applications/Keybase.app/Contents/SharedSupport/bin"

# Authenticate Keybase
if (( $+commands[keybase] )); then
  if ! keybase whoami >/dev/null 2>&1; then
    echo "  Keybase not authenticated.. please login now"
    keybase login
  fi
fi
