#!/usr/bin/env bash
set -euo pipefail

echo "Initializing and updating submodules..."
git submodule init
git submodule update --init --recursive

echo "Done."
