showlocked() {
  if [ -z "$1" ]
    then
      local dir="."
    else
      local dir="$1"
  fi

  find "$dir" -flags uchg
}

unlock() {
  if [ -z "$1" ]
    then
      local dir="."
    else
      local dir="$1"
  fi

  chflags -R nouchg "$dir"
}

# http://superuser.com/questions/443989/mac-per-kext-memory-extension-aka-which-kext-is-leaky#comment1037660_448665
kernelMemory() {
  kextstat | awk 'NR==1{ printf "%10s %s\n", $5, $6; } NR!=1{ printf "%10d %s\n", $5, $6; }' | sort -n
}