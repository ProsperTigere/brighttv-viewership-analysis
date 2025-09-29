-- 1. Unique viewers
SELECT COUNT(DISTINCT user_id) AS unique_viewers
FROM brighttv.viewership_sessions_final;

-- 2. Most popular channels
SELECT channel, SUM(duration_minutes) AS total_minutes
FROM brighttv.viewership_sessions_final
GROUP BY channel
ORDER BY total_minutes DESC
LIMIT 10;

-- 3. Peak viewing times
SELECT HOUR(start_time) AS hour_of_day, COUNT(*) AS sessions
FROM brighttv.viewership_sessions_final
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- 4. Daily trends
SELECT DATE(start_time) AS day, SUM(duration_minutes) AS total_minutes
FROM brighttv.viewership_sessions_final
GROUP BY day
ORDER BY day;

-- 5. Top users by watch time
SELECT user_id, SUM(duration_minutes) AS total_watch_time
FROM brighttv.viewership_sessions_final
GROUP BY user_id
ORDER BY total_watch_time DESC
LIMIT 10;
