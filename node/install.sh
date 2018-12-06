#!/bin/sh

export NODE_VER="10.14.1"

npmGlobalCheckOrInstall() {
  local module="$1"

  if [ $(npm list -g --depth=0 | grep -c "$module") -eq 0 ]
  then
    echo "  [NPM] Installing $module for you."
    npm install -g "$module"
  else
  	echo "  [NPM] $module already installed."
  fi
}

if test ! $(which nodenv)
then
  echo "  Installing nodenv for you."
  brew install nodenv > /tmp/nodenv-install.log
fi

if test ! $(which node-build)
then
  echo "  Installing node-build for you."
  brew install node-build > /tmp/node-build-install.log
fi

if [[ ! -z "$NODE_VER" ]]; then
  if [ -z "$(nodenv versions | grep $NODE_VER)" ]; then
    echo "  [nodenv] Installing node $NODE_VER for you.."
    nodenv install $NODE_VER
    nodenv rehash

    echo "  [nodenv] Setting node $NODE_VER as global.."
    nodenv global $NODE_VER
  else
    echo "  [nodenv] Node $NODE_VER already installed."
  fi
else
  echo "  [nodenv] Warning: No NODE_VER set, not installing."
fi

# npmGlobalCheckOrInstall "grunt-cli"
# npmGlobalCheckOrInstall "gulp"
# npmGlobalCheckOrInstall "bower"
# npmGlobalCheckOrInstall "bower-check-updates"
