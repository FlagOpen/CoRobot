#!/usr/bin/env bash
set -euo pipefail

# Create GitHub repositories (main + submodules) using GitHub CLI `gh`.
# Requires: gh auth login
#
# Usage examples:
#   scripts/create-github-remotes.sh --org your-org --visibility private
#   scripts/create-github-remotes.sh --visibility public
#
# Options:
#   --org <org>            GitHub organization (omit to use your user account)
#   --visibility <vis>     public|private|internal (default: private)

ORG=""
VIS="private"

while [ $# -gt 0 ]; do
  case "$1" in
    --org)
      ORG="$2"; shift 2;;
    --visibility)
      VIS="$2"; shift 2;;
    *)
      echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: GitHub CLI 'gh' not found. Install from https://cli.github.com/" >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "Error: gh not authenticated. Run 'gh auth login' first." >&2
  exit 1
fi

if [ -n "$ORG" ]; then
  OWNER="$ORG"
else
  OWNER=$(gh api user --jq '.login')
fi

REPOS=(CoRobot RoboCOIN RoboCOIN-DataManage DataTrain DataCollect DataConvert DataForge)

create_repo(){
  local name="$1"
  local full="$OWNER/$name"
  if gh repo view "$full" >/dev/null 2>&1; then
    echo "Repo already exists: $full (skip create)"
    return
  fi
  echo "Creating repo: $full (visibility=$VIS)"
  gh repo create "$full" --$VIS >/dev/null
}

set_remote_and_push(){
  local name="$1"
  local dir="$2"
  local full="$OWNER/$name"
  local url="git@github.com:$full.git"
  (
    cd "$dir"
    if git remote get-url origin >/dev/null 2>&1; then
      git remote set-url origin "$url"
    else
      git remote add origin "$url"
    fi
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD)
    git push -u origin "$branch"
  )
}

for r in "${REPOS[@]}"; do
  create_repo "$r"
done

# Main repo remote
set_remote_and_push CoRobot "."

# Submodules remotes + .gitmodules URLs
for name in RoboCOIN RoboCOIN-DataManage DataTrain DataCollect DataConvert DataForge; do
  set_remote_and_push "$name" "$name"
  git submodule set-url "$name" "git@github.com:$OWNER/$name.git"
  if [ -d "$name/.git" ]; then
    git -C "$name" remote set-url origin "git@github.com:$OWNER/$name.git" || true
  fi
done

git submodule sync --recursive
git add .gitmodules
git commit -m "chore: switch submodules to GitHub remotes" || true

echo "All remotes created and pushed."
