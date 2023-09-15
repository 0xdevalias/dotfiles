#!/bin/bash

echo "[osx::install]"

if [[ "$(uname)" != "Darwin" ]]; then
  echo "[osx::install] Not on macOS, skipping: $0"
  exit 0
fi

# Ensure MSI MPG Artymis 343CQR doesn't attempt to mount it's built in driver USB
echo "[osx::install] "
echo "  Ensure monitor doesn't attempt to automount it's driver USB:"
echo "    sudo vifs"
echo ""
echo "  Then add the following line:"
echo "    /dev/disk2 none msdos ro,noauto"
echo ""
echo "  You can use the following command to check it's the correct drive:"
echo "    diskutil list"
echo ""
echo "  ChatGPT Ref: https://chat.openai.com/c/6dececbd-5e93-43dd-a16f-f0712190e3bb"

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

# echo "› softwareupdate -l"
# softwareupdate -l

# echo "› sudo softwareupdate -i -a"
# sudo softwareupdate -i -a
