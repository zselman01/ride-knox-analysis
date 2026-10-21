CREATE VIEW clean_trips AS
SELECT trip_id, start_time, end_time, start_station_id, end_station_id,
rider_type, bike_type, has_end_station, has_end_time,
ROUND((julianday(end_time) - julianday(start_time)) * 1440, 1) AS duration_min
FROM trips_v2
WHERE end_station_id IS NOT NULL
AND end_time IS NOT NULL
AND (julianday(end_time) - julianday(start_time)) * 1440 BETWEEN 1 AND 1440;