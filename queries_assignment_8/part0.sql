-- TODO 0a: Four-count query from class lecture
SELECT
COUNT(*) AS rows_total,
COUNT(end_station_id) AS with_end_station,
COUNT(DISTINCT start_station_id) AS distinct_start_ids,
COUNT(DISTINCT rider_type) AS rider_type_spellings
FROM trips;