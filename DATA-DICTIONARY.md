# DATA 501; SQL Module Project

**Name: Zaharia Selman**
**NetID: zselman**
**SQL tool used: DB Browser for SQLite**

## Part A: Schema design & the data dictionary
*Below is every table, every column, every constraint, and two - three sentences of rationale that a new teammate could follow for each design decision.*

*Create the stations_v2 table first because trips_v2 depends on it*

CREATE TABLE stations_v2 (
station_id TEXT NOT NULL PRIMARY KEY,
station_name TEXT NOT NULL,
neighborhood TEXT,
latitude REAL,
longitude REAL,
docks INTEGER,
year_installed INTEGER
);

*Create the trips table*

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

*Rider_types look-up table: I chose this design for the rider-product problem to avoid having to constantly change the entire schema with each new product. I would reject this decision because it adds a new join to every query. The bike type column is another column that faces the same risk as the rider type column.*

CREATE TABLE rider_types_lookup (
    rider_type TEXT PRIMARY KEY,
    price REAL,
	start_date TEXT
);

*"The number moved (docks) problem" table: This design choice does require another table join/merge, but makes sure that each year's denominator is derivable and not overwritten.*

CREATE TABLE stations_docks (
	station_id TEXT NOT NULL REFERENCES stations_v2(station_id),
    effective_date TEXT NOT NULL,
	docks_before INTEGER,
    docks_after INTEGER
);

*All staging tables were also included in teh schema. There is one for each raw data file (stations_v2, trips_v2, trips_26, and trips_26_07) that have a raw structure (no constraints) to clean data before importing into production tables presented above.*

*The three demonstrated rejections include the six different spellings in the rider_type column in the trips table, the duplicate rows, and the missing end_time values or trips ending before they have started in the trips table. Each check shows that the constraints are appropriately doing their job.*

1. CHECK constraint failed: rider_type IN ('member','casual')

2. CHECK constraint failed: end_time IS NULL OR end_time > start_time

3. Result: UNIQUE constraint failed: trips_v2.trip_id

## Part B: Load and reconcile the history

--- 2026 Stations Table

- Query table

- Load's predictions: 25 stations 

- Migration's actual row counts: SELECT COUNT(*) AS trips FROM stations_v2;

trips
25


--- Stations_Docks Table

- Query table

- Load's predictions: 3 stations (confirmed capacity events)

- Migration's actual row counts: SELECT * FROM stations_docks;

station_id	effective_date	docks_before	docks_after
S06	2026-02-15	24	32
S08	2026-02-15	24	32
S25	2026-03-01	0	16


--- 2025 Trips Table
- Query table

- Load's predictions: 250,600 (from data) - 263 (test stations-S99) - 600 (duplicate trips) - 747 (negative/impossible trips) = 248,990 total trips 

- Migration's actual row counts: SELECT COUNT(*) AS trips 
FROM staging_trips_v2
WHERE start_station_id <> 'S99'
AND (end_time IS NULL OR end_time > start_time);

trips
248990


--- Rider Types Lookup Table
- Query table

- Load's predictions: 3 rider types

- Migration's actual row counts: SELECT * FROM rider_types_lookup;

rider_type	price	start_date
member	50.5	2025-01-01
casual	35.5	2026-01-01
day pass	15.0	2026-03-01


--- After adding 2026 to Trips Table (added to 2025 Trips table)
- Query table

- Load's predictions: 248,990 (2025 trips) + 136,991 (2026 trips) - 180 (trips where end_time IS NULL or end_time > start_time) = 385,801 *total* trips

- Migration's actual row counts: SELECT COUNT(*) AS trips FROM trips_v2;

trips
385801



## Part C: The July drill

• Written inspection log

- Checked in staging (in SQL) before moving anything:
1. Duplicates
2. Null from all columns
3. End_time > Start_time
4. Correct distinct station_ids (start and end IDs), rider_type, bike_type
5. Make sure Day Pass riders are not < March 15, 2026
6. Need to remove station_name column (trip table only has IDs, not names)
7. After merging into trips_v2, check for duplicates again


- What was found --> Decision for each anomaly:
1. Duplicates 
- 120 rows --> rows deleted (impossible)

2. Any null from columns
- No null trip_id, start_station_id, or end_time
- 40 NULL start_time --> rows deleted (implausible and not many rows affected)
- 850 NULL end_station_id (846 that have NULL end_station_id ONLY and not also NULL start_time) --> Flagged before merged into trips_v2 (added columns to staged table before merging)


3. End_time < Start_time
- 60 trips --> rows deleted (impossible)

4. Correct distinct station_ids (start and end), rider_type, bike_type
- 25 start_stations reported (good!)
- 25 end_stations reported (good) BUT 850 NULL trips --> Flagged (see above)
- 6 different spellings for rider_type --> Normalized so there are only 3 spellings (member, casual, and day pass)
- 3 different bike_type (NEW type: cargo) --> Added a bike_type_lookup table to be able to add new bike types (similar to rider types)
*This is one of the row populations that my schema would refuse that I am choosing to repair so that new bike types are not lost/refused from the dataset. Adding the bike_type table also requires me to update the trips_v2 dependence for the bike_type column to point to this new table.*

5. Make sure Day Pass riders are not < March 15, 2026
- 0 trips (good!)

6. Need to remove station_name column (trip table only has IDs, not names) --> column deleted

7. After merging into trips_v2, check for duplicates again --> 180 duplicate trips removed before merging into trips_v2 (using INSERT OR IGNORE...)


Load's predictions: 385,801 (already populated 2025-2026 trips) + 32,685 (of the original 33,085 rows) = 418,486 *total* trips

Migration's actual row counts: SELECT COUNT(*) AS trips FROM trips_v2;

trips
418486


## Part D: The Reporting Layer

- View Defense:

CREATE VIEW clean_trips AS
SELECT trip_id, start_time, end_time, start_station_id, end_station_id,
rider_type, bike_type,
ROUND((julianday(end_time) - julianday(start_time)) * 1440, 1) AS duration_min
FROM trips_v2
WHERE end_station_id IS NOT NULL 
AND end_time IS NOT NULL
AND (julianday(end_time) - julianday(start_time)) * 1440 BETWEEN 1 AND 1440;

I chose to define my view this way to ensure that all the information plausible and accessible is reported. If we are interested in investigating Ride Knox operational issues (`NULL` `end_station_id` and `end_time`) that can be done in a separate analysis/report. Duration (whether minutes or hours) is a common analysis we have been reporting and ensuring the durations are no longer than 24 hours has also been a common reporting metric that makes sense for plausible trips considering bikes lock after 12 hours of use (information from previous project).

- The Anniversary Verdict:

Trips taken by casual riders decreased steeply by 30.03% from July 2025 (made up 33.8% of total trips (26,552) in July) vs July 2026 (made up 23.65% of total trips (31,733) in July).

The decline in trips taken by member riders was less steep (7.21%) from July 2025 (made up 66.2% of total trips (26,552)) vs July 2026 (made up 61.43% of total trips (31,733)).

The average duration (in minutes) for casual (M=22.9 min) and member (M=13.5 min) stayed consistent between July 2025 and July 2026.

For all riders, the classic bike type is riden more often than the electric bike type.

However, we cannot make any comparative analyses for the day pass rider when just comparing July 2025 and July 2026 (Day Pass didn't start until March 2026), so the following analyses compare the rider types from March - July across both years.

I have decided to keep all three rider types separate in this iteration of the project to consider the distinction being important for when Ride Knox adds new rider types in the future. There is no comparison of the day pass rider type in 2025, but we can still show how it's addition successfully offsets the trips that may have been lost after the price increase in July 2025 (see Figure 1 in project.ipynb).

From March to July 2026, day pass riders increase by 170.47% (5.52% (19,587 total trips) in March 2026 to 14.93% (31,733 total trips) in July 2026). However, adding Casual and Day Pass riders together (as non-members; 38.58%) in 2026 exceeds the percentage of Casual riders alone, showing the success of the Day Pass rider option offered in 2026 (see Figure 1 in project.ipynb).

- The Capacity Verdict:

Increasing the dock count at two (S06 and S08) out of the five stations leadership acted on, worked well for the pressure question. Pressure (trips/dock) decreased by 31% (2,746 vs 2,528 total trips) at S06 and pressure decreased by 29.3% (2,546 vs 2,408 total trips) at S08. The low pressure sites had little growth, but S23 increased by more than S24. Lastly, S25 shows the highest increase in pressure (increase by 132.75%), but this is because that station did not exist in 2025 (so had 0 trips and 0 docks to compare with; see Figure 2 in project.ipynb).

- Parameterized Query:

I made the query for the capacity verdict a query so that each month, analysts can compare the dock pressure. Even once other years are added (e.g., 2027, 2028, etc.) the same comparison can be made back to 2026 and 2025.

## Part E: Make It Fast, Prove It

- Index Justification: Anniversary verdict

CREATE INDEX idx_trip_anniversary ON trips_v2(end_station_id, start_time, end_time);

I chose to index by end_station_id, start_time and end_time because it is what I filtered by (WHERE) in the anniversary query (I had to rearrange my original query since Views cannot be indexed). These columns are wrapped in aggregate functions, but the order that they are presented makes them usable. The order also follows our class rule of thumb (equality columns first, range columns last) since end_station_id is an equality column that has distinct categories (S01, S02, etc.) and start_time and end_time are range columns (many values available).

- Index Justification: Dock Pressure verdict

CREATE INDEX idx_trips_dock_press ON stations_v2(station_id)

I chose to index by station_id because it is what I filtered by and the foreign keys I used to join to two other tables. 

I deliberately did not index by the rider_type or bike_type column in the anniversary query or start_time in the dock pressure query because rider_type only has three values and bike_type only has two values so much won't be eliminated from the searching time. Also, start_time is not filtered, joined, or ordered by in this query.

- Before/After Comparison

The index reduced the amount of time it took for the query to run. The anniversary query took 640.9 ms to run before the index and 627.3 ms after. The dock pressure query took 761.4 ms to run before the index and 727.3 ms afterwards. The size also increased, but not by much from from 81.2 mb to 94 mb.

## Part F: The Memo

*In project.ipynb*

## Reflection and AI Disclosure

*In project.ipynb*