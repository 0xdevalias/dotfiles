# init according to man page
if (( $+commands[rbenv] ))
then
  echo "Loading rbenv.."
  eval "$(rbenv init -)"
fi
