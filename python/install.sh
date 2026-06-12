#!/usr/bin/env zsh

set -e
set -o pipefail

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[python::install]"

source "${ZSH}/python/python-versions.zsh"

# Note: you can also install the latest head release with: brew unlink pyenv && brew install pyenv --head
require_installed_brew "pyenv"
require_installed_brew "pyenv-virtualenv"

install_python_version() {
  local version_series="$1"
  local version="$2"

  if [[ -z "$version" ]]; then
    echo "  [pyenv] Python ${version_series} version is disabled; skipping."
    return
  fi

  if pyenv versions --bare | grep -Fxq -- "$version"; then
    echo "  [pyenv] Python $version already installed."
  else
    echo "  [pyenv] Installing python $version for you.."
    pyenv install "$version"
    pyenv rehash
  fi

  if [[ "$PYTHON_GLOBAL_VER" == "$version_series" ]]; then
    echo "  [pyenv] Setting python $version as global.."
    pyenv global "$version"
  fi
}

case "$PYTHON_GLOBAL_VER" in
  2x)
    if [[ -z "$PYTHON_2X_VER" ]]; then
      echo "  [pyenv] Error: PYTHON_GLOBAL_VER is 2x, but PYTHON_2X_VER is disabled." >&2
      exit 1
    fi
    ;;
  3x)
    if [[ -z "$PYTHON_3X_VER" ]]; then
      echo "  [pyenv] Error: PYTHON_GLOBAL_VER is 3x, but PYTHON_3X_VER is disabled." >&2
      exit 1
    fi
    ;;
  *)
    echo "  [pyenv] Error: PYTHON_GLOBAL_VER must be either 2x or 3x." >&2
    exit 1
    ;;
esac

install_python_version "2x" "$PYTHON_2X_VER"
install_python_version "3x" "$PYTHON_3X_VER"
