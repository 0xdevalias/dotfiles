
if test ! $(which pyenv)
then
  echo "  Installing pyenv for you."
  brew install pyenv > /tmp/pyenv-install.log
fi

if [ -z "$(brew list | grep pyenv-virtualenv)" ]; then
  echo "  Installing pyenv-virtualenv for you."
  brew install pyenv-virtualenv > /tmp/pyenv-install.log
fi

pyenv install 2.7.11
pyenv install 3.5.1

pyenv rehash

pyenv global 2.7.11

#easy_install SpoofMAC
