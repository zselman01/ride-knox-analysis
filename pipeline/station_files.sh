#!/usr/bin/env bash
set -euo pipefail

# for TRIPS in trips_2025.csv; do
# STATIONS=$(tail -n +2 "$TRIPS" | awk -F, '$4=="S02" || $4=="S07" || $4=="S12" || $4=="S17" || $4=="S23" || $4=="S26" {c[$4]++} END {for (k in c) print k, c[k]}')
# printf "$STATIONS"
# done

# count=0

# for STATION in S02 S07 S12 S17 S23 S26; do
# #STATIONS=$(tail -n +2 trips_2025.csv | awk -F, '$4=="$STATION" {c[$4]++} END {for (k in c) print k, c[k]}')
# STATIONS=$(tail -n +2 trips_2025.csv | awk -F, -v st="$STATION" '$4 == st {c[$4]++} END {for (k in c) print k, c[k]}' | tee out_assignment11/dep_"$STATION".txt)
# [ -s out_assignment11/dep_"$STATION".txt ] || ((count+=1))
# OUTPUT=$(cat out_assignment11/dep_"$STATION".txt)
# printf "%s %s\n" "$STATION: " "$OUTPUT"
# done

# [ "$count" -eq 0 ] || { echo "$count station(s) with no trips recorded." >&2; exit 1; }
# printf "Number of stations with 0 trips: $count"

#########################################################
# rank=1

# for FILE in out_assignment11/dep_*.txt; do
# OUTPUT=$(cat "$FILE")
# printf "%s %s\n" "Rank $rank: " "$OUTPUT"
# ((rank+=1))
# done

#########################################################
# for F in $(ls out_assignment11/); do
# printf "%s\n" "$F"
# done

for F in out_assignment11/*; do
printf "%s\n" "$F"
done

