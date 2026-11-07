#!/usr/bin/env bash
set -euo pipefail
# build_all_skeleton.sh -- the shape of the one command, with the wiring
# left to you. The starter pack gives you known-good COMPONENTS (the gate,
# the prep stage, the loader, the SQL files, a report skeleton); deciding how
# they chain, what resets between runs, what each stage may assume about the
# last, and what the script reports when it finishes is the Final Project's
# architecture work -- which is to say, it is the graded part.
#
# Every TODO is yours. The stage list below is ONE defensible order, not the
# only one. Whatever you build must satisfy: clean-clone rebuild with this
# single command; raw files never modified; every stage boundary timestamped;
# a failure in any stage stops the stages after it.

cd "$(dirname "$0")"

# Configurable Inputs
DATA_DIR="${DATA_DIR:-data}"
DB="${RIDE_KNOX_DB:-out/ride_knox_wh.db}"

# Fixed Working Directories - fixed in the other files build_all.sh refers to
INCOMING_DIR="incoming"
ACCEPTED_DIR="accepted"
QUARANTINE_DIR="quarantine"
STAGING_DIR="staging"
OUT_DIR="out"

stamp() { echo "[$(date +%Y-%m-%dT%H:%M:%S)] $*"; }

[ -d "$DATA_DIR" ] || { echo "ERROR: DATA_DIR=$DATA_DIR not found" >&2; exit 1; }

stamp "STARTING BUILD"

# TODO stage 0: reset build products (which things are build products in YOUR
#               architecture? the database certainly; what else?)
stamp "Stage 0 START: Resetting build products"

rm -rf "$INCOMING_DIR" "$ACCEPTED_DIR" "$QUARANTINE_DIR" "$STAGING_DIR" "$OUT_DIR"

rm -f "$DB"

rm -f report/annual_report.html
rm -rf report/annual_report_files
rm -f site/annual_report.html
rm -rf site/annual_report_files

mkdir -p "$INCOMING_DIR" "$ACCEPTED_DIR" "$QUARANTINE_DIR" \
         "$STAGING_DIR" "$OUT_DIR"

stamp "Stage 0 COMPLETE: Build products reset"

# TODO stage 1: deliver working copies of the raw trip files to the inbox
#               (the raw files themselves are never touched)
echo
stamp "Stage 1 START: Copying raw trip files to incoming/ folder"

cp "$DATA_DIR"/trips_*.csv "$INCOMING_DIR"/

stamp "Stage 1 COMPLETE: Working copies delivered"

# TODO stage 2: run the intake gate; decide -- and defend in TOOL-DEFENSE.md
#               -- what your build does about quarantined files. The October
#               fragment needs a policy, and the policy must be visible.
echo
stamp "Stage 2 START: Running the intake gate"

bash pipeline/intake_gate.sh "$INCOMING_DIR"

# See TOOL-DEFENSE.md for justification
bash pipeline/release_quarantine.sh "trips_2026_10.csv" "Truncated October delivery is being released under the data teams December decision (board can't wait), with coverage caveats handled downstream in the report"

stamp "Stage 2 COMPLETE: Ran the intake gate"

# TODO stage 3: repair + structural filter into staging/
echo
stamp "Stage 3 START: Filter into staging/ folder"

bash pipeline/prepare_accepted.sh

stamp "Stage 3 COMPLETE: Filter complete"

# TODO stage 4: load the warehouse (the loader is the only code that writes
#               trips; its closure checks are allowed to kill the build --
#               that is what they are for)
echo
stamp "Stage 4 START: Loading the warehouse"

python3 pipeline/load_warehouse.py "$DB" "$STAGING_DIR" "$DATA_DIR"

stamp "Stage 4 COMPLETE: Warehouse loaded"

# TODO stage 5: reporting layer -- views, then extracts to out/
echo
stamp "Stage 5 START: Reporting layer (Views then Extracts)"

sqlite3 "$DB" < sql/views.sql
sqlite3 "$DB" < sql/extracts.sql

stamp "Stage 5 COMPLETE: Reporting layer completed"

# # TODO stage 6: render the report (it must read out/ and nothing else)
# echo
# stamp "Stage 6 START: Rendering report"

# if ! command -v quarto >/dev/null 2>&1; then
#     echo "ERROR: Quarto is required to render the annual report." >&2
#     exit 1
# fi

# quarto render report/annual_report.qmd --to html

# [ -s report/annual_report.html ] || {
#     echo "ERROR: Annual report rendering did not produce report/annual_report.html" >&2
#     exit 1
# }

# stamp "Stage 6 COMPLETE: Annual report rendered"

# # TODO stage 7: stage the public page (which files does Pages serve, and how
# #               do they get there? this is TOOL-DEFENSE.md material)
# echo
# stamp "Stage 7 START: Staging public page"

# cp report/annual_report.html site/annual_report.html

# if [ -d report/annual_report_files ]; then
#     cp -R report/annual_report_files site/
# fi

# stamp "Stage 7 COMPLETE: Public page staged"

# # TODO stage 8: write a build summary a stranger could read
# echo
# stamp "Stage 8 START: Building summary"

# TRIP_COUNT=$(sqlite3 "$DB" "SELECT COUNT(*) FROM trips;")
# REPORTABLE_COUNT=$(sqlite3 "$DB" "SELECT COUNT(*) FROM trips_reportable;")
# WEATHER_COUNT=$(sqlite3 "$DB" "SELECT COUNT(*) FROM weather;")

# {
#     echo "RIDE KNOX WAREHOUSE BUILD SUMMARY"
#     echo "================================="
#     echo "Completed: $(date +%Y-%m-%dT%H:%M:%S)"
#     echo "Database: $DB"
#     echo "Data directory: $DATA_DIR"
#     echo

#     echo "WAREHOUSE TOTALS"
#     echo "----------------"
#     echo "Total trips: $TRIP_COUNT"
#     echo "Reportable trips: $REPORTABLE_COUNT"
#     echo "Weather records: $WEATHER_COUNT"
#     echo

#     echo "ACCEPTED FILES"
#     echo "--------------"
#     for file in "$ACCEPTED_DIR"/*.csv; do
#         if [ -f "$file" ]; then
#             echo "  $(basename "$file")"
#         fi
#     done
#     echo

#     echo "QUARANTINED FILES"
#     echo "-----------------"
#     for file in "$QUARANTINE_DIR"/*.csv; do
#         if [ -f "$file" ]; then
#             echo "  $(basename "$file")"
#         fi
#     done
#     echo

#     echo "BUILD RECEIPTS"
#     echo "--------------"
#     echo "Intake decisions: $OUT_DIR/gate_receipts.csv"
#     echo "Preparation decisions: $OUT_DIR/prepare_receipts.csv"
#     echo "System reconciliation: $OUT_DIR/system_reconciliation.csv"
#     echo
#     echo "SQL extracts are available in: $OUT_DIR/"
# } > "$OUT_DIR/build_summary.txt"

# cat "$OUT_DIR/build_summary.txt"

# stamp "Stage 8 COMPLETE: Summary built"

stamp "BUILD SUCCESSFULL"
