# Sets reasonable OS X defaults.
#
# Or, in other words, set shit how I like in OS X.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#
# Can also look at:
#   https://github.com/kevinSuttle/macOS-Defaults/blob/master/.macos
#   https://www.defaults-write.com/
#   https://marcosantadev.com/manage-plist-files-plistbuddy/
#
# Run ./set-defaults.sh and you'll be good to go.

echo "TODO: Can we diff some settings and ask if we want to change them (eg. running in dot later, seeing what we should add/update here"

echo "TODO: Show file extensions for all files"
echo "TODO: Show user folder/etc in finder side menu"

# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

# Disable shortcut key for Emoji
defaults write -g NSUserKeyEquivalents -dict-add 'Emoji & Symbols' '\0'

# Use AirDrop over every interface. srsly this should be a default.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Show the ~/Library folder.
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Set a really fast key repeat.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Prevent .DS_Store file creation on network volumes / USB drives
# Ref: https://support.apple.com/en-us/HT208209
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Set the Finder prefs for showing a few different volumes on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Set calendar 'days in week' to 14
defaults write com.apple.iCal CalUIDebugDefaultDaysInWeekView 14

# ==============================================
# Mouse & Trackpad
# ==============================================
echo "Setting Mouse preferences"

# Set scrolling back to 'normal'
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# ==============================================
# Desktop & Screen Saver
# ==============================================
echo "Setting Desktop & Screen Saver preferences"

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# Top-Left Hot Corner: Launchpad (Applications)
defaults write com.apple.dock wvous-tl-corner -int 11
defaults write com.apple.dock wvous-tl-modifier -int 0

# Top-Right Hot Corner: Put Display to Sleep
defaults write com.apple.dock wvous-tr-corner -int 10
defaults write com.apple.dock wvous-tr-modifier -int 0

# Bottom-Left Hot Corner: Dashboard
defaults write com.apple.dock wvous-bl-corner -int 7
defaults write com.apple.dock wvous-bl-modifier -int 0

# Bottom-Right Hot Corner: Show Desktop
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

# ==============================================
# Safari & WebKit
# ==============================================

# Hide Safari's bookmark bar.
#defaults write com.apple.Safari ShowFavoritesBar -bool false

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# ==============================================
# Chrome
# ==============================================

# Tell Chrome to always restore windows to their original spaces
#   Ref: https://superuser.com/questions/1111535/how-can-i-make-osx-remember-the-desktop-assignment-of-different-chrome-windows
#   Original bug: https://bugs.chromium.org/p/chromium/issues/detail?id=74812#c117
#   Followup bug: https://bugs.chromium.org/p/chromium/issues/detail?id=1012034
defaults write com.google.Chrome NSWindowRestoresWorkspaceAtLaunch -bool YES

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true
