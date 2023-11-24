# Homebrew
alias brew-dir="cd $(brew --prefix) && pwd"
alias brew-cellardir="cd $(brew --cellar) && pwd"
alias brew-cachedir="cd $(brew --cache) && pwd"
alias brew-tapsdir="cd $(brew --prefix)/Homebrew/Library/Taps && pwd"
alias brew-tapsdir-homebrew="cd $(brew --prefix)/Homebrew/Library/Taps/homebrew/ && pwd"
alias brew-tapsdir-core="cd $(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-core/Formula && pwd"
alias brew-tapsdir-cask="cd $(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks && pwd"
alias brew-tapsdir-cask-versions="cd $(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-cask-versions/Casks && pwd"
alias brew-cask-devbindir="cd $(brew --repository homebrew/cask)/developer/bin && pwd"
alias brew-add="echo Try one of: 'brew create -h', brew-new-formula, brew-new-cask"
alias brew-commands="brew commands"

BREW_NEW_FORMULA_INFO=$(cat <<'END_HEREDOC'
Docs:
  TODO

Useful Commands:
  brew-new-formula-search-existing FORMULA
    Which is an alias for:
      gh search issues --include-prs --repo=Homebrew/homebrew-core FORMULA

  brew create --help

  brew-tapsdir-core

  brew style --fix FORMULA
  brew audit --new FORMULA
  brew audit --online FORMULA
  brew audit --strict FORMULA

  Once off:
    git remote add 0xdevalias git@github.com:0xdevalias/homebrew-core.git

  git new-branch 0xdevalias/add-formula-FORMULA
  git commit -m 'add FORMULA VERSION'
  git checkout master

  gh pr create --repo homebrew/homebrew-core --web

TODO: add more/better instructions/automations here..

See also this PR I created, and might be usable as a reference: https://github.com/Homebrew/homebrew-core/pull/120044
Or all my PRs: https://github.com/Homebrew/homebrew-core/pulls?q=is%3Apr+author%3A0xdevalias
END_HEREDOC
)

alias brew-new-formula="echo '$BREW_NEW_FORMULA_INFO'"
alias brew-new-formula-search-existing='f() { echo "Checking Homebrew/homebrew-core.."; gh search issues --include-prs --repo=Homebrew/homebrew-core "$1"; }; f'

BREW_NEW_CASK_INFO=$(cat <<'END_HEREDOC'
Docs:
  https://github.com/Homebrew/homebrew-cask/blob/master/CONTRIBUTING.md#adding-a-cask
  https://docs.brew.sh/Adding-Software-to-Homebrew#casks
  https://docs.brew.sh/Acceptable-Casks#finding-a-home-for-your-cask
  https://docs.brew.sh/Cask-Cookbook
    https://docs.brew.sh/Cask-Cookbook#stanza-livecheck
  https://docs.brew.sh/Brew-Livecheck
    https://docs.brew.sh/Brew-Livecheck#example-livecheck-blocks
    https://docs.brew.sh/Brew-Livecheck#strategy-blocks
    https://rubydoc.brew.sh/Homebrew/Livecheck/Strategy

Useful Commands:
  brew-new-cask-search-existing CASK
    Which is an alias for:
      gh search issues --include-prs --repo=Homebrew/homebrew-cask CASK
      gh search issues --include-prs --repo=Homebrew/homebrew-cask-versions CASK

  brew create --help

  Create the new cask, one of:
    brew create --cask URL
    brew create --cask --tap Homebrew/homebrew-cask-versions URL

  Note: Make sure to edit the cask with any additional things to add manually such as:
    Mapping the version to the download URL (if required) # (see https://docs.brew.sh/Cask-Cookbook#stanza-version)
    depends_on macos: ">= :monterey"                      # (see https://docs.brew.sh/Cask-Cookbook#depends_on-macos)
    auto_updates: true                                    # (see https://docs.brew.sh/Cask-Cookbook#:~:text=parse.rb)-,auto_updates,-no)

  Install the basic cask locally, then use the app a bit:
    brew install --cask PATH_TO_LOCAL_CASK
    eg. brew install --cask $(brew --repository homebrew/cask)/Casks/f/foo.rb

  Create the 'zap' stanza for cleanup when uninstalling the cask (see https://docs.brew.sh/Cask-Cookbook#stanza-zap):
    Note: You'll probably need to open/run the app and use it a little bit before running the createzap helper tool

    brew createzap CASK

    Note: If that doesn't work well, then the following more manual steps might:

    $(brew --repository homebrew/cask)/developer/bin/list_ids_in_app /path/to/application.app

    find ~/Library -iname '*FooApp*' 2>/dev/null | sort
    find ~/Library -iname '*com.foo.FooApp*' 2>/dev/null | sort
    find ~/.config -iname '*FooApp*' 2>/dev/null | sort
    find ~/.config -iname '*com.foo.FooApp*' 2>/dev/null | sort
    find ~/.local -iname '*FooApp*' 2>/dev/null | sort
    find ~/.local -iname '*com.foo.FooApp*' 2>/dev/null | sorts
    find / -iname "*FooApp*" | sort
    find / -iname "*com.foo.FooApp*" | sort

  Create the livecheck section if relevant (see https://docs.brew.sh/Cask-Cookbook#stanza-livecheck):
    brew livecheck -h
    brew livecheck --cask CASK
    $(brew --repository homebrew/cask)/developer/bin/find-appcast '/path/to/application.app'

  Check that all of the style/audit checks pass (and fix anything if they don't):
    brew style --fix CASK
    brew audit --new-cask CASK
    brew audit --cask --online CASK

  Switch to the appropriate directory, one of:
    brew-tapsdir-cask
    brew-tapsdir-cask-versions

  One of (once off):
    git remote add 0xdevalias git@github.com:0xdevalias/homebrew-cask.git
    git remote add 0xdevalias git@github.com:0xdevalias/homebrew-cask-versions.git

  Create a new branch and commit your new cask:
    git new-branch 0xdevalias/add-cask-CASK
    git status
    git add f/foo.rb
    git commit -m 'add CASK VERSION'
    git push

  Open a PR for your new change (on https://github.com/Homebrew/homebrew-cask), one of:
    gh pr create --repo homebrew/homebrew-cask --web
    gh pr create --repo homebrew/homebrew-cask-versions --web

  Switch your local branch back to main:
    git checkout master

TODO: add more/better instructions/automations here..

See also this PR I created, and might be usable as a reference: https://github.com/Homebrew/homebrew-cask/pull/138933
Or all my PRs: https://github.com/Homebrew/homebrew-cask/pulls?q=is%3Apr+author%3A0xdevalias
END_HEREDOC
)

alias brew-new-cask="echo '$BREW_NEW_CASK_INFO'"
alias brew-new-cask-search-existing='f() { echo "Checking Homebrew/homebrew-cask.."; gh search issues --include-prs --repo=Homebrew/homebrew-cask "$1"; echo "Checking Homebrew/homebrew-cask-versions.."; gh search issues --include-prs --repo=Homebrew/homebrew-cask-versions "$1"; }; f'
