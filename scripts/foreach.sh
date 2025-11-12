#!/usr/bin/env bash
set -euo pipefail

# 在所有子模块中执行命令
# 用法：scripts/foreach.sh 'git status'

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 '<command>'" >&2
  exit 1
fi

cmd="$1"
shift || true

exec git submodule foreach --recursive "$cmd"
