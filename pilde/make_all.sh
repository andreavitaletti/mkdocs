#!/bin/bash

# Define the range of years
START_YEAR=2006
END_YEAR=2021

# Define the file pattern prefix
PREFIX="blog_"

# Loop through the range of years
for year in $(seq $START_YEAR $END_YEAR); do
    # Define the input file name
    INPUT_FILE="${PREFIX}${year}.md"

    # Check if the file exists
    if [[ -f "$INPUT_FILE" ]]; then
        echo "Processing $INPUT_FILE..."

        # Define the output file name
        OUTPUT_FILE="${PREFIX}${year}.pdf"  # Adjust extension for desired output format

        # Run pandoc
        pandoc "$INPUT_FILE" -o "$OUTPUT_FILE"

        echo "Converted $INPUT_FILE to $OUTPUT_FILE."
    else
        echo "File $INPUT_FILE not found, skipping."
    fi
done
