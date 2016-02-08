#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update

# Install homebrew packages
brew install grc coreutils spark zsh zsh-completions antigen

# Install brew-cask
brew tap caskroom/cask
brew tap caskroom/versions
brew install brew-cask & brew upgrade brew-cask

# Install brew programs
brew install git
brew install hub
# brew install node # See node/install.sh
# brew install jenv # See jenv/install.sh
# brew install rbenv ruby-build # See ruby/install.sh

# Install cask programs
brew cask install adobe-reader
brew cask install evernote
brew cask install rescuetime

# Internet/Download
brew cask install google-chrome
brew cask install google-drive
brew cask install dropbox

# Chat/Social
brew cask install skype

# Gaming
brew cask install steam

# Media/Music/Etc
brew cask install spotify
brew cask install vlc
brew cask install lastfm

# Dev/Etc
brew install typesafe-activator
brew cask install sublime-text3
brew cask install sourcetree
brew cask install intellij-idea

# Security/Etc
brew cask install lastpass

# System/Etc
brew cask install asepsis
brew cask install alfred
brew cask install bartender
brew cask install bettertouchtool
brew cask install hyperdock
brew cask install totalfinder
brew cask install totalterminal
brew cask install nosleep

brew cask install qlstephen # Preview textfiles without extensions
brew cask install disk-inventory-x

# VM/Etc
brew cask install parallels-desktop
brew cask install vagrant vagrant-bar

exit 0
