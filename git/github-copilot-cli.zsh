# github-copilot-cli (https://www.npmjs.com/package/@githubnext/github-copilot-cli)
if (( $+commands[github-copilot-cli] ))
then
  echo "Loading github-copilot-cli.."
  eval "$(github-copilot-cli alias -- "$0")"
fi
