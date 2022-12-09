alias npm-list="npm list --depth=0"
alias npm-list-global="npm list -g --depth=0"

alias npm-outdated="npm outdated"
alias npm-outdated-global="npm outdated -g"

# https://github.com/dylang/npm-check
alias npm-check="npx npm-check"

alias yarn-check-cache-size="du -sh ~/Library/Caches/Yarn"
alias yarn-clean-cache="yarn-check-cache-size; rm -rf ~/Library/Caches/Yarn/*; yarn-check-cache-size"
alias clean-yarn-cache="yarn-clean-cache"
