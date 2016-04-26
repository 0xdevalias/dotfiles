if (( $+commands[pyenv] ))
then
  echo "Loading pyenv.."
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi
