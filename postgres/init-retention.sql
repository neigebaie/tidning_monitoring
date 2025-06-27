-- Enable the pg_cron extension
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Schedule a daily job at 2:00 AM to delete data older than 30 days
SELECT cron.schedule('delete_old_metrics', '0 2 * * *', $$
  DELETE FROM metrics WHERE time < NOW() - INTERVAL '30 days';
$$); 