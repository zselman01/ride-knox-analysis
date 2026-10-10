-- TODO 9a: View named completed_trips
SELECT COUNT(*)
FROM completed_trips;

-- TODO 9b: Ops lead's real question
WITH clean AS (
SELECT * 
FROM completed_trips
),
casual_first_half AS (
SELECT COUNT(*) AS casual_first_half_trips, start_station_id
FROM clean
WHERE rider_type = 'casual'
AND start_time >= '2025-01-01'
AND start_time < '2025-07-01'
GROUP BY start_station_id
),
casual_second_half AS (
SELECT COUNT(*) AS casual_second_half_trips, start_station_id
FROM clean
WHERE rider_type = 'casual'
AND start_time >= '2025-07-01'
AND start_time < '2026-01-01'
GROUP BY start_station_id
)

SELECT s.neighborhood, fi.casual_first_half_trips, se.casual_second_half_trips,
fi.casual_first_half_trips - se.casual_second_half_trips AS change_over_year,
ROUND((fi.casual_first_half_trips - se.casual_second_half_trips) * 1.0 / s.docks, 1) AS change_per_dock
FROM stations s
LEFT JOIN casual_first_half fi ON fi.start_station_id = s.station_id
LEFT JOIN casual_second_half se ON se.start_station_id= s.station_id
GROUP BY s.neighborhood
ORDER BY change_per_dock DESC;