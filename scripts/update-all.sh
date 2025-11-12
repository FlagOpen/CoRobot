#!/usr/bin/env bash
set -euo pipefail

# 更新所有子模块到远程跟踪分支并合并
# 可选参数：传递给 `git submodule update`，如 --remote --merge --recursive（默认已启用）

exec git -c protocol.file.allow=always submodule update --init --recursive --remote --merge "$@"
