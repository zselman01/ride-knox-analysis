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
export RIDE_KNOX_DB="${RIDE_KNOX_DB:-ride_knox.db}”
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

```

## Part 9
## Reflection
