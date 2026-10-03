-- TODO 6a: station name starts with 'Ave'
SELECT station_id, station_name
FROM stations
WHERE station_name LIKE '%Ave%';

-- TODO 6b: Wildcard
SELECT station_id, station_name, neighborhood
FROM stations
WHERE station_id LIKE 's2_';

-- TODO 6c: Neighborhood ends with the word Knoxville
SELECT station_id, neighborhood
FROM stations
WHERE neighborhood LIKE '%Knoxville';

-- TODO 6d: 6c but 3 with the most docks
SELECT station_name, neighborhood, docks
FROM stations
WHERE neighborhood LIKE '%Knoxville'
ORDER BY docks DESC
LIMIT 3;