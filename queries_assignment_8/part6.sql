-- TODO 6a: End station ids with no matching rows in stations table
SELECT t.end_station_id, COUNT(t.trip_id) AS trip_counts
FROM trips t
LEFT JOIN stations s ON t.end_station_id = s.station_id
WHERE s.station_id IS NULL
GROUP BY t.end_station_id;

-- TODO 6b: Check for duplicate station names
/*SELECT DISTINCT s.station_name
FROM trips t
LEFT JOIN stations s ON t.start_station_id = s.station_id;*/

SELECT station_name, COUNT(*) AS trips_count
FROM stations
GROUP BY station_name
HAVING COUNT(*) > 1;

-- TODO 6c(a): Investigating late night lighting (Version 1)
SELECT COUNT(t.trip_id) AS trips_count, s.station_name
FROM stations s
LEFT JOIN trips t ON t.start_station_id = s.station_id
WHERE t.start_time >= '2025-01-01'
AND t.start_time < '2025-02-01'
AND strftime('%H', t.start_time) >= '02'
AND strftime('%H', t.start_time) < '05'
GROUP BY s.station_name;

-- TODO 6c(b): Investigating late night lighting (Version 2)
SELECT COUNT(t.trip_id) AS trips_count, s.station_name
FROM stations s
LEFT JOIN trips t ON t.start_station_id = s.station_id
AND t.start_time >= '2025-01-01'
AND t.start_time < '2025-02-01'
AND strftime('%H', t.start_time) >= '02'
AND strftime('%H', t.start_time) < '05'
GROUP BY s.station_name;

-- TODO 6d: Late-night count <2
SELECT COUNT(t.trip_id) AS trips_count, s.station_name, s.neighborhood
FROM stations s
LEFT JOIN trips t ON t.start_station_id = s.station_id
AND t.start_time >= '2025-01-01'
AND t.start_time < '2025-02-01'
AND strftime('%H', t.start_time) >= '02'
AND strftime('%H', t.start_time) < '05'
GROUP BY s.station_name
HAVING COUNT(*) < 2
ORDER BY trips_count;