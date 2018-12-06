#!/bin/bash

if ! brew ls --versions zsh > /dev/null; then
  echo "Installing zsh.."
  brew install zsh
fi

if [[ -f "/usr/local/bin/zsh" ]]; then
  if [[ ! "$(cat /etc/shells|grep /usr/local/bin/zsh)" ]]; then
    echo Allowing non-standard zsh to be set as shell
    echo /usr/local/bin/zsh | sudo tee -a /etc/shells
  fi

  # Use homebrew version if it exists
  if [[ "$(default-user-shell)" != "/usr/local/bin/zsh" ]]; then
    echo "Setting default shell to zsh (homebrew) from '$(default-user-shell)'"
    chsh -s /usr/local/bin/zsh
  fi
else
  # Otherwise use system version
  if [[ "$(default-user-shell)" != "/bin/zsh" ]]; then
    echo "Setting default shell to zsh (system) from '$(default-user-shell)'"
    chsh -s /bin/zsh
  fi
fi

exit 0