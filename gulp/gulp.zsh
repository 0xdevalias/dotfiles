# init according to man page
if (( $+commands[gulp] ))
then
  eval "$(gulp --completion=zsh)"
fi
