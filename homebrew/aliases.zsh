# Homebrew
alias brew-dir="cd $(brew --prefix) && pwd"
alias brew-cellardir="cd $(brew --cellar) && pwd"
alias brew-cachedir="cd $(brew --cache) && pwd"
alias brew-tapsdir="cd $(brew --prefix)/Homebrew/Library/Taps && pwd"
alias brew-tapsdir-homebrew="cd $(brew --prefix)/Homebrew/Library/Taps/homebrew/ && pwd"
alias brew-tapsdir-core="cd $(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-core/Formula && pwd"
alias brew-tapsdir-cask="cd $(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks && pwd"
alias brew-tapsdir-cask-versions="cd $(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-cask-versions/Casks && pwd"
alias brew-add="echo Try one of: 'brew create -h', brew-new-formula, brew-new-cask"
alias brew-commands="brew commands"

BREW_NEW_FORMULA_INFO=$(cat <<'END_HEREDOC'
Docs:
  TODO

Useful Commands:
  brew create --help

  brew-tapsdir-core

  brew style --fix FORMULA
  brew audit --new FORMULA
  brew audit --online FORMULA
  brew audit --strict FORMULA

  git remote add 0xdevalias git@github.com:0xdevalias/homebrew-core.git
  git new-branch 0xdevalias/add-formula-FORMULA
  git commit -m 'add FORMULA VERSION'

  gh pr create --repo homebrew/homebrew-core --web

TODO: add more/better instructions/automations here..

See also this PR I created, and might be usable as a reference: https://github.com/Homebrew/homebrew-core/pull/120044
Or all my PRs: https://github.com/Homebrew/homebrew-core/pulls?q=is%3Apr+author%3A0xdevalias
END_HEREDOC
)

alias brew-new-formula="echo '$BREW_NEW_FORMULA_INFO'"

BREW_NEW_CASK_INFO=$(cat <<'END_HEREDOC'
Docs:
  https://github.com/Homebrew/homebrew-cask/blob/master/CONTRIBUTING.md#adding-a-cask
  https://docs.brew.sh/Adding-Software-to-Homebrew#casks
  https://docs.brew.sh/Cask-Cookbook
    https://docs.brew.sh/Cask-Cookbook#stanza-livecheck
  https://docs.brew.sh/Brew-Livecheck
    https://docs.brew.sh/Brew-Livecheck#example-livecheck-blocks
    https://docs.brew.sh/Brew-Livecheck#strategy-blocks
    https://rubydoc.brew.sh/Homebrew/Livecheck/Strategy

Useful Commands:
  gh search issues --include-prs --repo=Homebrew/homebrew-cask \"CASK\"
  gh search issues --include-prs --repo=Homebrew/homebrew-cask-versions \"CASK\"s

  brew create --help

  One of:
    brew create --cask
    brew create --cask --tap Homebrew/homebrew-cask-versions

  brew createzap CASK

  brew livecheck -h
  brew livecheck CASK
  $(brew --repository homebrew/cask)/developer/bin/find-appcast '/path/to/application.app'

  brew style --fix CASK
  brew audit --new-cask CASK
  brew audit --cask --online CASK

  One of:
    brew-tapsdir-cask
    brew-tapsdir-cask-versions

  One of (once off):
    git remote add 0xdevalias git@github.com:0xdevalias/homebrew-cask.git
    git remote add 0xdevalias git@github.com:0xdevalias/homebrew-cask-versions.git

  git new-branch 0xdevalias/add-cask-CASK
  git commit -m 'add CASK VERSION'

  One of:
    gh pr create --repo homebrew/homebrew-cask --web
    gh pr create --repo homebrew/homebrew-cask-versions --web

TODO: add more/better instructions/automations here..

See also this PR I created, and might be usable as a reference: https://github.com/Homebrew/homebrew-cask/pull/138933
Or all my PRs: https://github.com/Homebrew/homebrew-cask/pulls?q=is%3Apr+author%3A0xdevalias
END_HEREDOC
)

alias brew-new-cask="echo '$BREW_NEW_CASK_INFO'"
alias brew-new-cask-search-existing='f() { echo "Checking Homebrew/homebrew-cask.."; gh search issues --include-prs --repo=Homebrew/homebrew-cask "$1"; echo "Checking Homebrew/homebrew-cask-versions.."; gh search issues --include-prs --repo=Homebrew/homebrew-cask-versions "$1"; }; f'
