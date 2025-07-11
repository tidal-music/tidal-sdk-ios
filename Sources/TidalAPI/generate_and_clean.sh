#!/bin/bash

# Define the input and output directories
input_dir="Config/input"
output_dir="Generated"

# Parse command line arguments
SKIP_DOWNLOAD=false
LOCAL_FILE=""

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --skip-download)
      SKIP_DOWNLOAD=true
      shift
      ;;
    --local-file)
      LOCAL_FILE="$2"
      SKIP_DOWNLOAD=true
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# Display usage information
usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --skip-download         Skip downloading the API spec (use existing files in input dir)"
  echo "  --local-file <path>     Use a local OpenAPI JSON file instead of downloading"
  exit 1
}

# Step 1: Clear the contents of the input directory (only if not using existing files)
if [ "$SKIP_DOWNLOAD" = false ]; then
  echo "Clearing the contents of the input directory"
  rm -rf "$input_dir"/*
  mkdir -p "$input_dir"

  # Step 2: Download the JSON files and save them in the input directory
  echo "Downloading API specs from developer.tidal.com"
  curl -o "$input_dir/tidal-api-oas.json" https://tidal-music.github.io/tidal-api-reference/tidal-api-oas.json
elif [ -n "$LOCAL_FILE" ]; then
  echo "Using local file: $LOCAL_FILE"
  # Check if the local file exists
  if [ ! -f "$LOCAL_FILE" ]; then
    echo "Error: Local file '$LOCAL_FILE' not found."
    exit 1
  fi
  
  # Clear the input directory and copy the local file
  echo "Clearing the contents of the input directory"
  rm -rf "$input_dir"/*
  mkdir -p "$input_dir"
  
  # Copy the local file to the input directory
  cp "$LOCAL_FILE" "$input_dir/tidal-api-oas.json"
  echo "Copied local file to $input_dir/tidal-api-oas.json"
else
  echo "Skipping API spec download, using existing files in $input_dir"
fi

# Step 3: Clear the contents of the output directory
echo "Clearing the contents of the output directory"
rm -rf "$output_dir"/*
mkdir -p "$output_dir"

# Step 4: Loop through all JSON files in the input folder
for json_file in "$input_dir"/*.json; do
  echo "Generating Swift code for $(basename "$json_file")"
  openapi-generator generate \
    -i "$json_file" \
    -g swift5 \
    -o "$output_dir" \
    -c Config/openapi-config.yml \
    --skip-validate-spec

  # Step 5: Remove the unwanted files
  rm -f "$output_dir/Package.swift"
  rm -f "$output_dir/Cartfile"
  rm -f "$output_dir/git_push.sh"
  rm -f "$output_dir/project.yml"
  rm -f "$output_dir/OpenAPIClient.podspec"
  rm -f "$output_dir/.swiftformat"
  rm -f "$output_dir/.gitignore"
  rm -rf "$output_dir/.openapi-generator"
  rm -f "$output_dir/.openapi-generator-ignore"

  echo "Generation and cleanup completed successfully for $(basename "$json_file")."
done