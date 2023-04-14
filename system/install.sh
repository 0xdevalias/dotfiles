#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[system::install]"

require_installed_brew "coreutils"         # GNU File, Shell, and Text utilities: https://www.gnu.org/software/coreutils
# require_installed_brew "uutils-coreutils"  # Cross-platform Rust rewrite of the GNU coreutils: https://github.com/uutils/coreutils
require_installed_brew "grc"               # Colorize logfiles and command output: https://github.com/garabik/grc
require_installed_brew "zoxide"            # zoxide is a smarter cd command, inspired by z and autojump: https://github.com/ajeetdsouza/zoxide
require_installed_brew "fzf"               # Command-line fuzzy finder written in Go: https://github.com/junegunn/fzf
require_installed_brew "fd"                # Simple, fast and user-friendly alternative to find: https://github.com/sharkdp/fd
require_installed_brew "bat"               # Clone of cat(1) with syntax highlighting and Git integration: https://github.com/sharkdp/bat
require_installed_brew "jq"                # Lightweight and flexible command-line JSON processor: https://stedolan.github.io/jq/
require_installed_brew "xq"                # Command-line XML and HTML beautifier and content extractor: https://github.com/sibprogrammer/xq
require_installed_brew "fx"                # Terminal JSON viewer: https://fx.wtf
require_installed_brew "dasel"             # JSON, YAML, TOML, XML, and CSV query and modification tool: https://github.com/TomWright/dasel
