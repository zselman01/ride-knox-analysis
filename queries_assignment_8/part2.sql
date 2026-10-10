-- TODO 2a: Trip count for each station
SELECT 
COUNT(*) AS trip_count
FROM trips
GROUP BY start_station_id
ORDER BY trip_count DESC;

-- TODO 2b: when the system is busiest
SELECT 
strftime('%H', start_time) AS hour,
COUNT(*) AS trip_count_for_each_hour
FROM trips
GROUP BY hour
ORDER BY trip_count_for_each_hour DESC
LIMIT 6;

-- TODO 2c: Avg duration in minutes for combinations of bike and rider types
SELECT
COUNT(*) AS count_trips,
ROUND(AVG((julianday(end_time) - julianday(start_time)) * 1440) ,1) AS avg_duration_min,
LOWER(rider_type) AS rider,
bike_type
FROM trips
GROUP BY rider, bike_type;

-- TODO 2d: 2c without normalizing rider typeof
SELECT
COUNT(*) AS count_trips,
ROUND(AVG((julianday(end_time) - julianday(start_time)) * 1440) ,1) AS avg_duration_min,
rider_type,
bike_type
FROM trips
GROUP BY rider_type, bike_type;
