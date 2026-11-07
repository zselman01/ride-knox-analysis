library(tidyverse)
library(readxl)

trips    <- read_csv("trips_2025.csv", name_repair = )
stations <- read_excel("stations.xlsx")

count(trips, rider_type, sort = TRUE)

north_docks <- c(12, 10, 12)
length(north_docks)
mean(north_docks)
north_docks_total <- sum(north_docks)

share_of_van_cap <- north_docks / north_docks_total * 100
share_of_van_cap[1]

north_docks > 10
mean(north_docks > 10)

glimpse(stations)

count(trips, start_station_name)

trips |>
  distinct(start_station_name) |>
  nrow()
nrow(trips)

clean <- trips |>
  distinct() |>
  filter(start_station_id != "S99",
         is.na(end_station_id) | end_station_id != "S99") |>
  mutate (
    rider_type = str_to_lower(str_trim(rider_type)),
    duration_min = as.numeric(difftime(end_time, start_time, units="mins"))
  ) |>
  filter(duration_min >=1, duration_min <= 1440)

clean |> nrow()

round_trips <- clean |>
  filter(start_station_id == end_station_id)

round_trips |> nrow()

one_way <- clean |>
  filter(start_station_id != end_station_id)

one_way |> nrow()

missing_end <- clean |>
  filter(is.na(end_station_id))

missing_end |> nrow()

one_way_missing_end <- clean |>
  filter(start_station_id != end_station_id | is.na(end_station_id))

one_way_missing_end |> 
  nrow()

cat("One-way:", nrow(one_way), "+ Round trip:", nrow(round_trips),
    "+ End Unknown:", nrow(missing_end), "= Total cleaned trips: ", nrow(clean))

clean <- clean |>
  mutate(
    month = month(start_time, label=TRUE),
    hour = hour(start_time)
  )

clean <- clean |>
  mutate(
    is_evening = hour >= 16
  )

mean(clean$is_evening)

mix <- clean |>
  group_by(month) |>
  summarise(trips = n(), casual_pct = (sum(rider_type == "casual") / n()) * 100, median_min = median(duration_min), .groups="drop")

mix

cat("Percent point drop in casual percentage from June to July 2025:", mix$casual_pct[6] - mix$casual_pct[7])
cat("Drop in median duration (in minutes) from June to December 2025:", mix$median_min[6] - mix$median_min[12])
