#!/bin/bash

# Script to format and lint Python test files

# Define the target directories and files
FUNCTIONAL_TESTS_DIR="tests/functional"
UNIT_TESTS_DIR="tests/unit"

# Array of functional test files
FUNCTIONAL_TEST_FILES=("test_workflow.py")

# Array of unit test files
UNIT_TEST_FILES=("test_ingest_data.py")

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

# Check if functional tests directory exists
if [[ ! -d "$FUNCTIONAL_TESTS_DIR" ]]; then
    echo "Error: Directory $FUNCTIONAL_TESTS_DIR not found!"
    exit 1
fi

# Check if unit tests directory exists
if [[ ! -d "$UNIT_TESTS_DIR" ]]; then
    echo "Error: Directory $UNIT_TESTS_DIR not found!"
    exit 1
fi

# Process functional test files
for file in "${FUNCTIONAL_TEST_FILES[@]}"; do
    format_and_lint "$FUNCTIONAL_TESTS_DIR/$file"
done

# Process unit test files
for file in "${UNIT_TEST_FILES[@]}"; do
    format_and_lint "$UNIT_TESTS_DIR/$file"
done

echo "Code formatting and linting completed successfully for all test files."