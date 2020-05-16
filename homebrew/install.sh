#!/bin/bash
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

install_macOS() {
  if [[ ! $(which brew) ]]; then
    echo "  Installing Homebrew for you.."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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

  # Install some common core dependencies
  brew install coreutils
}

install_linux() {
  if [[ ! $(which brew) ]]; then
    echo "  Installing Homebrew (linux) for you.."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
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
