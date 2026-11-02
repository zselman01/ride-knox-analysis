#!/usr/bin/env bash
set -euo pipefail #e: stop on the first command that fails, -u: a misspelled variable is an error, not an empty string, -o pipefail: a pipeline fails if any stage fails, not just the last one

# : "${RIDE_KNOX_API_KEY:?set RIDE_KNOX_API_KEY before running}"

export RIDE_KNOX_DATA="${RIDE_KNOX_DATA:-.}"

DATA_DIR="${RIDE_KNOX_DATA:-.}"
[ -d "$DATA_DIR" ] || { echo "usage: $0 directory does not exist" >&2; exit 1; }

YEAR="${1:-}"
[ -n "$YEAR" ] || { echo "usage: $0 provide proper YYYY-MM" >&2; exit 1; }

TRIPS="${DATA_DIR}/trips_${YEAR}.csv"
[ -f "$TRIPS" ] || { echo "Exit code: $?, Usage: $0 file does not exist" >&2; exit 1; }

STATION_NAME="Market Square"
SLUG="out_assignment11/${STATION_NAME// /_}"

error=0

ROWS=$(tail -n +2 "$TRIPS" | wc -l) || error=1
HAS_END_ID=$(tail -n +2 "$TRIPS" | awk -F',' '$6 != ""' | wc -l)
# grep -c "NOSUCHPATTERN" trips_2025.csv > out_assignment11/junk.txt || error=1
UNIQUE=$(tail -n +2 "$TRIPS" | sort -u | wc -l) || error=1

RIDE_KNOX_MAX_DUPES="${RIDE_KNOX_MAX_DUPES:-1000}"
DUPLICATES=$((ROWS - UNIQUE))
[ "$DUPLICATES" -lt "$RIDE_KNOX_MAX_DUPES" ] || { echo "ERROR: File has more than "$RIDE_KNOX_MAX_DUPES" duplicate rows" >&2; exit 1; }

echo "Row count: $ROWS, Count of rows with an end station id: $HAS_END_ID, Count of rows without an end station id: $((ROWS - HAS_END_ID))"
echo "$SLUG"
[ $error -eq 0 ] && { echo "Row count: $ROWS, Distinct row count: $UNIQUE, Exact duplicates: $((ROWS - UNIQUE))"; }
[ $error -eq 0 ] || { echo "Error: One or more operations failed."; }
echo "Exit code: $?"