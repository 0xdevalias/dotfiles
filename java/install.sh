#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

# See also
#   https://adoptopenjdk.net (find the latest release version from here)
#     https://github.com/AdoptOpenJDK/homebrew-openjdk (contains additional versions)
#       brew tap adoptopenjdk/openjdk
#   https://dzone.com/articles/a-guide-to-java-versions-and-features
#   brew search java
#   brew search jdk

require_installed_brew "jenv"
require_installed_brew_cask "adoptopenjdk"

# Add java versions to jenv
/usr/libexec/java_home | xargs jenv add

# See also: ls -la /Library/Java/JavaVirtualMachines
echo "\nInstalled Java versions:"
prefix_lines "  " "$(/usr/libexec/java_home -V 2>&1)"

