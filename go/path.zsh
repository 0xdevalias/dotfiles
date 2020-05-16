# Import our common helper scripts
source "${ZSH}/lib/_helpers"

if is_installed "go" 1> /dev/null; then
  export GOPATH="$(go env GOPATH):$HOME/dev/go"
  export PATH="$PATH:$HOME/go/bin:$HOME/dev/go/bin"
fi
