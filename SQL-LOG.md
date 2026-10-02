# DATA 501; Assignment 7 SQL Log

**Name: Zaharia Selman**
**NetID: zselman**
**SQL tool used: DB Browser for SQLite**

## Part 0
**Output**
*0a*
trips

CREATE TABLE trips (
    trip_id           TEXT PRIMARY KEY,
    start_time        TEXT NOT NULL,
    end_time          TEXT,
    start_station_id  TEXT REFERENCES stations(station_id),
    end_station_id    TEXT REFERENCES stations(station_id),
    rider_type        TEXT,
    bike_type         TEXT
)

*0b*
0	station_id	TEXT	0		1
1	station_name	TEXT	1		0
2	neighborhood	TEXT	0		0
3	latitude	REAL	0		0
4	longitude	REAL	0		0
5	docks	INTEGER	0		0
6	year_installed	INTEGER	0		0

*The station_id column is flagged as the primary key*
## Part 1
...
