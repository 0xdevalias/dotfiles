#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[system::install]"

# Set up our standard directory structures
echo "[system::install] Creating standard directory structures.."

ZSH_DIR_DEV="$HOME/dev"

if [ ! -d "$ZSH_DIR_DEV" ]; then
  mkdir "$ZSH_DIR_DEV"
  echo "[system::install]   $ZSH_DIR_DEV"
fi

# Set up symlinks to cloud storage/etc
echo "[system::install] Creating symlinks to cloud storage directories.."

CLOUD_STORAGE_DIR="$HOME/Library/CloudStorage"
DROPBOX_DIR="$CLOUD_STORAGE_DIR/Dropbox"
ONEDRIVE_DIR="$CLOUD_STORAGE_DIR/OneDrive-Personal"

create_symlink "$DROPBOX_DIR" "$HOME/Dropbox"
create_symlink "$ONEDRIVE_DIR" "$HOME/OneDrive"

# Handle Google Drive directory selection
GOOGLE_DRIVE_DIRS=($(find "$CLOUD_STORAGE_DIR" -maxdepth 1 -type d -name 'GoogleDrive-*'))

if [ ${#GOOGLE_DRIVE_DIRS[@]} -eq 0 ]; then
  echo "[system::install]  No Google Drive directories found. Skipping symlink."
elif [ ${#GOOGLE_DRIVE_DIRS[@]} -eq 1 ]; then
  GOOGLE_DRIVE_DIR="${GOOGLE_DRIVE_DIRS[0]}"
  create_symlink "$GOOGLE_DRIVE_DIR" "$HOME/Google Drive"
else
  echo "[system::install]  Multiple Google Drive directories found. Please select one:"
  select dir in "${GOOGLE_DRIVE_DIRS[@]}"; do
    if [[ -n $dir ]]; then
      echo "[system::install]    You selected $dir"
      GOOGLE_DRIVE_DIR="$dir"
      break
    else
      echo "[system::install]    Invalid selection"
    fi
  done

  create_symlink "$GOOGLE_DRIVE_DIR" "$HOME/Google Drive"
fi

echo "[system::install] Checking/installing standard system utilities.."
require_installed_brew "coreutils"                   # GNU File, Shell, and Text utilities: https://www.gnu.org/software/coreutils
# require_installed_brew "uutils-coreutils"            # Cross-platform Rust rewrite of the GNU coreutils: https://github.com/uutils/coreutils
require_installed_brew "grc"                         # Colorize logfiles and command output: https://github.com/garabik/grc
require_installed_brew "zoxide"                      # zoxide is a smarter cd command, inspired by z and autojump: https://github.com/ajeetdsouza/zoxide
require_installed_brew "fzf"                         # Command-line fuzzy finder written in Go: https://github.com/junegunn/fzf
require_installed_brew "fd"                          # Simple, fast and user-friendly alternative to find: https://github.com/sharkdp/fd
require_installed_brew "bat"                         # Clone of cat(1) with syntax highlighting and Git integration: https://github.com/sharkdp/bat
require_installed_brew "jq"                          # Lightweight and flexible command-line JSON processor: https://stedolan.github.io/jq/
require_installed_brew "xq"                          # Command-line XML and HTML beautifier and content extractor: https://github.com/sibprogrammer/xq
require_installed_brew "pup"                         # Parse HTML at the command-line
require_installed_brew "cascadia"                    # Go cascadia package command-line CSS selector
require_installed_brew "fx"                          # Terminal JSON viewer: https://fx.wtf
require_installed_brew "dasel"                       # JSON, YAML, TOML, XML, and CSV query and modification tool: https://github.com/TomWright/dasel
require_installed_brew "gron"                        # Make JSON greppable: https://github.com/tomnomnom/gron
require_installed_brew "ast-grep"                    # A CLI tool for code structural search, lint and rewriting. Written in Rust: https://github.com/ast-grep/ast-grep
require_installed_brew "git-delta"                   # Syntax-highlighting pager for git and diff output: https://github.com/dandavison/delta
require_installed_brew "difftastic"                  # Diff that understands syntax: https://github.com/Wilfred/difftastic

require_installed_brew_cask "karabiner-elements"  # A powerful and stable keyboard customizer for macOS

echo "[system::install] Done"
