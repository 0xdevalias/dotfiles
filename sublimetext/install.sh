#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[sublimetext::install]"

require_installed_brew_cask "sublime-text"

# https://packagecontrol.io/docs/syncing
#   install Package Control on all machines and then to sync only the Packages/User/ folder.
#   This folder contains the Package Control.sublime-settings file, which includes a list of all installed packages.
#   If this file is copied to another machine, the next time Sublime Text is started, Package Control will install the
#   correct version of any missing packages.

# ST_USERPATH="$HOME/Library/Application Support/Sublime Text/Packages/User"
ST_USERPATH="$(sublpm --settingsPath)"
ST_DOTFILEPATH="$ZSH/sublimetext/SublimeSettings"

# Make sublime settings folder if it doesn't exist
if [[ ! -d "$ST_USERPATH" ]]; then
  echo "[sublimetext] Making settings folder.. ($ST_USERPATH)"
  mkdir -p "$ST_USERPATH"
fi

if [[ -d "$ST_USERPATH" ]] && [[ ! -L "$ST_USERPATH" ]]; then
  echo "[sublimetext] User settings found, moving into dotfiles.. ($ST_DOTFILEPATH)"
  mv "$ST_USERPATH" "$ST_DOTFILEPATH"
fi

if [[ ! -L "$ST_USERPATH" ]]; then
  echo "[sublimetext] Symlinking settings path to dotfiles.. ($ST_USERPATH)"
  ln -s "$ST_DOTFILEPATH" "$ST_USERPATH"
else
  echo "[sublimetext] Everything looks good here. Nothing to setup."
fi

# While we could do these things manually here, lets use our sublpm helper script instead
#   https://forum.sublimetext.com/t/installing-packages-from-the-command-line/64029/4
#     subl --command "install_package_control"
#     subl --command "advanced_install_package {\"packages\": \"TODO\"}"
sublpm init
