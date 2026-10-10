-- TODO 3a: Wide version of 2c
SELECT
COUNT(*) AS count_trips,
SUM(CASE WHEN LOWER(bike_type) = 'classic' THEN 1 ELSE 0 END) AS classic,
SUM(CASE WHEN LOWER(bike_type) = 'electric' THEN 1 ELSE 0 END) AS electric,
LOWER(rider_type) AS rider
FROM trips
GROUP BY rider; 

-- TODO 3b: Purposefully break grouping rule
SELECT 
COUNT(*) AS trips_count,
rider_type
FROM trips
GROUP BY bike_type;