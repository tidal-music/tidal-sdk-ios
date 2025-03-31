#!/bin/bash

# Define the input and output directories
input_dir="Config/input"
output_dir="Generated"

# Step 1: Clear the contents of the input directory
rm -rf "$input_dir"/*
mkdir -p "$input_dir"

# Step 2: Download the JSON files and save them in the input directory
echo "Dowloading API specs from developer.tidal.com"

curl -o "$input_dir/tidal-api-oas-prod.json" https://developer.tidal.com/specs/tidal/tidal-api/tidal-api-oas-prod.json
#curl -o "$input_dir/tidal-catalog-v2-openapi-3.0.json" https://developer.tidal.com/apiref/api-specifications/api-public-catalogue-jsonapi/tidal-catalog-v2-openapi-3.0.json
#curl -o "$input_dir/tidal-search-v2-openapi-3.0.json" https://developer.tidal.com/apiref/api-specifications/api-public-search-jsonapi/tidal-search-v2-openapi-3.0.json
#curl -o "$input_dir/tidal-user-v2-openapi-3.0.json" https://developer.tidal.com/apiref/api-specifications/api-public-user-jsonapi/tidal-user-v2-openapi-3.0.json
#curl -o "$input_dir/tidal-user-content-openapi-3.0.json" https://developer.tidal.com/apiref/api-specifications/api-public-user-content/tidal-user-content-openapi-3.0.json

# Step 3: Clear the contents of the output directory
echo "Clear the contents of the output directory"
rm -rf "$output_dir"/*
mkdir -p "$output_dir"

# Step 4: Loop through all JSON files in the input folder
for json_file in "$input_dir"/*.json; do
  # Run the OpenAPI generator for each JSON file
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
