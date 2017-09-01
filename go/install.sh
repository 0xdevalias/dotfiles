#!/bin/sh

if test ! $(which goenv)
then
  echo "  Installing goenv for you."
  brew install goenv > /tmp/goenv-install.log
fi

if test ! $(which go)
then
  echo "  Installing go for you."
  brew install go > /tmp/go-install.log
else
  echo "  Already Installed: go"
fi
