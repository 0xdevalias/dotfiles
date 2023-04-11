#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[gpg::install]"

require_installed_brew "gpg"
require_installed_brew "pinentry-mac"

# Ensure correct pinentry file is configured for gpg-agent.conf
PINENTRY_BIN="$(brew --prefix)/bin/pinentry-mac"
sed -i.bak "s|^pinentry-program.*|pinentry-program $PINENTRY_BIN|" ~/.gnupg/gpg-agent.conf

# Ensure correct permissions are set (avoids gpg: WARNING: unsafe permissions on homedir '/Users/devalias/.gnupg')
#   https://superuser.com/questions/954509/what-are-the-correct-permissions-for-the-gnupg-enclosing-folder-gpg-warning/954536#954536
echo "[gpg] Ensuring correct folder permissions are set"
chown -R "$(whoami):$(id -gn)" ~/.gnupg/
chmod 700 ~/.gnupg
find ~/.gnupg -type f -exec chmod 600 {} \;
find ~/.gnupg -type d -exec chmod 700 {} \;
