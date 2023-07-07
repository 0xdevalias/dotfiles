# Note: I originally added this customisation due to an issue with subl when running under both root and non-root simultaneously:
#   https://github.com/sublimehq/sublime_text/issues/3897#issuecomment-1522599530
#
# Though according to the following comment, that bug will be fixed as of Sublime Text build 4148 (dev build as of 14 Mar 2023):
#   https://github.com/sublimehq/sublime_text/issues/3897#issuecomment-1522628513
if [[ $EUID -eq 0 ]]; then
  export EDITOR='vi'
else
  export EDITOR='subl'
fi

# zoxide is a smarter cd command, inspired by z and autojump.
# https://github.com/ajeetdsouza/zoxide
if (( $+commands[zoxide] )); then
  export _ZO_ECHO=1
fi
