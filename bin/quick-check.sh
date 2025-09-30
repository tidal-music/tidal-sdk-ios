#!/usr/bin/env bash
set -euo pipefail

# Fast validation for changed files + quick build sanity check.
# Usage:
#   bin/quick-check.sh [files...]

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd .. && pwd)"

FILES=("$@")
if [[ ${#FILES[@]} -eq 0 ]]; then
  # Default to staged Swift files; if none, all tracked Swift files
  while IFS= read -r file; do
    FILES+=("$file")
  done < <(git --no-pager diff --name-only --diff-filter=ACM --cached | grep -E '\.swift$' || true)

  if [[ ${#FILES[@]} -eq 0 ]]; then
    while IFS= read -r file; do
      FILES+=("$file")
    done < <(git ls-files | grep -E '\.swift$' || true)
  fi
fi

echo "Quick Check"
echo "============"
echo "Files: ${FILES[*]:-<none>}"
echo

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "No Swift files to check. Skipping format and lint."
  echo
else
  echo "1) SwiftFormat (lint-only)"
  if command -v swiftformat >/dev/null 2>&1; then
    swiftformat --config "$ROOT_DIR/.swiftformat" --lint "${FILES[@]}"
  else
    echo "swiftformat not found. Install with: brew install swiftformat" >&2
  fi
  echo

  echo "2) SwiftLint (targeted)"
  "$ROOT_DIR/bin/swiftlint/run-swiftlint.sh" -i "${FILES[*]}"
  echo
fi

echo "3) Build (SPM)"
swift build
echo

echo "4) Tests (SPM quick pass; Player skipped)"
swift test --skip PlayerTests
echo

echo "Quick check completed."

