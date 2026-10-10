-- TODO 1a: capacity summary of stations table
SELECT
SUM(docks) AS docks_total,
ROUND(AVG(docks),1) AS avg_docks_per_station,
MIN(docks) AS smallest_dock_count,
MAX(docks) AS largest_dock_count
FROM stations;
-- DONT USE ROUND(SUM(docks) / COUNT(station_id), 1) AS avg_dock_per_station,
-- Instead use AVG from above

-- TODO 1b: Duration units in hours, not minutes
SELECT 
COUNT(*) AS count_of_trips,
ROUND(AVG((julianday(end_time) - julianday(start_time)) * 24), 2) AS avg_duration_hours,
ROUND(MIN((julianday(end_time) - julianday(start_time)) * 24), 2) AS min_dur_hours,
ROUND(MAX((julianday(end_time) - julianday(start_time)) * 24), 2) AS max_dur_hours
FROM trips;

-- TODO 1C: Duration units in hours, with 1 min and 6 hour limitation
SELECT 
COUNT(*) AS count_of_trips,
ROUND(AVG((julianday(end_time) - julianday(start_time)) * 24), 2) AS avg_duration_hours,
ROUND(MIN((julianday(end_time) - julianday(start_time)) * 24), 2) AS min_dur_hours,
ROUND(MAX((julianday(end_time) - julianday(start_time)) * 24), 2) AS max_dur_hours
FROM trips
WHERE (julianday(end_time) - julianday(start_time)) * 1440 BETWEEN 1 AND 360;

-- TODO 1d: Share of fleet's usage that is electric
SELECT
COUNT(*) AS count_of_trips,
SUM(CASE WHEN bike_type = 'electric' THEN 1 ELSE 0 END) AS electric_bike_count,
ROUND((SUM(CASE WHEN bike_type = 'electric' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)),1) AS percent_electric_trips
FROM trips;

-- TODO 1f: Using 100 instead of 100.0
SELECT
COUNT(*) AS count_of_trips,
SUM(CASE WHEN bike_type = 'electric' THEN 1 ELSE 0 END) AS electric_bike_count,
ROUND((SUM(CASE WHEN bike_type = 'electric' THEN 1 ELSE 0 END) * 100 / COUNT(*)),1) AS percent_electric_trips
FROM trips;