# DATA 501; Assignment 11 Pipeline Log

**Name: Zaharia Selman**
**NetID: zselman**
**Shell: GNU bash, version 5.3.15(2)-release (x86_64-pc-cygwin)**
**sqlite3 version: 3.54.1 2026-10-16 14:45:20 555e07ef33f69a0957d24d8e555b702464a131d6f1607f4c3c1e4551e8e6ca76 (64-bit)**

## Part 0

*0a*

On branch feature/bash-week11-automation
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   .gitignore

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        PIPELINE-LOG.md
        pipeline/

*0c*

```bash
$ set -e | cat exports/nosuchfile.csv | wc -l
cat: exports/nosuchfile.csv: No such file or directory
0
```
```bash
$ set -eo pipefail | cat exports/nosuchfile.csv | wc -l
cat: exports/nosuchfile.csv: No such file or directory
0
```

*Q0d:  `#!/usr/bin/env bash` is one piece of syntac that I will use in Part 2 that would fail on a shell that is not Bash. This is how bash tells my operating system (OS) which interpreter to use. Without it I'm at the mercy of whatever shell the caller happens to run.*

## Part 1

*1a*
```bash
ROWS=$(tail -n +2 "trips_2025.csv" | wc -l)
UNIQUE=$(tail -n +2 "trips_2025.csv" | sort -u | wc -l)
echo "presented $ROWS, distinct $UNIQUE, exact duplicates $((ROWS - UNIQUE))"

$ pipeline/check_data.sh
presented 250600, distinct 250000, exact duplicates 600
```

*1b*
```bash WITH set -euo pipefail
$ pipeline/check_data.sh

Exit code: 0
```
```bash WITHOUT set -euo pipefail
$ pipeline/check_data.sh
presented 250600, distinct 250000, exact duplicates 600
Exit code: 0
```

*1c*
```bash Summary only if everything succeeds
$ pipeline/check_data.sh
presented 250600, distinct 250000, exact duplicates 600
```
```bash Fallback message
$ pipeline/check_data.sh
Error: One or more operations failed.
```

*Q1d: The run from 1b without set -e left 0 in out/junk.txt and this is worse than an empty file because that represents success. This plainly represents the module's meta-rule that a wrong pipeline returns a number, not an error; and a re-typed pipeline returns a different number, with nothing to differentiate.*

## Part 2
*2a*

```bash
DATA_DIR="."
TRIPS="${DATA_DIR}/trips_2025.csv"
```

*2b*
```bash
ROWS=$(tail -n +2 "$TRIPS" | wc -l) || error=1
HAS_END_ID=$(tail -n +2 "$TRIPS" | awk -F',' '$6 != ""' | wc -l)
echo "Row count: $ROWS, Count of rows with an end station id: $HAS_END_ID, Count of rows without an end station id: $((ROWS - HAS_END_

$ pipeline/check_data.sh 2025
Row count: 250600, Count of rows with an end station id: 246826, Count of rows without an end station id: 3774
```

*2c*
```bash
SLUG="out_assignment11/${STATION_NAME// /_}"

$ pipeline/check_data.sh 2025
Row count: 250600, Count of rows with an end station id: 246826, Count of rows without an end station id: 3774
out/Market_Square
```

*Q2d: My prediction is that if we didn't have the quotations, the echo line would only print `Market` because it would split at the space between `Market` and `Square`. However, surprisingly the result was the same (out_assignment11/Market_Square) when I didn't have the quotation marks.*

*Q2e: Bash actually holds text in the $ROWS variable, but $(( … )) is the one construct in my script where Bash treats text as numbers*

## Part 3

*3a*
```bash
YEAR="${1:-}"
[ -n "$YEAR" ] || { echo "usage: $0 YYYY-MM" >&2; exit 1; } 

$ pipeline/check_data.sh
usage: pipeline/check_data.sh provide proper YYYY-MM
```

*3b*
```bash when DATA_DIR="./ride_knox_analyses/"
[ -d "$DATA_DIR" ] || { echo "usage: $0 directory does not exist" >&2; exit 1; } 

$ pipeline/check_data.sh 2025
usage: pipeline/check_data.sh directory does not exist
```

*3c*
```bash
$ ./pipeline/check_data.sh 2024
Exit code: 1, Usage: ./pipeline/check_data.sh file does not exist
```

*3d - if I add an environmental variable, this guard would fire on the real file without me editing the script*
```bash trips_2025.csv passes
DUPLICATES=$((ROWS - UNIQUE))
[ "$DUPLICATES" -lt 1000 ] || { echo "ERROR: File has more than 1,000 duplicate rows" >&2; exit 1; }

$ pipeline/check_data.sh 2025
Row count: 250600, Count of rows with an end station id: 246826, Count of rows without an end station id: 3774
out_assignment11/Market_Square
```

*3e*
```bash
$ ./pipeline/check_data.sh 2025
Row count: 250600, Count of rows with an end station id: 246826, Count of rows without an end station id: 3774
out_assignment11/Market_Square
Row count: 250600, Distinct row count: 250000, Exact duplicates: 600
Exit code: 0
```

*Q3f: Three of my guards write to stderr so a broken command's complaint doesn't end up inside my results file. Keeping stderr separate, helps the shell avoid quietly corrupting a results file. All of these complaints would show up in the log file (in Part 8) if I had used plain `echo`.*

*Q3g: Without ${1:-}, running the script with no argument would make set -u stop the script with an “unbound variable” error before any friendly usage message could print (making it very hard for any analyst who inherits my script unable to find and resolve the issue).*

## Part 4

*4a*
```bash
for STATION in S02 S07 S12 S17 S23 S26; do
STATIONS=$(tail -n +2 trips_2025.csv | awk -F, -v st="$STATION" '$4 == st {c[$4]++} END {for (k in c) print k, c[k]}' | tee out_assignment11/dep_"$STATION".txt)
OUTPUT=$(cat out_assignment11/dep_"$STATION".txt)
printf "%s\n" "$OUTPUT"
done

$ ./pipeline/station_files.sh
S02:  S02 16570
S07:  S07 14177
S12:  S12 9492
S17:  S17 7134
S23:  S23 2103
S26:
```

*4b*
```bash
[ "$count" -eq 0 ] || { echo "$count station(s) with no trips recorded." >&2; exit 1; }

$ ./pipeline/station_files.sh
S02:  S02 16570
S07:  S07 14177
S12:  S12 9492
S17:  S17 7134
S23:  S23 2103
S26:
1 station(s) with no trips recorded.
```

*4c*
```bash Sums to 49,476!
for FILE in out_assignment11/dep_*.txt; do
OUTPUT=$(cat "$FILE")
printf "%s %s\n" "Rank $rank: " "$OUTPUT"
((rank+=1))
done

$ ./pipeline/station_files.sh
Rank 1:  S02 16570
Rank 2:  S07 14177
Rank 3:  S12 9492
Rank 4:  S17 7134
Rank 5:  S23 2103
Rank 6:
```

*4d*
```bash With $(ls out_assignment11/)
$ ./pipeline/station_files.sh
dep_S02.txt
dep_S07.txt
dep_S12.txt
dep_S17.txt
dep_S23.txt
dep_S26.txt
junk.txt
q1
station
notes.txt
```
```bash With wildcard (includes output for .txt with spaces and junk.txt)
$ ./pipeline/station_files.sh
out_assignment11/dep_S02.txt
out_assignment11/dep_S07.txt
out_assignment11/dep_S12.txt
out_assignment11/dep_S17.txt
out_assignment11/dep_S23.txt
out_assignment11/dep_S26.txt
out_assignment11/junk.txt
out_assignment11/q1 station notes.txt
```

*Q4e: The number of files using ls was 10 (because of the file with spaces), whereas the number of files using the wildcard was 8 (correct number). In the first version (using `ls`), the shell parsed each word separated by a space in the file with spaces making it seem like there are more files than there actually are. The rules stated by the lecture to avoid this is to let the shell glob using the wildcard (e.g., *.csv), don't loop over using $(ls), and quote every variable that holds a path.*

*Q4f: Setting an exit code matters for script nobody is watching to explain why the script failed regardless of who is running it.*

## Part 5
```bash
export RIDE_KNOX_DATA="${RIDE_KNOX_DATA:-.}”
```
```bash Environment variable unset
$ ./pipeline/check_data.sh 2025
Row count: 250600, Count of rows with an end station id: 246826, Count of rows without an end station id: 3774
out_assignment11/Market_Square
Row count: 250600, Distinct row count: 250000, Exact duplicates: 600
Exit code: 0
```
```bash Environment variable set to valid path (./out_assignment11)
$ ./pipeline/check_data.sh 2025
Exit code: 1, Usage: ./pipeline/check_data.sh file does not exist
```

*5b*
```bash
$ ./pipeline/check_data.sh 2025
ERROR: File has more than 100 duplicate rows
```

*5c*
```bash
: "${RIDE_KNOX_API_KEY:?set RIDE_KNOX_API_KEY before running}"

export RIDE_KNOX_API_TOKEN=

$ ./pipeline/check_data.sh 2025
./pipeline/check_data.sh: line 4: RIDE_KNOX_API_KEY: set RIDE_KNOX_API_KEY before running
```

*Q5d: My script now mentioned RIDE_KNOX_API_KEY, but never actually contains the key and this is important because the token still lives in the environment without it actually being in my script where other people can see that "secret" information.*

*Q5e: .env goes in .gitignore while .env.example (keys, no values) gets committed to allow an analyst that clones my repo to have a blueprint/template of the key needed (the key) without actually giving them the key to protect against having secret, detrimental information just out there.*

## Part 6
```bash
$ python -m venv .venv

$ source .venv/Scripts/activate
(.venv)

$ which python
/c/Users/zselm/OneDrive - University of Tennessee/Personal/Data Science Toolkit/ride-knox-analysis/.venv/Scripts/python
(.venv)
```

*6b*
```bash
$ pip freeze | wc -l
0
(.venv)

$ pip freeze | wc -l
15
(.venv)
```

- requirements_assignment11.txt file

pandas==3.1.0
matplotlib==3.11.2
openpyxl==3.1.5

*Q6c: The first number from 6b was 0 because I hadn't installed any packages. After installing, the second number from 6b was 15. If I had shipped the pip freeze version, analysts wouldn't know which versions of the packages were used when I was working on the files.*

*6d*
- Monday briefing

*Must add first:* export RIDE_KNOX_TOKEN=… # ask the data team
*Windows:* source .venv/Scripts/activate (.venv/bin/activate for Mac)
*Bash:* ./pipeline/check_data.sh 2025
*Inputs:* trips_YYYY.csv *or* trips_YYYY_MM.csv; ride_knox.db
*Outputs:* out_assignment11/*.txt, out_assignment11/stations_pressure.csv
*Safe to re-run:* yes (trip_id primary key rejects re-loads)
*Fails if:* the API key, export or database is missing, or has more than 1,000 duplicates

*Q6e: The "Safe to re-run" and "Fails if" items from the "Monday briefing" are two of the five that nobody writes but everybody needs. They're the difference between a colleague running my pipeline and a colleague messaging me on vacation because they're unable to determine what's safe to re-run vs when the script/code fails.*

## Part 7

*7a*
.mode csv
.headers on
.once out_assignment11/station_pressure.csv
SELECT t.start_station_id, s.station_name, s.docks, COUNT(*) AS total_departures, (COUNT(*) / s.docks) AS trips_per_dock
FROM trips t
LEFT JOIN stations s ON t.start_station_id = s.station_id
GROUP BY t.start_station_id 
ORDER BY trips_per_dock DESC;

*7b*
```bash
$ sqlite3 ride_knox.db < ./pipeline/station_pressure.sql
```
*Output*

start_station_id	station_name	docks	total_departures	trips_per_dock
S11	Cumberland Ave & 17th St	16	18934	1183
S07	The Hill - Ayres Hall	12	14132	1177
S01	Market Square	20	22606	1130
...
S24	Sequoyah Hills Park	10	1935	193
S23	Bearden - Kingston Pike	12	2095	174
S99			263	

*7c*
```bash
import sys
import pandas as pd

file = sys.argv[1]

df = pd.read_csv(file)

if df.empty:
    print("Error: The CSV provided has no rows.")
    sys.exit(1)

total_trips = df['total_departures'].sum()

station_pressure = df[['start_station_id', 'trips_per_dock']]
station_count = df['start_station_id'].value_counts()

high_stations = station_pressure.sort_values(['trips_per_dock','start_station_id'], ascending=[False, True]).head(3)
low_stations = station_pressure.sort_values(['trips_per_dock', 'start_station_id'], ascending=[True, True]).head(3)

print(f"Total Stations Read: {len(station_count)}")
print(f"\nTotal Trips Read: {total_trips}")

# print(station_pressure)

print("--- 3 Most Pressured Stations ---")
for station, count in high_stations.values:
    print(f"Station: {station} | Pressure: {count}")

print("\n--- 3 Least Pressured Stations ---")
for station, count in low_stations.values:
    print(f"Station: {station} | Pressure: {count}")

$ python ./pipeline/summarize.py ./out_assignment11/station_pressure.csv
Total Stations Read: 25

Total Trips Read: 250000

--- 3 Most Pressured Stations ---
Station: S11 | Pressure: 1183.0
Station: S07 | Pressure: 1177.0
Station: S01 | Pressure: 1130.0

--- 3 Least Pressured Stations ---
Station: S23 | Pressure: 174.0
Station: S24 | Pressure: 193.0
Station: S21 | Pressure: 283.0
```

*7d*
```bash Unbroken
$ sqlite3 ride_knox.db < ./pipeline/station_pressure.sql && python ./pipeline/summarize.py ./out_assignment11/station_pressure.csv
Total Stations Read: 25

Total Trips Read: 250000

--- 3 Most Pressured Stations ---
Station: S11 | Pressure: 1183.0
Station: S07 | Pressure: 1177.0
Station: S01 | Pressure: 1130.0

--- 3 Least Pressured Stations ---
Station: S23 | Pressure: 174.0
Station: S24 | Pressure: 193.0
Station: S21 | Pressure: 283.0
```
``` Broken
$ sqlite3 ride_knox_nonexistent.db < ./pipeline/station_pressure.sql && python ./pipeline/summarize.py ./out_assignment11/station_pressure.csv
Parse error near line 5: no such table: trips
```

*Q7e: The 24 stations (minus S99) account for 249,737 of the 250,000 trips. The difference are the 263 trips from the S99 stations that the JOIN drops because S99 is not in the stations table.*

*Q7f: The module prefers to aggregate in SQL and analyzes in Python to keep bash script in the former and the analysis (pandas) in the latter. It is better to keep small Python scripts with one job each and let Shell script chain them.*

*Q7g: Because GUI's cannot be scheduled, the DB Browser was explicitly ruled out.*

## Part 8

*8a*
```bash
$ ./pipeline/run_briefing.sh 2025
[2026-11-01T21:25:50] check_data.sh starting for 2025
Row count: 250600, Count of rows with an end station id: 246826, Count of rows without an end station id: 3774
out_assignment11/Market_Square
Row count: 250600, Distinct row count: 250000, Exact duplicates: 600
Exit code: 0

Script succeeded

[2026-11-01T21:25:50] sqlite3 query starting for 2025

sqlite3 query succeeded

[2026-11-01T21:25:50] summarize.py starting for 2025
Total Stations Read: 25

Total Trips Read: 250000

--- 3 Most Pressured Stations ---
Station: S11 | Pressure: 1183.0
Station: S07 | Pressure: 1177.0
Station: S01 | Pressure: 1130.0

--- 3 Least Pressured Stations ---
Station: S23 | Pressure: 174.0
Station: S24 | Pressure: 193.0
Station: S21 | Pressure: 283.0

summarize.py succeeded

[2026-11-01T21:25:50] run_briefing.sh is Done!
(.venv)
```

*8b: Second Run*
```bash
$ ./pipeline/run_briefing.sh 2025
[2026-11-01T21:29:32] check_data.sh starting for 2025
Row count: 250600, Count of rows with an end station id: 246826, Count of rows without an end station id: 3774
out_assignment11/Market_Square
Row count: 250600, Distinct row count: 250000, Exact duplicates: 600
Exit code: 0

Script succeeded

[2026-11-01T21:29:32] sqlite3 query starting for 2025

sqlite3 query succeeded

[2026-11-01T21:29:32] summarize.py starting for 2025
Total Stations Read: 25

Total Trips Read: 250000

--- 3 Most Pressured Stations ---
Station: S11 | Pressure: 1183.0
Station: S07 | Pressure: 1177.0
Station: S01 | Pressure: 1130.0

--- 3 Least Pressured Stations ---
Station: S23 | Pressure: 174.0
Station: S24 | Pressure: 193.0
Station: S21 | Pressure: 283.0

summarize.py succeeded

[2026-11-01T21:29:32] run_briefing.sh is Done!
(.venv)
```
```bash Module 10 comparison to confirm that the output is the same
$ wc -l ./out_assignment11/station_pressure.csv
26 ./out_assignment11/station_pressure.csv
(.venv)

$ wc -l ./out_assignment11/pressure_run1.csv
26 ./out_assignment11/pressure_run1.csv
(.venv)

$ cat ./out_assignment11/station_pressure.csv ./out_assignment11/pressure_run1.csv | sort -u | wc -l
26
(.venv)

# My file is idempotent because running the script twice leaves the repo in the same state as running it once
```

*8d*
```bash
$ git -C . add pipeline/latest_summary.txt
warning: in the working copy of 'pipeline/latest_summary.txt', LF will be replaced by CRLF the next time Git touches it
(.venv)

$ git -C . commit -m "Add latest station pressure summary" || echo "nothing to commit"
[feature/bash-week11-automation 44d0d64] Add latest station pressure summary
 1 file changed, 15 insertions(+)
 create mode 100644 pipeline/latest_summary.txt
(.venv)

$ git -C . commit -m "Add latest station pressure summary" || echo "nothing to commit"
On branch feature/bash-week11-automation
...
no changes added to commit (use "git add" and/or "git commit -a")
nothing to commit
(.venv)
```

*Q8e: The plain > would have overriden all of the files instead of the desired result which was to append. This matters for Part 9 where we'll be using cron meaning we would lose all of the history from the previous runs if `tee` wasn't used*

## Part 9

*9a*
```bash Runs run_briefing.sh for 2025 at 07:15 every Monday, capturing both normal output and errors into logs/cron.log. 
15 07 * * 1 ./ride-knox-analysis/pipeline/run_briefing.sh >> ./ride-knox-analysis/logs/cron.log 2>&1
```
15 - marks the minute the job is run

07 - marks the hour the job is run

`*` - marks that any day a during the week that a Monday falls on the job is run

`*` - marks that Mondays during all months the job is run

1 - marks the day of the week (Monday) that the job is run 

*9b*

`cd "$(dirname "$0")"` is the one from the lecture slides that makes the cron run correctly no matter which directory it is launched from.

To change any Python call to one that does not depend on a virtual environment being active we have to activate the venv inside the script, or call `/full/path/.venv/bin/python` directly.

*9c*
```bash First run using env -i (Needed to add PATH= because environment is completely wiped so needs to be redirected to Bash)
$ env -i PATH=/usr/bin:/bin ./pipeline/run_briefing.sh 2025
[2026-11-02T17:50:33] check_data.sh starting for 2025
Row count: 250600, Count of rows with an end station id: 246826, Count of rows without an end station id: 3774
out_assignment11/Market_Square
Row count: 250600, Distinct row count: 250000, Exact duplicates: 600
Exit code: 0

Script succeeded

[2026-11-02T17:50:33] sqlite3 query starting for 2025
./pipeline/run_briefing.sh: line 17: sqlite3: command not found
ERROR: sqlite query did not run properly
(.venv)
```
```bash Second run using env -i to fix failing run_briefing.sh
$ env -i PATH="/usr/bin:/c/Program Files/sqlite:/c/Users/zselm/OneDrive - University of Tennessee/Personal/Data Science Toolkit/ride-knox-analysis/.venv/Scripts" PWD="$PWD" HOME="$HOME" SYSTEMROOT="/c/Windows" TEMP="/tmp" TMPDIR="/tmp" ./pipeline/run_briefing.sh 2025 sqlite3 python
[2026-11-02T19:32:33] check_data.sh starting for 2025
Row count: 250600, Count of rows with an end station id: 246826, Count of rows without an end station id: 3774
out_assignment11/Market_Square
Row count: 250600, Distinct row count: 250000, Exact duplicates: 600
Exit code: 0

Script succeeded

[2026-11-02T19:32:33] sqlite3 query starting for 2025

sqlite3 query succeeded

[2026-11-02T19:32:33] summarize.py starting for 2025

[2026-11-02T19:32:33] run_briefing.sh is Done!
(.venv)
```
*I ended up having to make quite a few changes because I didn't know we were supposed to run the lines from 9b (since we didn't run the actual `cron` Job). I've learned a new method, but I believe the previous commands from 9b wouold have avoided me having to do this longer method. The Python call would have been responsible for making sure I didn't have to add that path line like I did in the `Bash` command*

```bash Using the commands from 9b (could have also been placed in run_briefing.sh; would have been easier to run)
$ env -i PATH="/usr/bin:/c/Program Files/sqlite" PWD="$PWD" HOME="$HOME" SYSTEMROOT="/c/Windows" TEMP="/tmp" TMPDIR="/tmp" ./pipeline/run_briefing.sh 2025 sqlite3                                      ./pipeline/..
[2026-11-02T19:57:14] check_data.sh starting for 2025
Row count: 250600, Count of rows with an end station id: 246826, Count of rows without an end station id: 3774
out_assignment11/Market_Square
Row count: 250600, Distinct row count: 250000, Exact duplicates: 600
Exit code: 0

Script succeeded

[2026-11-02T19:57:14] sqlite3 query starting for 2025

sqlite3 query succeeded

[2026-11-02T19:57:14] summarize.py starting for 2025

[2026-11-02T19:57:14] run_briefing.sh is Done!
(.venv)
```

*Q9d: My interactive shell has an activated venv, a full PATH, and a working directory that I chose. Of those three, cron will not give me an acticated venv. Activating the venv inside the script (or calling /full/path/.venv/bin/python directly) compensates for the activated venv. Adding `cd "$(dirname "$0")"` at the top of the script allows absolute paths to be used for everything to compensate for the PATH. Cron automatically runs the script with the home directory as the working directory to compensate for the working directory.*

## Part 10 (Challenge)

*C1*
```bash New loop for all 24 stations
$ ./pipeline/station_files.sh
S01 22656
S02 16570
S03 10633
S04 14302
S05 15435
S06 26112
S07 14177
S08 25044
S09 13032
S10 7268
S11 18983
S12 9492
S13 6069
S14 8324
S15 3782
S16 4258
S17 7134
S18 4691
S19 5280
S20 3548
S21 2843
S22 6662
S23 2103
S24 1939
Number of stations with 0 trips: 0(.venv)
```

*The departures across my 24 stations is 250,337. This does not align with the 250,600 trips in the file because we no longer have the test station S99 (accounted for 250600 - 250337 = 263 trips) since that station is not in stations.xlsx.*

*C2: The one thing that must be added to `run_briefing.sh` so the dependent loop cannot silently run against a stale or missing out_assignment11/stations.csv is a guard clause that makes sure the proper csv exists before running it*
```bash
[ -s out_assignment11/stations.csv ] || { echo "Error: out_assignment11/stations.csv is missing or stale. Ensure the Python script has run first and successfully"; >&2; exit 1; }
```

## Reflection
*R1. Four tasks this week had a version that exits 0 and is still wrong: the missing set -eo pipefail in 0c, the unquoted variable in 2d, the $(ls) loop in 4d, and the silently short join in 7e. I would have been least likely to catch the missing set -eo pipefail on my own. To avoid this in the future, I will create a .sh template that I will copy to make files that will always have the proper commands at the top to make sure this is something I won't have to worry about in the future.*

*R2. In one or two sentences: your pipeline now runs unattended. The single failure that would be hardest for the ops lead to notice is a false positive success. To make it noisy, I would add guards using && and ||.*

*R3. AI disclosure: describe any use of generative AI tools in this assignment, or state "No generative AI tools were used." Example: "I used Google a lot for this assignment because Bash is completely new to me and caused a lot of confusion. I tried to look up why I was getting the same result for 2c regardless of if I had quotations or not, but I was not successful. I also couldn't figure out why my >>SQL ... SQL commands weren't working in the .sql file. I used Google as a refresh for creating loops in Python and Bash. I needed Google a lot to get the syntax correct. `"($)"` versus `$()` confused me. I went down the rabbit hole to figure out how to get env -i working in Part 9. All final scripts, results, and conclusions are my own."*

