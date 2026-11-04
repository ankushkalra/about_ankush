##!/bin/bash

set -e

until pg_isready -q; do sleep 1; done

psql_db() {
  psql -tAq -v ON_ERROR_STOP=1 
}

echo "CREATE TABLE IF NOT EXISTS schema_migrations (filename TEXT PRIMARY KEY);" | psql_db

for file in migrations/*.sql; do
  done=$(echo "SELECT 1 FROM schema_migrations WHERE filename = '$file';" | psql_db)
  
  if [ "$done" = "1" ]; then
    echo "skip       $file"
  else
    echo "running $file"
    psql_db < "$file"
    echo "INSERT INTO schema_migrations (filename) VALUES ('$file');" | psql_db
  fi
done

