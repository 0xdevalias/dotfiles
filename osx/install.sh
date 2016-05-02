if test ! $(which mas)
then
  echo "  Installing mas (Mac App Store command-line interface) for you."
  brew install mas > /tmp/mas-install.log
fi

# The Brewfile handles Homebrew-based app and library installs, but there may
# still be updates and installables in the Mac App Store. There's a nifty
# command line interface to it that we can use to just install everything, so
# yeah, let's do that.

echo "› sudo softwareupdate -i -a"
sudo softwareupdate -i -a
