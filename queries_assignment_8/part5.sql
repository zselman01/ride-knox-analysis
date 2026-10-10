-- TODO 5a: Combine JOIN, WHERE, and ORDER BY
SELECT
t.trip_id,
t.start_time,
s.station_name,
s.docks
FROM trips t
JOIN stations s ON t.start_station_id = s.station_id
WHERE (s.neighborhood = 'Old City'
OR s.neighborhood = 'Fort Sanders')
AND t.bike_type = 'electric'
ORDER BY start_time;

-- TODO 5b: Inner JOIN
SELECT
COUNT(*) AS trips_count
FROM trips t
JOIN stations s ON t.end_station_id = s.station_id;

-- TODO 5c: Combine JOIN, GROUP BY, and an aggregate
SELECT
s.neighborhood,
COUNT(*) AS trips_count,
ROUND(AVG((julianday(t.end_time) - julianday(t.start_time)) * 1440), 1) AS avg_duration_min
FROM trips t
JOIN stations s ON t.start_station_id = s.station_id
GROUP BY s.neighborhood
ORDER BY trips_count DESC;