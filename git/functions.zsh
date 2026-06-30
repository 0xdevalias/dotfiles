function list-git-dirs() {
  local check_path="." # Default path is current directory
  local action="all"
  local git_dirs=() non_git_dirs=()

  show_help() {
    echo "Usage: list-git-dirs [check_path] [--repos | --non-repos] [-h | --help]"
    echo
    echo "check_path  Optional path to list Git or non-Git directories. Defaults to the current directory."
    echo "--repos     List directories that are Git repositories within the specified path."
    echo "--non-repos List directories that are not Git repositories within the specified path."
    echo "-h, --help  Show this help message."
    echo
    echo "If no action argument is provided, it lists all directories, indicating whether they are Git repos or not."
  }

  # Check for help
  for arg in "$@"; do
    if [[ "$arg" == "-h" ]] || [[ "$arg" == "--help" ]]; then
      show_help
      return 0
    fi
  done

  # Check for action arguments and set path if provided
  for arg in "$@"; do
    case "$arg" in
      --repos) action="repos" ;;
      --non-repos) action="non-repos" ;;
      *)
        if [[ -d "$arg" ]]; then
          check_path="$arg"
        elif [[ "$arg" != -* ]]; then
          show_help
          echo
          echo "Error: Invalid argument: $arg doesn't seem to be a valid directory/path. Are you in the right folder?"
          return 1
        fi
        ;;
    esac
  done

  # Iterate over directories within the specified path
  for dir in "$check_path"/*/; do
    # Check if $dir is a git repository and find its root
    git_root=$(git -C "$dir" rev-parse --show-toplevel 2> /dev/null)

    # Normalize paths for comparison
    # normalized_dir=$(realpath "$dir" 2>/dev/null)
    # normalized_git_root=$(realpath "$git_root" 2>/dev/null)
    # normalized_dir=$(grealpath "$dir" 2>/dev/null)
    # normalized_git_root=$(grealpath "$git_root" 2>/dev/null)
    normalized_dir=$(grealpath --relative-to="$PWD" "$dir" 2>/dev/null)
    normalized_git_root=$(grealpath --relative-to="$PWD" "$git_root" 2>/dev/null)
    # normalized_dir=$(grealpath --relative-base="$PWD" "$dir" 2>/dev/null)
    # normalized_git_root=$(grealpath --relative-base="$PWD" "$git_root" 2>/dev/null)

    # Determine if the directory is a Git repo root or not
    if [[ -n $git_root && "$normalized_dir" == "$normalized_git_root" ]]; then
      git_dirs+=("$normalized_dir")
    else
      non_git_dirs+=("$normalized_dir")
    fi
  done

  if [[ $action == "repos" || $action == "all" ]]; then
    echo "Git Repo Root Directories:"
    printf '  %s\n' "${git_dirs[@]}"
  fi

  if [[ $action == "all" ]]; then
    echo
  fi

  if [[ $action == "non-repos" || $action == "all" ]]; then
    echo "Non-Git Repo Root Directories:"
    printf '  %s\n' "${non_git_dirs[@]}"
  fi
}

function git-worktree-cd() {
  local use_worktrunk=1

  for arg in "$@"; do
    case "$arg" in
      -h|--help)
        echo "Usage: git-worktree-cd [--no-worktrunk]"
        echo
        echo "Interactively select an existing Git worktree and cd into it."
        echo
        echo "By default, uses Worktrunk (wt) when its shell integration is available,"
        echo "otherwise falls back to git worktree + fzf."
        echo
        echo "Options:"
        echo "  --no-worktrunk  Use git worktree + fzf even when Worktrunk is available."
        echo "  -h, --help      Show this help message."
        return 0
        ;;
      --no-worktrunk)
        use_worktrunk=0
        ;;
      *)
        echo "Error: unknown option for git-worktree-cd: $arg" >&2
        echo "Run 'git-worktree-cd --help' for usage." >&2
        return 1
        ;;
    esac
  done

  # worktrunk: CLI for Git worktree management, designed for parallel AI agent workflows (https://worktrunk.dev)
  #   Worktrunk only changes the current shell directory through its generated shell function; the standalone
  #   binary cannot cd the parent shell.
  if (( use_worktrunk && $+functions[wt] && $+commands[wt] )); then
    wt switch-with-early-path-column
    return
  fi

  if ! (( $+commands[fzf] )); then
    echo "Error: fzf is required for git-worktree-cd when Worktrunk (wt) shell integration is unavailable" >&2
    return 1
  fi

  local worktree_dir="$(git worktree list --porcelain | awk '/^worktree / { print substr($0, 10) }' | fzf)" || return

  if [[ -n "$worktree_dir" ]]; then
    if [[ ! -d "$worktree_dir" ]]; then
      echo "Error: selected git worktree path does not exist: $worktree_dir" >&2
      return 1
    fi

    if ! cd "$worktree_dir"; then
      echo "Error: failed to cd into selected git worktree path: $worktree_dir" >&2
      return 1
    fi
  fi
}
