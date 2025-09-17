#!/usr/bin/env bash
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

install_macOS() {
  if [[ ! $(which brew) ]]; then
    echo "  Installing Homebrew for you.."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # else
  #   echo "Homebrew already installed, skipping..: $0"
  else
    brew update
  fi

  if [[ ! $(which mas) ]]; then
    echo "  Installing mas (Mac App Store command-line interface) for you."
    brew install mas > /tmp/mas-install.log
  # else
  #   echo "Mas already installed, skipping..: $0"
  fi

  # Ensure Homebrew "command-not-found" tap is available.
  #
  # This provides:
  #   - brew which-formula <cmd>: shows which formula provides a binary
  #   - brew which-update: refreshes the executables database
  #   - a shell handler that suggests `brew install <formula>` when you type
  #     a missing command that matches something in Homebrew.
  #
  # See: https://github.com/Homebrew/homebrew-command-not-found
  if ! brew tap | grep -q "^homebrew/command-not-found\$"; then
    echo "  Tapping homebrew/command-not-found for command-not-found support."
    brew tap homebrew/command-not-found

    # Source the handler immediately so it works in this shell session
    if brew command command-not-found-init &>/dev/null; then
      eval "$(brew command-not-found-init)"
    fi
  fi
}

install_linux() {
  if [[ ! $(which brew) ]]; then
    echo "  Installing Homebrew (linux) for you.."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    brew update
  fi
}

main() {
  local system=$(uname -s)

  case "${system:0:5}" in
    "Darwi") install_macOS "$@" ;;
    "Linux") install_linux "$@" ;;
    *)
      echo "Unsupported platform ($system), skipping: $0"
      echo "  $(uname -a)"
    ;;
  esac
}

main "$@"

exit 0
