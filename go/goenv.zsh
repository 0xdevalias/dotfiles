# init according to man page
if (( $+commands[goenv] ))
then
  echo "Loading goenv.."
  eval "$(goenv init -)"
fi
