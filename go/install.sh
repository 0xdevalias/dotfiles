#!/bin/sh

if test ! $(which go)
then
  echo "  Installing go for you."
  brew install go > /tmp/go-install.log
else
  echo "  Already Installed: go"
fi
