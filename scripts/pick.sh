#!/bin/bash

# List all script files (.sh) in the current directory and subdirectories
echo "Available scripts:"
mapfile -t script_files < <(find ~/scripts/ -type f -name "*.sh")

# Check if there are any script files
if [ ${#script_files[@]} -eq 0 ]; then
  echo "No scripts found."
  exit 1
fi

# Display the list of script files with indices
for i in "${!script_files[@]}"; do
  echo "[$i] ${script_files[$i]}"
done

# Prompt the user to choose a script by index
echo ""
read -p "Enter the index of the script you want to run: " index

# Check if the entered index is valid
if ! [[ "$index" =~ ^[0-9]+$ ]] || [ "$index" -ge ${#script_files[@]} ]; then
  echo "Invalid index."
  exit 1
fi

# Get the selected script file
SCRIPT_FILE="${script_files[$index]}"

# Make the script executable (if it is not already)
chmod +x "$SCRIPT_FILE"

echo ""

# Execute the selected script
"$SCRIPT_FILE"
