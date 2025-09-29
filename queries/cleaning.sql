-- ===============================================================
-- BrightTV Viewership Project
-- File: cleaning.sql
-- Purpose: Clean raw viewership data and prepare a final dataset
-- Author: [Prosper Tigere]
-- ===============================================================

-- STEP 1: Create a staging table (viewership_sessions_clean)
-- ---------------------------------------------------------------
-- This step lightly cleans raw columns:
--  * Casts user_id into integer
--  * Keeps channel column
--  * Keeps record_date as string (to be parsed later)
--  * Keeps duration as string (to be cleaned later)

CREATE OR REPLACE TABLE brighttv.viewership_sessions_clean AS
SELECT
    TRY_CAST("UserID" AS INT) AS user_id,
    "Channel2" AS channel,
    TRIM("RecordDate2") AS record_date,
    TRIM("Duration 2") AS duration
FROM brighttv.viewership_sessions
WHERE TRY_CAST("UserID" AS INT) IS NOT NULL;


-- STEP 2: Create the final cleaned table (viewership_sessions_final)
-- ---------------------------------------------------------------
-- This step fully prepares the dataset for analysis:
--  * Parses record_date (yyyy/MM/dd HH:mm) into proper timestamp
--    and converts from UTC → Africa/Johannesburg timezone
--  * Cleans duration column (removes non-numeric characters)
--    and casts it into integer minutes
--  * Keeps channel and user_id for linking behavior

CREATE OR REPLACE TABLE brighttv.viewership_sessions_final AS
SELECT
    TRY_CAST(user_id AS INT) AS user_id,
    channel,
    FROM_UTC_TIMESTAMP(
        TRY_TO_TIMESTAMP(TRIM(record_date), 'yyyy/MM/dd HH:mm'),
        'Africa/Johannesburg'
    ) AS start_time,
    TRY_CAST(REGEXP_REPLACE(duration, '[^0-9]', '') AS INT) AS duration_minutes
FROM brighttv.viewership_sessions_clean;


-- STEP 3: Quick validation check
-- ---------------------------------------------------------------
-- Preview 20 rows from the final cleaned dataset to confirm
-- everything looks correct before analysis.

SELECT *
FROM brighttv.viewership_sessions_final
LIMIT 20;
