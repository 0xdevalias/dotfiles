#!/bin/sh

export RUBY_VER="2.3.0"

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

if [[ ! -z "$RUBY_VER" ]]; then
  if [ -z "$(rbenv versions | grep $RUBY_VER)" ]; then
    echo "  [rbenv] Installing ruby $RUBY_VER for you.."
    rbenv install $RUBY_VER
    rbenv rehash

    echo "  [rbenv] Setting ruby $RUBY_VER as global.."
    rbenv global $RUBY_VER
  else
    echo "  [rbenv] Ruby $RUBY_VER already installed."
  fi
else
  echo "  [rbenv] Warning: No RUBY_VER set, not installing."
fi

gem install bundler
gem install jekyll
