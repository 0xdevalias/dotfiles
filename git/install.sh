#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

echo "[git::install]"

check_installed brew

require_installed_brew gh                          # GitHub’s official command line tool: https://github.com/cli/cli
require_installed_brew git-delta                   # Syntax-highlighting pager for git and diff output: https://github.com/dandavison/delta
require_installed_brew git-recent                  # See your latest local git branches, formatted real fancy: https://github.com/paulirish/git-recent
require_installed_brew git-delete-merged-branches  # Command-line tool to delete merged Git branches: https://github.com/hartwork/git-delete-merged-branches

# Authenticate the GitHub CLI + set up SSH key
if (( $+commands[gh] )); then
  if ! gh auth status >/dev/null 2>&1; then
    echo "[git::install]  GitHub CLI (gh) not authenticated.. please login now"
    gh auth login
  fi

  # https://github.com/github/gh-copilot
  if ! gh extension list | grep -q 'github/gh-copilot'; then
    gh extension install github/gh-copilot
  fi
fi

# Function to synchronize system Git templates into dotfiles templates
function sync_git_templates_to_dotfiles() {
  # Helper function to normalize a path
  normalize_path() {
    local input_path="$1"

    # Expand ~ using the shell before passing to realpath
    input_path="${input_path/#\~/$HOME}"

    realpath "$input_path"
  }

  # Read the current Git template directory from configuration
  local git_template_dir=$(git config --global --get init.templatedir || echo "")
  local expected_dir="${ZSH}/git/templates"

  local normalized_git_template_dir=$(normalize_path "$git_template_dir")
  local normalized_expected_dir=$(normalize_path "$expected_dir")

  # Check if the Git template directory is blank
  if [[ -z "$git_template_dir" ]]; then
    echo "  Skipping template synchronization: Git template directory is not set."
    return
  fi

  # Ensure the directory matches the expected dotfiles path
  if [[ "$normalized_git_template_dir" != "$normalized_expected_dir" ]]; then
    echo "  Skipping template synchronization: Git template directory is not set to ${normalized_expected_dir}."
    return
  fi

  # Define paths for the source and destination
  local template_source="/usr/local/share/git-core/templates/hooks"
  local template_dest="${normalized_expected_dir}/hooks"

  # Ensure the destination directory exists
  mkdir -p "$template_dest"

  # Copy all hook templates from the system directory into the dotfiles directory
  echo "Copying system Git templates into ${template_dest}..."
  for file in "$template_source"/*; do
    if [[ -f "$file" ]]; then
      target_file="$template_dest/$(basename "$file")"

      # If the file exists, check if it's identical
      if [[ -f "$target_file" ]]; then
        if cmp -s "$file" "$target_file"; then
          echo "  Skipped: $(basename "$file") (identical)"
          continue
        else
          while true; do
            echo -n "  Overwrite $(basename "$file")? [y/N/d (show diff)] "
            read choice
            case "$choice" in
              [yY]*) cp -f "$file" "$target_file"
                     echo "  Overwritten: $(basename "$file")"
                     break
                     ;;
              [nN]*) echo "  Skipped: $(basename "$file") (user chose not to overwrite)"
                     break
                     ;;
              [dD]*) echo "    Showing diff for $(basename "$file"):"
                     diff -u "$target_file" "$file" | sed 's/^/      /'
                     ;;
              *)     echo "  Skipped: $(basename "$file") (user chose not to overwrite)"
                     break
                     ;;
            esac
          done
          continue
        fi
      fi

      # Copy the file if it doesn't exist
      cp "$file" "$target_file"
      echo "  Copied: $(basename "$file")"
    fi
  done
}

# Function to validate and fix symlinks between $ZSH/git/templates and $ZSH/git/templates-source
function sync_git_template_symlinks() {
  local templates_dir="$ZSH/git/templates"
  local source_dir="$ZSH/git/templates-source"

  # Resolve absolute paths
  local expanded_source_dir=$(realpath "$source_dir")

  echo "Checking symlinks in: $templates_dir"

  # Ensure the templates directory exists
  if [[ ! -d "$templates_dir" ]]; then
    echo "  Templates directory does not exist: $templates_dir"
    return
  fi

  # Iterate over all symlinks found by find
  for symlink in $(find "$templates_dir" -type l -print0 | xargs -0); do
    # Get the current target of the symlink
    local current_target=$(readlink "$symlink")

    # Skip symlinks that don't point to `git/templates-source`
    if [[ "$current_target" != */git/templates-source/* ]]; then
      echo "  Skipped (non-relevant): $symlink -> $current_target"
      continue
    fi

    # Check if the symlink points to the correct source directory
    if [[ "$current_target" == "$expanded_source_dir/"* ]]; then
      echo "  Skipped (valid prefix): $symlink -> $current_target"
    else
      local relative_target=${current_target#*/git/templates-source/}
      local new_target="$expanded_source_dir/$relative_target"

      echo "  Invalid (incorrect prefix): $symlink"
      echo "    Current target: $current_target"
      echo "    Fixed target  : $new_target"
      echo -n "    Do you want to fix this symlink? [y/N]: "
      read -r choice
      case "$choice" in
        [yY]*)
          ln -sf "$new_target" "$symlink"
          echo "  Fixed: $symlink -> $new_target"
          ;;
        *)
          echo "  Skipped (user choice): $symlink -> $current_target"
          ;;
      esac
    fi
  done
  echo ""
}

sync_git_templates_to_dotfiles
sync_git_template_symlinks
