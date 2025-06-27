#!/bin/sh

# Start supervisor (which starts postgres, telegraf, grafana, cron)
supervisord -c /etc/supervisord.conf &

# Wait for PostgreSQL to be ready
until pg_isready -U postgres -h localhost; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

# Create telegraf user and database if not exist
psql -U postgres -h localhost <<-EOSQL
DO \$\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'telegraf') THEN
      CREATE USER telegraf WITH PASSWORD 'telegraf';
   END IF;
END
\$\$;
CREATE DATABASE telegraf OWNER telegraf;
EOSQL

# Wait for all background jobs (supervisord) to finish
wait