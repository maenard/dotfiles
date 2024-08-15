#!/bin/bash

# Set the PostgreSQL credentials
PGUSER="default"
PGCONTAINER="laradock-postgres-1"

# Get the current date in YYYY-MM-DD format
CURRENT_DATE=$(date +%F)

# List all databases
echo "Fetching list of databases..."
databases=($(docker exec -t $PGCONTAINER psql -U $PGUSER -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;"))

# Check if there are any databases
if [ ${#databases[@]} -eq 0 ]; then
  echo "No databases found."
  exit 1
fi

# Display the list of databases with indices
echo "Available databases:"
for i in "${!databases[@]}"; do
  echo "[$i] ${databases[$i]}"
done

# Prompt the user to choose a database by index
echo ""
read -p "Enter the index of the database you want to dump: " index

# Check if the entered index is valid
if ! [[ "$index" =~ ^[0-9]+$ ]] || [ "$index" -ge ${#databases[@]} ]; then
  echo "Invalid index."
  exit 1
fi

# Get the database name based on the chosen index
DB_NAME=$(echo "${databases[$index]}" | tr -d '[:space:]')

# Automatically generate the output file name
OUTPUT_FILE="${DB_NAME}_${CURRENT_DATE}.sql"

# # Dump the selected database
docker exec -t $PGCONTAINER pg_dump -U $PGUSER -d "$DB_NAME" -F p >"$OUTPUT_FILE"
# docker exec -t $PGCONTAINER pg_dump -U $PGUSER -d $DB_NAME -f p >$OUTPUT_FILE

# Check if the dump was successful
if [ $? -eq 0 ]; then
  echo "Database '$DB_NAME' dumped successfully to '$OUTPUT_FILE'."
else
  echo "Failed to dump database '$DB_NAME'."
fi
