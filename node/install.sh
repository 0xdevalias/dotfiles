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

if [[ -z $NVM_DIR ]] || [[ ! -f "$HOME/.nvm" ]]
then
  echo "  Installing nvm for you.."
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | PROFILE="$ZSH/node/nvm.zsh" bash
fi

if test ! $(which node)
then
  echo "  Installing node for you.."
  nvm install node
  nvm alias default node
fi

#npmGlobalCheckOrInstall "grunt-cli"
npmGlobalCheckOrInstall "gulp"
npmGlobalCheckOrInstall "bower"
npmGlobalCheckOrInstall "bower-check-updates"