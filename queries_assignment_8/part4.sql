-- TODO 4a: Stations carrying the heaviest load_extension
SELECT
start_station_id,
COUNT(*) AS trips_count
FROM trips
GROUP BY start_station_id
HAVING COUNT(*) > 15000
ORDER BY trips_count DESC; 

-- TODO 4b: Electric bikes, just October, >=300
SELECT
start_station_id,
COUNT(*) AS trips_count
FROM trips
WHERE bike_type = 'electric' -- ← keeps ROWS
AND start_time >= '2025-08-01'
AND start_time < '2025-09-01'
GROUP BY start_station_id
HAVING COUNT(*) >= 300 -- ← keeps GROUPS
ORDER BY trips_count DESC;

-- TODO 4c: Each month's trip count
SELECT 
strftime('%m', start_time) AS month,
COUNT(*) AS trips_count
FROM trips
GROUP BY month
HAVING COUNT(*) > 25000;

-- TODO 4d: Moving HAVING statement into WHERE clause
SELECT 
strftime('%m', start_time) AS month,
COUNT(*) AS trips_count
FROM trips
WHERE COUNT(*) > 25000
GROUP BY month;