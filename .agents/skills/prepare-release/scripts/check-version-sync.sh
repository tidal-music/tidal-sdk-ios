#!/bin/bash

if grep -q "$(cat ./version.txt)" ./CHANGELOG.md; then
  echo "✅ Version string "$(cat ./version.txt)" found in CHANGELOG.md"
  exit 0
else
  echo "⛔️ String "$(cat ./version.txt)" not found in CHANGELOG.md"
  exit 1
fi
