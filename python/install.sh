#!/bin/sh

source `dirname $0`/python-versions.zsh

if test ! $(which pyenv)
then
  echo "  Installing pyenv for you."
  brew install pyenv > /tmp/pyenv-install.log
fi

if [ -z "$(brew list | grep pyenv-virtualenv)" ]; then
  echo "  Installing pyenv-virtualenv for you."
  brew install pyenv-virtualenv > /tmp/pyenv-install.log
fi

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

#easy_install SpoofMAC
