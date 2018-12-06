#!/bin/zsh
#
# Antigen
#

if test ! "$(which antigen)"; then
  echo "  Installing Antigen for you."

  brew install antigen
else
  echo "  › antigen update"
  $ZSH/antigen/antigen update 2>&1
fi

exit 0
