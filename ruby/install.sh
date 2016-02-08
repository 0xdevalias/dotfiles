#!/bin/sh

if test ! $(which rbenv)
then
  echo "  Installing rbenv for you."
  brew install rbenv > /tmp/rbenv-install.log
fi

if test ! $(which ruby-build)
then
  echo "  Installing ruby-build for you."
  brew install ruby-build > /tmp/ruby-build-install.log
fi

rbenv install 2.3.0

rbenv rehash

rbenv global 2.3.0

gem install bundler
gem install jekyll