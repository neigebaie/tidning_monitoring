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

# Enable pg_cron and schedule cleanup for all tables with a 'time' column
psql -U postgres -d telegraf -h localhost <<-EOSQL
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Schedule a daily job at 2:00 AM to delete old rows from each table with a 'time' column
SELECT cron.schedule('delete_old_cpu', '0 2 * * *', $$
  DELETE FROM cpu WHERE time < NOW() - INTERVAL '30 days';
$$);

SELECT cron.schedule('delete_old_disk', '0 2 * * *', $$
  DELETE FROM disk WHERE time < NOW() - INTERVAL '30 days';
$$);

SELECT cron.schedule('delete_old_mem', '0 2 * * *', $$
  DELETE FROM mem WHERE time < NOW() - INTERVAL '30 days';
$$);

SELECT cron.schedule('delete_old_net', '0 2 * * *', $$
  DELETE FROM net WHERE time < NOW() - INTERVAL '30 days';
$$);

SELECT cron.schedule('delete_old_temp', '0 2 * * *', $$
  DELETE FROM temp WHERE time < NOW() - INTERVAL '30 days';
$$);
EOSQL

# Wait for all background jobs (supervisord) to finish
wait