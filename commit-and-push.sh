#!/bin/sh
set -eu

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "This script must be run inside a git repository." >&2
  exit 1
fi

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

git add .

if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

if [ "$#" -gt 0 ]; then
  commit_message="$*"
else
  file_count=$(git diff --cached --name-only | wc -l | tr -d ' ')

  if [ "$file_count" -eq 1 ]; then
    file=$(git diff --cached --name-only)
    base=${file##*/}
    dir=${file%/*}

    if [ "$dir" = "$file" ]; then
      commit_message="Update $base"
    else
      commit_message="Update $base in $dir"
    fi
  else
    top_count=$(git diff --cached --name-only | awk -F/ '{print $1}' | sort -u | wc -l | tr -d ' ')

    if [ "$top_count" -eq 1 ]; then
      top_path=$(git diff --cached --name-only | awk -F/ '{print $1}' | sort -u)
      commit_message="Update $top_path files"
    elif [ "$top_count" -le 3 ]; then
      top_paths=$(git diff --cached --name-only | awk -F/ '{print $1}' | sort -u | awk 'BEGIN { out = "" } { out = out ? out ", " $0 : $0 } END { print out }')
      commit_message="Update $file_count files in $top_paths"
    else
      commit_message="Update $file_count files"
    fi
  fi
fi

echo "Committing with message: $commit_message"
git commit -m "$commit_message"
git push
