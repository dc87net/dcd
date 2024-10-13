#!/bin/bash

# Function to segment a multiline string into three columns
segmentlist() {
    local input="$1"

    # Create an array to hold the lines
    lines=()

    # Read the input line by line
    while IFS= read -r line; do
        lines+=("$line\n")
    done <<< "$input"

    # Sort the lines in descending order
    linear=$(echo -e $(cat <<< "${lines[@]}"))

    # Calculate the number of lines
    local totallines=${#linear[@]}
    local rows=$(( (totallines + 2) / 3 ))  # Calculate rows needed for 3 columns

    # Print the lines in three columns
    for ((i = 0; i < rows; i++)); do
        for ((j = 0; j < 3; j++)); do
            index=$((i + j * rows))
            if (( index < totallines )); then
                printf "%-20s" "${lines[index]}"
            fi
        done
        echo
    done
}

# Example usage

segmentlist "$(ls -la)"
