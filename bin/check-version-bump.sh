#!/bin/bash

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && cd .. && pwd)
readonly ROOT_DIR

VERSION_FILE="$ROOT_DIR/version.txt"
readonly VERSION_FILE

# see https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
readonly SEMVER_REGEX='(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?'

echo "Checking '$VERSION_FILE'"

last_commit="$(git rev-parse @)"
previous_commit="$(git rev-parse @~)"

# Check if the submitted file exists and is correctly named
verify_file_validity() {
    file=$1
    if [ ! -f "$file" ]; then
        echo "File '$file' not found. Cannot check for version bump in '$DIR'"
        exit 1
    fi
}

# Compare two version entries
is_version_bump() {
    result="false"
    old_version=$1
    new_version=$2

    old_version=${old_version##*:}
    new_version=${new_version##*:}

    if  [[ "$new_version" > "$old_version" ]]; then
        result="true"
    fi
    echo $result
}

verify_file_validity "$VERSION_FILE"

version_diff="$(git diff $previous_commit $last_commit -- "$VERSION_FILE")"
should_build_release=false

if [ -n "$version_diff" ]; then
    old_version=$(echo "$version_diff" | grep '^-' | awk '{print $NF}' | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')
    new_version=$(echo "$version_diff" | grep '^+' | awk '{print $NF}' | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')

    should_build_release=$(is_version_bump "$old_version" "$new_version")
fi

if [ "$should_build_release" == "true" ]; then
    echo "Version bump detected"
    exit 0
else
    echo "No version bump detected"
    exit 1
fi
