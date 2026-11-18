# Ride Knox Ridership Analysis: Two Years, One System

## Overview 
### The Day Pass Brought the Casual Riders Back, Campus Pressure was Relieved, and Member Riders Were Unaffected


## Repository handover

This repository contains the Ride Knox data science projects and the final integrated warehouse and reporting pipeline. The Final Project/ directory contains the reproducible build system. The build system takes the raw trips, station (2026), and weather data, validates and prepares the trip files, loads a SQLite warehouse, produces reporting extracts, renders the annual report, and stages the public-facing GitHub Pages site.

The purpose of this handover is to let someone unfamiliar with the project rebuild it, locate its outputs, and understand its operational limits without relying on me (the original developer).


## Data
Raw files are **not** in this repo (~22 MB, and we believe you should never edit raw data).
We have schemas of our data below, but request raw data files from the Ride Knox data team.

*2025 bundle (~247,844 cleaned trips across 24 stations)*
*2026 bundle (~135,545 cleaned trips across 25 stations)*


`trips_2025.csv` and `trips_2026_h1.csv` — one row per trip:

| column                | type     | notes                                 |
| ----------------------| -------- | ------------------------------------- |
| trip_id               | str      | unique, T-series                      |
| start_time / end_time | datetime | stored as text in the raw file        |
| start_station_id      | str      | joins to stations.station_id          |
| start_station_name    | str      | authoritative names in stations.xlsx  |
| end_station_id        | str      | ~3,800 missing (kept and flagged)     |
| rider_type            | str      | member / casual (raw has 6 spellings) |
| bike_type             | str      | classic / electric                    |


`stations.xlsx` and `stations_2026.xlsx` — one row per station:

| column                | type     | notes                                 |
| ----------------------| -------- | ------------------------------------- |
| station_id            | str      | unique, T-series                      |
| station_name          | str      | authoritative names                   |
| neighborhood          | str      | broader location stations share       |
| latitude              | float    | Latitude location of each station     |
| longitude             | float    | Longitude location of each station    |
| docks                 | int      | number of docks                       |
| year_installed        | int      | year station was installed            |


## Repository layout

| Location                         | Purpose                                                                        |
|----------------------------------|--------------------------------------------------------------------------------|
|2025_bundle/                      | Earlier project materials and 2025 report                                      |
|2026_bundle/                      | Earlier project materials and 2026 memo                               |
|Final Project/                    | Main integrated pipeline and annual report                                     |
|Final Project/data/               | Raw input data; supplied separately and not committed                          |
|Final Project/pipeline/           | Intake gate, quarantine release, preparation, and Python warehouse loader      |
|Final Project/sql/                | Warehouse schema, reporting views, and extract queries                         |
|Final Project/report/             | Quarto (R) annual report source and generated report                               |
|Final Project/docs/               | GitHub Pages source and locally staged publication files                       |
|docs/                             | Repository-level GitHub Pages publication directory                            |
|Final Project/out/                | Generated database, SQL extracts, receipts, and build summary                  |
|Final Project/expected_receipts/  | Reference receipt files for comparison                                         |
|Final Project/ARCHITECTURE.md     | Pipeline architecture documentation                                            |
|Final Project/TOOL-DEFENSE.md     | Tool choices and implementation trade-offs                                     |

The build script runs from its own directory (Final Project/), so paths inside the pipeline are relative to Final Project/, even when the command is launched from the repository root.


## Tools/How to Run: Bash, Python, SQL, Quarto, and R
To run the build script: 

The build is intended to run in Bash. On Windows, use Git Bash or another compatible Bash environment.

Install and make available:
- Bash
- Python 3
- SQLite command-line tools (sqlite3)
- Quarto
- R
- The Python and R packages listed in Final Project/requirements.txt
- The R packages used by the annual report: knitr, readr, dplyr, ggplot2, lubridate, and broom

The Python requirements are:
```bash
pandas==3.0.3
openpyxl==3.1.5
```

From Final Project/, install them with:
```bash
python3 -m pip install -r requirements.txt
```

The R package versions are not pinned by this project. Quarto must be installed separately and available on the command line.

Install the R packages from an R console:
```bash
install.packages(c(
  "knitr",
  "readr",
  "dplyr",
  "ggplot2",
  "lubridate",
  "broom"
))
```

## Where the data goes

Obtain the original source data separately and place it in:
```bash
Final Project/data/
```
The directory must contain:
- The trip CSV files named trips_*.csv
- stations_2026.xlsx
- weather_knoxville_daily.csv

The trip files are copied into incoming/ by the build. Do not manually place files into accepted/, quarantine/, or staging/; those directories are generated by the pipeline. The loader uses stations_2026.xlsx for station reference data.

**Important**: data/ is gitignored. A clean Git clone does not include the raw data, so the successor must obtain the source data bundle before rebuilding. Keep the original files unchanged. The pipeline works on copies.

## Rebuilding the project: The one command rebuild

From the repository root, run:
```bash
bash "Final Project/build_all.sh"
```
or from inside Final Project/, run:
```bash
bash build_all.sh
```





### Limitations
Our data for a few variables is only over a short period of time. There are stations that have been excluded because they were missing both end station IDs and end times. We should collect information from our rider that could be influencing their riding (e.g., reasons for riding, etc.). The one minute cutoff rule implemented in the analysis causes us to lose data points that may otherwise influence our analysis. We excluded trips longer than 24 hours (bikes likely never docked properly).



### Monday briefing
*Must add first:* export RIDE_KNOX_TOKEN=… # ask the data team

*Windows:* source .venv/Scripts/activate (.venv/bin/activate for Mac)

*Bash:* ./pipeline/check_data.sh 2025

*Inputs:* trips_YYYY.csv *or* trips_YYYY_MM.csv; ride_knox.db

*Outputs:* out_assignment11/*.txt, out_assignment11/stations_pressure.csv

*Safe to re-run:* yes (trip_id primary key rejects re-loads)

*Fails if:* the API key, export or database is missing, or has more than 1,000 duplicates