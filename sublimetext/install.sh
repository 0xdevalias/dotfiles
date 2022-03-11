#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[sublimetext::install]"

require_installed_brew_cask "sublime-text"

ST_USERPATH="$HOME/Library/Application Support/Sublime Text/Packages/User"
ST_SETTINGSPATH="$ST_USERPATH/Preferences.sublime-settings"
ST_DOTFILEPATH="$ZSH/sublimetext/Preferences.sublime-settings"

# Make settings folder if it doesn't exist
if [[ ! -d "$ST_USERPATH" ]]; then
  echo "[sublimetext] Making settings folder.. ($ST_USERPATH)"
  mkdir -p "$ST_USERPATH"
fi

# If file exists already, move into dotfiles (git will track differences)
if [[ -f "$ST_SETTINGSPATH" ]] && [[ ! -h "$ST_SETTINGSPATH" ]]; then
  echo "[sublimetext] User settings found, moving into dotfiles.. ($ST_DOTFILEPATH)"
  mv "$ST_SETTINGSPATH" "$ST_DOTFILEPATH"
fi

if [[ ! -L "$ST_SETTINGSPATH" ]]; then
  echo "[sublimetext] Symlinking settings path to dotfiles.. ($ST_SETTINGSPATH)"
  ln -s "$ST_DOTFILEPATH" "$ST_SETTINGSPATH"
else
  echo "[sublimetext] Everything looks good here. Nothing to setup."
fi
