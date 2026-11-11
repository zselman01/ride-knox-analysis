# DATA 501; Assignment 12 Analysis Log

**Name: Zaharia Selman**
**NetID: zselman**
**R version: 4.6.2 (2026-10-29 ucrt)**
**tidyverse version: tidyverse 2.0.0**

## Part 0

*0a*

> getwd()
[1] "C:/Users/zselm/OneDrive - University of Tennessee/Personal/Data Science Toolkit/ride-knox-analysis"

*I did not have to type a full path to my data because we created the R file inside of ride_knox_analysis already.*

*0b*

> library(tidyverse)
── Attaching core tidyverse packages ───────────────────────────────────────────────────────────────────────────── tidyverse 2.0.0 ──
✔ dplyr     1.2.1     ✔ readr     2.2.0
✔ forcats   1.0.1     ✔ stringr   1.6.0
✔ ggplot2   4.0.3     ✔ tibble    3.3.1
✔ lubridate 1.9.5     ✔ tidyr     1.3.2
✔ purrr     1.2.2     
── Conflicts ─────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
ℹ Use the conflicted package to force all conflicts to become errors
> library(readxl)

*0c*

> count(trips, rider_type, sort = TRUE)
*# A tibble: 6 × 2*
  rider_type      n
  <chr>       <int>
1 member     153388
2 casual      88395
3 Member       3170
4 MEMBER       2369
5 Casual       1906
6 CASUAL       1372

*Q0d: A classmate's script opens with install.packages("tidyverse") so that "it works on any machine." `install.packages(...)` belongs in the console, never in the script because it is a one-time setup for your computer and for reproducibility purposes does not match what should only be produced by your script.*

## Part 1

*1a*

> north_docks <- c(12, 10, 12)
> length(north_docks)
[1] 3
> mean(north_docks)
[1] 11.33333
> sum(north_docks)
[1] 34

*1b*

> share_of_van_cap <- north_docks / north_docks_total * 100
> share_of_van_cap[1]
[1] 35.29412

*1c*

> north_docks > 10
[1]  TRUE FALSE  TRUE
> mean(north_docks > 10)
[1] 0.6666667

*The second number represents the average of all values greater than 10 in the vector.*

*Q1d: 1c is a shortcut you will use again in Part 5. `mean(x > 10)` gives me a proportion rather than an average dock count because only those values that return TRUE from the boolean command are included in the calculation for mean (not all the numbers if they are not all > 10).*

## Part 2

*2a*

> trips <- read_csv("trips_2025.csv")
Rows: 250600 Columns: 8                                                                                                              
── Column specification ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
Delimiter: ","
chr  (6): trip_id, start_station_id, start_station_name, end_station_id, rider_type, bike_type
dttm (2): start_time, end_time

*2b*

**Commented out to avoid formatting issues below output**
<!-- > glimpse(stations)
Rows: 24
Columns: 7
$ station_id     <chr> "S01", "S02", "S03", "S04", "S05", "S06", "S07", "S08", "S09", "S10", "S11", "S12", "S13", "S14", "S15", "S1…
$ station_name   <chr> "Market Square", "Gay Street & Union Ave", "Krutch Park", "Old City - Jackson Ave", "World's Fair Park", "Ho…
$ neighborhood   <chr> "Downtown", "Downtown", "Downtown", "Old City", "World's Fair Park", "UT Campus", "UT Campus", "UT Campus", …
$ latitude       <dbl> 35.9649, 35.9662, 35.9636, 35.9721, 35.9622, 35.9553, 35.9546, 35.9560, 35.9550, 35.9448, 35.9575, 35.9601, …
$ longitude      <dbl> -83.9197, -83.9184, -83.9186, -83.9151, -83.9265, -83.9264, -83.9256, -83.9295, -83.9250, -83.9376, -83.9330…
$ docks          <dbl> 20, 16, 12, 16, 20, 24, 12, 24, 16, 12, 16, 12, 10, 12, 10, 10, 12, 10, 12, 10, 10, 12, 12, 10
$ year_installed <dbl> 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2022, 2023, 2023, 2022, 2023, 2023, 2023, 2024, 2024, 2023, 2024, … -->

*2c*

> count(trips, start_station_name)
**# A tibble: 73 × 2**
   start_station_name           n
   <chr>                    <int>
 1 AG CAMPUS - MORGAN HALL    127
 2 Ag Campus - Morgan Hall   7004
 3 BEARDEN - KINGSTON PIKE     49
 4 BROADWAY & CENTRAL         112
 5 Bearden - Kingston Pike   2028
 6 Broadway & Central        5094
 7 CASWELL PARK                54
 8 CUMBERLAND AVE & 17TH ST   332
 9 Caswell Park              2749
10 Cumberland Ave & 17th St 18342
**# ℹ 63 more rows**
**ℹ Use `print(n = ...)` to see more rows**
> 
> trips |>
+   distinct(start_station_name) |>
+   nrow()
[1] 73

*Matches with the anchor: trips_2025.csv holds 250,600 rows, with 73 distinct start_station_name values as read_csv() imports them.*

*Q2d: Module 10 counted 121 distinct raw values in this same column (start_station_name), straight from the text of the file. However, I got 73 here, not 121. The read_csv() argument responsible, is `trim_ws`. The one-line change that reproduces Module 10's number is `trim_ws = FALSE`. `readr` assumed that I wanted white spaces removed (truncating the number of station names present in the data) before I ever looked at it.*

*Q2e: The two columns read_csv() typed as <dttm> are start_time and end_time. Calculating the duration is one specific thing in Part 4 that would break if those had come in as <chr> instead.*

*Q2f: Stations has 24 rows and trips has 250,600. These two objects are called `tibble/data.frame` in `R` and a signle column of one of them is called `df$col`.*

## Part 3

*3a*

> clean <- trips |>
+   distinct() |>
+   filter(start_station_id != "S99",
+          is.na(end_station_id) | end_station_id != "S99") |>
+   mutate (
+     rider_type = str_to_lower(str_trim(rider_type)),
+     duration_min = as.numeric(difftime(end_time, start_time, units="mins"))
+   ) |>
+   filter(duration_min >=1, duration_min <= 1440)
> 
> clean |> nrow()
[1] 247967

*3b*

> round_trips <- clean |>
+   filter(start_station_id == end_station_id)
> 
> round_trips |> nrow()
[1] 30112

*3c*

> one_way <- clean |>
+   filter(start_station_id != end_station_id)
> 
> one_way |> nrow()
[1] 214129

*3d*

*The gap between what I got for 3b and 3c and 247,967 trips is the 3,726 trips that have a missing end_station_id (dropped by R because it doesn't fit into either filter category). I have decided that those trips belong in a category of their own similar to our flagged column in previous modules to reflect an operational issue that may need to be addressed later.*

> one_way <- clean |>
+   filter(start_station_id != end_station_id)
> 
> one_way |> nrow()
[1] 214129
> 
> missing_end <- clean |>
+   filter(is.na(end_station_id))
> 
> missing_end |> nrow()
[1] 3726

**VERSUS**

> one_way_missing_end <- clean |>
+   filter(start_station_id != end_station_id | is.na(end_station_id))
> 
> one_way_missing_end |> 
+   nrow()
[1] 217855

*3e*

> cat("One-way:", nrow(one_way), "+ Round trip:", nrow(round_trips),
+     "+ End Unknown:", nrow(missing_end), "= Total cleaned trips: ", nrow(clean))
One-way: 214129 + Round trip: 30112 + End Unknown: 3726 = Total cleaned trips:  247967

*Q3f: Class hit this same trap on a different comparison. The general rule about NA inside filter() that covers both cases is that in R, NA != "S99" is NA, and filter() drops rows that aren't TRUE. Therefore, we should fix it with filter(is.na(end_station_id) | end_station_id != "S99"). A student who only ever tested their pipeline against a row count would never find it, because the issue (NA) is embedded within the trips table.*

*Q3g: One of the 3d fixes keeps trips with no end station in the "one-way" group. The ops lead might actually want those 3,726 trips in a category of their own if they later want to investigate data that supports the lack of end_station_ids being reported for certain stations, docks, neighborhoods, etc.*

## Part 4

*4a & 4b*

> clean <- clean |>
+   mutate(
+     month = month(start_time, label=TRUE),
+     hour = hour(start_time)
+   )
> clean <- clean |>
+   mutate(
+     is_evening = hour >= 16
+   )
> mean(clean$is_evening)
[1] 0.40457

*Q4c: You created month as a labelled month rather than a number. This allows me to have the specific month names in the Part 7 figure so that just numbers aren't displayed which would make the figure harder to read/understand.*

*Q4d: 4a and 4b could have been one `mutate()` call instead of two; `is_evening` depends on `hour`, which 4a creates. The single-call version is legal because later expressions can use earlier expressions in the same call. However, a reviewer may prefer the call being written as two to avoid anything getting overwritten by the `mutate()` call.*

## Part 5

*5a & 5b*

> mix <- clean |>
+   group_by(month) |>
+   summarise(trips = n(), casual_pct = (sum(rider_type == "casual") / n()) * 100, median_min = median(duration_min), .groups="drop")
> 
> mix
**# A tibble: 12 × 4**
   month trips casual_pct median_min
   <ord> <int>      <dbl>      <dbl>
 1 Jan   10791       43.5       14.1
 2 Feb   13280       42.7       14.0
 3 Mar   19725       43.4       14.3
 4 Apr   25396       44.3       14.2
 5 May   29613       44.6       14.4
 6 Jun   31279       44.2       14.2
 7 Jul   26926       33.8       13.5
 8 Aug   24611       30.4       13.4
 9 Sep   22947       27.4       13.1
10 Oct   19568       25.5       13.0
11 Nov   13587       24.4       13.0
12 Dec   10244       22.7       12.8

*5c*

> cat("Percent point drop in casual percentage from June to July 2025:", mix$casual_pct[6] - mix$casual_pct[7])
Percent point drop in casual percentage from June to July 2025: 10.41845
> cat("Drop in median duration (in minutes) from June to December 2025:", mix$median_min[6] - mix$median_min[12])
Drop in median duration (in minutes) from June to December 2025: 1.4

*5d*

*Q5d: Class charted casual trips as a count and found a cliff. Here, I measured the same period as a share. The count shows raw scores (can clearly see the impact of the cliff) that the percentage/share cannot show. The percentage/share shows a value that can be compared across months that the count cannot show.*

*Q5e: Your median_min falls steadily across the year, but nothing about any individual rider's habits changed. Using my casual_pct column and the class figure that casual trips run about 19.0 minutes against a member's 11.6, the steady fall in median_min across the year can be explained by the decline in the proportion of casual riders (the group with the higher median duration). This kind of effect is bringing the overall median duration down.*

## Part 6

*6a*

> clean |>
+   count(end_station_id, name = "arrivals", sort = TRUE)
**# A tibble: 25 × 2**
   end_station_id arrivals
   <chr>             <int>
 1 S06               25301
 2 S08               24263
 3 S01               22131
 4 S11               18783
 5 S02               16141
 6 S05               15021
 7 S07               14034
 8 S04               13922
 9 S09               12899
10 S03               10507
**15 more rows**

*Station S99 is a group in our count that is not a station and its count is 3,726 trips*

*6c*

> print(bind_rows(head(pressure, 5), tail(pressure, 3)))
**# A tibble: 8 × 9**
  end_station_id trips station_name             neighborhood latitude longitude docks year_installed arrivals_per_dock
  <chr>          <int> <chr>                    <chr>           <dbl>     <dbl> <dbl>          <dbl>             <dbl>
1 S11            18783 Cumberland Ave & 17th St Fort Sanders     36.0     -83.9    16           2022              1174
2 S07            14034 The Hill - Ayres Hall    UT Campus        36.0     -83.9    12           2022              1170
3 S01            22131 Market Square            Downtown         36.0     -83.9    20           2022              1107
4 S06            25301 Hodges Library           UT Campus        36.0     -83.9    24           2022              1054
5 S08            24263 Student Union - UT       UT Campus        36.0     -83.9    24           2022              1011
6 S21             2892 Caswell Park             East Knoxvi…     36.0     -83.9    10           2024               289
7 S24             1931 Sequoyah Hills Park      Sequoyah Hi…     35.9     -84.0    10           2025               193
8 S23             2087 Bearden - Kingston Pike  Bearden          35.9     -84.0    12           2025               174
> cat("Arrivals ratio for busiest station:", round(max(pressure$arrivals_per_dock) / max(pressure$trips), 2),"Arrivals ratio for least busiest station:", round(min(pressure$arrivals_per_dock) / min(pressure$trips), 2))
Arrivals ratio for busiest station: 0.05 Arrivals ratio for least busiest station: 0.09

*6d*

> sum(arrivals$arrivals)
[1] 247967
> nrow(clean)
[1] 247967
> sum(arrivals$arrivals)-nrow(clean)
[1] 0

*Because we removed the S99 stations, this is why the numbers match perfectly with 247,967 trips (there is no S99 in stations).*

*Q6e: Class ranked departures and got a top station of about 1,175 trips per dock. Your arrivals ranking lands within a few points of that. The arrival ranking tells us the pressure of bikes piling up at a station and the departure ranking does not answer this. ; and One reason an annual total of either might still send the van to the wrong place is because annual aggregates tell us nothing about time-of-day and seasonal variations, masking the actual time pressure.*

## Part 7

*7a*
ops_theme <- theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 15),
    legend.position = "top",
    panel.grid.minor = element_blank()
  )
print(ops_theme)

*7b*
> ggplot(mix, aes(x = month, y = casual_pct, group = 1)) +
+   geom_line(linewidth = 1) + 
+   geom_point(size = 2)

*7c*
> ggplot(mix, aes(x = month, y = casual_pct, group = 1)) +
+   geom_line(linewidth = 1) + 
+   geom_point(size = 2) + 
+   geom_vline(xintercept = 7, linetype = "dashed", colour = "red") +
+   annotate("text", x = 7.5, y = 45, label = "July 1 price increase",
+            hjust = 0, size = 3.5, colour = "grey30")

*7d*
> ggplot(mix, aes(x = month, y = casual_pct, group = 1)) +
+   geom_line(linewidth = 1) + 
+   geom_point(size = 2) + 
+   geom_vline(xintercept = 7, linetype = "dashed", colour = "red") +
+   annotate("text", x = 7.5, y = 45, label = "July 1 price increase",
+            hjust = 0, size = 3.5, colour = "grey30") + 
+   scale_y_continuous(limits = c(0, NA)) + 
+   labs(title = "Percentage of casual riders in 2025",
+        subtitle = "Ride Knox casual rider trips per month",
+        x = "Month", y = "Percentage (%) of Casual Riders",
+        caption = "n = 247,967 trips, Ride Knox export.") 

*7e*
> ggplot(mix, aes(x = month, y = casual_pct, group = 1)) +
+   geom_line(linewidth = 1) + 
+   geom_point(size = 2) + 
+   geom_vline(xintercept = 7, linetype = "dashed", colour = "red") +
+   annotate("text", x = 7.5, y = 45, label = "July 1 price increase",
+            hjust = 0, size = 3.5, colour = "grey30") + 
+   scale_y_continuous(limits = c(0, NA)) + 
+   labs(title = "Percentage of casual riders in 2025",
+        subtitle = "Ride Knox casual rider trips per month",
+        x = "Month", y = "Percentage (%) of Casual Riders",
+        caption = "n = 247,967 trips, Ride Knox export.") +
+   ops_theme

*The finished figure shows a sharp decline in the percentage of casual riders after the July 1 price increase (marked by the red dashed line).*

*Q7f: You pinned the y-axis at zero. If I instead let it start at 20, the apparent size of the July drop looks much greater than it actually is. That is one of the crimes from the class ledger (truncated bar axis) because the y-axis bar length encodes value.*

## Part 8

*8a*
> ggplot(pressure, aes(x=arrivals_per_dock, y=fct_reorder(station_name, arrivals_per_dock))) +
+   geom_col(linewidth = 1)

*8b*
> ggplot(pressure, aes(x = arrivals_per_dock, y = fct_reorder(station_name, arrivals_per_dock), fill = neighborhood)) +
+   geom_col(linewidth = 1) +
+   scale_fill_viridis_d(option = "viridis")

*8c*
> ggplot(pressure, aes(x = arrivals_per_dock, y = fct_reorder(station_name, arrivals_per_dock), fill = neighborhood)) +
+   geom_col(linewidth = 1) +
+   scale_fill_viridis_d(option = "viridis") + # options include "viridis", "magma", "plasma", "inferno", "cividis"
+   scale_x_continuous(labels = scales::label_comma()) +
+   labs(title = "Cumberland Ave & 17th St had the highest arrivals per dock in 2025",
+        subtitle = "Ride Knox arrivals per dock per station",
+        x = "Arrivals (trips) per dock", y = "Station Name",
+        caption = "n = 247,967 trips, Ride Knox export.") +
+   ops_theme

*Q8d: Class set fill to a constant grey and said explicitly why. However, here I mapped to a variable (neighborhood). My version is justified because the variable adds information to the bar chart that would otherwise be lost without the mapping.*

*Q8e: Your chart now carries 12 fill colours. Not only is figure harder to read because of the colourblind-safe discrete  scale, but it's harder to read quickly/understand because of how many colors there are. If the ops lead complained, I would definitely map by a different variable (e.g., mutate a column for a certain threshold and map by those that cross that threshold vs those that dont).*

## Part 9

*9a - 9c*
> ggplot(clean, aes(x = bike_type, y = duration_min)) +
+   geom_boxplot(outlier.shape = NA) +
+   coord_cartesian(ylim = c(0, 60)) + 
+   labs(title = "Median duration of two bike-types do not vary",
+        subtitle = "Ride Knox durations (min) per bike type (classic and electric), 2025",
+        x = "Bike Type", y = "Duration (min)",
+        caption = "n = 247,967 trips, Ride Knox export.") +
+   ops_theme

*Q9d: Despite the fleet team's belief that electric bikes get taken on longer trips, the duration of trips taken by classic and electric bikes are about the same.*

*Q9e: Changing the argument about setting the y-axis to a range that makes the boxes readable would make these two boxes look meaningfully different. This would be another example of the truncated bar axis crime from class and would cause a reader to wrongfully conclude that the duration of electric bikes is longer than classic bikes.*

## Part 10

*10a*
> hourly <- clean |> mutate(hour = hour(start_time)) |> count(hour, bike_type)
> print(hourly)
*# A tibble: 48 × 3*
    hour bike_type     n
   <int> <chr>     <int>
 1     0 classic     574
 2     0 electric    321
 3     1 classic     280
 4     1 electric    156
 5     2 classic     179
 6     2 electric    130
 7     3 classic     194
 8     3 electric    136
 9     4 classic     532
10     4 electric    333
*38 more rows*

*10b*

ggplot(hourly, aes(x = hour, y = n)) +
  geom_col() +
  facet_wrap(~ bike_type) + 
  labs(title = "More trips are taken with classic bikes throughout the day than with electric bikes",
       subtitle = "Ride Knox trips taken per bike type (classic and electric) per hour, 2025",
       x = "Hour", y = "No. trips",
       caption = "n = 247,967 trips, Ride Knox export.") +
  ops_theme

*10c*

*When `scales = "free_y"`, the figures are still correct, but they become easier to misinterpret because the y-axis values change to reflect the true counts across the two biketypes but the height of the bars are similar across the types making it seem like they have equal counts (if someone is looking at it quickly and not reading it carefully).*

*Q10d: The classic bike's peak hour is 5pm with 15,591 trips. The electric bike's peak hour is also 5pm but with 9,187 trips. Without looking carefully, the free-scales version tells a reader that the max count for trips is the same across classic and electric bikes at 5pm, which is not true.*

## Part 11

*11a*
> ggsave("figs_assignment12/mix_over_time.png", plot = mix_over_time,
+        width = 9, height = 5, dpi = 300, bg = "white")
> 
> ggsave("figs_assignment12/dock_pressure.png", plot = dock_pressure,
+        width = 9, height = 5, dpi = 300, bg = "white")
> 
> ggsave("figs_assignment12/dur_by_bike.png", plot = dur_by_bike,
+        width = 9, height = 5, dpi = 300, bg = "white")
> 
> ggsave("figs_assignment12/daily_rhythm.png", plot = daily_rhythm,
+        width = 9, height = 5, dpi = 300, bg = "white")

*11b*

*Last few rows of output and four images are in figs_assignment12/:*

**# A tibble: 48 × 3**
    hour bike_type     n
   <int> <chr>     <int>
 1     0 classic     574
 2     0 electric    321
 3     1 classic     280
 4     1 electric    156
 5     2 classic     179
 6     2 electric    130
 7     3 classic     194
 8     3 electric    136
 9     4 classic     532
10     4 electric    333
**# ℹ 38 more rows**
**# ℹ Use `print(n = ...)` to see more rows**

*11c: Write the one-pager in ANALYSIS-LOG.md, addressed to the operations lead, using the five-part structure from Module 4: bottom line, evidence, interpretation labeled as interpretation, limitations, recommendation. Reference each figure by filename. 150–250 words. At least three limitations, one of which must come from a judgment call you made in Part 3 or Part 6.*

### Bottom Line
The percentage of casual riders continues to decline steadily after July 1 price increase and on the arrival side, Cumberland Ave & 17th St, The Hill - Ayres Hall, and Market Square have the highest dock pressure.

### Evidence
Between June (31,279 total trips) to July (26,926 total trips) 2025 there was a 10.42% drop in casual riders using Ride Knox (see `figs_assignment12/mix_over_time.png`), but there was only a 1.4 minute drop in median duration from June to December (10,244 total trips) 2025.

Of the three North Knoxville stations that the ops lead's van serves, one of them (Cumberland Ave & 17th St) has the highest dock pressure for bikes arriving to this station (see `figs_assignment12/dock_pressure.png`).

Despite the fleet team's belief that electric bikes get taken on longer trips, the duration of trips taken by classic and electric bikes are about the same (see `figs_assignment12/dur_by_bike.png`). Additionally, the number of trips taken by classic bikes throughout the day is higher than for electric bikes (see `figs_assignment12/daily_rhythm.png`)

### Interpretation
By the end of 2025, casual riders have not recovered from their decline after the price increase in June. The ops lead's van may only be appropriately serving one of the highest pressured stations for arrivals. Classic bikes are being used by consumers in a different way than expected by the team.

### Limitations
Trips shorter than 1 minute and longer than 24 hours have been filtered out, trips missing an end_station_id have been kept in, and S99 stations have been filtered out from these analyses. Other than the test stations (S99) that should not be included in any analyses, the other options were chosen to best represent valid trips, while not losing trips that may have operational problems that can be investigated by the op's team at a later time.

### Recommendations
There needs to be an incentive to encourage an increase in casual riders and use of the electric bike types. The op's team should reevaluate their concentration on three North Knoxville stations to those that also have many bikes pilling up at them.

*Q11e: We commit the script that made the figure, but not the figures because the script is the origin or source of our figures. The figures can be regenerated from the script without providing the figures themselves. The one circumstance where we would commit the figures anyway is when our script/code is not available anywhere else.*

## Part 12

*C1*
We have much more trips reported for member riders, but the histogram shows that casual riders have a higher median duration than member riders. See `figs_assignment12/duration_min_by_rider.png`

*C2*
See `figs_assignment12/arr_dep_difference.png`

*C3: The net-flow numbers in C2 are far smaller than you might expect; no station gains or loses more than a few hundred bikes across a whole year. Based on these numbers/findings, we cannot prove that the ops lead's van is needed at Cumberland Ave & 17th St and **not** at Hodges Library, for example. Fluctuations throughout the year may cancel out what we would see if we looked at this same pattern across stations but at the daily or hourly level to find the imbalance she is actually chasing.*


## Reflection

*R1. Two tasks this week had a version that ran perfectly and was wrong: the filter() in 3c, and the free-scales facet in 10c. I would have been least likely to catch the filter() on my own. I think an important habit to practice to avoid this includes the exploratory stage of data analysis. Before mutating any new columns, filtering, etc., its important to check the values (and distinct) of every column, any NULL values, and things like that.*

*R2. Through this assignment, I have now drawn the same underlying dataset in matplotlib (Module 4) and in ggplot2. One thing that was genuinely easier using ggplot2 was being able to add all of the labels (title, subtitle, axes, and caption) all in one function. One thing that was not easier using ggplot2 was having to remember to add the `+` after each line of code for the chart. The tool that I would probably reach for to sketch a chart nobody but me would see is ggplot2.*

*AI Disclosure: I used Google to remeber how to use the simple math operations (instead of a loop) for Part 1b. This is very convenient because it is done for every index in the vector without explicitly having to write out a for loop. I also used Google to learn how to print text out to the console in R (similar to bash using `cat`), set a mutate column to a boolean value when a condition is met (similar to 1d), how to merge only one column from a joined tibble, how to get the median for each rider type to show up on the figure in Part 9, and fix a warning message that I recevied about trying to call summarise in 5a using mix$summarise. This can't be done because summarise is not a column in the tibble, but the actual columns can be called using that method. All final code, figures, and conclusions are my own."*
