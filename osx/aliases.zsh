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