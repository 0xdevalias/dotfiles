#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

# See also
#   https://adoptium.net/
#     https://adoptium.net/faq.html#temurinName
#       This is the project and brand name for the binaries that the Eclipse Foundation produces. You can think of these as the successor binaries to AdoptOpenJDK.
#
#   https://adoptopenjdk.net (find the latest release version from here)
#     https://github.com/AdoptOpenJDK/homebrew-openjdk (contains additional versions)
#       brew tap adoptopenjdk/openjdk
#
#   https://dzone.com/articles/a-guide-to-java-versions-and-features
#
#   brew search java
#   brew search jdk

require_installed_brew "jenv"
require_installed_brew_cask "temurin"

# Add java versions to jenv
/usr/libexec/java_home | xargs jenv add

# See also: ls -la /Library/Java/JavaVirtualMachines
echo "\nInstalled Java versions:"
prefix_lines "  " "$(/usr/libexec/java_home -V 2>&1)"

