#!/bin/bash

# Get a list of all running containers
containers=($(docker ps --format "{{.Names}}"))

# Check if there are any running containers
if [ ${#containers[@]} -eq 0 ]; then
  echo "No running containers found."
  exit 1
fi

# Display the list of running containers with indices
echo "Available running containers:"
for i in "${!containers[@]}"; do
  # Remove "laradock-" prefix and the final "-{index}" part
  simplified_name=$(echo "${containers[$i]}" | sed -E 's/^laradock-//; s/-[0-9]+$//')
  echo "[$i] $simplified_name"
done

# Prompt the user to choose a container by index
echo ""
read -p "Enter the index of the container you want to access: " index

# Check if the entered index is valid
if ! [[ "$index" =~ ^[0-9]+$ ]] || [ "$index" -ge ${#containers[@]} ]; then
  echo "Invalid index."
  exit 1
fi

# Get the original container name based on the chosen index
CONTAINER_NAME="${containers[$index]}"

# Enter the chosen container using docker exec
docker exec -it $CONTAINER_NAME bash
