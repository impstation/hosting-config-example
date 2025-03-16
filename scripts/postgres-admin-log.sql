SELECT pg_size_pretty(pg_total_relation_size('public.admin_log')) AS pg_size_pretty_admin_log;
SELECT pg_size_pretty(pg_total_relation_size('public.admin_log_player')) AS pg_size_pretty_admin_log_player;
-- demo how to get logs older than certain date from now
-- you can use this to prune the old logs and then free disk space
-- by replacing SELECT with DELETE FROM
-- note that deleting from admin_log will delete
-- any related admin_log_player entries due to cascade,
-- don't have to do that manually
-- if you run this as-is it will show you how many will be deleted and kept
WITH vars AS (
    SELECT count(*) log_count_trim FROM admin_log WHERE admin_log.date < date_subtract(current_timestamp, '7 days'::interval)
), vars2 AS (
    SELECT count(*) log_count_all FROM admin_log
)
    SELECT
        log_count_all, log_count_trim,
        (log_count_all - log_count_trim) AS log_count_difference,
        ((log_count_trim::float / log_count_all::float) * 100) AS log_percent_trim
FROM vars, vars2;
