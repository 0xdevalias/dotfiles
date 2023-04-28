### OSX Hibernation Modes
alias hibernateon="sudo pmset -a hibernatemode 25"
alias hibernateoff="sudo pmset -a hibernatemode 3"
alias hibernatecheck="pmset -g | grep hibernate"

### Hosts
alias hosts="sudo vi /private/etc/hosts"
alias edit_hosts="sudo vi /private/etc/hosts"
alias cat_hosts="cat /private/etc/hosts"

alias plainpaste="(pbpaste | pbcopy) && echo Clipboard content converted to plaintext"

alias unlocktrash="unlock ~/.Trash && echo All files in trash unlocked"

# Ref: https://apple.stackexchange.com/questions/342042/how-can-i-query-the-hardware-uuid-of-a-mac-programmatically-from-a-command-line/342043#342043
alias show-macos-platform-uuid='ioreg -d2 -c IOPlatformExpertDevice | awk -F\" "/IOPlatformUUID/{print \$(NF-1)}"'
