-- TODO 5a: Trips from Sept 2025 using half-open RANGE
SELECT trip_id, start_time, rider_type
FROM trips
WHERE start_time >= '2025-09-01'
AND start_time < '2025-10-01';

-- TODO 5b: 5a using BETWEEN (wrong!)
SELECT trip_id, start_time, rider_type
FROM trips
WHERE start_time BETWEEN 
'2025-09-01' AND '2025-09-30';

-- TODO 5c: trips that started in second half of March 2025; March 15 through March 31 inclusive. 
SELECT trip_id, start_time
FROM trips
WHERE start_time >= '2025-03-15'
AND start_time < '2025-04-01';

-- TODO 5d: Member trips in Oct 2025 using =
SELECT trip_id
FROM trips
WHERE (rider_type = 'member')
AND (start_time >= '2025-10-01')
AND (start_time < '2025-11-01');

-- TODO 5d: Member trips in Oct 2025 using LOWER()
SELECT trip_id
FROM trips
WHERE (LOWER(rider_type) = 'member')
AND (start_time >= '2025-10-01')
AND (start_time < '2025-11-01');