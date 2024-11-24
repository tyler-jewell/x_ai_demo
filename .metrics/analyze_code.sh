#!/bin/bash

# Create .metrics directory if it doesn't exist
mkdir -p .metrics

# Initialize the JSON file
echo "{" > .metrics/metrics.json

# Function to count non-empty, non-comment lines in a Dart file
count_lines() {
    # Remove empty lines, single-line comments, and multi-line comments
    grep -v '^\s*$' "$1" | \
    grep -v '^\s*\/\/' | \
    grep -v '^\s*\/\*' | \
    grep -v '^\s*\*' | \
    grep -v '^\s*\*\/' | \
    wc -l | tr -d ' '
}

# Function to process directory and write to JSON
process_directory() {
    local dir=$1
    local first_entry=true
    local total_lines=0

    # Process each Dart file
    for file in $(find "$dir" -name "*.dart"); do
        # Get relative path
        rel_path=${file#./}
        
        # Count lines
        lines=$(count_lines "$file")
        total_lines=$((total_lines + lines))

        # Add comma if not first entry
        if [ "$first_entry" = false ]; then
            echo "," >> .metrics/metrics.json
        fi
        first_entry=false

        # Write to JSON
        echo "  \"$rel_path\": $lines" >> .metrics/metrics.json
    done

    echo "$total_lines"
}

# Process lib directory
echo "Processing lib directory..."
lib_total=$(process_directory "lib")

# Add comma between lib and test entries
echo "," >> .metrics/metrics.json

# Process test directory
echo "Processing test directory..."
test_total=$(process_directory "test")

# Close JSON file
echo "}" >> .metrics/metrics.json

# Print totals
echo "----------------------------------------"
echo "Total lines of code (excluding comments and blank lines):"
echo "lib:  $lib_total lines"
echo "test: $test_total lines"
echo "total: $((lib_total + test_total)) lines"
echo "----------------------------------------"
echo "Detailed metrics written to .metrics/metrics.json" 