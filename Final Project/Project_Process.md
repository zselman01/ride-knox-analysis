## Below illustrates the Order in which this project was completed (to be used as a template for future projects)

1. Inspect (using `cat`) the Bash Scripts in pipeline/
- intake_gate.sh: reads files from incoming/, checks 8 columns, minimum row count, malformed rows, duplicate rows, dominant month, moves files into accepted/ or quarantine/, and records output to out/gate_receipts.csv
- prepare_accepted.sh: reads files from accepted/, repairs August station-name formatting, removes malformed rows, moves repaired files to staging/, and records output for records repaired and dropped

2. Inspect Quarantine Release and Python Loader
- release_quarantine.sh: moves file from quarantine/ to accepted/ when authorized (by a human); records override in out/gate_receipts.csv
- load_warehouse.py: creates and populates the SQLite database
    - Initialize database, load reference data (stations, dock-history, rider types), load weather data, load trips data, track exclusions, and reconciles data to out/system_reconciliation.csv (accountability of all changes)

3. Inspect SQL Files (sql/)
- schema.sql: creates 4 main tables (stations, dock_history, rider type products, trips, weather)
- views.sql: creates 2 views
    - trips_reportable: sets criteria for including trips in annual report (must have start time, can have missing end time, otherwise duration must be no less than 1 min and no greater than 24 hours)
    - docks_by_year: calculates number of docks depending on the year
- extracts.sql: creates 5 CSV outputs for visualization in R (annual report will read from these CSV files instead of directly from the database)

4. Inspect Remaining Starter Files
- report/annual_report_skeleton.qmd: combines R code with text, tables, and figures into an HTML presentation
- site/index_skeleton.md: public landing page for the final project

5. Start creating build_all.sh
- TO DO comments have remained in place to see the process of completing the script
- annual_report.qmd also needed to be editted (TO DO comments remain in that file as well)