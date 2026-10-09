# DATA 501; Assignment 7 SQL Log

**Name: Zaharia Selman**
**NetID: zselman**
**SQL tool used: DB Browser for SQLite**

## Part 0
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

*Q0: PRAGMA table_info(stations) automatically tells me the type of each column in stations which opening stations.xlsx in Excel would not have told me.*




## Part 1
*1a*

station primary key: station_id
trips primary key: trip_id

Foreign keys:
- trips.start_station_id → stations.station_id
- trips.end_station_id → stations.station_id

*1b*

The database is designed this way to prevent overstating or duplicating information unnecessarily. Every fact is stored once, in the table where it belongs, and referenced everywhere else (reduces redundancy). This prevents us from having the problem when we were using Python where we had 121 different station-name spellings when there was only 24 stations.

*1c*

In a normalized database 1 row would have to change (the one for Suttree Landing) in the stations table with one line of code. In the flat CSV you would have to manually fix the latitude and longitude (and possibly neighborhood).

*Q1d: Having a primary key linking trips and stations constrained the database from being 'dirty' and having duplicate rows. This is better than the drop_duplicates() from Module 3 because no one had to notice, decide, or write code (this was done automatically by SQL).*




## Part 2
*2a*

S01	Downtown	35.9649	-83.9197
S02	Downtown	35.9662	-83.9184
S03	Downtown	35.9636	-83.9186
S04	Old City	35.9721	-83.9151
S05	World's Fair Park	35.9622	-83.9265

Result: 24 rows returned in 18ms

*2b*

station_id	station_name	year_installed	age_years
S01	Market Square	2022	4
S02	Gay Street & Union Ave	2022	4
S03	Krutch Park	2022	4
S04	Old City - Jackson Ave	2022	4
S05	World's Fair Park	2022	4

Result: 24 rows returned in 991ms

*2c*

trip_id	start_time	duration_hr
T0057984	2025-01-01 00:06:48	0.21
T0073896	2025-01-01 00:40:20	0.67
T0206129	2025-01-01 00:42:40	0.46
T0163585	2025-01-01 00:42:54	0.25
T0094124	2025-01-01 01:19:33	0.51

Result: 250000 rows returned in 2129ms

*Q2d: No, age_years does not exist anywhere in stations after I run 2b. A result set is a temporary retrieval of data that does not affect/change the raw data tables.*

*Q2e: The ops team should not ask to see everything from trips because that would result in a large (250,000 rows of data), uninformative (it hides your intent to yourself and other readers later on) report.* 




## Part 3
*3a*

neighborhood
Downtown
Old City
World's Fair Park
UT Campus
UT Ag Campus
Fort Sanders
South Knoxville
North Knoxville
East Knoxville
West Knoxville
Bearden
Sequoyah Hills

*3b*

Result: 25 rows returned in 53ms

start_station_id
S23
S24
S99

*Q3c: The station ID that does not appear in stations is S99, the test station that we're not supposed to use in our analysis. SQLite doesn't enforce foreign keys unless you switch it on (PRAGMA foreign_keys = ON).*

*Q3d: The database normalized stations but nobody constrained rider_type. This illustrates that text/strings still have to be cleaned in databases.*




## Part 4
*4a*

station_name
Cumberland Ave & 17th St
Fort Sanders - Laurel Ave

*4b*

station_id	station_name	docks
S01	Market Square	20
S05	World's Fair Park	20
S06	Hodges Library	24
S08	Student Union - UT	24

*4c*

station_name	neighborhood	docks
Hodges Library	UT Campus	24
Student Union - UT	UT Campus	24
Neyland Stadium	UT Campus	16
Cumberland Ave & 17th St	Fort Sanders	16

*4d*

station_name	neighborhood	docks
Hodges Library	UT Campus	24
The Hill - Ayres Hall	UT Campus	12
Student Union - UT	UT Campus	24
Neyland Stadium	UT Campus	16
Cumberland Ave & 17th St	Fort Sanders	16

*4e*

station_name
South Waterfront
Suttree Landing Park
Ijams Nature Center
Zoo Knoxville
Caswell Park

*4f*

station_id	station_name	docks
S02	Gay Street & Union Ave	16
S03	Krutch Park	12
S04	Old City - Jackson Ave	16
S07	The Hill - Ayres Hall	12
S09	Neyland Stadium	16
S10	Ag Campus - Morgan Hall	12
S11	Cumberland Ave & 17th St	16
S12	Fort Sanders - Laurel Ave	12
S14	South Waterfront	12
S17	Happy Holler	12
S19	Broadway & Central	12
S22	Tyson Park	12
S23	Bearden - Kingston Pike	12

*Q4g: 4c returns 4 rows while 4d returns 5 rows, but 4c is the one that answers the ops lead's question. Operator precedence is very important to check because it can change the entire result you get when it's wrong.*

*Q4h: WHERE docks >= 12 AND docks < 17*

*I would rather hand a colleague the answer using BETWEEN because it's a lot straight forward (you dont have to think about what BETWEEN means like you do when using the operators).*




## Part 5
*5a*

Result: 23139 rows returned in 105ms

trip_id	start_time	rider_type
T0089973	2025-09-01 00:07:55	member
T0244496	2025-09-01 00:07:57	member
T0004667	2025-09-01 00:14:49	member

*5b*

Result: 22343 rows returned in 65ms

*5c*

trip_id	start_time
T0241055	2025-03-15 00:25:55
T0179889	2025-03-15 00:31:29
T0134722	2025-03-15 00:51:01

Result: 10912 rows returned in 62ms

*5d*

Using rider_type = 'member'
Result: 14164 rows returned in 59ms

Using LOWER(rider_type) = 'member'
Result: 14686 rows returned in 108ms

*Q5e: 5b lost 796 trips compared with 5a because 5b excludes almost the entire day of September 30 (anything past midnight of the 29th). For example, '2025-09-30 18:04:11' would be excluded when using BETWEEN*

*Q5f: The naive version in 5d missed 522 trips revealing that we are missing valuable data (522) in our analyses when not accounting for the various spellings of rider type.*


## Part 6
*6a*

station_id	station_name
S02	Gay Street & Union Ave
S04	Old City - Jackson Ave
S11	Cumberland Ave & 17th St
S12	Fort Sanders - Laurel Ave

*6b*

station_id	station_name	neighborhood
S20	Zoo Knoxville	East Knoxville
S21	Caswell Park	East Knoxville
S22	Tyson Park	West Knoxville
S23	Bearden - Kingston Pike	Bearden
S24	Sequoyah Hills Park	Sequoyah Hills

*6c*

station_id	neighborhood
S14	South Knoxville
S15	South Knoxville
S16	South Knoxville
S17	North Knoxville
S18	North Knoxville
S19	North Knoxville
S20	East Knoxville
S21	East Knoxville
S22	West Knoxville

*6d*

station_name	neighborhood	docks
South Waterfront	South Knoxville	12
Happy Holler	North Knoxville	12
Broadway & Central	North Knoxville	12

*Q6e: It would not be the same for PostgrSQL database because it is case sensitive (not insensitive like SQLite). You should write %_ark* if you mean "case-insensitive".




## Part 7
*7a*

Result: 3767 rows returned in 219ms

trip_id	start_station_id	start_time
T0168031	S06	2025-01-01 08:17:12
T0043727	S12	2025-01-01 10:24:35
T0237204	S03	2025-01-01 16:18:45

*7b*

Result: 223917 rows returned in 170ms

*7c*

Result: 227684 rows returned in 111ms

*7d*

trip_id	start_station_id
T0084969	S16
T0197506	S14
T0238948	S15

Result: 238 rows returned in 91ms

*Q7e: The naive <> filter (7b) silently dropped 3767 rows because NULL does not mean 0. It's not equal to anything so will be added to the total number of rows.*

*Q7f: I believe the answer from 7c actually answers the question because if we haven't cleaned anything yet, then we want to know all of the stations that dont end at S01 from all possible trips in our dataset. We can explain the difference in the answer to these questions after we have taken the necessary cleaning steps.*


## Part 8
*8a*

station_id	station_name	docks	year_installed
S04	Old City - Jackson Ave	16	2022
S11	Cumberland Ave & 17th St	16	2022
S03	Krutch Park	12	2022
S07	The Hill - Ayres Hall	12	2022
S09	Neyland Stadium	16	2023

*8b*

station_name	neighborhood	year_installed
Bearden - Kingston Pike	Bearden	2025
Sequoyah Hills Park	Sequoyah Hills	2025
Suttree Landing Park	South Knoxville	2024

*8c*

station_name	neighborhood	year_installed
Bearden - Kingston Pike	Bearden	2025
Sequoyah Hills Park	Sequoyah Hills	2025
Suttree Landing Park	South Knoxville	2024

*Q8d: To get the correct query you must have both clauses (ORDER BY and LIMIT). LIMIT without ORDER BY gives you arbitrary rows and the arbitrary set can change between runs. The correct query is ORDER BY docks DESC LIMIT 3*




## Part 9
*9b*

We have negative durations which are impossible. The data needs to be cleaned

*9c*

SELECT 
trip_id,
start_station_id,
start_time,
ROUND((julianday(end_time) - julianday(start_time)) * 24, 2) AS duration_hr
FROM trips, stations
WHERE LOWER(rider_type) = 'member'
AND bike_type = 'classic'
AND station_id IN ('S06', 'S07', 'S08', 'S09')
AND start_time >= '2025-03-15'
AND start_time < '2025-04-01'
AND end_station_id IS NOT NULL
AND duration_hr > 0
ORDER BY duration_hr
LIMIT 8;

trip_id	start_station_id	start_time	duration_hr
T0023480	S01	2025-03-19 17:34:48	0.03
T0042244	S08	2025-03-20 13:32:03	0.03
T0145983	S03	2025-03-21 09:31:57	0.03
T0015561	S22	2025-03-25 08:34:06	0.03
T0088672	S06	2025-03-27 17:11:30	0.03
T0086098	S22	2025-03-30 17:11:08	0.03
T0189686	S04	2025-03-31 18:35:55	0.03
T0023480	S01	2025-03-19 17:34:48	0.03

PR URL: https://github.com/zselman01/ride-knox-analysis/pull/33

*Q9e: ROUND >> WHERE >> AND >> ORDER BY >> LIMIT*
*ORDER BY can sort by duration_hr by name because duration_hr is made before ORDER BY is run in the query*

*Q9f: If we want to get more rows, I would drop the LIMIT condition. We dont lose any of the data from the question but can also see the range from lowest to highest trips on classic bikes on UT Campus in the second half of March.*




## Part 10
*10a*

trip_id	start_time	start_station_id	bike_type
T0002779	2025-01-01 03:59:22	S02	classic
T0009131	2025-01-02 03:00:37	S16	classic
T0174344	2025-01-04 02:55:55	S04	classic
T0149178	2025-01-05 03:44:59	S02	electric
T0096295	2025-01-06 03:53:07	S01	classic
T0165811	2025-01-07 03:06:27	S22	classic

Result: 6 rows returned in 4492ms

*Q10b: I just had to put trips, stations in the FROM line. I also had to add DISTINCT after SELECT to make sure that the query didn't result in duplicates.*

*Q10c: The SQL feature that would remove a manual step of copying one query to another is Module 8s joins and aggregates.*




## Reflection and AI Disclosure

*R1: This pattern teaches me that checking my versions consistently are important to avoid redundancy. Also to avoid having a query that's not easily able to understand later on is important in comparison to a Python traceback.*

*R2: I used Google to explain how to calculate hours versus minutes (* 24 instead of * 1440). I also used Google to learn how to copy headers from the DB Browser All final queries, results, and conclusions are my own.*

# Assignment 8
## Part 0

Query (Q)

SELECT
COUNT(*) AS rows_total,
COUNT(end_station_id) AS with_end_station,
COUNT(DISTINCT start_station_id) AS distinct_start_ids,
COUNT(DISTINCT rider_type) AS rider_type_spellings
FROM trips;

Result (R)

rows_total	with_end_station	distinct_start_ids	rider_type_spellings
250000	        246233	                25	                  6


*Q0c: The with_end_station and rider_type_spellings results are diagnostic. They tell us that several of our trips (250k - 246,233 = 3,767 trips) lack an end station and although we genuinely only have 2 rider types (casual and member) we have seemingly six different rider types accounted for in our data.* 




## Part 1





## Part 2






## Part 3







## Part 4







## Part 5






## Part 6







## Part 7







## Part 8 (not graded)







## Part 9 (not graded)






## Part 10 (not graded)






## Reflection & AI Disclosure (not graded)