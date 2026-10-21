-- TO RUN EVERY TIME: Foreign keys
PRAGMA foreign_keys = ON; -- run it in every session, before you write!
PRAGMA foreign_keys;
PRAGMA foreign_key_check;

-- Anniversary Index 
CREATE INDEX idx_trip_anniversary ON trips_v2(start_time, end_station_id);

-- Dock Pressure INDEX
CREATE INDEX idx_trip_dock_press ON stations_v2(station_id);