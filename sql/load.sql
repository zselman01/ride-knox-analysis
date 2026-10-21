-- TO RUN EVERY TIME: Foreign keys
PRAGMA foreign_keys = ON; -- run it in every session, before you write!
PRAGMA foreign_keys;
PRAGMA foreign_key_check;

-- Load data into stations_v2
BEGIN TRANSACTION;
INSERT INTO stations_v2
SELECT station_id, station_name, neighborhood, latitude, longitude, docks, year_installed
FROM staging_stations_v2;
SELECT COUNT(*) AS trips FROM stations_v2;
COMMIT;

-- Load data into stations_docks
BEGIN TRANSACTION;
INSERT INTO stations_docks
(station_id, effective_date, docks_before, docks_after)
VALUES
('S06', '2026-02-15', 24, 32), ('S08', '2026-02-15', 24, 32), ('S25', '2026-03-01', 0, 16);
SELECT DISTINCT station_id FROM stations_docks;
SELECT * FROM stations_docks;
COMMIT;

-- Load data into rider_types_lookup
BEGIN TRANSACTION;
INSERT INTO rider_types_lookup
(rider_type, price, start_date)
VALUES
('member', 50.5, '2025-01-01'), ('casual', 35.5, '2025-01-01'), ('day pass', 15.0, '2026-03-01');
SELECT * FROM rider_types_lookup;
COMMIT;

-- Load data into bike_types_lookup
BEGIN TRANSACTION;
INSERT INTO bike_types_lookup
(bike_type, start_date)
VALUES
('classic', '2025-01-01'), ('electric', '2025-01-01'), ('cargo', '2026-07-06');
SELECT * FROM bike_types_lookup;

-- STAGING TABLE: Normalize rider_type
SELECT COUNT(*) AS trips FROM staging_trips_v2;
UPDATE staging_trips_v2 SET rider_type = LOWER(rider_type)
WHERE rider_type <> LOWER(rider_type);
SELECT rider_type, COUNT(*) AS trips FROM staging_trips_v2 GROUP BY rider_type;


-- STAGING TABLE: Delete training trips not really in data set
-- SELECT COUNT(*) FROM staging_trips_v2 WHERE start_station_id = 'S99';
DELETE FROM staging_trips_v2 WHERE start_station_id = 'S99';
SELECT COUNT(*) AS trips 
FROM staging_trips_v2 
WHERE start_station_id = 'S99';

-- STAGING TABLE: Delete duplicates so unique constraint doesn't fail when adding data to production tables
SELECT COUNT(*) FROM staging_trips_v2
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM staging_trips_v2
    GROUP BY trip_id
);

DELETE FROM staging_trips_v2
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM staging_trips_v2
    GROUP BY trip_id
);
SELECT COUNT(*) AS trips FROM staging_trips_v2;
COMMIT;

BEGIN TRANSACTION;
SELECT COUNT(*) AS trips 
FROM staging_trips_v2
WHERE end_time IS NULL OR end_time > start_time;

SELECT COUNT(*) AS trips FROM staging_trips_v2 
WHERE end_station_id IS NULL;

ALTER TABLE staging_trips_v2 DROP COLUMN start_station_name;
--ALTER TABLE staging_trips_v2 ADD COLUMN has_end_station;
--ALTER TABLE staging_trips_v2 ADD COLUMN has_end_time; -- Commented out because this column will already be populated when data is imported through Python and not on DB Browser

-- Insert 2025 trips
INSERT INTO trips_v2
SELECT trip_id, start_time, end_time, start_station_id, end_station_id,
rider_type, bike_type, has_end_station, has_end_time
FROM staging_trips_v2
WHERE start_station_id <> 'S99'
AND (end_time IS NULL OR end_time > start_time);

-- STAGING TABLE FOR 2026 data: Normalize rider_type
UPDATE staging_trips_26 SET rider_type = LOWER(rider_type)
WHERE rider_type <> LOWER(rider_type);
SELECT rider_type, COUNT(*) AS trips FROM staging_trips_26 GROUP BY rider_type;

UPDATE staging_trips_26
SET rider_type = 'day pass'
WHERE rider_type = 'day_pass';
SELECT rider_type, COUNT(*) AS trips FROM staging_trips_26 GROUP BY rider_type;
COMMIT;

-- STAGING TABLE: Delete duplicates so unique constraint doesn't fail when adding data to production tables
BEGIN TRANSACTION;
DELETE FROM staging_trips_26
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM staging_trips_26
    GROUP BY trip_id
);
SELECT COUNT(*) AS trips FROM staging_trips_26;
COMMIT;

-- STAGING TABLE: Remove station names so that the trips table only has IDs, not names. Add flag columns
BEGIN TRANSACTION;
ALTER TABLE staging_trips_26 DROP COLUMN start_station_name;
-- ALTER TABLE staging_trips_26 ADD COLUMN has_end_station;
-- ALTER TABLE staging_trips_26 ADD COLUMN has_end_time;

-- Insert 2026 trips
INSERT INTO trips_v2
SELECT trip_id, start_time, end_time, start_station_id, end_station_id,
rider_type, bike_type, has_end_station, has_end_time
FROM staging_trips_26
WHERE start_station_id <> 'S99'
AND (end_time IS NULL OR end_time > start_time);
SELECT COUNT(*) AS trips FROM trips_v2;
COMMIT;

-- STAGING TABLE: Investigate duplicates in July 2026 data export (trips_2026_07.csv)
BEGIN TRANSACTION;
SELECT COUNT(*) AS duplicates
FROM staging_trips_26_07
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM staging_trips_26_07
    GROUP BY trip_id
);

-- STAGING TABLE: Distinct values from columns
SELECT start_station_id, COUNT(*) AS trips FROM staging_trips_26_07 GROUP BY start_station_id;

SELECT end_station_id, COUNT(*) AS trips FROM staging_trips_26_07 GROUP BY end_station_id;

SELECT rider_type, COUNT(*) AS trips FROM staging_trips_26_07 GROUP BY rider_type;

SELECT bike_type, COUNT(*) AS trips FROM staging_trips_26_07 GROUP BY bike_type;

-- STAGING TABLE: NULL values from columns
SELECT COUNT(*) AS trips FROM staging_trips_26_07 WHERE trip_id IS NULL;
SELECT COUNT(*) AS trips FROM staging_trips_26_07 WHERE start_time IS NULL OR end_time < start_time;
SELECT COUNT(*) AS trips FROM staging_trips_26_07 WHERE end_time IS NULL;

-- STAGING TABLE: Make sure Day Pass riders are not < March 15, 2026
SELECT trip_id, COUNT(*) AS trips 
FROM staging_trips_26_07 
WHERE (LOWER(rider_type) = 'day pass' OR LOWER(rider_type) = 'day_pass' OR LOWER(rider_type) = 'daypass') 
AND (start_time < '2026-03-01' OR end_time < '2026-03-01');

-- STAGING TABLE: Delete duplicates
DELETE FROM staging_trips_26_07
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM staging_trips_26_07
    GROUP BY trip_id
);
SELECT COUNT(*) AS trips FROM staging_trips_26_07; -- should be 32,965
COMMIT;

-- STAGING TABLE: Delete NULL columns or add flag once merged with trips_v2
BEGIN TRANSACTION;
DELETE FROM staging_trips_26_07
WHERE start_time IS NULL;
SELECT COUNT(*) AS trips FROM staging_trips_26_07; -- should be 32,925

-- STAGING TABLE: Delete trips with end_time < start_time
DELETE FROM staging_trips_26_07
WHERE end_time < start_time;
SELECT COUNT(*) AS trips FROM staging_trips_26_07; -- should be 32,865

-- STAGING TABLE: Normalize rider and bike types
UPDATE staging_trips_26_07 SET rider_type = LOWER(rider_type)
WHERE rider_type <> LOWER(rider_type);
SELECT rider_type, COUNT(*) AS trips FROM staging_trips_26_07 GROUP BY rider_type;

-- SELECT DISTINCT rider_type FROM  staging_trips_26_07 WHERE rider_type LIKE 'd%';
UPDATE staging_trips_26_07 SET rider_type = 'day pass'
WHERE rider_type LIKE 'd%';
SELECT rider_type, COUNT(*) AS trips FROM staging_trips_26_07 GROUP BY rider_type;

-- STAGING TABLE: Remove station names so that the trips table only has IDs, not names
ALTER TABLE staging_trips_26_07 DROP COLUMN start_station_name;
-- ALTER TABLE staging_trips_26_07 ADD COLUMN has_end_station;
-- ALTER TABLE staging_trips_26_07 ADD COLUMN has_end_time;

-- Load data into trips_v2
INSERT OR IGNORE INTO trips_v2 --avoid importing duplicates
SELECT trip_id, start_time, end_time, start_station_id, end_station_id, rider_type, bike_type,
has_end_station, has_end_time
FROM staging_trips_26_07
WHERE start_station_id <> 'S99'
AND (end_time IS NULL OR end_time > start_time);
SELECT COUNT(*) AS trips FROM trips_v2; -- should be 418,666 - duplicates (180) = 418,486
COMMIT;

-- Flag Implausible trips (when end_station_id AND end_time are NULL)
BEGIN TRANSACTION;
UPDATE trips_v2
SET has_end_station = 1
WHERE end_station_id IS NOT NULL;

UPDATE trips_v2
SET has_end_station = 0
WHERE end_station_id IS NULL;

UPDATE trips_v2
SET has_end_time = 1
WHERE end_time IS NOT NULL;

UPDATE trips_v2
SET has_end_time = 0
WHERE end_time IS NULL;
COMMIT;