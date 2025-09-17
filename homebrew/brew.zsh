# Enable the Homebrew "command-not-found" handler if available.
#
# This defines a command_not_found_handler that runs `brew which-formula` on the
# missing command. If it matches something in Homebrew’s executables database,
# it suggests the formula you need to install (e.g. `brew install foo`).
#
# The executables database is kept up to date by `brew which-update`, and is
# refreshed automatically when you run `brew update`.
#
# To enable this feature, first tap the repo:
#   brew tap homebrew/command-not-found
#
# See: https://github.com/Homebrew/homebrew-command-not-found
if (( $+commands[brew] )) && brew command command-not-found-init &>/dev/null; then
  eval "$(brew command-not-found-init)"
fi
