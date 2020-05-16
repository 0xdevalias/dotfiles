# init according to man page
if (( $+commands[rbenv] ))
then
  echo "Loading rbenv.."
  eval "$(rbenv init -)"

  # RubyMine needs this env var explicitly set or it can't find things..
  export RBENV_ROOT=$(rbenv root)
fi
