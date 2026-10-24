**Name: *Zaharia Selman***
**NetID: *zselman***
**Terminal used:** *Git Bash on Windows*

## Part 0
*0a*
```bash
$ head -1 trips_2025.csv
trip_id,start_time,end_time,start_station_id,start_station_name,end_station_id,rider_type,bike_type
```
```bash
$ wc -l trips_2025.csv
250601 trips_2025.csv
```
*Q0c: wc -l reported 250601 but the dataset has 250,600 rows. This is because Git Bash counts the header as a row. sed '1d' or tail -n +2 are two commands from the slides that would let me drop the offending line before counting.*

## Part 1 Navigation, Files & Directories 
*1a*
```bash
$ pwd
/c/Users/zselm/OneDrive - University of Tennessee/Personal/Data Science Toolkit/ride-knox-analysis
```
```bash
$ ls -lh
total 155M
-rw-r--r-- 1 zselm 197609   22 Oct 23 10:27 1
drwxr-xr-x 1 zselm 197609    0 Oct 23 10:09 2025_bundle/
drwxr-xr-x 1 zselm 197609    0 Oct 21 18:11 2026_bundle/
-rw-r--r-- 1 zselm 197609  12K Oct 21 18:42 DATA-DICTIONARY.md
-rw-r--r-- 1 zselm 197609  18K Sep 26 17:55 PROJECT-LOG.md
-rw-r--r-- 1 zselm 197609 5.5K Sep 26 15:31 README.md
-rw-r--r-- 1 zselm 197609 1.5K Sep 26 18:14 RELEASE-NOTE.md
-rw-r--r-- 1 zselm 197609  735 Oct 23 10:15 SHELL-LOG.md
-rw-r--r-- 1 zselm 197609  33K Oct 10 00:22 SQL-LOG.md
-rw-r--r-- 1 zselm 197609  179 Sep 26 15:23 _config.yml
drwxr-xr-x 1 zselm 197609    0 Oct 21 18:42 charts/
-rw-r--r-- 1 zselm 197609 1.4K Sep 26 16:45 index.md
-rw-r--r-- 1 zselm 197609 3.6K Oct 21 18:42 memo.md
-rw-r--r-- 1 zselm 197609 114K Oct 21 18:42 project.ipynb
drwxr-xr-x 1 zselm 197609    0 Oct  3 00:11 queries/
drwxr-xr-x 1 zselm 197609    0 Oct 10 00:29 queries_assignment_8/
-rw-r--r-- 1 zselm 197609   93 Sep 26 15:23 requirements.txt
-rw-r--r-- 1 zselm 197609  24M Oct 10 00:30 ride_knox.db
-rw-r--r-- 1 zselm 197609  95M Oct 21 17:58 ride_knox_v2.db
drwxr-xr-x 1 zselm 197609    0 Oct 21 18:42 sql/
-rw-r--r-- 1 zselm 197609  15K Aug 27 20:15 stations.xlsx
-rw-r--r-- 1 zselm 197609  22M Aug 27 20:15 trips_2025.csv
-rw-r--r-- 1 zselm 197609 2.9M Oct  8 11:29 trips_2026_07.csv
-rw-r--r-- 1 zselm 197609  12M Sep  2 12:02 trips_2026_h1.csv
```
*-h changed the output by displaying every thing that's inside the present working directory (pwd).*

*1c*
```bash
$ ls -a
./            2026_bundle/        SQL-LOG.md   project.ipynb          sql/
../           DATA-DICTIONARY.md  _config.yml  queries/               stations.xlsx
.git/         PROJECT-LOG.md      charts/      queries_assignment_8/  trips_2025.csv
.gitignore    README.md           index.md     requirements.txt       trips_2026_07.csv
1             RELEASE-NOTE.md     memo.md      ride_knox.db           trips_2026_h1.csv
2025_bundle/  SHELL-LOG.md        out/         ride_knox_v2.db
```
```bash
$ ls
1                   README.md        charts/        queries/               sql/
2025_bundle/        RELEASE-NOTE.md  index.md       queries_assignment_8/  stations.xlsx
2026_bundle/        SHELL-LOG.md     memo.md        requirements.txt       trips_2025.csv
DATA-DICTIONARY.md  SQL-LOG.md       out/           ride_knox.db           trips_2026_07.csv
PROJECT-LOG.md      _config.yml      project.ipynb  ride_knox_v2.db        trips_2026_h1.csv
```
*.gitignore only appears in ls -a; not when we do the ls command alone.*

*Q1d: The files in out/ should not be committed because they are derived and regenerable. For this week's outputs in particular, someone would need the raw data (csv and xlsx) to regenerate them which are always in .gitignore.*

## Part 2 Wildcards & the Multi-File Folder 
*2a*
```bash
$ wc -l trips_*.csv | tee out/line-count-every-trip-CSV
  250601 trips_2025.csv
   33086 trips_2026_07.csv
  137342 trips_2026_h1.csv
  421029 total
```
*2b*
```bash
$ ls -lh trips_2026*.csv | tee out/line-count-every-2026-trip-CSV
-rw-r--r-- 1 zselm 197609 2.9M Oct  8 11:29 trips_2026_07.csv
-rw-r--r-- 1 zselm 197609  12M Sep  2 12:02 trips_2026_h1.csv
```
*2c*
```bash
$ ls -lh stations*.xlsx | tee out/line-count-stations-XLSX
-rw-r--r-- 1 zselm 197609 15K Aug 27 20:15 stations.xlsx
-rw-r--r-- 1 zselm 197609 15K Sep  2 12:02 stations_2026.xlsx
```

*Q2d: In 2a you typed one \*, and the output named three files individually. What happens to the \* between pressing Enter and wc running is that the shell replaces it (the \*) with the matching filenames first. This is why calling rm \*.csv is exactly as dangerous as typing every filename out because they both do the same thing.*

*Q2e: When comparing the sizes from 2b with the line counts from 2a, the 2026 half-year file holds 55% of the trips_2025.csv's rows and roughly 55% of trips_2025.csv's bytes. The relationship between those two shares tells me that the rows have the same information taking up the same amount of space in them. Long-format kinds of CSV columns would break that relationship.*

## Part 3 Inspecting Files Without Loading Them 
*3a*
```bash
$ tail -3 trips_2025.csv | tee out/last-3-lines-2025-trips
T0029313,2025-12-31 23:33:25,2025-12-31 23:47:31,S08,Student Union - UT,S09,CASUAL,classic
T0233859,2025-12-31 23:40:52,2025-12-31 23:51:14,S04,Old City - Jackson Ave,S04,member,electric
T0140894,2025-12-31 23:42:04,2026-01-01 00:37:04,S12,Fort Sanders - Laurel Ave,S12,casual,electric
```
*Tail gives us the rows we want without the header row (which is included when running head).*

*3b1 - AI here don't need file name after tail as well*
```bash
$ head -504 trips_2025.csv | tail -5 | tee out/lines-500-to-504-2025-trips
T0193042,2025-01-02 12:56:34,2025-01-02 13:07:49,S06,HODGES LIBRARY,S08,member,classic
T0109309,2025-01-02 12:58:14,2025-01-02 13:08:04,S05,World's Fair Park,S04,casual,classic
T0017188,2025-01-02 12:59:01,2025-01-02 13:17:00,S11,Cumberland Ave & 17th St,S02,member,electric
T0004700,2025-01-02 12:59:54,2025-01-02 13:37:33,S07,The Hill - Ayres Hall,S02,member,electric
T0183710,2025-01-02 12:59:57,2025-01-02 13:14:14,S01,Market Square,S01,casual,classic
```
*3b2*
```bash
$ sed -n '500,504p' trips_2025.csv | tee out/lines-500-504-using-sed-2025-trips
T0193042,2025-01-02 12:56:34,2025-01-02 13:07:49,S06,HODGES LIBRARY,S08,member,classic
T0109309,2025-01-02 12:58:14,2025-01-02 13:08:04,S05,World's Fair Park,S04,casual,classic
T0017188,2025-01-02 12:59:01,2025-01-02 13:17:00,S11,Cumberland Ave & 17th St,S02,member,electric
T0004700,2025-01-02 12:59:54,2025-01-02 13:37:33,S07,The Hill - Ayres Hall,S02,member,electric
T0183710,2025-01-02 12:59:57,2025-01-02 13:14:14,S01,Market Square,S01,casual,classic
```
*3c*
```bash
$ tail -n +2 stations.xlsx | wc -l | out/rows-of-stations
47 stations.xlsx
```

*Q3d: The number in 3c is not the number of stations, and it is dangerously close to being believable. There is a formatting issue occuring where the wc call actually also counted newline characters created when bash loaded the data. This file behaves differently from trips_2025.csv under every command in this module because it is an Excel file (Zip folder). One command that can be run to confirm this explanation is ```grep -c "Hodges" stations.xlsx returns 0```. Searching for a known station_name shows that bash treats these files differently.*

*Q3e: To get the column names of trips_2026_07.csv without loading it, you run ```less trips_2026_07.csv | head -1```. This replaces the head() panda attribute from Module 2.*
```bash
$ less trips_2026_07.csv | head -1 | tee out/column-names-2026-07
trip_id,start_time,end_time,start_station_id,start_station_name,end_station_id,rider_type,bike_type
```

## Part 4
*4a - remember grep does not include header row!*
```bash
$ grep -c ",2025-09" trips_2025.csv | tee out/rows-with-Sept-2025
23202
```
*4b*
```bash
$ grep -c "member" trips_2025.csv | tee out/rows-with-member-case-sensitive
153388
```
```bash
$ grep -c -i "member" trips_2025.csv | tee out/rows-with-member-case-insensitive
158927
```
*Only including -c counts those rows that have member in its exact form (all lowercase). Including -c -i ignores case and counts all instances of the string m-e-m-b-e-r regardless of case.*

*4c*
```bash
$ grep -c -v ",S24," trips_2025.csv | tee out/rows-not-including-S24
246853
```
*4d - cut does include the header row (assignment asks for first 4 lines of file)*
```bash
$ cut -d, -f8 trips_2025.csv | head -4 | tee out/bike-type-first-four-rows
bike_type
electric
classic
classic
```
*Bike_type is in field 8 and this was determined by ```head -1```.*

*Q4e: In 4b, the number ignoring *member* case is the answer to "how many member trips are there" because it includes all instances the same word and the other that doesn't ignore case is not. This is why it's imperative to make sure the commands that I'm calling are correct and that I'm checking myself against known facts from the data, because a wrong pipeline returns a number, not an error.*

*Q4f: My 4b case-insensitive count and the anchor figure for member at the top of this assignment do agree. If a classmate's did not, the most likely mistake in their command is that they didn't also include -i.*

## Part 5
*5a*
```bash
$ grep ",2025-09" trips_2025.csv > out/trips_2025_09.csv
$ grep ",2025-10" trips_2025.csv > out/trips_2025_10.csv
$ grep ",2025-11" trips_2025.csv > out/trips_2025_11.csv
```
*5b*
```bash
$ wc -l out/trips_*.csv | tee out/line-count-every-created-CSV-in-out-folder
  23202 out/trips_2025_09.csv
  19795 out/trips_2025_10.csv
  13750 out/trips_2025_11.csv
  56747 total
```
*5c*
```bash
$ wc -l out/trips_2025_09.csv > out/summary.txt
$ wc -l out/trips_2025_10.csv >> out/summary.txt
$ wc -l out/trips_2025_11.csv >> out/summary.txt
$ cat out/summary.txt
23202 out/trips_2025_09.csv
19795 out/trips_2025_10.csv
13750 out/trips_2025_11.csv
```
*5d*
```bash
$ grep "day pass" trips_2027.csv 2> out/errors.log
$ cat out/errors.log
grep: trips_2027.csv: No such file or directory
```
*Q5e: out/summary.txt would have only contained the number of rows in out/trips_2025_11.csv because > silently overwrites what is already present in the file. This is why that one-character difference is a reason to read a redirection twice before pressing Enter.*

*Q5f: In 5d you separated the error from the results. Errors go to a separate .log file, so a broken command's complaint doesn't end up inside the results file. This helps the shell avoid quietly corrupting a results file.*

## Part 6
*6a*
```bash
$ cut -d, -f8 trips_2025.csv | tail -n +2 | sort | uniq -c | tee out/trips-each-bike-type
 155300 classic
  95300 electric
```
*6b*
```bash
$ cut -d, -f4 trips_2025.csv | tail -n +2 | sort | uniq -c | sort -rn | tee out/trips-each-start-station-id
  26112 S06
  25044 S08
  22656 S01
  18983 S11
  16570 S02
$ cut -d, -f4 trips_2025.csv | tail -n +2 | sort | uniq -c | sort -r | tee out/trips-each-start-station-id-r-only
  26112 S06
  25044 S08
  22656 S01
  18983 S11
  16570 S02
```
*Q6c: The two orderings in 6b are identical, even though sort -r compares text and sort -rn compares numbers. They agree here because 2 is always greater than 1 whether viewed as text or as a number. The condition under which they would stop agreeing is if one of the values is greater than another but the first character is less than the greater number.*

*6d*
```bash
$ cut -d, -f1 trips_2025.csv | tail -n +2 | sort | uniq -d | wc -l | tee out/dupl-trip-id
600
```
*6e*
```bash
$ cut -d, -f1 trips_2025.csv | tail -n +2 | sort | uniq -d | head -1 | tee out/first-dupl-trip
T0000118
$ grep "T0000118" trips_2025.csv | tee out/pair-dupl-trip
T0000118,2025-04-23 15:56:40,2025-04-23 16:15:49,S16,Ijams Nature Center,S14,member,electric
T0000118,2025-04-23 15:56:40,2025-04-23 16:15:49,S16,Ijams Nature Center,S14,member,electric
```
*The two rows do not differ in any column (exact duplicates)*

*Q6f: If 6d and 6e were combined the result would output a row for every pair of duplicates (1200 rows). ```tail -n +2 trips_2025.csv | sort -u | wc -l``` is the single command that would remove all of the duplicates (600) leaving the real count of total trips (250,600-600=250,000).*

## Part 7
*7a*
Reminders --> cut: column; -d,: comma separated col; -f5: 5th column is start_station_name; filename; tail -n +2: drops header; sort|uniq -c: get counts for unique data passed through so far; grep -i: ignore case for all instances of "Market Square"; sort -u: drop dupl
```bash
$ cut -d, -f5 trips_2025.csv | tail -n +2 | sort | uniq -c | grep -i "Market Square" | sort -u | tee out/market-square-spellings
    341 market square
    429 Market Square
    461 MARKET SQUARE
    644   Market Square
  20781 Market Square
```
*There are 5 different spellings for Market Square.*

*7b*
```bash
$ cut -d, -f5 trips_2025.csv | tail -n +2 | sed 's/^ *//; s/ *$//' | tr 'A-Z' 'a-z' | sort | uniq -c | sort -u | sort -rn| head -5 | tee out/top-5-station-ranking
  26112 hodges library
  25044 student union - ut
  22656 market square
  18983 cumberland ave & 17th st
  16570 gay street & union ave
```
*Q7c: The most common spelling from 7a had 20,781 trips for Market Square. However, this misses 1,875 trips that is captured by 7b's method (22,656-20,781 = 1,875).*

*Q7d: Your 7b ranking is by station name. Your 6b ranking is by station id. The two top-5 lists are below. They carry the same counts in the same order. If they didn't match, this would mean that there were still different spellings for some/all station names in my Part 7 pipeline.*
```bash
26112 hodges library
  25044 student union - ut
  22656 market square
  18983 cumberland ave & 17th st
  16570 gay street & union ave
```
```bash
26112 S06
  25044 S08
  22656 S01
  18983 S11
  16570 S02
```

## Part 8
*8a*
```bash
$ grep -c ",S11," trips_2025.csv | tee out/all-trips-from-or-to-S11
35415
$ awk -F, '$4=="S11"' trips_2025.csv | tail -n +2 | wc -l | tee out/trips-starting-from-S11
18982
```
*Q8b: My two numbers in 8a differ by a large margin. The gap comes from `grep` accounting for **any** row that has `S11` in it, while `awk` only accounts for when `S11` appears in the `start_station_id` column. `awk` combines both the functions of `cut` and `grep`: `cut` picks columns but can’t test their values, and `grep` tests values but can’t tell which columns they’re in.*

*8c*
```bash
$ tail -n +2 trips_2025.csv | sort -u | grep -v ",S99," | awk -F, '$6==""' | grep -i "member" | wc -l | tee out/no-end-station-member-trips
2367
```
*Q8d: The 8c count as a share of the 3,774 trips with no end station is 63% of the trips (2,367/3,774 * 100). This means that more than half of the trips missing an end station id are from member riders. However, this number cannot tell me **why** these rides don't have end_station_ids reported.*

*8e*
```bash
$ tail -n +2 trips_2025.csv | sort -u | grep -v ",S99," | awk -F, 'NR>1 && tolower($8)=="electric" {c[substr($2,6,2)]++} END {for (k in c) print k, c[k]}' trips_2025.csv | sort | tee out/electr-bike-trips-per-month-2025-sorted
01 4186
02 5090
03 7526
04 9749
05 11331
06 12067
07 10447
08 9348
09 8837
10 7571
11 5287
12 3861
```
*8f*
```bash
$ tail -n +2 trips_2025.csv | sort -u | grep -v ",S99," | awk -F, 'NR>1 && tolower($8)=="electric" {c[substr($2,6,2)]++} END {for (k in c) print k, c[k]}' trips_2025.csv | sort -k2 -r| tee out/electr-bike-trips-per-month-2025-sorted-k2-r
04 9749
08 9348
09 8837
10 7571
$ tail -n +2 trips_2025.csv | sort -u | grep -v ",S99," | awk -F, 'NR>1 && tolower($8)=="electric" {c[substr($2,6,2)]++} END {for (k in c) print k, c[k]}' trips_2025.csv | sort -k2 -rn| tee out/electr-bike-trips-per-month-2025-sorted-k2-rn
06 12067
05 11331
07 10447
04 9749
```
*Q8g: This time the two orderings disagree; the text sort (-k2 -r) names a different busiest month than the numeric sort (-k2 -rn). The text sort names April (9,749) as the highest while the numeric sort names June (12,067) as the highest month. The numeric sort is correct. These orderings differ because there are a variety of numbers making a smaller number all together seem higher just because the first number is large (9 is greater than 1, but 9,749 < 12,067). Therefore, a colleague reading only the wrong version would have concluded that Ride Knox's electric fleet was over 80% less than what it actually is (9749/12067 * 100 = ~81%) and would base these conclusions on the wrong month.*

## Part 9
*9a - don't need to drop header b/c the CSVs already don't have the header row*
```bash
$ cat out/trips_*.csv | awk -F, '{c[substr($2,6,2), $8]++} END {for (k in c) print k, c[k]}' | sort | tee out/trips-by-month-and-bike-type
08classic 6
08electric 4
09classic 14361
09electric 8842
10classic 12215
10electric 7576
11classic 8456
11electric 5287
```
*Q9b. I built three month files, and each has two bike types, so I expected six groups. I did not get six, though; I got 8 (unexpected classic and electric bike results from August (08)). The results from August probably represent when a trip started in August but ended in September. The overlap was included by `grep` because `grep` includes all instances (whether Sept, Oct, or Nov were found in the `start_time` or `end-time` columns). This also reveals that there were no trips that started in Nov but ended in Dec.*

*Q9c. Reconcile: the counts in 9a must sum to the total line count from 5b. 6 + 4 + 14,361 + 8,842 + 12,215 + 7,576 + 8,456 + 5,287 = 56,747 (same total from 5b). However, this total still includes S99 and duplicate trips. It needs `sort -u |  grep -v ",S99,"` to remove S99 and duplicate trips and a way to work with date-math (`julianday(end_time) − julianday(start_time)`) since `awk` has no dates (this hasn't been taught in this module though).*

## Part 10 (Challenge)
*C1*
```bash
$ tail -n +2 trips_2025.csv | sort -u | grep -v ",S99," | awk -F, '$6!=""' | awk -F, '{c[$4]++; d[$6]++; stations[$4]} END {for (s in stations) print " Net:", (c[s]) - (d[s]), "Station:", s, " Departures:", c[s], " Arrivals:", d[s]}' | sort -k2 -rn
 Net: 210 Station: S06  Departures: 25696  Arrivals: 25486
 Net: 129 Station: S14  Departures: 8172  Arrivals: 8043
 Net: 129 Station: S13  Departures: 5959  Arrivals: 5830

 Net: -194 Station: S09  Departures: 12804  Arrivals: 12998
 Net: -223 Station: S07  Departures: 13915  Arrivals: 14138
 Net: -295 Station: S11  Departures: 18626  Arrivals: 18921

```
*C2*
*Module 8 computed this same quantity in SQL with three CTEs, and got a net outflow for Hodges Library (S06) of 581. My number (210) is not identical to 581. Module 8's clean_trips view also excluded trips that were longer than 24 hours, but my pipeline keeps these rows. Also, Module 8's clean_trips view also assumed data would continue to grow and include trips from 2026 and so forth. Here, I am only working with one file (trips_2025.csv) so there will be differences.*

## Reflection

*R1. Four tasks this week had a version that ran cleanly and still gave the wrong answer: the case-sensitive grep in 4b, the text sort in 8f, the field-blind grep in 8a, and the stray month groups in 9a. I probably would have been least likely to catch the field-blind grep in 8a on my own. To avoid this I will make a habit of not only using awk -F, most of the time, but also checking my work by using both.*

*R2. Calculating the accurate number of stations is a question I could have answered faster in SQL than in the shell. The shell was the wrong tool because it handles CSVs a lot better than Excel files. Being honest about where the tool stops is worth as much as using it well.*

*R3. AI disclosure: I used Google to help explain why I was getting 47 instead of 25 stations, to remind me when is it most appropriate to use `cat`, to play around with the challenge question in getting the correct format, and to look up the different types of CSV columns for Q2e. All final commands, results, and conclusions are my own.*
