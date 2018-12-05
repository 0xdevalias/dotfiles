if test ! $(which mas)
then
  echo "  Installing mas (Mac App Store command-line interface) for you."
  brew install mas > /tmp/mas-install.log
fi

# Headers required for dev things (eg. compiling python)
sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /

# TODO:
#  * Launchpad database stored at: ~/Library/Application Support/Dock/*.db
#  * SQLite 3 format
#  * Is it possible to automate creating/grouping applications into folders?
#  http://www.defaults-write.com/cat/launchpad/
#  http://osxdaily.com/2011/08/01/refresh-launchpad-in-mac-os-x-10-7-lion/
#  http://osxdaily.com/2015/05/05/reset-launchpad-layout-mac-os-x/
#    defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock
#    This will reset/remove the defaults command when Dock starts again

# https://apple.stackexchange.com/questions/18535/where-is-the-launchpad-database-stored-and-is-there-a-way-to-edit-it-directly
# https://apple.stackexchange.com/questions/237136/where-does-launchpad-store-folder-information-database-etc
#   $TMPDIR/../0/com.apple.dock.launchpad/db/
#     db == the sqlite db
#     db-shm and db-wal are related to it
#       https://stackoverflow.com/questions/12928294/shm-and-wal-files-in-sqlite-db/12948036#12948036
#       https://www.sqlite.org/tempfiles.html
#         2.2 Write-Ahead Log (WAL) Files
#         2.3 Shared-Memory Files

# http://krypted.com/uncategorized/viewing-mac-app-store-purchases-from-the-command-line/
# http://osxdaily.com/2013/09/28/list-mac-app-store-apps-terminal/

# The Brewfile handles Homebrew-based app and library installs, but there may
# still be updates and installables in the Mac App Store. There's a nifty
# command line interface to it that we can use to just install everything, so
# yeah, let's do that. (note: doesn't install 3rd party, use mas for that)

echo "› sudo softwareupdate -l"
sudo softwareupdate -l

# echo "› sudo softwareupdate -i -a"
# sudo softwareupdate -i -a
