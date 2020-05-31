#!/bin/sh

if test ! $(which asdf)
then
  echo "  Installing asdf for you.."
  brew install asdf | tee /tmp/asdf-install.log
fi
