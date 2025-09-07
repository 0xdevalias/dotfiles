# Pin Homebrew auto-update interval to 24h (86400 seconds).
#
# Why: In `$(brew --repository)/Library/Homebrew/brew.sh`, when HOMEBREW_AUTO_UPDATE_SECS is unset, it is set
# dynamically based on the following logic:
#
# - 300s (5m) if HOMEBREW_NO_INSTALL_FROM_API or HOMEBREW_AUTO_UPDATE_TAP is set
# - 3600s (1h) if HOMEBREW_DEV_CMD_RUN is set (developer command was run)
# - 86400s (24h) otherwise
#
# The confusing part is HOMEBREW_DEV_CMD_RUN: running a developer command or enabling
# developer mode sets it. Homebrew records this by writing homebrew.devcmdrun=true
# to "$(brew --repository)/.git/config" and exporting HOMEBREW_DEV_CMD_RUN=1.
# Check or change the state with: brew developer state, brew developer on|off.
#
# If HOMEBREW_DEV_CMD_RUN is set, Homebrew would otherwise shorten the interval
# to 1 hour. Explicitly exporting 86400 here ensures we keep the 24h behaviour
# regardless of developer mode.
#
# To override locally, set HOMEBREW_AUTO_UPDATE_SECS in ~/.localrc before this
# file is sourced.
export HOMEBREW_AUTO_UPDATE_SECS="${HOMEBREW_AUTO_UPDATE_SECS:-86400}"
