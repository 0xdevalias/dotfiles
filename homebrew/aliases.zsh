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

_brew_new_formula_info() {
  cat <<'END_HEREDOC'
Docs:
  TODO
  https://github.com/Homebrew/homebrew-core/blob/master/CONTRIBUTING.md#to-add-a-new-formula-for-foo-version-234-from-url
  https://docs.brew.sh/Adding-Software-to-Homebrew#formulae
  https://docs.brew.sh/Acceptable-Formulae
  https://docs.brew.sh/Formula-Cookbook
    https://docs.brew.sh/Formula-Cookbook#specifying-gems-python-modules-go-projects-etc-as-dependencies
      https://github.com/samertm/homebrew-go-resources
      https://github.com/Homebrew/brew/issues/16261
        Automatically create formula 'resource' entries from go.mod/go.sum (like update-python-resources / homebrew-go-resources)
    https://docs.brew.sh/Formula-Cookbook#livecheck-blocks
    https://rubydoc.brew.sh/Formula
  https://docs.brew.sh/Brew-Livecheck
    https://docs.brew.sh/Brew-Livecheck#example-livecheck-blocks
    https://docs.brew.sh/Brew-Livecheck#strategy-blocks
    https://rubydoc.brew.sh/Homebrew/Livecheck/Strategy
  https://justinoconnor.codes/2023/07/22/converting-pythons-requirements-txt-into-homebrew-formula-resources/
  https://kevin.burke.dev/kevin/install-homebrew-go/
  https://goreleaser.com/
    brew install goreleaser
    goreleaser init
    goreleaser build --skip=validate
    goreleaser release --skip=publish

Useful Commands:
  brew-new-formula-search-existing FORMULA
    Which is an alias for:
      gh search issues --include-prs --repo=Homebrew/homebrew-core FORMULA
      brew search --pull-request FORMULA

  brew create --help

  Create the new formula, one of (see https://docs.brew.sh/Formula-Cookbook#grab-the-url):
    brew create --go URL_TO_SOURCE.tar.gz                 # (examples https://github.com/search?q=repo%3AHomebrew%2Fhomebrew-core+depends_on+%5C%22go%5C%22&type=code)
    brew create --go --set-name FOO URL_TO_SOURCE.tar.gz  # (examples https://github.com/search?q=repo%3AHomebrew%2Fhomebrew-core+depends_on+%5C%22go%5C%22&type=code)
    etc

  Note: Make sure to edit the formula with any additional things to add manually such as:
    Add the correct license                                            # (see https://docs.brew.sh/Formula-Cookbook#fill-in-the-license)
    head "https://github.com/USER/PROJECT.git", branch: "master"       # (see https://docs.brew.sh/Formula-Cookbook#unstable-versions-head)
    Check for dependencies                                             # (see https://docs.brew.sh/Formula-Cookbook#check-for-dependencies)
    generate_completions_from_executable(bin/"foo", "completion")      # (see https://rubydoc.brew.sh/Formula.html#generate_completions_from_executable-instance_method)
    etc

  Create the livecheck section if needed (usually should work fine without) (see https://docs.brew.sh/Formula-Cookbook#livecheck-blocks):
    brew livecheck -h
    brew livecheck --formula FORMULA

  Install the formula locally (see https://docs.brew.sh/Formula-Cookbook#install-the-formula):
    HOMEBREW_NO_INSTALL_FROM_API=1 brew install --formula --build-from-source PATH_TO_LOCAL_FORMULA
    eg. HOMEBREW_NO_INSTALL_FROM_API=1 brew install --formula --build-from-source $(brew --repository homebrew/core)/Formula/f/foo.rb

  Create/run the tests, and ensure they pass (see https://docs.brew.sh/Formula-Cookbook#add-a-test-to-the-formula):
    brew test FORMULA

  Check that all of the style/audit checks pass (and fix anything if they don't):
    brew style --fix FORMULA
    brew audit --formula --new FORMULA  # (This implies both --strict and --online)

  Switch to the appropriate directory:
    brew-tapsdir-core

  Once off:
    git remote add 0xdevalias git@github.com:0xdevalias/homebrew-core.git

  Create a new branch and commit your new formula:
    git status
    git new-branch 0xdevalias/add-formula-FORMULA
    git add f/foo.rb
    git commit -m 'FORMULA VERSION (new formula)'
    git push 0xdevalias

  Open a PR for your new change (on https://github.com/Homebrew/homebrew-core):
    gh pr create --repo homebrew/homebrew-core --web

  Switch your local branch back to main:
    git checkout master

TODO: add more/better instructions/automations here..

See also this PR I created, and might be usable as a reference: https://github.com/Homebrew/homebrew-core/pull/120044
Or all my PRs: https://github.com/Homebrew/homebrew-core/pulls?q=is%3Apr+author%3A0xdevalias
END_HEREDOC
}

alias brew-new-formula="_brew_new_formula_info"
alias brew-new-formula-search-existing='f() { echo "Checking Homebrew/homebrew-core.."; gh search issues --include-prs --repo=Homebrew/homebrew-core "$1"; brew search --pull-request "$1"; }; f'

_brew_new_cask_info() {
  cat <<'END_HEREDOC'
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
      brew search --pull-request CASK

  brew create --help

  Create the new cask, one of:
    brew create --cask URL
    brew create --cask --tap Homebrew/homebrew-cask-versions URL

  Note: Make sure to edit the cask with any additional things to add manually such as:
    Mapping the version to the download URL (if required) # (see https://docs.brew.sh/Cask-Cookbook#stanza-version)
    auto_updates: true                                    # (see https://docs.brew.sh/Cask-Cookbook#:~:text=parse.rb)-,auto_updates,-no)

  Add a depends_on section if needed (see https://docs.brew.sh/Cask-Cookbook#depends_on-macos):
    plutil -extract LSMinimumSystemVersion raw /Applications/Foo.app/Contents/Info.plist

    https://rubydoc.brew.sh/MacOSVersion.html
      depends_on macos: ">= :sonoma"      # 14"
      depends_on macos: ">= :ventura"     # 13
      depends_on macos: ">= :monterey"    # 12
      depends_on macos: ">= :big_sur"     # 11
      depends_on macos: ">= :catalina"    # 10.15
      depends_on macos: ">= :mojave"      # 10.14
      depends_on macos: ">= :high_sierra" # 10.13
      depends_on macos: ">= :sierra"      # 10.12
      depends_on macos: ">= :el_capitan"  # 10.11

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
    brew audit --cask --new CASK    # (This implies both --strict and --online)

  Switch to the appropriate directory, one of:
    brew-tapsdir-cask
    brew-tapsdir-cask-versions

  One of (once off):
    git remote add 0xdevalias git@github.com:0xdevalias/homebrew-cask.git
    git remote add 0xdevalias git@github.com:0xdevalias/homebrew-cask-versions.git

  Create a new branch and commit your new cask:
    git status
    git new-branch 0xdevalias/add-cask-CASK
    git add f/foo.rb
    git commit -m 'add CASK VERSION'
    git push 0xdevalias

  Open a PR for your new change (on https://github.com/Homebrew/homebrew-cask), one of:
    gh pr create --repo homebrew/homebrew-cask --web
    gh pr create --repo homebrew/homebrew-cask-versions --web

  Switch your local branch back to main:
    git checkout master

TODO: add more/better instructions/automations here..

See also this PR I created, and might be usable as a reference: https://github.com/Homebrew/homebrew-cask/pull/138933
Or all my PRs: https://github.com/Homebrew/homebrew-cask/pulls?q=is%3Apr+author%3A0xdevalias
END_HEREDOC
}

alias brew-new-cask="_brew_new_cask_info"
alias brew-new-cask-search-existing='f() { echo "Checking Homebrew/homebrew-cask.."; gh search issues --include-prs --repo=Homebrew/homebrew-cask "$1"; echo "Checking Homebrew/homebrew-cask-versions.."; gh search issues --include-prs --repo=Homebrew/homebrew-cask-versions "$1"; brew search --pull-request "$1" }; f'
