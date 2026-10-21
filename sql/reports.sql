-- TO RUN EVERY TIME: Foreign keys
PRAGMA foreign_keys = ON; -- run it in every session, before you write!
PRAGMA foreign_keys;
PRAGMA foreign_key_check;

-- Part D: Anniversary Verdict
SELECT 
strftime('%Y', start_time) AS year, rider_type AS rider, COUNT(*) AS trips, 
ROUND(AVG(duration_min), 1) AS avg_min,
SUM(CASE WHEN bike_type = 'classic' THEN 1 ELSE 0 END) AS classic_bike,
SUM(CASE WHEN bike_type = 'electric' THEN 1 ELSE 0 END) AS electric_bike,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY (strftime('%Y', start_time)), (strftime('%m', start_time))),2) AS rider_share_pct, --AI Here: percentage of riders/month
SUM(COUNT(*)) OVER(PARTITION BY (strftime('%Y', start_time)), (strftime('%m', start_time))) AS percentage_denominator
FROM clean_trips
WHERE (start_time >= '2025-07-01'
AND start_time < '2025-08-01')
OR (start_time >= '2026-07-01'
AND start_time < '2026-08-01')
GROUP BY year, rider_type;

-- Anniversary verdict: Monthly series
SELECT 
strftime('%Y-%m', start_time) AS date_label, rider_type AS rider, 
COUNT(*) AS trips, ROUND(AVG(duration_min), 1) AS avg_min,
SUM(CASE WHEN bike_type = 'classic' THEN 1 ELSE 0 END) AS classic_bike,
SUM(CASE WHEN bike_type = 'electric' THEN 1 ELSE 0 END) AS electric_bike,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY (strftime('%Y', start_time)), (strftime('%m', start_time))),2) AS rider_share_pct,
SUM(COUNT(*)) OVER(PARTITION BY (strftime('%Y', start_time)), (strftime('%m', start_time))) AS percentage_denominator
FROM clean_trips
WHERE (start_time >= '2025-03-01'
AND start_time < '2025-08-01')
OR (start_time >= '2026-03-01'
AND start_time < '2026-08-01')
GROUP BY strftime('%Y', start_time), strftime('%m', start_time), rider_type;

-- Combined Casual and Day Pass (Non-members) for July 2025 and July 2026
SELECT 
strftime('%Y', start_time) AS year, COUNT(*) AS trips, ROUND(AVG(duration_min), 1) AS avg_min,
SUM(CASE WHEN bike_type = 'classic' THEN 1 ELSE 0 END) AS classic_bike,
SUM(CASE WHEN bike_type = 'electric' THEN 1 ELSE 0 END) AS electric_bike
FROM clean_trips
WHERE rider_type IN ('casual', 'day pass')
AND(start_time >= '2025-03-01'
AND start_time < '2025-08-01')
OR (start_time >= '2026-03-01'
AND start_time < '2026-08-01')
GROUP BY year;

-- Capacity verdict for S06, S08, S23, S24, and S25
-- AI Here, but updated to reflect my understanding of the code
SELECT 
    b.station_id,
    
	-- 1. Get 2025 Trips and calculate 2025 Pressure (using COALESCE for before expansion dock counts)
    SUM(CASE WHEN strftime('%Y', t.start_time) = '2025' THEN 1 ELSE 0 END) AS trips_2025,
    COALESCE(e.docks_before, b.docks) AS docks_2025, --AI Here
    ROUND(SUM(CASE WHEN strftime('%Y', t.start_time) = '2025' THEN 1 ELSE 0 END) * 1.0 / COALESCE(e.docks_before, b.docks), 2) AS July_2025_pressure,

    -- 2. Get 2026 Trips and calculate 2026 Pressure (after expansion dock counts are already currently stored in stations)
    SUM(CASE WHEN strftime('%Y', t.start_time) = '2026' THEN 1 ELSE 0 END) AS trips_2026,
    b.docks AS docks_2026, --2026 which is current
    ROUND(SUM(CASE WHEN strftime('%Y', t.start_time) = '2026' THEN 1 ELSE 0 END) * 1.0 / b.docks, 2) AS July_2026_pressure

FROM stations_v2 b
-- Look up 2025 before dock counts if they exist
LEFT JOIN stations_docks e ON b.station_id = e.station_id
-- Join all trip records that occurred in July of either year
LEFT JOIN clean_trips t ON b.station_id = t.start_station_id 
    AND strftime('%m', t.start_time) = '07'

-- Filter down to just the five leadership target stations
WHERE b.station_id IN ('S06', 'S08', 'S23', 'S24', 'S25')
GROUP BY b.station_id;