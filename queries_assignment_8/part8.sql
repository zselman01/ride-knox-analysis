-- TODO 8a: Scalar subquery
SELECT s.neighborhood, COUNT(*) AS trip_count
FROM trips t
JOIN stations s ON t.start_station_id = s.station_id --Departures
GROUP BY s.neighborhood
HAVING COUNT(*) * 1.0 / s.docks > (
SELECT COUNT(*) * 1.0 / s.docks FROM stations
)
ORDER BY trip_count DESC;

-- TODO 8b: Subquery in FROM
SELECT ROUND(AVG(trip_count), 2) AS avg_per_station, MIN(trip_count) AS smallest, MAX(trip_count) AS largest
FROM (
SELECT COUNT(*) AS trip_count
FROM trips
GROUP BY strftime('%m', start_time)
);

-- TO DO 8c: 8b using a CTE instead of a subquery in FROM
WITH station_trips AS (
SELECT COUNT(*) AS trip_count
FROM trips
GROUP BY strftime('%m', start_time)
)
SELECT ROUND(AVG(trip_count), 2) AS avg_per_station, MIN(trip_count) AS smallest, MAX(trip_count) AS largest
FROM station_trips;

-- TODO 8d: Two-chained CTE
WITH trip_counts AS (
    -- CTE 1: Count total trips per station
    SELECT start_station_id, COUNT(*) AS trip_count
    FROM trips
    GROUP BY start_station_id
),

station_metrics AS (
    -- CTE 2: Attach station details and compute the ratio
    SELECT 
        s.station_name,
        s.docks,
        t.trip_count,
        ROUND(t.trip_count * 1.0 / s.docks, 1) AS trips_per_dock
    FROM trip_counts t
    JOIN stations s ON t.start_station_id = s.station_id
)

-- Final SELECT get bottom 5 stations
SELECT 
    station_name,
    docks,
    trip_count,
    trips_per_dock
FROM station_metrics
ORDER BY trips_per_dock
LIMIT 5;
