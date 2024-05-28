#!/bin/bash

# Script to generate a new module package for the TIDAL iOS SDK
# Run it and follow the prompt

readonly PLACEHOLDER="Template"
ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly ROOT_DIR
readonly SOURCES_DIR="$ROOT_DIR/Sources"
readonly TESTS_DIR="$ROOT_DIR/Tests"

# Validate that our root directory contains a 'Template' dir. The script won't work otherwise
check_correct_repo() {
    if ! find "$SOURCES_DIR" -maxdepth 1 -type d | grep -q "$PLACEHOLDER"; then
        echo "Repository root does not contain a '$PLACEHOLDER' directory!"
        echo "Are you sure you are in the correct project for this script?"
        exit 1
    fi
}

# Ask user for module name
get_user_input() {
    printf "\nEnter new module's name, using PascalCasee\nExample: PlaybackEngine\n" >&2
    read -r input 
    printf "\nDo you want to create a module named '%s'?" "$input" >&2

    read -r -p "(y/n)"
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted!" >&2     
        exit 1
    fi
    echo "$input"
}

# Transform a string to lowercase
lowercase() {
    echo $1 | tr '[:upper:]' '[:lower:]'
}

# Copy template files to new module location
copy_files() {
echo "Copying files to '$SOURCES_DIR/$module_name'..."
rsync -a --exclude='*build/*' --prune-empty-dirs "$SOURCES_DIR"/$PLACEHOLDER/* "$SOURCES_DIR"/$module_name
mkdir "${TESTS_DIR}/${module_name}Tests"
rsync -a --exclude='*build/*' --prune-empty-dirs "$TESTS_DIR"/${PLACEHOLDER}Tests/* "$TESTS_DIR"/${module_name}Tests
}

# Rename 'Template' in new module's filenames to module name
rename_files() {
    target_name=$1

    echo "Rename $PLACEHOLDER to '$target_name'..."
    for file in $(find "$SOURCES_DIR/$target_name" -name "*$PLACEHOLDER*" -type f); do
    echo $file
        if [[ $file == *.swift ]]; then
            fixed=$(echo "$file" | sed "s/$PLACEHOLDER/$target_name/g")
            mv "$file" "$fixed"
        fi
    done

    for file in $(find "$TESTS_DIR/${target_name}Tests" -name "*$PLACEHOLDER*" -type f); do
        if [[ $file == *.swift ]]; then
            fixed=$(echo "$file" | sed "s/$PLACEHOLDER/$target_name/g")
            mv "$file" "$fixed"
        fi
    done
}

# Rename 'Template' keywords in new module's files to module name
rename_keywords() {
    target_name=$1

    echo "Rename keywords in files to '$target_name'..."
    for file in $(find "$SOURCES_DIR/$target_name" -type f); do
        if [[ $file == *.swift || $file == *.md ]]; then
            sed -i '' "s/$PLACEHOLDER/$target_name/g" "$file"
        fi
    done

        echo "Rename keywords in files to '$target_name'..."
    for file in $(find "${TESTS_DIR}/${target_name}Tests" -type f); do
        if [[ $file == *.swift || $file == *.md ]]; then
            sed -i '' "s/$PLACEHOLDER/$target_name/g" "$file"
        fi
    done
}

# Returns the line number above the line of a submitted string, because that is 
# where we want to insert new product entries.
# The first line containing only and ending with '],' indicates the end of the 'products' block, 
# the first line containing only and ending with ']' indicates the end of the 'targets' block.
get_block_end_line() {
    closing_string="$1"
    end_line="$(grep -n -m 1 "    $closing_string$" Package.swift |sed  's/\([0-9]*\).*/\1/')"
    echo "$end_line"
}

get_block_start_line() {
    headline="$1"
    end_line="$(grep -n -m 1 "    $headline$" Package.swift |sed  's/\([0-9]*\).*/\1/')"
    echo "$end_line"
}

# Adds an entry for the new module to the 'products' block in 'Package.swift'
build_products_block() {
    block_header="products: \["
    line_number="$(get_block_start_line "$block_header")"
    line1=$(printf "%*s%s" 8 '' ".library(")
    line2=$(printf "%*s%s" 12 '' "name: \"$1\",")
    line3=$(printf "%*s%s" 12 '' "targets: [\"$1\"]")
    line4=$(printf "%*s%s" 8 '' "),")
    awk -v insert="$line1\n$line2\n$line3\n$line4" "{print} NR==$line_number{print insert}" Package.swift > tmp && mv tmp Package.swift
}

# Adds an entry for the new module to the 'targets' block in 'Package.swift'
build_targets_block() {
    block_header="targets: \["
    line_number="$(get_block_start_line "$block_header")"
    line1=$(printf "%*s%s" 8 '' ".target(name: \"$1\",")
    line2=$(printf "%*s%s" 8 '' "dependencies: [")
    line3=$(printf "%*s%s" 12 '' ".common")
    line4=$(printf "%*s%s" 12 '' "]),")
    line5=$(printf "%*s%s" 8 '' ".testTarget(")
    line6=$(printf "%*s%s" 8 '' "name: \"${1}Tests\",")
    line7=$(printf "%*s%s" 8 '' "dependencies: [")
    line8=$(printf "%*s%s" 12 '' ".$(lowercase "$1")")
    line9=$(printf "%*s%s" 12 '' "]),")
    awk -v insert="$line1\n$line2\n$line3\n$line4\n$line5\n$line6\n$line7\n$line8\n$line9" "{print} NR==$line_number{print insert}" Package.swift > tmp && mv tmp Package.swift
}

# Adds an entry to the extensions to quick-reference the module
add_extension() {
    block_header="// Local"
    line_number="$(get_block_start_line "$block_header")"
    line=$(printf "%*s%s" 4 '' "static let $(lowercase "$1") = byName(name: \"$1\")")
    awk -v insert="$line" "{print} NR==$line_number{print insert}" Package.swift > tmp && mv tmp Package.swift
}

check_correct_repo
module_name="$(echo "$(get_user_input)" | tr -d '\n')"
copy_files
rename_files "$module_name"
rename_keywords "$module_name"
build_products_block "$module_name"
build_targets_block "$module_name" 
add_extension "$module_name" 

echo "Done! Module '$module_name' has been successfully created in '$ROOT_DIR/$module_name' "
