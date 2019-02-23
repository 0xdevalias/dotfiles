#!/bin/sh

if test ! $(which asdf)
then
  echo "  Installing asdf for you."
  brew install asdf > /tmp/asdf-install.log
fi
