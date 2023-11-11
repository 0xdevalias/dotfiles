# GitHub Copilot CLI (https://github.com/github/gh-copilot)
# Check if the gh copilot extension is installed and load aliases accordingly
# TODO: potentially refactor/improve this to work with the new gh copilot extension better
#   see https://github.com/github/gh-copilot/issues/5
if gh extension list | grep -q 'github/gh-copilot'; then
  echo "Loading gh copilot extension aliases.. (??, git?, gh?)"

  # Function to handle general shell command suggestions
  copilot_shell_suggest() {
    gh copilot suggest -t shell "$@"
  }
  alias '??'='copilot_shell_suggest'

  # Function to handle Git command suggestions
  copilot_git_suggest() {
    gh copilot suggest -t git "$@"
  }
  alias 'git?'='copilot_git_suggest'

  # Function to handle GitHub CLI command suggestions
  copilot_gh_suggest() {
    gh copilot suggest -t gh "$@"
  }
  alias 'gh?'='copilot_gh_suggest'
fi
