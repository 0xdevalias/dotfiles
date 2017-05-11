#!/bin/sh

if test ! $(which jenv)
then
  echo "  Installing jenv for you."
  brew install jenv > /tmp/jenv-install.log
fi

echo "Installing java.."
brew cask install java > /tmp/java-install.log
