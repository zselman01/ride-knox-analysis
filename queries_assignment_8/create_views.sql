-- TODO 9a: View named completed_trips
CREATE VIEW completed_trips AS
SELECT trip_id, start_time, start_station_id, end_station_id,
LOWER(rider_type) AS rider_type, bike_type,
ROUND((julianday(end_time) - julianday(start_time)) * 1440, 1) AS duration_min,
strftime('%m', start_time) AS month
FROM trips
WHERE start_station_id <> 'S99'
AND end_station_id IS NOT NULL
AND (julianday(end_time) - julianday(start_time)) * 1440 BETWEEN 2 AND 720;