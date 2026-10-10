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

*Query*
---
SELECT
COUNT(*) AS rows_total,
COUNT(end_station_id) AS with_end_station,
COUNT(DISTINCT start_station_id) AS distinct_start_ids,
COUNT(DISTINCT rider_type) AS rider_type_spellings
FROM trips;

*Result*
---
rows_total	with_end_station	distinct_start_ids	rider_type_spellings

250000	        246233	                25	                  6


*Q0c: The with_end_station and rider_type_spellings results are diagnostic. They tell us that several of our trips (250k - 246,233 = 3,767 trips) lack an end station and although we genuinely only have 2 rider types (casual and member) we have seemingly six different rider types accounted for in our data.* 




## Part 1

*1a*

SELECT
SUM(docks) AS docks_total,
ROUND(AVG(docks),1) AS avg_docks_per_station,
MIN(docks) AS smallest_dock_count,
MAX(docks) AS largest_dock_count
FROM stations;

docks_total	avg_docks_per_station	smallest_dock_count	largest_dock_count

330	                  13.8	                  10	              24


SELECT 
COUNT(*) AS count_of_trips,
ROUND(AVG((julianday(end_time) - julianday(start_time)) * 24), 2) AS avg_duration_hours,
ROUND(MIN((julianday(end_time) - julianday(start_time)) * 24), 2) AS min_dur_hours,
ROUND(MAX((julianday(end_time) - julianday(start_time)) * 24), 2) AS max_dur_hours
FROM trips;

count_of_trips	avg_duration_hours	min_dur_hours	max_dur_hours

250000	              0.47	           -1.75	        71.81

*1c*

WHERE (julianday(end_time) - julianday(start_time)) * 1440 BETWEEN 1 AND 360;

count_of_trips	avg_duration_hours	min_dur_hours	max_dur_hours

248230	              0.28	             0.02	          3.0

*1d*

SELECT
COUNT(*) AS count_of_trips,
SUM(CASE WHEN bike_type = 'electric' THEN 1 ELSE 0 END) AS electric_bike_count,
ROUND((SUM(CASE WHEN bike_type = 'electric' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)),1) AS percent_electric_trips
FROM trips;

count_of_trips	electric_bike_count	percent_electric_trips

250000	                 95083	              38.0

*Q1e: I would put a figure illustrating the results from 1c instead of 1b. This figure represents the count of trips, average, shortest, and longest trip duration in **hours**, rounded to 2 decimal places.*

*Q1f: Nothing changed when I used 100 versus 100.0. I'm not sure if it's because of the software that I'm using, but from class we learned that dividing by an integer truncates the value. This can give an inaccurate result, is why we should divide by a float (100.0) so the precision remains, and is something to keep an eye out for.*

Result of using 100 instead of 100.0

count_of_trips	electric_bike_count	percent_electric_trips

250000	                 95083	              38.0




## Part 2
*2a*

SELECT 
COUNT(*) AS trip_count
FROM trips
GROUP BY start_station_id
ORDER BY trip_count DESC;


trip_count

26058

24959

22606

18934

16542

Result: 25 rows returned in 329ms

*This does not match the number of stations actually present in our data (24).*


*2b*

SELECT strftime('%H', start_time) AS hour,
COUNT(*) AS trip_count_for_each_hour
FROM trips
GROUP BY hour
ORDER BY trip_count_for_each_hour DESC
LIMIT 6;

hour	trip_count_for_each_hour

17	         25178

08	         21766

18	         21404

16	         19220

12	         16690

07	         14910


*2c*

SELECT
COUNT(*) AS count_trips,
ROUND(AVG((julianday(end_time) - julianday(start_time)) * 1440) ,1) AS avg_duration_min,
LOWER(rider_type) AS rider,
bike_type
FROM trips
GROUP BY rider, bike_type;

count_trips	avg_duration_min	rider	bike_type

56538	34.6	casual	classic

34920	34.8	casual	electric

98379	23.9	member	classic

60163	25.9	member	electric


*2d*

*When we don't normalize rider type, we get 6 different results for each rider type when there should only be 2 (one for classic and one for electric bike types)*

count_trips	avg_duration_min	rider_type	bike_type

852	27.7	CASUAL	classic

518	36.8	CASUAL	electric

1188	33.0	Casual	classic

710	52.8	Casual	electric

1481	24.6	MEMBER	classic

882	22.3	MEMBER	electric

1970	20.0	Member	classic

1192	27.6	Member	electric

54498	34.7	casual	classic

33692	34.4	casual	electric

94928	24.0	member	classic

58089	26.0	member	electric

*Q2e: 2d returned 12 rows, but 8 of them describe rider types that don't really exist. GROUP BY groups by value, so if there are 6 distinct spellings, this is how the result will be grouped, unless "told" otherwise.*

*Q2f: The wide version would look like each rider type having their own row with each bike type having their own column. The pandas method from Module 3 that produced wide output is called unstack().*




## Part 3

*3a*

SELECT
COUNT(*) AS count_trips,
SUM(CASE WHEN LOWER(bike_type) = 'classic' THEN 1 ELSE 0 END) AS classic,
SUM(CASE WHEN LOWER(bike_type) = 'electric' THEN 1 ELSE 0 END) AS electric,
LOWER(rider_type) AS rider
FROM trips
GROUP BY rider; 

count_trips	classic	electric	rider

91458	56538	34920	casual

158542	98379	60163	member


*3b*

SELECT 
COUNT(*) AS trips_count,
rider_type
FROM trips
GROUP BY bike_type;

trips_count	rider_type

154917	casual

95083	casual


*Q3c: 3b did not produce an error or a warning. It produced a clean-looking answer. The value in the rider_type column is actually the bike types. A reader of my result would have no way to tell that anything was wrong because what's listed in the header and the rows match (but the result should show bike type, not rider type).*

*Q3d: The grouping rule states that every expression in SELECT list must be in GROUP BY or in an aggregate function. If run in Ride KNox's PostgreSQL database instead, it would have refused to output a result because of this grouping rule. I would prefer the behavior by PostgreSQL to avoid publishing results that are inaccurate and unable to be corrected by readers other than by inspecting the query.*




## Part 4

*4a*

SELECT
start_station_id,
COUNT(*) AS trips_count
FROM trips
GROUP BY start_station_id
HAVING COUNT(*) > 15000
ORDER BY trips_count DESC;

start_station_id	trips_count

S06	26058

S08	24959

S01	22606

S11	18934

S02	16542

S05	15398


*4b*

SELECT
start_station_id,
COUNT(*) AS trips_count
FROM trips
WHERE bike_type = 'electric' -- ← keeps ROWS
AND start_time >= '2025-08-01'
AND start_time < '2025-09-01'
GROUP BY start_station_id
HAVING COUNT(*) >= 300 -- ← keeps GROUPS
ORDER BY trips_count DESC;

start_station_id	trips_count

S08	913

S06	912

S01	818

S11	718

S02	643

S05	560

S04	543

S07	534

S09	492

S12	374

S03	370

S14	323


*4c*

SELECT 
strftime('%m', start_time) AS month,
COUNT(*) AS trips_count
FROM trips
GROUP BY month
HAVING COUNT(*) >25000;

month	trips_count

04	25597

05	29843

06	31528

07	27134


*4d*

SELECT 
strftime('%m', start_time) AS month,
COUNT(*) AS trips_count
FROM trips
WHERE COUNT(*) > 25000
GROUP BY month;

Execution finished with errors.

Result: misuse of aggregate: COUNT()


*Q4e: WHERE runs before GROUP BY, so the groups don't exist yet for this filter to work. WHERE filters out rows before the grouping occurs.*

*Q4f: In 4b, bike type and the date range filters trips and grouping by the start station id filters stations. Moving the bike_type condition from WHERE into HAVING would be a bad idea even in a case where it returned the same answer because we don't want to get rid of the clause order. The HAVING clause is best for working with groups that have already been created instead of having to work with all of the raw rows (if we hadn't filtered by bike type before running the HAVING command).*




## Part 5

*5a*

SELECT
t.trip_id,
t.start_time,
s.station_name,
s.docks
FROM trips t
JOIN stations s ON t.start_station_id = s.station_id
WHERE (s.neighborhood = 'Old City'
OR s.neighborhood = 'Fort Sanders')
AND t.bike_type = 'electric'
ORDER BY start_time;

trip_id	bike_type	start_time	station_name	docks

T0094124	electric	2025-01-01 01:19:33	Old City - Jackson Ave	16

T0158367	electric	2025-01-01 06:14:57	Cumberland Ave & 17th St	16

T0115606	electric	2025-01-01 07:49:31	Fort Sanders - Laurel Ave	12

T0051723	electric	2025-01-01 08:28:33	Fort Sanders - Laurel Ave	12

T0139613	electric	2025-01-01 08:46:28	Old City - Jackson Ave	16

Result: 16312 rows returned in 453ms


*5b*

SELECT
COUNT(*) AS trips_count
FROM trips t
JOIN stations s ON t.end_station_id = s.station_id;

246233


*5c*

SELECT
s.neighborhood,
COUNT(*) AS trips_count,
ROUND(AVG((julianday(t.end_time) - julianday(t.start_time)) * 1440), 1) AS avg_duration_min
FROM trips t
JOIN stations s ON t.start_station_id = s.station_id
GROUP BY s.neighborhood
ORDER BY trips_count DESC;

neighborhood	trips_count	avg_duration_min

UT Campus	78141	28.7

Downtown	49760	27.6

Fort Sanders	28408	28.9

World's Fair Park	21455	25.1

North Knoxville	17065	28.8

South Knoxville	16331	26.9

Old City	14269	30.2

UT Ag Campus	7255	30.1

West Knoxville	6651	32.8

East Knoxville	6372	26.6

Bearden	2095	32.7

Sequoyah Hills	1935	35.4


*Q5d: 5b lost 3,767 trips compared with the 250,000 trips. This number matches the number of trips that don't have an end station id in the trips table and this is convenient but dangerous if we wanted to keep any of those trips.*


*Q5e: The neighborhood column would be ambiguous without its prefix and the database would throw an error saying that column doesn't exist (this is what actually happened to me).*


*Q5f: No, after 5a runs station_name is not stored anywhere in the trips table. The join is computed at query time, so the two tables don't change allowing us to do all of these queries without our original data changing.*




## Part 6

*6a*

SELECT t.end_station_id, COUNT(*) AS trip_counts
FROM trips t
LEFT JOIN stations s ON t.end_station_id = s.station_id
WHERE s.station_id IS NULL
GROUP BY t.end_station_id;

end_station_id	trip_counts
*NULL*	           3767


*6b*

SELECT station_name, COUNT(*) AS trips_count
FROM stations
GROUP BY station_name
HAVING COUNT(*) > 1

*Nothing in output*


*6c*

*VERSION 1*

SELECT COUNT(*) AS trips_count, s.station_name
FROM stations s
LEFT JOIN trips t ON t.start_station_id = s.station_id
WHERE t.start_time >= '2025-01-01'
AND t.start_time < '2025-02-01'
AND strftime('%H', t.start_time) >= '02'
AND strftime('%H', t.start_time) < '05'
GROUP BY s.station_name;

trips_count	station_name
1	Ag Campus - Morgan Hall
1	Bearden - Kingston Pike
1	Broadway & Central
2	Caswell Park
3	Cumberland Ave & 17th St
1	Fort Sanders - Laurel Ave
1	Fourth & Gill
7	Gay Street & Union Ave
1	Happy Holler
13	Hodges Library
2	Ijams Nature Center
4	Krutch Park
5	Market Square
6	Neyland Stadium
5	Old City - Jackson Ave
1	Second Creek Greenway
1	South Waterfront
8	Student Union - UT
3	The Hill - Ayres Hall
2	Tyson Park
3	World's Fair Park
2	Zoo Knoxville

Result: 22 rows

*VERSION 2*

SELECT COUNT(*) AS trips_count, s.station_name
FROM stations s
LEFT JOIN trips t ON t.start_station_id = s.station_id
AND t.start_time >= '2025-01-01'
AND t.start_time < '2025-02-01'
AND strftime('%H', t.start_time) >= '02'
AND strftime('%H', t.start_time) < '05'
GROUP BY s.station_name;

trips_count	station_name
1	Ag Campus - Morgan Hall
1	Bearden - Kingston Pike
1	Broadway & Central
2	Caswell Park
3	Cumberland Ave & 17th St
1	Fort Sanders - Laurel Ave
1	Fourth & Gill
7	Gay Street & Union Ave
1	Happy Holler
13	Hodges Library
2	Ijams Nature Center
4	Krutch Park
5	Market Square
6	Neyland Stadium
5	Old City - Jackson Ave
1	Second Creek Greenway
1	Sequoyah Hills Park **
1	South Waterfront
8	Student Union - UT
1	Suttree Landing Park **
3	The Hill - Ayres Hall
2	Tyson Park
3	World's Fair Park
2	Zoo Knoxville

Result: 24 rows


*6d*

SELECT COUNT(t.trip_id) AS trips_count, s.station_name, s.neighborhood
FROM stations s
LEFT JOIN trips t ON t.start_station_id = s.station_id
AND t.start_time >= '2025-01-01'
AND t.start_time < '2025-02-01'
AND strftime('%H', t.start_time) >= '02'
AND strftime('%H', t.start_time) < '05'
GROUP BY s.station_name
HAVING COUNT(*) < 2
ORDER BY trips_count;

trips_count	station_name	neighborhood
0	Sequoyah Hills Park	Sequoyah Hills
0	Suttree Landing Park	South Knoxville
1	Ag Campus - Morgan Hall	UT Ag Campus
1	Bearden - Kingston Pike	Bearden
1	Broadway & Central	North Knoxville
1	Fort Sanders - Laurel Ave	Fort Sanders
1	Fourth & Gill	North Knoxville
1	Happy Holler	North Knoxville
1	Second Creek Greenway	World's Fair Park
1	South Waterfront	South Knoxville

*Q6e: Version 1 and Version 2 of 6c return a different number of rows. Version 2 with 24 rows is right for the ops lead's question because she asked for all 24 stations even if the count is 0. Unmatched rows are NULL in the output and NULL is unknown, so WHERE discards exactly the rows LEFT JOIN was keeping (the zero-trip stations). This is why we must move the condition into the ON statement to keep the zero-trip stations*

Q6f: COUNT(*) would have reported the zero-trip stations as 1 (count) for a station with no matching trips because NULL rows are counted as a trip.




## Part 7

*7a*

SELECT s.station_name, s.neighborhood, s.docks, 
COUNT(t.trip_id) AS trip_count, ROUND(COUNT(t.trip_id) * 1.0 / s.docks , 2) AS arrivals_per_dock
FROM stations s
LEFT JOIN trips t ON t.end_station_id = s.station_id
AND t.end_time >= '2025-10-01'
AND t.end_time < '2026-01-01'
GROUP BY s.station_name, s.neighborhood, s.docks
ORDER BY arrivals_per_dock DESC;

*Top 5 rows*

station_name	neighborhood	docks	trip_count	arrivals_per_dock
Cumberland Ave & 17th St	Fort Sanders	16	3381	211.31
The Hill - Ayres Hall	UT Campus	12	2454	204.5
Market Square	Downtown	20	3919	195.95
Hodges Library	UT Campus	24	4527	188.63
Student Union - UT	UT Campus	24	4254	177.25

*Bottom 5 rows*

station_name	neighborhood	docks	trip_count	arrivals_per_dock
Suttree Landing Park	South Knoxville	10	647	64.7
Zoo Knoxville	East Knoxville	10	630	63.0
Caswell Park	East Knoxville	10	525	52.5
Sequoyah Hills Park	Sequoyah Hills	10	323	32.3
Bearden - Kingston Pike	Bearden	12	372	31.0


*7b*

-- This ranking counts all trips completed during October 1 - December 31, 2025 and excludes those taken during January 1 - September 30, 2025. 

*Q7c: In comparing my top 5 with the departures-per-dock ranking from the Module 8 slides, the top 5 stations are the same, but the arrivals-per-dock differs from the departures-per-dock. A station appearing high on one list but not the other would tell the operations team that there is a difference in the busyness of that station in regard to departures and arrivals. For example, maybe one station is closer to a major location for students (Hodges library) making it a hub for returning bikes (arrivals), but not for departures.*

*Q7d: Removing LEFT JOIN from stations, COUNT(t.trip_id), or * 1.0 would silently produce a wrong number. Removing the LEFT JOIN would cause future zero-trip stations to NOT appear. Removing COUNT(...) could cause zero-trip stations to read as greater than 0. Removing * 1.0 would cause the ratio to be flattened beause of integer (vs float) division.*




## Part 8 (not graded)

*8a*

SELECT s.neighborhood, COUNT(*) AS trip_count
FROM trips t
JOIN stations s ON t.start_station_id = s.station_id --Departures
GROUP BY s.neighborhood
HAVING COUNT(*) * 1.0 / s.docks > (
SELECT COUNT(*) * 1.0 / s.docks FROM stations
)
ORDER BY trip_count DESC;

neighborhood	trip_count
UT Campus	78141
Downtown	49760
Fort Sanders	28408
World's Fair Park	21455
North Knoxville	17065
South Knoxville	16331
Old City	14269
UT Ag Campus	7255
West Knoxville	6651
East Knoxville	6372
Bearden	2095
Sequoyah Hills	1935


*8b*

SELECT ROUND(AVG(trip_count), 2) AS avg_per_station, MIN(trip_count) AS smallest, MAX(trip_count) AS largest
FROM (
SELECT COUNT(*) AS trip_count
FROM trips
GROUP BY strftime('%m', start_time)
);

avg_per_station	smallest	largest
20833.33	10335	31528


*8d*

WITH trip_counts AS (
    -- CTE 1: Count total trips per station
    SELECT start_station_id, COUNT(*) AS trip_count
    FROM trips
    GROUP BY start_station_id
),

station_metrics AS (
    -- CTE 2: Attach station details and compute the ratio
    SELECT 
        s.station_name,
        s.docks,
        t.trip_count,
        ROUND(t.trip_count * 1.0 / s.docks, 1) AS trips_per_dock
    FROM trip_counts t
    JOIN stations s ON t.start_station_id = s.station_id
)

-- Final SELECT get bottom 5 stations
SELECT 
    station_name,
    docks,
    trip_count,
    trips_per_dock
FROM station_metrics
ORDER BY trips_per_dock
LIMIT 5;

station_name	docks	trip_count	trips_per_dock
Bearden - Kingston Pike	12	2095	174.6
Sequoyah Hills Park	10	1935	193.5
Caswell Park	10	2835	283.5
Zoo Knoxville	10	3537	353.7
Suttree Landing Park	10	3776	377.6

*Q8e: I would rather hand the second version to a reviewer in a pull request because it's easier to read/follow the flow of the query than in the first version.*

*Q8f: While debugging 8d, I would inspect what the first CTE returns without deleting the rest of the query by commenting out the WHERE and just printing the SELECT result.




## Part 9 (not graded)

*9a*

CREATE VIEW completed_trips AS
SELECT trip_id, start_time, start_station_id, end_station_id,
LOWER(rider_type) AS rider_type, bike_type,
ROUND((julianday(end_time) - julianday(start_time)) * 1440, 1) AS duration_min,
strftime('%m', start_time) AS month
FROM trips
WHERE start_station_id <> 'S99'
AND end_station_id IS NOT NULL
AND (julianday(end_time) - julianday(start_time)) * 1440 BETWEEN 2 AND 720;

244115


*9b*

WITH clean AS (
SELECT * 
FROM completed_trips
),
casual_first_half AS (
SELECT COUNT(*) AS casual_first_half_trips, start_station_id
FROM clean
WHERE rider_type = 'casual'
AND start_time >= '2025-01-01'
AND start_time < '2025-07-01'
GROUP BY start_station_id
),
casual_second_half AS (
SELECT COUNT(*) AS casual_second_half_trips, start_station_id
FROM clean
WHERE rider_type = 'casual'
AND start_time >= '2025-07-01'
AND start_time < '2026-01-01'
GROUP BY start_station_id
)

SELECT s.neighborhood, fi.casual_first_half_trips, se.casual_second_half_trips,
fi.casual_first_half_trips - se.casual_second_half_trips AS change_over_year,
ROUND((fi.casual_first_half_trips - se.casual_second_half_trips) * 1.0 / s.docks, 1) AS change_per_dock
FROM stations s
LEFT JOIN casual_first_half fi ON fi.start_station_id = s.station_id
LEFT JOIN casual_second_half se ON se.start_station_id= s.station_id
GROUP BY s.neighborhood
ORDER BY change_per_dock DESC;

neighborhood	casual_first_half_trips	casual_second_half_trips	change_over_year	change_per_dock
Fort Sanders	4340	2403	1937	121.1
Downtown	5187	3054	2133	106.7
UT Campus	5880	3481	2399	100.0
Old City	3258	1913	1345	84.1
World's Fair Park	3475	2021	1454	72.7
South Knoxville	1862	1140	722	60.2
UT Ag Campus	1686	986	700	58.3
West Knoxville	1508	810	698	58.2
North Knoxville	1619	941	678	56.5
East Knoxville	759	487	272	27.2
Sequoyah Hills	432	251	181	18.1
Bearden	468	270	198	16.5

## Part 10 (not graded)

*10a*

WITH trips_per_neighb_per_month AS (
SELECT s.neighborhood, c.month, COUNT(*) AS monthly_count, c.start_station_id
FROM completed_trips c
LEFT JOIN stations s ON c.start_station_id = s.station_id
GROUP BY s.neighborhood, c.month
)

SELECT s.neighborhood, MIN(monthly_count) AS quietest, MAX(monthly_count) AS busiest, 
ROUND(MIN(monthly_count) * 1.0 / MAX(monthly_count), 2) AS ratio_btw_seasons
FROM stations s
LEFT JOIN trips_per_neighb_per_month t ON t.start_station_id = s.station_id 
GROUP BY s.neighborhood
ORDER BY ratio_btw_seasons DESC;


neighborhood	quietest	busiest	ratio_btw_seasons
Sequoyah Hills	80	219	0.37
West Knoxville	269	796	0.34
UT Campus	3185	9583	0.33
UT Ag Campus	298	911	0.33
North Knoxville	696	2109	0.33
East Knoxville	259	789	0.33
Bearden	86	261	0.33
Old City	564	1760	0.32
Fort Sanders	1140	3536	0.32
Downtown	1958	6031	0.32
World's Fair Park	850	2712	0.31
South Knoxville	652	2071	0.31

*10b*

WITH departures AS (
SELECT start_station_id, COUNT(*) AS dep
FROM completed_trips 
GROUP BY start_station_id
),
arrivals AS (
SELECT end_station_id, COUNT(*) AS arr
FROM completed_trips
GROUP BY end_station_id
)
SELECT s.neighborhood, d.dep, a.arr,
d.dep - a.arr AS diff_btw_departures_arrivals
FROM stations s
LEFT JOIN departures d ON d.start_station_id = s.station_id
LEFT JOIN arrivals a ON a.end_station_id = s.station_id
GROUP BY s.neighborhood
ORDER BY diff_btw_departures_arrivals DESC; -- Top neighborhood loses the most bikes over the year

neighborhood	dep	arr	diff_btw_departures_arrivals
UT Campus	25511	25290	221
South Knoxville	8102	7982	120
World's Fair Park	15122	15009	113
North Knoxville	6940	6862	78
West Knoxville	6468	6448	20
UT Ag Campus	7082	7063	19
Old City	13921	13915	6
Downtown	22119	22118	1
Sequoyah Hills	1901	1931	-30
Bearden	2046	2086	-40
East Knoxville	3465	3521	-56
Fort Sanders	18478	18774	-296

*UT Campus is the neighborhood that loses the most bikes throughout the year, while Fort Sanders gains the most amount of bikes throughout the year.*