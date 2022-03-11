#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[python::install]"

source "${ZSH}/python/python-versions.zsh"

# Note: you can also install the latest head release with: brew unlink pyenv && brew install pyenv --head
require_installed_brew "pyenv"
require_installed_brew "pyenv-virtualenv"

# Install python 2x
if [[ ! -z "$PYTHON_2X_VER" ]]; then
  if [ -z "$(pyenv versions | grep $PYTHON_2X_VER)" ]; then
    echo "  [pyenv] Installing python $PYTHON_2X_VER for you.."
    pyenv install $PYTHON_2X_VER
    pyenv rehash
  else
    echo "  [pyenv] Python $PYTHON_2X_VER already installed."
  fi

  if [[ "$PYTHON_GLOBAL_VER" = '2x' ]]; then
    echo "  [pyenv] Setting python $PYTHON_2X_VER as global.."
    pyenv global $PYTHON_2X_VER
  fi
else
  echo "  [pyenv] Warning: No PYTHON_2X_VER set, not installing."
fi

# Install python 3x
if [[ ! -z "$PYTHON_3X_VER" ]]; then
  if [ -z "$(pyenv versions | grep $PYTHON_3X_VER)" ]; then
    echo "  [pyenv] Installing python $PYTHON_3X_VER for you.."
    pyenv install $PYTHON_3X_VER
    pyenv rehash
  else
    echo "  [pyenv] Python $PYTHON_3X_VER already installed."
  fi

  if [[ "$PYTHON_GLOBAL_VER" = '3x' ]]; then
    echo "  [pyenv] Setting python $PYTHON_3X_VER as global.."
    pyenv global $PYTHON_3X_VER
  fi
else
  echo "  [pyenv] Warning: No PYTHON_3X_VER set, not installing."
fi
