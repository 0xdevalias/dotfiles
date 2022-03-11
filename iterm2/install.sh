#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

# Refs:
#   https://iterm2.com/documentation-hidden-settings.html

echo "[iTerm2::install]"

require_installed_brew_cask "iterm2"

ITERM_PREFS="$HOME/.iterm2"

if [ -d "${ITERM_PREFS}" ]; then
  echo "[iTerm2] Configuring iTerm2 custom preference folder to ${ITERM_PREFS}"

  # iTerm2(menu) > Preferences > General > Preferences > Load preferences from a custom folder or URL (file selector)
  defaults write com.googlecode.iterm2 PrefsCustomFolder "${ITERM_PREFS}"

  # iTerm2 (menu) > Preferences > General > Preferences > Load preferences from a custom folder or URL (checkbox)
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

  # iTerm2 (menu) > Preferences > General > Preferences > Save changes to folder when iTerm2 quits (selectbox)
  # Manually:
  #   NoSyncNeverRemindPrefsChangesLostForFile = 1
  #   ManuallyNoSyncNeverRemindPrefsChangesLostForFile_selection = 1
  # Automatically:
  #   NoSyncNeverRemindPrefsChangesLostForFile = 1
  #   NoSyncNeverRemindPrefsChangesLostForFile_selection = 2
  # When Quitting
  #   NoSyncNeverRemindPrefsChangesLostForFile = 1
  #   NoSyncNeverRemindPrefsChangesLostForFile_selection = <deleted>
  defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true
  defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 2
else
  echo "[iTerm2] Preference folder doesn't exist, skipping custom folder configuration"
fi

echo "[iTerm2] Enabling automatic updates"
defaults write com.googlecode.iterm2 SUEnableAutomaticChecks -bool true

# TODO: move com.googlecode.iterm2.plist into iterm2.symlink folder (when we commit it, commit any diffs to it separate to the move)
