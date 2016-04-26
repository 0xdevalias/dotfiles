# Docker (https://docs.docker.com/engine/installation/mac/#from-your-shell)
# Note: No longer required with docker native app, so disable this if present.
if [ ! -d "/Applications/Docker.app" ]; then
  if (( $+commands[docker-machine] ))
  then
    echo "Loading docker.."
    eval $(docker-machine env default)
  fi
fi
