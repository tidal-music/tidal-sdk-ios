#!/bin/bash
#
# Extracts the release-notes section for a given version from CHANGELOG.md.
#
# Usage:
#   extract-release-notes.sh                # latest released section
#   extract-release-notes.sh 0.11.20        # a specific version
#
# Useful for the body of release PRs or GitHub Release drafts.

set -eu

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../../.. && pwd)
readonly ROOT_DIR

CHANGELOG_FILE="$ROOT_DIR/CHANGELOG.md"

if [ ! -f "$CHANGELOG_FILE" ]; then
  echo "❌ CHANGELOG.md not found at $CHANGELOG_FILE" >&2
  exit 2
fi

version="${1:-}"

if [ -z "$version" ]; then
  # First `## [X.Y.Z]` header (skipping `## [Unreleased]`).
  version=$(grep -E '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' "$CHANGELOG_FILE" \
    | head -n1 \
    | sed -E 's/^## \[([0-9]+\.[0-9]+\.[0-9]+)\].*/\1/')
fi

if [ -z "$version" ]; then
  echo "❌ No released version found in $CHANGELOG_FILE" >&2
  exit 2
fi

# Use awk with literal-string matching (index) so [ ] don't need escaping.
notes=$(awk -v target="## [$version]" '
  index($0, target) == 1 { found=1; next }
  found && /^## \[/ { exit }
  found { print }
' "$CHANGELOG_FILE")

# Trim leading/trailing blank lines.
trimmed=$(printf '%s\n' "$notes" | awk 'NF{flag=1} flag{a[++n]=$0} END{for(i=n;i>=1;i--){if(a[i]!=""){last=i;break}} for(i=1;i<=last;i++)print a[i]}')

if [ -z "$trimmed" ]; then
  echo "❌ No notes found for version $version in $CHANGELOG_FILE" >&2
  exit 2
fi

printf '%s\n' "$trimmed"
