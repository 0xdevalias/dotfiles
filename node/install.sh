#!/bin/zsh

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

if test ! $(which node)
then
  echo "  Installing node for you."
  brew install node > /tmp/node-install.log
fi

#npmGlobalCheckOrInstall "grunt-cli"
npmGlobalCheckOrInstall "gulp"
npmGlobalCheckOrInstall "bower"
npmGlobalCheckOrInstall "bower-check-updates"