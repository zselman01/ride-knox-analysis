-- TODO 9a: One query to answer ops lead's real question
SELECT 
trip_id,
start_station_id,
start_time,
ROUND((julianday(end_time) - julianday(start_time)) * 24, 2) AS duration_hr
FROM trips, stations
WHERE LOWER(rider_type) = 'member'
AND bike_type = 'classic'
AND station_id IN ('S06', 'S07', 'S08', 'S09')
AND start_time >= '2025-03-15'
AND start_time < '2025-04-01'
AND end_station_id IS NOT NULL
ORDER BY duration_hr
LIMIT 8;

-- TODO 9b: One more condition so impossible rows are excluded
SELECT 
trip_id,
start_station_id,
start_time,
ROUND((julianday(end_time) - julianday(start_time)) * 24, 2) AS duration_hr
FROM trips, stations
WHERE LOWER(rider_type) = 'member'
AND bike_type = 'classic'
AND station_id IN ('S06', 'S07', 'S08', 'S09')
AND start_time >= '2025-03-15'
AND start_time < '2025-04-01'
AND end_station_id IS NOT NULL
AND duration_hr > 0
ORDER BY duration_hr
LIMIT 8;

