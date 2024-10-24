#!/bin/bash

# Script to format and lint Python application code

# Define the target file
TARGET_FILE="app.py"

# Check if the target file exists
if [[ ! -f "$TARGET_FILE" ]]; then
    echo "Error: $TARGET_FILE not found!"
    exit 1
fi

# Format the code using Black
echo "Formatting code with Black..."
black "$TARGET_FILE"

# Sort imports using isort
echo "Sorting imports with isort..."
isort "$TARGET_FILE"

# Lint the code using flake8
echo "Linting code with flake8..."
flake8 "$TARGET_FILE"

echo "Code formatting and linting completed successfully."