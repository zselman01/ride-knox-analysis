# DATA 501; Assignment 12 Analysis Log

## Name: Zaharia Selman**
## NetID: zselman**


### Part 0: Setup, Project & Warm-Up 
library(tidyverse)
library(readxl)

trips    <- read_csv("trips_2025.csv")
stations <- read_excel("stations.xlsx")

glimpse(trips)
glimpse(stations)

count(trips, rider_type, sort = TRUE)

### Part 1: R Basics; Vectors and the Logical Shortcut 
north_docks <- c(12, 10, 12)
length(north_docks)
mean(north_docks)
north_docks_total <- sum(north_docks)

share_of_van_cap <- north_docks / north_docks_total * 100
share_of_van_cap[1]

north_docks > 10
mean(north_docks > 10)

### Part 2: Import & Inspect
glimpse(stations)

count(trips, start_station_name)

trips |>
  distinct(start_station_name) |>
  nrow()
nrow(trips)

### Part 3: Filtering, the NA Trap & the Three-Way Reconciliation 
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

### Part 4: mutate(); The Features This Week Needs 
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

### Part 5: group_by() + summarise() + mutate(); The Casual Share 
mix <- clean |>
  group_by(month) |>
  summarise(trips = n(), casual_pct = (sum(rider_type == "casual") / n()) * 100, median_min = median(duration_min), .groups="drop")

mix

cat("Percent point drop in casual percentage from June to July 2025:", mix$casual_pct[6] - mix$casual_pct[7])
cat("Drop in median duration (in minutes) from June to December 2025:", mix$median_min[6] - mix$median_min[12])

### Part 6: left_join(); Arrivals Per Dock 
arrivals <- clean |>
  count(end_station_id, name = "arrivals", sort = TRUE)
print(arrivals, n=25)

pressure <- clean |>
  filter(end_station_id != "S99") |>
  count(end_station_id, name = "trips") |>
  left_join(stations, by = c("end_station_id" = "station_id")) |>
  mutate(arrivals_per_dock = round(trips / docks)) |>
  arrange(desc(arrivals_per_dock))
print(pressure)

#bind_rows(...) to get them to print in the same table
print(bind_rows(head(pressure, 5), tail(pressure, 3)))
cat("Arrivals ratio for busiest station:", round(max(pressure$arrivals_per_dock) / max(pressure$trips), 2),"Arrivals ratio for least busiest station:", round(min(pressure$arrivals_per_dock) / min(pressure$trips), 2))

sum(arrivals$arrivals)
nrow(clean)
sum(arrivals$arrivals)-nrow(clean)

### Part 7: Figure 1; The Mix, Over Time 
ops_theme <- theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 15),
    legend.position = "top",
    panel.grid.minor = element_blank()
  )

mix_over_time <- ggplot(mix, aes(x = month, y = casual_pct, group = 1)) +
  geom_line(linewidth = 1) + 
  geom_point(size = 2) + 
  geom_vline(xintercept = 7, linetype = "dashed", colour = "red") +
  annotate("text", x = 7.5, y = 45, label = "July 1 price increase",
           hjust = 0, size = 3.5, colour = "grey30") + 
  scale_y_continuous(limits = c(0, NA)) + 
  labs(title = "Percentage of casual riders decline after July 1 price increase",
       subtitle = "Ride Knox casual rider trips per month, 2025",
       x = "Month", y = "Percentage (%) of Casual Riders",
       caption = "n = 247,967 trips, Ride Knox export.") +
  ops_theme


### Part 8: Figure 2; Dock Pressure 
dock_pressure <- ggplot(pressure, aes(x = arrivals_per_dock, y = fct_reorder(station_name, arrivals_per_dock), fill = neighborhood)) +
  geom_col(linewidth = 1) +
  scale_fill_viridis_d(option = "viridis") + # options include "viridis", "magma", "plasma", "inferno", "cividis"
  scale_x_continuous(labels = scales::label_comma()) +
  labs(title = "Cumberland Ave & 17th St had the highest arrivals per dock in 2025",
       subtitle = "Ride Knox arrivals per dock per station",
       x = "Arrivals (trips) per dock", y = "Station Name",
       caption = "n = 247,967 trips, Ride Knox export.") +
  ops_theme


### Part 9: Figure 3; Durations by Bike Type 
dur_bike_types <- clean |> group_by(bike_type) |> 
  summarise(
    trips = n(),
    median_dur = median(duration_min)
  ) |>
  arrange(desc(trips))
print(dur_bike_types)

dur_by_bike <- ggplot(clean, aes(x = bike_type, y = duration_min)) +
  geom_boxplot(outlier.shape = NA) +
  coord_cartesian(ylim = c(0, 60)) + 
  labs(title = "Median duration of two bike-types do not vary",
       subtitle = "Ride Knox durations (min) per bike type (classic and electric), 2025",
       x = "Bike Type", y = "Duration (min)",
       caption = "n = 247,967 trips, Ride Knox export.") +
  ops_theme

### Part 10: Figure 4; The Daily Rhythm 
hourly <- clean |> mutate(hour = hour(start_time)) |> count(hour, bike_type)
print(hourly)

daily_rhythm <- ggplot(hourly, aes(x = hour, y = n)) +
  geom_col() +
  facet_wrap(~ bike_type) + 
  labs(title = "More trips are taken with classic bikes throughout the day than with electric bikes",
       subtitle = "Ride Knox trips taken per bike type (classic and electric) per hour, 2025",
       x = "Hour", y = "No. trips",
       caption = "n = 247,967 trips, Ride Knox export.") +
  ops_theme

hourly |> arrange(desc(n))

### Part 11: Export, Git & the Operations One-Pager 
ggsave("figs_assignment12/mix_over_time.png", plot = mix_over_time,
       width = 9, height = 5, dpi = 300, bg = "white")

ggsave("figs_assignment12/dock_pressure.png", plot = dock_pressure,
       width = 15, height = 10, dpi = 300, bg = "white")

ggsave("figs_assignment12/dur_by_bike.png", plot = dur_by_bike,
       width = 9, height = 5, dpi = 300, bg = "white")

ggsave("figs_assignment12/daily_rhythm.png", plot = daily_rhythm,
       width = 9, height = 5, dpi = 300, bg = "white")


### Part 12: Challenge
dur_rider_types <- clean |> group_by(rider_type) |> 
  summarise(
    trips = n(),
    median_dur = median(duration_min)
  ) |>
  arrange(desc(trips))

challenge1 <- ggplot(clean, aes(x = duration_min)) +
  geom_histogram(bins = 60) +
  coord_cartesian(xlim = c(0, 90)) +
  facet_wrap(~ rider_type) +
  geom_vline(
    data = dur_rider_types, 
    aes(xintercept = median_dur), 
    linetype = "dashed", 
    colour = "red"
  ) +
  annotate("text", x = 25, y = 30000, label = "Median duration",
           hjust = 0, size = 3.5, colour = "black") + 
  labs(title = "Median duration for members is much higher than for casual riders",
       subtitle = "Ride Knox durations (min) per rider type (member and casual), 2025",
       x = "Duration (min)", y = "No. trips",
       caption = "n = 247,967 trips, Ride Knox export.") +
  ops_theme

ggsave("figs_assignment12/duration_min_by_rider.png", plot = challenge1,
       width = 9, height = 5, dpi = 300, bg = "white")

# Challenge 2
departures <- clean |>
  filter(end_station_id != "S99") |>
  count(start_station_id, name = "departures") |>
  left_join(stations, by = c("start_station_id" = "station_id")) |>
  mutate(departures_per_dock = round(departures / docks)) |>
  arrange(desc(departures_per_dock))
print(departures)

arrivals <- clean |>
  filter(end_station_id != "S99") |>
  count(end_station_id, name = "arrivals") |>
  left_join(stations, by = c("end_station_id" = "station_id")) |>
  mutate(arrivals_per_dock = round(arrivals / docks)) |>
  arrange(desc(arrivals_per_dock))
print(arrivals)

dep_and_arr <- departures |> 
  left_join(arrivals |> select(end_station_id, arrivals, arrivals_per_dock), #join only two columns that I need
            by = c("start_station_id" = "end_station_id")) |>
  mutate(arr_dep_diff = arrivals - departures) |>
  arrange(desc(arr_dep_diff))

ranking <- bind_rows(head(dep_and_arr, 5), tail(dep_and_arr, 5))

challenge_2 <- ggplot(ranking,
       aes(x = arr_dep_diff,
           y = fct_reorder(station_name, arr_dep_diff))) +
  geom_col(fill = "grey35") + 
  labs(title = "Cumberland Ave... has the largest arrival minus departure while Hodges Library has the smallest.",
       subtitle = "Ride Knox durations (arrival minus departure in min) per station, 2025",
       x = "Arrival - Departure Difference (min)", y = "Station",
       caption = "n = 247,967 trips, Ride Knox export.") +
  ops_theme

ggsave("figs_assignment12/arr_dep_difference.png", plot = challenge_2,
       width = 12, height = 5, dpi = 300, bg = "white")
