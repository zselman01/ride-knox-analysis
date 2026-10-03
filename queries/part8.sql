-- TODO 8a: All stations, oldest first, breaking ties by largest dock count first_value
SELECT station_id, station_name, docks, year_installed
FROM stations
ORDER BY year_installed, docks DESC;

-- TODO 8b: 8a only rows 6 through 10
SELECT station_id, station_name, docks, year_installed
FROM stations
ORDER BY year_installed, docks DESC
LIMIT 5 OFFSET 5;

-- TODO 8c: 3 newest stations
SELECT station_name, neighborhood, year_installed
FROM stations
ORDER BY year_installed DESC
LIMIT 3;
