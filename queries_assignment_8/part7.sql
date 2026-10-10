-- TODO 7a: arrivals per dock over the 2025 year_installed
-- This ranking counts all trips taken during October 1 - December 31, 2025 and excludes those taken during January 1 - September 30, 2025. 
SELECT s.station_name, s.neighborhood, s.docks, 
COUNT(t.trip_id) AS trip_count, ROUND(COUNT(t.trip_id) * 1.0 / s.docks , 2) AS arrivals_per_dock
FROM stations s
LEFT JOIN trips t ON t.end_station_id = s.station_id
AND t.end_time >= '2025-10-01'
AND t.end_time < '2026-01-01'
GROUP BY s.station_name, s.neighborhood, s.docks
ORDER BY arrivals_per_dock DESC;

