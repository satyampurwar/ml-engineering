#!/bin/bash

# Script to format and lint Python files in the housing_value directory

# Define the target directory and files
TARGET_DIR="src/housing_value"
FILES=("ingest_data.py" "utility.py" "train.py" "score.py")

# Check if the target directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: Directory $TARGET_DIR not found!"
    exit 1
fi

# Function to format and lint a file
format_and_lint() {
    local file="$1"

    echo "Processing $file..."
    
    # Format the code using Black
    black "$file" || { echo "Error formatting $file with Black"; exit 1; }

    # Sort imports using isort
    isort "$file" || { echo "Error sorting imports in $file with isort"; exit 1; }

    # Lint the code using flake8
    flake8 "$file" || { echo "Linting errors found in $file"; }
}

# Iterate over each file and process it
for file in "${FILES[@]}"; do
    format_and_lint "$TARGET_DIR/$file"
done

echo "Code formatting and linting completed successfully for all files."