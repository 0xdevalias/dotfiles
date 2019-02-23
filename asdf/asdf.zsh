# asdf (https://asdf-vm.com/#/core-manage-asdf-vm?id=install-asdf-vm)
if (( $+commands[asdf] ))
then
  echo "Loading asdf.."
  export ASDF_DATA_DIR=`brew --prefix asdf`/
  source $ASDF_DATA_DIR/asdf.sh
fi
