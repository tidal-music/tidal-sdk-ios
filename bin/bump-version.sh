#!/bin/bash

set -e

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && cd .. && pwd)
readonly ROOT_DIR

VERSION_FILE="$ROOT_DIR/version.txt"
readonly VERSION_FILE

CHANGELOG_FILE="$ROOT_DIR/CHANGELOG.md"
readonly CHANGELOG_FILE

TIDAL_API_SPEC_FILE="$ROOT_DIR/Sources/TidalAPI/Config/input/tidal-api-oas.json"
readonly TIDAL_API_SPEC_FILE

# Usage function
usage() {
    echo "Usage: $0 [major|minor|patch] [changelog_entry]"
    echo "Bumps the version in version.txt and updates CHANGELOG.md"
    echo ""
    echo "Arguments:"
    echo "  major|minor|patch  Version bump type (defaults to patch)"
    echo "  changelog_entry    Text entry to add to changelog (optional)"
    echo ""
    echo "Examples:"
    echo "  $0 patch \"Generated API code using spec version 0.1.79\""
    echo "  $0 minor"
    echo ""
    echo "The script will:"
    echo "  1. Bump the version in version.txt"
    echo "  2. Add a new changelog entry with provided text (if any)"
    echo "  3. Move any Unreleased items to the new version section"
    exit 1
}

# Validate required files exist
if [ ! -f "$VERSION_FILE" ]; then
    echo "Error: Version file '$VERSION_FILE' not found"
    exit 1
fi

if [ ! -f "$CHANGELOG_FILE" ]; then
    echo "Error: Changelog file '$CHANGELOG_FILE' not found"
    exit 1
fi


# Helper function to insert version section
insert_version_section() {
    local temp_file="$1"
    local new_version="$2"
    local current_date="$3"
    local changelog_entry="$4"
    local unreleased_content="$5"

    echo "## [$new_version] - $current_date" >> "$temp_file"
    echo "" >> "$temp_file"

    # Add the provided changelog entry if any
    if [ -n "$changelog_entry" ]; then
        echo "### Changed" >> "$temp_file"
        echo "- $changelog_entry (TidalAPI)" >> "$temp_file"
        echo "" >> "$temp_file"
    fi

    # Add unreleased content if any
    if [ -n "$unreleased_content" ]; then
        printf '%s' "$unreleased_content" >> "$temp_file"
    fi
}

# Helper function to collect unreleased content
collect_unreleased_content() {
    local changelog_file="$1"
    local inside_unreleased=false
    local unreleased_content=""
    local found_unreleased=false

    while IFS= read -r line; do
        if [[ "$line" =~ ^##[[:space:]]*\[Unreleased\] ]]; then
            found_unreleased=true
            inside_unreleased=true
            continue
        elif [[ "$line" =~ ^##[[:space:]]*\[ ]] && [ "$inside_unreleased" = true ]; then
            # End of Unreleased section
            break
        elif [ "$inside_unreleased" = true ] && [ -n "$line" ]; then
            # Collect unreleased content with proper newlines
            unreleased_content="${unreleased_content}${line}"$'\n'
        fi
    done < "$changelog_file"

    # Output results (found_unreleased|unreleased_content)
    echo "${found_unreleased}|${unreleased_content}"
}

# Function to update changelog
update_changelog() {
    local new_version="$1"
    local changelog_entry="$2"
    local current_date=$(date +%Y-%m-%d)
    local unreleased_content
    local found_unreleased

    # Collect unreleased content first
    local result=$(collect_unreleased_content "$CHANGELOG_FILE")
    local found_unreleased="${result%%|*}"
    local unreleased_content="${result#*|}"

    if [ "$found_unreleased" = true ]; then
        update_changelog_with_unreleased "$new_version" "$current_date" "$changelog_entry" "$unreleased_content"
    else
        update_changelog_without_unreleased "$new_version" "$current_date" "$changelog_entry"
    fi

    # Add empty Unreleased section at the top
    add_unreleased_section
}

# Handle changelog update when Unreleased section exists
update_changelog_with_unreleased() {
    local new_version="$1"
    local current_date="$2"
    local changelog_entry="$3"
    local unreleased_content="$4"
    local temp_file=$(mktemp)
    local inside_unreleased=false

    while IFS= read -r line; do
        if [[ "$line" =~ ^##[[:space:]]*\[Unreleased\] ]]; then
            inside_unreleased=true
            continue
        elif [[ "$line" =~ ^##[[:space:]]*\[ ]] && [ "$inside_unreleased" = true ]; then
            # Insert new version entry
            insert_version_section "$temp_file" "$new_version" "$current_date" "$changelog_entry" "$unreleased_content"
            inside_unreleased=false
            echo "$line" >> "$temp_file"
        elif [ "$inside_unreleased" = false ]; then
            echo "$line" >> "$temp_file"
        fi
    done < "$CHANGELOG_FILE"

    mv "$temp_file" "$CHANGELOG_FILE"
}

# Handle changelog update when no Unreleased section exists
update_changelog_without_unreleased() {
    local new_version="$1"
    local current_date="$2"
    local changelog_entry="$3"
    local temp_file=$(mktemp)
    local header_passed=false

    while IFS= read -r line; do
        echo "$line" >> "$temp_file"

        # Insert new version before first existing version
        if [ "$header_passed" = false ] && [[ "$line" =~ ^##[[:space:]]*\[ ]]; then
            echo "" >> "$temp_file"
            insert_version_section "$temp_file" "$new_version" "$current_date" "$changelog_entry" ""
            header_passed=true
        fi
    done < "$CHANGELOG_FILE"

    mv "$temp_file" "$CHANGELOG_FILE"
}

# Add empty Unreleased section at the top
add_unreleased_section() {
    local temp_file=$(mktemp)
    local added_unreleased=false

    while IFS= read -r line; do
        # Insert empty Unreleased section before first version
        if [ "$added_unreleased" = false ] && [[ "$line" =~ ^##[[:space:]]*\[ ]]; then
            echo "## [Unreleased]" >> "$temp_file"
            echo "" >> "$temp_file"
            added_unreleased=true
        fi
        echo "$line" >> "$temp_file"
    done < "$CHANGELOG_FILE"

    mv "$temp_file" "$CHANGELOG_FILE"
}

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

# Parse arguments
bump_type="${1:-patch}"
changelog_entry="$2"

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

# Update changelog
update_changelog "$new_version" "$changelog_entry"

if [ -n "$changelog_entry" ]; then
    echo "Version successfully updated to $new_version and changelog updated with entry: $changelog_entry"
else
    echo "Version successfully updated to $new_version and changelog updated (unreleased items moved)"
fi