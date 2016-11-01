if (( $+commands[pyenv] ))
then
  echo "Loading pyenv.."
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
fi
