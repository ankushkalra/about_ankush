##!/bin/bash

set -e

psql_db() {
  podman compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -tAq -v ON_ERROR_STOP=1' 
}

last=$(echo "SELECT filename FROM schema_migrations ORDER BY filename DESC LIMIT 1;" | psql_db)

if [ -z "$last" ]; then
  echo "nothing to undo"
  exit 0
fi

echo "undoing $last"
psql_db < "rollbacks/$(basename "$last")"
echo "DELETE FROM schema_migrations WHERE filename = '$last';" | psql_db
