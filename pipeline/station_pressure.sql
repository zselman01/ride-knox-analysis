-- sqlite3 "$ride_knox.db" <<SQL -- I'm not sure why this isn't working
.mode csv
.headers on
.once ./out_assignment11/station_pressure.csv
SELECT t.start_station_id, s.station_name, s.docks, COUNT(*) AS total_departures, (COUNT(*) / s.docks) AS trips_per_dock
FROM trips t
LEFT JOIN stations s ON t.start_station_id = s.station_id
GROUP BY t.start_station_id 
ORDER BY trips_per_dock DESC;
--- SQL -- I'm not sure why this isn't working