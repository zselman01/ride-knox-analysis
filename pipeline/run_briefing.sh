#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
echo "$(dirname "$0")/.."

source .venv/Scripts/activate


YEAR="${1:-$(date -d +%Y)}"

STAMP=$(date +%Y-%m-%dT%H:%M:%S)

echo "[$STAMP] check_data.sh starting for $YEAR" | tee -a "./logs/briefing.log"
if ./pipeline/check_data.sh "$YEAR"; then
    echo -e "\nScript succeeded" # -e lets Bash know what the backslash means
else
    echo "ERROR: check_data.sh "$YEAR" did not run properly" >&2; exit 1;
fi | tee -a "./logs/briefing.log"


echo -e "\n[$STAMP] sqlite3 query starting for $YEAR" | tee -a "./logs/briefing.log"
if sqlite3 ride_knox.db < ./pipeline/station_pressure.sql; then
    echo -e "\nsqlite3 query succeeded"
else
    echo "ERROR: sqlite query did not run properly" >&2; exit 1;
fi | tee -a "./logs/briefing.log"


echo -e "\n[$STAMP] summarize.py starting for $YEAR" | tee -a "./logs/briefing.log"
if python ./pipeline/summarize.py ./out_assignment11/station_pressure.csv; then
    echo -e "\nsummarize.py succeeded"
else
    echo "ERROR: summarize.py did not run properly" >&2; exit 1;
fi | tee -a "./logs/briefing.log" | tee "./pipeline/latest_summary.txt"

# In Bash
# git -C . add pipeline/latest_summary.txt # it stages one specific file
# git -C . commit -m "Add latest station pressure summary" || echo "nothing to commit"

echo -e "\n[$STAMP] run_briefing.sh is Done!" | tee -a "./logs/briefing.log"