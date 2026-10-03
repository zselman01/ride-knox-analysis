-- TODO 10a: Trips at 2 or 3am
SELECT DISTINCT trip_id, start_time, start_station_id, bike_type
FROM trips, stations
WHERE (strftime('%H', start_time) = '02')
OR (strftime('%H', start_time) = '03')
AND (station_name LIKE '%Park%')
ORDER BY start_time
LIMIT 6;