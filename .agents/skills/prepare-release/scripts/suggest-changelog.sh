#!/bin/bash
#
# Drafts changelog entries for unreleased commits, grouped by category and
# suffixed with the module scope (e.g. "(Player)") used by this repo.
#
# Strategy:
#   - Walks non-merge commits since the commit that last touched version.txt.
#   - Strips a leading `Module:` prefix from the subject and re-adds it as
#     a `(Module)` suffix to match the existing CHANGELOG.md style.
#   - Categorizes by leading verb:
#       Add/Added/feat       -> ### Added
#       Fix/Fixed/fix        -> ### Fixed
#       Remove/Removed       -> ### Removed
#       Deprecate/Deprecated -> ### Deprecated
#       everything else      -> ### Changed
#   - Folds repeated `Update Tidal API - N files changed` commits into a
#     single `Generated API code using spec version <X.Y.Z> (TidalAPI)`
#     line based on Sources/TidalAPI/Config/input/tidal-api-oas.json.
#
# Output is markdown on stdout — review it, then paste into ## [Unreleased]
# (or use as the basis for the entry passed to bump-version.sh).

set -eu

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && cd ../../../.. && pwd)
readonly ROOT_DIR
cd "$ROOT_DIR"

API_SPEC_FILE="$ROOT_DIR/Sources/TidalAPI/Config/input/tidal-api-oas.json"

last_bump_commit=$(git log -1 --format=%H -- version.txt 2>/dev/null || true)
if [ -z "$last_bump_commit" ]; then
  echo "❌ Could not find a commit that touched version.txt." >&2
  exit 2
fi

added=""
changed=""
fixed=""
removed=""
deprecated=""
saw_tidal_api=false

# Read commits oldest -> newest so the changelog reads chronologically.
while IFS= read -r subject; do
  [ -z "$subject" ] && continue

  # Skip noise commits that should never be release notes.
  case "$subject" in
    "Bump version to "*) continue ;;
    "Release v"*)        continue ;;
    "Update changelog "*) continue ;;
    "Merge pull request"*|"Merge branch"*|"Merge remote-tracking"*) continue ;;
    "typo"|"Typo"|"fix typo"|"Fix typo") continue ;;
  esac

  # Fold all "Update Tidal API ..." commits into one entry.
  if [[ "$subject" =~ ^Update[[:space:]]Tidal[[:space:]]API ]]; then
    saw_tidal_api=true
    continue
  fi

  # Extract module scope from `Module: rest of subject`.
  scope=""
  body="$subject"
  if [[ "$subject" =~ ^([A-Za-z][A-Za-z0-9]+):[[:space:]]*(.*)$ ]]; then
    candidate_scope="${BASH_REMATCH[1]}"
    candidate_body="${BASH_REMATCH[2]}"
    # Only treat as a scope if it looks like one of the repo's modules.
    case "$candidate_scope" in
      Player|Offliner|Auth|EventProducer|TidalAPI|Common|Template)
        scope="$candidate_scope"
        body="$candidate_body"
        ;;
    esac
  fi

  # Categorize by leading verb of the (descoped) body.
  category="changed"
  case "$body" in
    Add\ *|Added\ *|add\ *|added\ *|feat:*|Feat:*) category="added" ;;
    Fix\ *|Fixed\ *|fix\ *|fixed\ *|fix:*|Fix:*)   category="fixed" ;;
    Remove\ *|Removed\ *|remove\ *|removed\ *|Delete\ *|Deleted\ *|delete\ *) category="removed" ;;
    Deprecate\ *|Deprecated\ *|deprecate\ *|deprecated\ *) category="deprecated" ;;
  esac

  # Capitalize the first letter of the body for consistent style.
  first_char=$(printf '%s' "$body" | cut -c1 | tr '[:lower:]' '[:upper:]')
  rest=$(printf '%s' "$body" | cut -c2-)
  body="$first_char$rest"

  if [ -n "$scope" ]; then
    line="- $body ($scope)"
  else
    line="- $body"
  fi

  case "$category" in
    added)      added="$added$line"$'\n' ;;
    changed)    changed="$changed$line"$'\n' ;;
    fixed)      fixed="$fixed$line"$'\n' ;;
    removed)    removed="$removed$line"$'\n' ;;
    deprecated) deprecated="$deprecated$line"$'\n' ;;
  esac
done < <(git log --no-merges --reverse --pretty='tformat:%s' "$last_bump_commit"..HEAD)

# Synthesize the rolled-up TidalAPI entry, if any.
if [ "$saw_tidal_api" = true ]; then
  spec_version=""
  if [ -f "$API_SPEC_FILE" ] && command -v jq >/dev/null 2>&1; then
    spec_version=$(jq -r '.info.version' "$API_SPEC_FILE" 2>/dev/null || echo "")
  fi
  if [ -n "$spec_version" ]; then
    changed="$changed- Generated API code using spec version $spec_version (TidalAPI)"$'\n'
  else
    changed="$changed- Regenerated TidalAPI client (TidalAPI)"$'\n'
  fi
fi

if [ -z "$added$changed$fixed$removed$deprecated" ]; then
  echo "(No release-worthy commits found since the last bump.)" >&2
  exit 1
fi

# Emit markdown.
print_section() {
  local heading="$1"
  local body="$2"
  if [ -n "$body" ]; then
    echo "$heading"
    printf '%s' "$body"
    echo ""
  fi
}

print_section "### Added"      "$added"
print_section "### Changed"    "$changed"
print_section "### Fixed"      "$fixed"
print_section "### Removed"    "$removed"
print_section "### Deprecated" "$deprecated"
