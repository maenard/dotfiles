#!/bin/bash
# Set the PostgreSQL credentials
PGUSER="default"
PGCONTAINER="laradock-postgres-1"

# Get the current directory
CURRENT_DIR=$(pwd)

# List all dump files (.sql and .psql) in the current directory and subdirectories
echo "Available dump files:"
mapfile -t dump_files < <(find "$CURRENT_DIR" -type f \( -name "*.sql" -o -name "*.psql" \))

# Check if there are any dump files
if [ ${#dump_files[@]} -eq 0 ]; then
  echo "No dump files found."
  exit 1
fi

# Display the list of dump files with indices
for i in "${!dump_files[@]}"; do
  echo "[$i] ${dump_files[$i]}"
done

echo ""
read -p "Enter the index of the dump file you want to import: " index

# Check if the entered index is valid
if ! [[ "$index" =~ ^[0-9]+$ ]] || [ "$index" -ge ${#dump_files[@]} ]; then
  echo "Invalid index."
  exit 1
fi

# Get the selected dump file
DUMP_FILE="${dump_files[$index]}"

# Extract the base name (without date and extension) for new database naming
echo ""
BASE_NAME=$(basename "$DUMP_FILE" | sed -r 's/_.*\.(sql|psql)//')

# Generate a new unique database name
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DB_NAME="${BASE_NAME}_${TIMESTAMP}"

# Create the new database
docker exec -t "$PGCONTAINER" psql -U "$PGUSER" -c "CREATE DATABASE \"$DB_NAME\";" >/dev/null 2>&1

# Import the dump file into the new database
echo "Importing dump file '$DUMP_FILE' into database '$DB_NAME'..."
cat "$DUMP_FILE" | docker exec -i "$PGCONTAINER" psql -U "$PGUSER" -d "$DB_NAME" >/dev/null 2>&1
echo "Done"
