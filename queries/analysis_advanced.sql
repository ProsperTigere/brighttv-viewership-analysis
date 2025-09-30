-- ===============================================================
-- BrightTV Viewership Project
-- File: analysis_advanced.sql
-- Purpose: Advanced analysis queries to extend core insights
-- Author: [Prosper Tigere]
-- ===============================================================

-- Dataset used:
--   brighttv.viewership_sessions_final
-- Columns:
--   user_id (INT)          - unique viewer ID
--   channel (STRING)       - TV channel name
--   start_time (TIMESTAMP) - viewing session start time
--   duration_minutes (INT) - session duration in minutes


-- 1. Average session length per channel
-- ---------------------------------------------------------------
-- Business Value:
--   Identifies channels with highest engagement levels.
SELECT channel, ROUND(AVG(duration_minutes), 2) AS avg_session_length
FROM brighttv.viewership_sessions_final
GROUP BY channel
ORDER BY avg_session_length DESC;


-- 2. Channel share of total viewing time
-- ---------------------------------------------------------------
-- Business Value:
--   Compares channel performance in terms of market share.
SELECT
    channel,
    ROUND(
        100 * SUM(duration_minutes) / SUM(SUM(duration_minutes)) OVER(),
        2
    ) AS channel_share_pct
FROM brighttv.viewership_sessions_final
GROUP BY channel
ORDER BY channel_share_pct DESC;


-- 3. Sessions per user (engagement distribution)
-- ---------------------------------------------------------------
-- Business Value:
--   Reveals how frequently viewers return (loyalty indicator).
SELECT
    user_id,
    COUNT(*) AS session_count
FROM brighttv.viewership_sessions_final
GROUP BY user_id
ORDER BY session_count DESC
LIMIT 10;


-- 4. Average daily watch time per user
-- ---------------------------------------------------------------
-- Business Value:
--   Highlights typical engagement per day for an average viewer.
SELECT
    user_id,
    ROUND(SUM(duration_minutes) / COUNT(DISTINCT DATE(start_time)), 2) AS avg_daily_watch_time
FROM brighttv.viewership_sessions_final
GROUP BY user_id
ORDER BY avg_daily_watch_time DESC
LIMIT 10;


-- 5. Prime time detection (top 3 hours with most viewing)
-- ---------------------------------------------------------------
-- Business Value:
--   Finds when audiences are most active for scheduling/ads.
SELECT
    HOUR(start_time) AS hour_of_day,
    SUM(duration_minutes) AS total_watch_minutes
FROM brighttv.viewership_sessions_final
GROUP BY hour_of_day
ORDER BY total_watch_minutes DESC
LIMIT 3;


-- 6. Weekly viewing patterns
-- ---------------------------------------------------------------
-- Business Value:
--   Understands viewing behavior by day of week (content planning).
SELECT
    DATE_FORMAT(start_time, 'E') AS day_of_week,
    SUM(duration_minutes) AS total_watch_minutes
FROM brighttv.viewership_sessions_final
GROUP BY day_of_week
ORDER BY total_watch_minutes DESC;


-- 7. Longest single viewing sessions
-- ---------------------------------------------------------------
-- Business Value:
--   Detects binge-watching behavior (possible for promotions/alerts).
SELECT
    user_id,
    channel,
    MAX(duration_minutes) AS longest_session
FROM brighttv.viewership_sessions_final
GROUP BY user_id, channel
ORDER BY longest_session DESC
LIMIT 10;
