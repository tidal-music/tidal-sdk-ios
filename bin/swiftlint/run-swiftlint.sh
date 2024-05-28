#!/bin/bash

# Run this script to execute SwiftLint version as specified in bin/swiftlint/version.txt.
# If non-existent, SwiftLint will be downloaded and installed. You can specify a
# different location via argument. Example: './run-swiftlint.sh [PATH-TO-MY-SWIFTLINT]'
# This is useful to debug issues bettween versions, if needed.
# Specify files to be linted by appending them to the -i parameter.
# Example: './run-swiftlint.sh -i "File1.swift File2.swift File3.swift'

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../.. && pwd)
readonly ROOT_DIR

CONFIG_DIR="$ROOT_DIR/bin/swiftlint"
readonly CONFIG_DIR

SWIFTLINT_VERSION=$(<"$CONFIG_DIR/swiftlint-cli-version.txt")
readonly SWIFTLINT_VERSION

INSTALL_DIR="$ROOT_DIR/bin/swiftlint"
readonly INSTALL_DIR

exists() {
  command -v "$1" >/dev/null 2>&1
}

getSwiftLint() {
  rm "$INSTALL_DIR/swiftlint" 2>/dev/null || true
  rm "$INSTALL_DIR/LICENSE" 2>/dev/null || true
  mkdir -p "$INSTALL_DIR"

  # Checking the used OS. Darwin is MacOs. For our usecase we can safely assume every other
  # result means Linux.
  if [ "$(uname)" == "Darwin" ]; then
    archive_name="portable_swiftlint.zip"
  else
    archive_name="swiftlint_linux.zip"

  fi
  curl -sSLO "https://github.com/realm/SwiftLint/releases/download/$SWIFTLINT_VERSION/$archive_name"
  unzip "$archive_name" -d "$INSTALL_DIR"
  rm "$archive_name"
  command="$INSTALL_DIR/swiftlint"
}

set -e
echo
echo "Running SwiftLint version $SWIFTLINT_VERSION"

# Analyze inputs
input=()
while getopts ":e:i:" opt; do
  case $opt in
  e)
    command="$OPTARG"
    ;;
  i)
    input+=($OPTARG)
    ;;
  \?)
    echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  case $OPTARG in
  -*)
    echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done

# Looking for SwiftLint
if exists "$command"; then
  echo "SwiftLint found at submitted location."
elif exists "$INSTALL_DIR/swiftlint"; then
  command="$INSTALL_DIR/swiftlint"
  echo "SwiftLint found in $INSTALL_DIR."

  # Safeguard correct version
  installed_version="$($command --version)"
  if [ "$installed_version" != "$SWIFTLINT_VERSION" ]; then
    echo "SwiftLint version $installed_version outdated! Updating to $SWIFTLINT_VERSION..."
    getSwiftLint

  fi
else
  echo "SwiftLint not found. Installing into $INSTALL_DIR/..."
  getSwiftLint
fi

# Build files argument with all files to analyze
files_argument=""
for i in "${input[@]}"; do
  files_argument="$files_argument\"$i\" "
  echo "$files_argument"
done

# Run linter
echo
echo "Running SwiftLint..."
command="$command $files_argument"
eval "$command"
echo "Done."
