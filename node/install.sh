#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

# Import config for n
source "${ZSH}/node/n.zsh"

echo "[node::install]"

require_installed_brew "n"
require_installed_brew "nodenv"
require_installed_brew "node-build"
require_installed_brew "yarn"

# Ensure n and nodenv use the same install directory
mkdir -p "$HOME/.n/n/versions"
mkdir -p "$HOME/.nodenv/versions"

if [[ ! -e "$HOME/.n/n/versions/node" ]]; then
  echo "  Symlinking 'n' install directory to 'nodenv' install directory"
  ln -s "$HOME/.nodenv/versions" "$HOME/.n/n/versions/node"
fi

NODE_VER=`n --lts`

# Pre-install checks
if [[ -z "$NODE_VER" ]]; then
  echo "  Warning: No NODE_VER set, not installing."
  exit 1
fi

if [[ ! -z "$(nodenv versions | grep $NODE_VER)" ]]; then
  echo "  Node ${NODE_VER} already installed."
  exit 0
fi

# Install node
if [[ ! -z "$(node-build --definitions | grep $NODE_VER)" ]]; then
  echo "  Installing node $NODE_VER for you via 'node-build'.."
  nodenv install $NODE_VER
elif [[ ! -z "$(n ls-remote --all | grep $NODE_VER)" ]]; then
  echo "  Installing node $NODE_VER for you via 'n'.."
  n $NODE_VER
else
  echo "  Error: Node ${NODE_VER} was unable to be installed via 'node-build' or 'n'"
  exit 1
fi

echo "  [nodenv] Rehashing node versions.."
nodenv rehash

echo "  [nodenv] Setting node $NODE_VER as global.."
nodenv global $NODE_VER

echo "  [nodenv] Versions:"
nodenv versions
