#!/usr/bin/env bash
set -euo pipefail

# 批量设置子模块远程 URL
# 用法：
#   scripts/set-remote-urls.sh RoboCOIN git@github.com:org/RoboCOIN.git \
#                              DataManage git@github.com:org/DataManage.git ...
# 或提供一个映射文件：每行 'name url'，传入 --file <path>

MAP_FILE=""
if [ "${1:-}" = "--file" ]; then
  MAP_FILE="$2"; shift 2 || true
fi

if [ -n "$MAP_FILE" ]; then
  while read -r name url; do
    [ -z "$name" ] && continue
    [ "${name#\#}" != "$name" ] && continue  # skip comments
    echo "Setting $name => $url"
    git submodule set-url "$name" "$url"
    # If submodule working tree exists, also update its 'origin' remote
    if [ -d "$name/.git" ]; then
      git -C "$name" remote set-url origin "$url" || true
    fi
  done < "$MAP_FILE"
else
  if [ $(( $# % 2 )) -ne 0 ]; then
    echo "Error: expect pairs of <name> <url> or --file <path>" >&2
    exit 1
  fi
  while [ $# -gt 0 ]; do
    name="$1"; url="$2"; shift 2
    echo "Setting $name => $url"
    git submodule set-url "$name" "$url"
    if [ -d "$name/.git" ]; then
      git -C "$name" remote set-url origin "$url" || true
    fi
  done
fi

echo "Syncing submodule config..."
 git submodule sync --recursive

echo "Done."
