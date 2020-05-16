#!/usr/bin/env zsh
#
# Antigen

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

if ! is_installed "brew" &> /dev/null; then
  echo "  [ERROR] Antigen installer requires homebrew to be installed. Exiting."
  exit 1
fi

if ! brew list antigen &> /dev/null; then
  echo "  Installing Antigen for you."

  brew install antigen
else
  echo "  › antigen update"
  $ZSH/antigen/antigen update 2>&1
fi

exit 0
