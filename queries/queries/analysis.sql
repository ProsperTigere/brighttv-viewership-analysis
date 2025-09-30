-- ===============================================================
-- BrightTV Viewership Project
-- File: analysis.sql
-- Purpose: Example analysis queries on cleaned viewership data
-- Author: [Prosper Tigere]
-- ===============================================================

-- Dataset used:
--   brighttv.viewership_sessions_final
-- Columns:
--   user_id (INT)          - unique viewer ID
--   channel (STRING)       - TV channel name
--   start_time (TIMESTAMP) - viewing session start time
--   duration_minutes (INT) - session duration in minutes


-- ===============================================================
-- 1. Total watch time per channel
-- ---------------------------------------------------------------
-- Business Value:
--   Identifies the most popular channels by total watch time.
--   Useful for advertisers and programming strategy.
-- ===============================================================

SELECT
    channel,
    SUM(duration_minutes) AS total_watch_minutes
FROM brighttv.viewership_sessions_final
GROUP BY channel
ORDER BY total_watch_minutes DESC;


-- ===============================================================
-- 2. Average session length per channel
-- ---------------------------------------------------------------
-- Business Value:
--   Reveals which channels keep viewers engaged the longest.
--   Long session lengths may suggest strong content retention.
-- ===============================================================

SELECT
    channel,
    ROUND(AVG(duration_minutes), 2) AS avg_session_length
FROM brighttv.viewership_sessions_final
GROUP BY channel
ORDER BY avg_session_length DESC;


-- ===============================================================
-- 3. Peak viewing hours (by day of week & hour)
-- ---------------------------------------------------------------
-- Business Value:
--   Highlights prime-time slots.
--   Can be used for ad pricing or scheduling premium shows.
-- ===============================================================

SELECT
    DATE_FORMAT(start_time, 'E') AS day_of_week,   -- Mon, Tue, etc.
    HOUR(start_time) AS hour_of_day,
    SUM(duration_minutes) AS total_watch_minutes
FROM brighttv.viewership_sessions_final
GROUP BY day_of_week, hour_of_day
ORDER BY total_watch_minutes DESC
LIMIT 20;


-- ===============================================================
-- 4. Top 10 most active viewers
-- ---------------------------------------------------------------
-- Business Value:
--   Shows loyal viewers who generate the most engagement.
--   Could be used for targeted campaigns or loyalty rewards.
-- ===============================================================

SELECT
    user_id,
    COUNT(*) AS session_count,
    SUM(duration_minutes) AS total_watch_minutes
FROM brighttv.viewership_sessions_final
GROUP BY user_id
ORDER BY total_watch_minutes DESC
LIMIT 10;


-- ===============================================================
-- 5. Channel share of total viewing time
-- ---------------------------------------------------------------
-- Business Value:
--   Shows relative share (%) of each channel in overall watch time.
--   Useful for market share analysis.
-- ===============================================================

SELECT
    channel,
    ROUND(
        100 * SUM(duration_minutes) / SUM(SUM(duration_minutes)) OVER(),
        2
    ) AS channel_share_pct
FROM brighttv.viewership_sessions_final
GROUP BY channel
ORDER BY channel_share_pct DESC;
