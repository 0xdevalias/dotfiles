cd ~/.dotfiles/homebrew

echo Updating homebrew list files..
brew list > brew.list
brew tap > brew-tap.list
brew cask list > brew-cask.list

# echo Staging in git..
# git add brew.list
# git add brew-tap.list
# git add brew-cask.list

echo Diffs..
git diff brew.list
git diff brew-tap.list
git diff brew-cask.list
git status