#!/bin/sh

# See available versions: asdf list-all java
export JAVA_VER="openjdk-11.0.1"

if test ! $(which asdf)
then
  echo "  asdf is required.."
  $ZSH/asdf/install.sh
fi

# https://github.com/skotchpine/asdf-java
asdf plugin-add java
asdf plugin-update java

echo "Installing java.."
asdf install java $JAVA_VER
asdf global java $JAVA_VER

echo "Java versions installed:"
asdf list java

echo "Current Java version in use:"
asdf current java
