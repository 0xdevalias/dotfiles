GCPATH="`brew --prefix`/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"

if [ -f "$GCPATH" ]; then
  source "$GCPATH"
fi
