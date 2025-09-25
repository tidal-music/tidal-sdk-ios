#!/bin/bash

set -e

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && cd .. && pwd)
readonly ROOT_DIR

VERSION_FILE="$ROOT_DIR/version.txt"
readonly VERSION_FILE

# Usage function
usage() {
    echo "Usage: $0 [major|minor|patch]"
    echo "Bumps the version in version.txt"
    echo ""
    echo "Arguments:"
    echo "  major  Bump major version (X.0.0)"
    echo "  minor  Bump minor version (X.Y.0)"
    echo "  patch  Bump patch version (X.Y.Z)"
    echo ""
    echo "If no argument provided, defaults to patch bump"
    exit 1
}

# Validate version file exists
if [ ! -f "$VERSION_FILE" ]; then
    echo "Error: Version file '$VERSION_FILE' not found"
    exit 1
fi

# Read current version
current_version=$(cat "$VERSION_FILE" | tr -d '\n')

# Validate version format
if ! [[ $current_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid version format in '$VERSION_FILE': '$current_version'"
    echo "Expected format: X.Y.Z (e.g., 1.2.3)"
    exit 1
fi

# Parse version components
IFS='.' read -r major minor patch <<< "$current_version"

# Determine bump type (default to patch)
bump_type="${1:-patch}"

case "$bump_type" in
    major)
        major=$((major + 1))
        minor=0
        patch=0
        ;;
    minor)
        minor=$((minor + 1))
        patch=0
        ;;
    patch)
        patch=$((patch + 1))
        ;;
    *)
        echo "Error: Invalid bump type '$bump_type'"
        usage
        ;;
esac

# Create new version
new_version="$major.$minor.$patch"

echo "Bumping version from $current_version to $new_version"

# Write new version to file
echo "$new_version" > "$VERSION_FILE"

echo "Version successfully updated to $new_version"