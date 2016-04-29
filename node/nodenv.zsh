# init according to man page
if (( $+commands[nodenv] ))
then
  echo "Loading nodenv.."
  eval "$(nodenv init -)"
fi
