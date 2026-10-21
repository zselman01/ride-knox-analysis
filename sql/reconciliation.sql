-- TO RUN EVERY TIME: Foreign keys
PRAGMA foreign_keys = ON; -- run it in every session, before you write!
PRAGMA foreign_key_check;

-- Accounting query for stations_v2 TABLE
SELECT COUNT(*) AS stations FROM stations_v2;

-- Accounting query for stations_docks TABLE
SELECT COUNT(*) AS station_expansions FROM stations_docks;

-- Accounting query for rider_types_lookup TABLE
SELECT COUNT(*) AS rider_types FROM rider_types_lookup;

-- Accounting query for 2025 trips
SELECT COUNT(*) AS trips_2025 FROM staging_trips_v2;

-- Accounting query for Jan - June 2026 trips 
SELECT COUNT(*) AS trips_2026 FROM staging_trips_26;

-- Accounting query for "July" 2026 trips
SELECT COUNT(*) AS trips_07_2026 FROM staging_trips_26_07;

-- Accounting query for all trips_v2 trips
SELECT COUNT(*) AS trips_total FROM trips_v2;