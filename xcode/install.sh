#!/bin/bash

if [[ "$(uname)" != "Darwin" ]]; then
  echo "Not on macOS, skipping: $0"
  exit 0
fi

main() {
  # Install the command line tools
  # TODO: How best to check if already installed?
  xcode-select --install

  # Headers required for dev things (eg. compiling python)
  # TODO: Is this required if we have xcode installed?
  local sdkheaderspath="/Library/Developer/CommandLineTools/Packages"
  local sdkheaderspkg="macOS_SDK_headers_for_macOS_10.14.pkgAAA"
  if [[ -f "$sdkheaderspath/$sdkheaderspkg" ]]; then
    # TODO: only install first time
    echo sudo installer -pkg  -target /
  else
    echo "Couldn't find SDK headers, has the path changed? $sdkheaderspath/$sdkheaderspkg"
    ls -la $sdkheaderspath
  fi

  # Install xcode
  if [[ ! "$(which mas)" ]]; then
    echo "Mas not installed.. you'll need to manually check/install xcode, then run this again: $0"
  elif [[ ! "$(mas list | grep Xcode)" ]]; then
    echo "Installing xcode.."
    mas lucky xcode
  else
    echo "xcode already installed"
    mas list | grep xcode
  fi

  # Ref: https://stackoverflow.com/questions/32729049/filemerge-quits-immediately-after-launching-from-sourcetree/52221151#52221151
  local xcodedevpath="/Applications/Xcode.app/Contents/Developer"
  local clitoolsdevpath="/Library/Developer/CommandLineTools"
  if [[ -d "$xcodedevpath" ]]; then
    if [[ "$(xcode-select -p)" != "$xcodedevpath" ]]; then
      echo "Found xcode, updating dev path.."
      sudo xcode-select -switch "$xcodedevpath"
      xcode-select -p
    fi
  elif [[ "$(xcode-select -p)" != "$clitoolsdevpath" ]]; then
    echo "Couldn't find xcode, updating dev path to CLI tools.."
    sudo xcode-select -switch "$clitoolsdevpath"
    xcode-select -p
  fi
}

main "$@"
