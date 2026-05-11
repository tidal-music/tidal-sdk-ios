#!/bin/bash
#
# Reports whether the repo has unreleased work that warrants a new release.
#
# Strategy:
#   - "Last release" = the commit that most recently changed version.txt.
#     This is more reliable than `git tag` because tags only appear after
#     a draft GitHub release is published manually.
#   - Lists non-merge commits since that point.
#   - Flags TidalAPI spec drift between the repo (Sources/TidalAPI/Config/input/
#     tidal-api-oas.json) and the most recent `(TidalAPI)` line in CHANGELOG.md.
#   - Reports whether ## [Unreleased] reflects what landed.
#
# Exit codes:
#   0 = release recommended
#   1 = nothing new since the last bump (skip release)
#   2 = error / cannot determine

set -eu

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../../.. && pwd)
readonly ROOT_DIR
cd "$ROOT_DIR"

CHANGELOG_FILE="$ROOT_DIR/CHANGELOG.md"
VERSION_FILE="$ROOT_DIR/version.txt"
API_SPEC_FILE="$ROOT_DIR/Sources/TidalAPI/Config/input/tidal-api-oas.json"

if [ ! -f "$CHANGELOG_FILE" ] || [ ! -f "$VERSION_FILE" ]; then
  echo "❌ CHANGELOG.md or version.txt not found at repo root ($ROOT_DIR)"
  exit 2
fi

current_version=$(tr -d '\n' < "$VERSION_FILE")

# The commit that last changed version.txt is our "released baseline".
last_bump_commit=$(git log -1 --format=%H -- version.txt 2>/dev/null || true)

if [ -z "$last_bump_commit" ]; then
  echo "❌ Could not find a commit that touched version.txt."
  exit 2
fi

last_bump_short=$(git rev-parse --short "$last_bump_commit")
last_bump_subject=$(git log -1 --format=%s "$last_bump_commit")

echo "version.txt        : $current_version"
echo "last bump commit   : $last_bump_short  $last_bump_subject"
echo ""

# ---- Commits since the last bump (excluding merge commits, excluding the bump itself) ----
commit_count=$(git log --no-merges --oneline "$last_bump_commit"..HEAD 2>/dev/null | wc -l | tr -d ' ')

if [ "$commit_count" -eq 0 ]; then
  echo "✅ No commits since the last version bump — release not needed."
  exit 1
fi

echo "🔎 $commit_count non-merge commit(s) since last bump:"
git log --no-merges --pretty='format:   %h %s' "$last_bump_commit"..HEAD
echo ""
echo ""

# ---- Bump-type heuristic ----
#
# major  : any commit subject contains "BREAKING" or a conventional-commit "!:"
# minor  : any commit looks additive (Add/Added, feat:)
# patch  : everything else (fixes, regens, chores)
suggested_bump="patch"
subjects=$(git log --no-merges --pretty='format:%s' "$last_bump_commit"..HEAD)

if echo "$subjects" | grep -Eq 'BREAKING|^[A-Za-z]+(\([^)]+\))?!:'; then
  suggested_bump="major"
elif echo "$subjects" | grep -Eq '^(Add |Added |add |feat:|feat\(|.*: Add )'; then
  suggested_bump="minor"
fi

echo "🎯 Suggested bump type: $suggested_bump"
echo ""

# ---- TidalAPI spec drift ----
spec_drift=false
suggested_entry=""
if [ -f "$API_SPEC_FILE" ] && command -v jq >/dev/null 2>&1; then
  current_spec=$(jq -r '.info.version' "$API_SPEC_FILE" 2>/dev/null || echo "")
  last_changelog_spec=$(grep -Eo 'Generated API code using spec version [0-9]+\.[0-9]+\.[0-9]+' "$CHANGELOG_FILE" \
    | head -n1 \
    | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' || echo "")

  if [ -n "$current_spec" ] && [ -n "$last_changelog_spec" ] && [ "$current_spec" != "$last_changelog_spec" ]; then
    spec_drift=true
    suggested_entry="Generated API code using spec version $current_spec"
    echo "⚠️  TidalAPI spec drift:"
    echo "    repo spec version : $current_spec"
    echo "    last in changelog : $last_changelog_spec"
    echo "    → suggested entry : $suggested_entry"
    echo ""
  fi
fi

# ---- Unreleased section emptiness ----
unreleased_content=$(awk '/^## \[Unreleased\]/{flag=1; next} /^## \[/{flag=0} flag {print}' "$CHANGELOG_FILE" \
  | sed '/^[[:space:]]*$/d')

if [ -z "$unreleased_content" ]; then
  echo "⚠️  ## [Unreleased] section is empty."
  echo "    Commits have landed but the changelog has not been updated."
  echo ""
  echo "    Suggested next steps:"
  echo "      ./.agents/skills/prepare-release/scripts/suggest-changelog.sh   # draft entries"
  if [ "$spec_drift" = true ]; then
    echo "      ./.agents/skills/prepare-release/scripts/bump-version.sh $suggested_bump \"$suggested_entry\""
  else
    echo "      ./.agents/skills/prepare-release/scripts/bump-version.sh $suggested_bump"
  fi
else
  echo "ℹ️  ## [Unreleased] currently contains:"
  echo "$unreleased_content" | sed 's/^/    /'
fi
echo ""

echo "✅ Release recommended."
exit 0
