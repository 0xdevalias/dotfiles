# nvm (https://github.com/creationix/nvm)
NVM_SH="$HOME/.nvm/nvm.sh"

if [[ -f $NVM_SH ]]
then
  echo "Loading nvm.."

  export NVM_DIR="$HOME/.nvm"
  eval "$NVM_SH";

  autoload -U add-zsh-hook
  load-nvmrc() {
    if [[ -f .nvmrc && -r .nvmrc ]]; then
      nvm use
      export NVMRC_DIR="$PWD"
    elif [[ ! -z "$NVMRC_DIR" ]]; then
      case $PWD/ in
        $NVMRC_DIR/*)
          true # Still in .nvmrc directory, do nothing
        ;;
        *)
          echo "Leaving .nvmrc directory: $NVMRC_DIR"
          nvm use default
          export NVMRC_DIR=""
        ;;
      esac
    fi
  }
  add-zsh-hook chpwd load-nvmrc
fi