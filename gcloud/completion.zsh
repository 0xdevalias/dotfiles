GCCOMP="`brew --prefix`/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

if [ -f "$GCCOMP" ]; then
  source "$GCCOMP"
fi
