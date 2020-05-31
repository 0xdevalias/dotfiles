#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[ruby::install]"

# See https://www.ruby-lang.org/en/downloads/
export RUBY_VER="2.7.1"

require_installed_brew "rbenv"
require_installed_brew "ruby-install"
# require_installed_brew "ruby"

if brew list "ruby-build" &> /dev/null; then
  echo "  Making sure ruby-build is uninstalled.. we have a ruby-install wrapper instead.."
  prefix_lines "  " "$(brew uninstall --force --ignore-dependencies ruby-build 2>&1)"
fi

if [[ ! -z "$RUBY_VER" ]]; then
  if [ -z "$(rbenv versions | grep $RUBY_VER)" ]; then
    echo "  [rbenv] Installing ruby $RUBY_VER for you.."
    # rbenv install $RUBY_VER
    $ZSH/bin/rbenv-install ruby $RUBY_VER
    # ruby-install --install-dir "$HOME/.rbenv/versions/$RUBY_VER" ruby $RUBY_VER
    rbenv rehash

    echo "  [rbenv] Setting ruby $RUBY_VER as global.."
    rbenv global $RUBY_VER
  else
    echo "  [rbenv] Ruby $RUBY_VER already installed."
  fi
else
  echo "  [rbenv] Warning: No RUBY_VER set, not installing."
fi

eval "$(rbenv init -)"
rbenv shell $RUBY_VER

gem install bundler
# gem install jekyll
