-- TODO 7a: Trips with no end station
SELECT trip_id, start_station_id, start_time
FROM trips
WHERE end_station_id IS NULL;

-- TODO 7b: Trips that end at Market Square
SELECT trip_id
FROM trips
WHERE end_station_id <> 'S01';

-- TODO 7c: 7b plus never docked trips
SELECT trip_id
FROM trips
WHERE end_station_id <> 'S01'
OR end_station_id IS NULL;

-- TODO 7d: Combine IS NULL with IN
SELECT trip_id, start_station_id
FROM trips
WHERE start_station_id IN ('S14', 'S15', 'S16')
AND end_station_id IS NULL;