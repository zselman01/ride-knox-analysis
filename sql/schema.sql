-- TO RUN EVERY TIME: Foreign keys
PRAGMA foreign_keys = ON; -- run it in every session, before you write!
PRAGMA foreign_keys;
PRAGMA foreign_key_check;

-- Part A: Create the Stations table
CREATE TABLE stations_v2 (
station_id TEXT NOT NULL PRIMARY KEY,
station_name TEXT NOT NULL,
neighborhood TEXT,
latitude REAL,
longitude REAL,
docks INTEGER,
year_installed INTEGER
);

-- Staging table: stations
CREATE TABLE staging_stations_v2 (
station_id TEXT,
station_name TEXT,
neighborhood TEXT,
latitude REAL,
longitude REAL,
docks INTEGER,
year_installed INTEGER
);

-- "The number moved (docks) problem" table
CREATE TABLE stations_docks (
	station_id TEXT NOT NULL REFERENCES stations_v2(station_id),
    effective_date TEXT NOT NULL,
	docks_before INTEGER,
    docks_after INTEGER
);

-- Rider_types look-up table
CREATE TABLE rider_types_lookup (
    rider_type TEXT PRIMARY KEY,
    price REAL,
	start_date TEXT
);

-- Create the Trips table
CREATE TABLE trips_v2 (
trip_id TEXT PRIMARY KEY,
start_time TEXT NOT NULL,
end_time TEXT,
start_station_id TEXT NOT NULL REFERENCES stations_v2(station_id),
end_station_id TEXT REFERENCES stations_v2(station_id),
--rider_type TEXT NOT NULL CHECK (rider_type IN ('member','casual')), --TAKE CHECK OUT AFTER GETTING REJECTION MESSAGES
rider_type TEXT NOT NULL REFERENCES rider_types_lookup(rider_type), --UNCOMMENT AFTER GETTING THE REJECTIONS (AFTER INSERTING DATA)
bike_type TEXT NOT NULL REFERENCES bike_types_lookup(bike_type),
has_end_station	INTEGER CHECK("has_end_station" IN (0, 1)),
has_end_time INTEGER CHECK("has_end_time" IN (0, 1)),
CHECK (end_time IS NULL OR end_time > start_time)
);

-- Staging table for Trips
CREATE TABLE staging_trips_v2 (
trip_id TEXT,
start_time TEXT,
end_time TEXT,
start_station_id TEXT,
start_station_name TEXT,
end_station_id TEXT,
--rider_type TEXT NOT NULL CHECK (rider_type IN ('member','casual')), --TAKE CHECK OUT AFTER GETTING REJECTION MESSAGES
rider_type TEXT, --UNCOMMENT AFTER GETTING THE REJECTIONS (AFTER INSERTING DATA)
bike_type TEXT,
has_end_station INTEGER,
has_end_time INTEGER
);

-- Staging table for Trips 2026
CREATE TABLE staging_trips_26 (
	trip_id TEXT,
	start_time	TEXT,
	end_time	TEXT,
	start_station_id	TEXT,
	start_station_name TEXT,
	end_station_id	TEXT,
	rider_type	TEXT,
	bike_type	TEXT,
	has_end_station INTEGER,
	has_end_time INTEGER
);

-- Staging table for Trips July 2026
CREATE TABLE staging_trips_26_07 (
	trip_id	TEXT,
	start_time	TEXT,
	end_time	TEXT,
	start_station_id	TEXT,
	start_station_name TEXT,
	end_station_id	TEXT,
	rider_type	TEXT,
	bike_type	TEXT,
	has_end_station	INTEGER,
	has_end_time	INTEGER
);

-- Bike_types look-up table
CREATE TABLE bike_types_lookup (
    bike_type TEXT PRIMARY KEY,
	start_date TEXT
);