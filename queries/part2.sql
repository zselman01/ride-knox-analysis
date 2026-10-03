-- TODO 2a: Return station_id, neighborhood, latitude, and longitude for every station.
SELECT station_id, neighborhood, latitude, longitude FROM stations;

-- TODO 2b: Computed column of age for each station
SELECT DISTINCT station_id, station_name, year_installed,
(2026 - year_installed)
AS age_years
FROM stations, trips;

-- TODO 2c: Computed column for trip duration in hours
SELECT trip_id, start_time,
ROUND((julianday(end_time) - julianday(start_time)) * 24, 2)
AS duration_hr
FROM trips;
