-- TODO 4a: Neighborhoods in Fort Sanders
SELECT station_name
FROM stations
WHERE neighborhood = 'Fort Sanders';

-- TODO 4b: Stations with 20+ docks
SELECT station_id, station_name, docks
FROM stations
WHERE docks >= 20;

-- TODO 4c: UT/Fort Sanders w/ 16+ docks
SELECT station_name, neighborhood, docks
FROM stations
WHERE (neighborhood = 'UT Campus' OR neighborhood = 'Fort Sanders')
AND (docks >= 16);

-- TODO 4d: 4c without parentheses
SELECT station_name
FROM stations
WHERE neighborhood = 'UT Campus' OR neighborhood = 'Fort Sanders'
AND docks >= 16;

-- TODO 4e: Stations in South or East Knoxville using IN
SELECT station_name
FROM stations
WHERE neighborhood IN ('South Knoxville', 'East Knoxville');

-- TODO 4f: Dock count is between 12-16 inclusive
SELECT station_id, station_name, docks
FROM stations
WHERE docks BETWEEN 12 AND 16;