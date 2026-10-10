-- TODO 10a: Aggreggating an aggregate
WITH trips_per_neighb_per_month AS (
SELECT COUNT(*) AS trips_count, start_station_id, month
FROM completed_trips
GROUP BY start_station_id, month
)

SELECT s.neighborhood, MIN(trip_count) AS quietest, MAX(trip_count) AS busiest, ROUND(MIN(trip_count) / MAX(trip_count), 2) AS ratio_btw_seasons
FROM (
SELECT COUNT(*) AS trip_count
FROM stations s
LEFT JOIN trips_per_neighb_per_month t ON t.start_station_id = s.station_id
GROUP BY s.neighborhood
);