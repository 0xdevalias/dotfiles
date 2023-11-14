if (( $+commands[pyenv] ))
then
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
  export PYENV_ROOT="$HOME/.pyenv"

  echo "Loading pyenv.."
  eval "$(pyenv init - zsh)"
  eval "$(pyenv virtualenv-init - zsh)"

  # Make sure we don't accidentally forgot to use pyenv-virtualenv instead of plain python -m venv
  python_venv_warning() {
    local cmd=$1
    shift

    if [[ $1 == "-m" && $2 == "venv" && $3 ]]; then
      echo "Warning: You are about to create a virtual environment without pyenv-virtualenv."
      echo
      read "reply?Are you sure you want to continue? (y/N) "
      if [[ ! $reply =~ ^[Yy]$ ]]; then
        echo
        echo "Syntax for creating a virtual environment with pyenv-virtualenv:"
        echo "  pyenv virtualenv <python_version> <env_name>"
        echo
        read "use_pyenv?Would you like to create a pyenv-virtualenv now? (Y/n) "
        if [[ ! $use_pyenv =~ ^[Nn]$ ]]; then
          local project_name=$(basename "$PWD")
          read "env_name?Enter a name for the virtual environment (default: $project_name): "
          env_name=${env_name:-$project_name}
          echo "Creating a pyenv-virtualenv named '$env_name'..."
          pyenv virtualenv $(pyenv version-name) $env_name
          pyenv local $env_name
        fi

        return 1
      fi
    fi
    command $cmd "$@"
  }
  alias python='python_venv_warning python'
  alias python2='python_venv_warning python2'
  alias python3='python_venv_warning python3'
fi
