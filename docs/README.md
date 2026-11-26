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


## Repository (ride-knox-analysis/) layout
| Location                           | Purpose                                                                        |
|------------------------------------|--------------------------------------------------------------------------------|
|`2025_bundle/`                      | Earlier project materials and 2025 report                                      |
|`2026_bundle/`                      | Earlier project materials and 2026 memo                                        |
|...from entire semester             | ...                                                                            |
|`Final Project/`                    | Main integrated pipeline and annual report                                     |
|`Final Project/data/`               | Raw input data; supplied separately and not committed                          |
|`Final Project/pipeline/`           | Intake gate, quarantine release, preparation, and Python warehouse loader      |
|`Final Project/sql/`                | Warehouse schema, reporting views, and extract queries                         |
|`Final Project/report/`             | Quarto (R) annual report source and generated report                           |
|`Final Project/docs/`               | GitHub Pages source and locally staged publication files                       |
|`docs/`                             | Repository-level GitHub Pages publication directory                            |
|`Final Project/out/`                | Generated database, SQL extracts, receipts, and build summary                  |
|`Final Project/expected_receipts/`  | Reference receipt files for comparison                                         |
|`Final Project/ANCHORS.md`          | Anchors used to check against for this project                                 |
|`Final Project/ARCHITECTURE.md`     | Pipeline architecture documentation                                            |
|`Final Project/TOOL-DEFENSE.md`     | Tool choices and implementation trade-offs                                     |

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
- The trip CSV files named `trips_*.csv`
- `stations_2026.xlsx`
- `weather_knoxville_daily.csv`

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

## Stage table

The stages run in order. Each stage prints a timestamped START and COMPLETE message. The script uses set -euo pipefail, so a failing command stops the build rather than allowing later stages to proceed.

Click here for the ![Architecture Diagram]("Final Project/pipeline/diagram.png") for the diagram. 

| Stage | Reads | Writes | What happens |
|---|---|---|---|
| 0. Reset | Existing generated directories and files | Clean working directories | Removes prior `incoming/`, `accepted/`, `quarantine/`, `staging/`, and `out/` directories; removes the configured database and generated report/publication copies. Preserves raw data and source files. |
| 1. Working copies | `data/trips_*.csv` | `incoming/` | Copies raw trip files into the working inbox. Raw source files are never modified. |
| 2. Intake gate and quarantine release*** | `incoming/` | `accepted/`, `quarantine/`, `out/gate_receipts.csv` | Checks headers, row counts, malformed rows, and duplicates. Files that pass move to `accepted/`; failing files move to `quarantine/`. The build explicitly releases `trips_2026_10.csv` from the documented October exception. |
| 3. Repair and Structural Filter*** | `accepted/*.csv` | `staging/`, `out/prepare_receipts.csv` | Repairs the known August station-name defect and removes rows that do not have exactly eight fields. Original accepted files remain unchanged. |
| 4. Warehouse loading | `staging/`, `data/stations_2026.xlsx`, `data/weather_knoxville_daily.csv`, `sql/schema.sql`, preparation and gate receipts | SQLite database, `out/system_reconciliation.csv` | Creates the warehouse, loads reference and weather data, normalizes rider types, and loads trips in chronological order based on file contents. Checks that each source file's raw rows reconcile to loaded and excluded rows. |
| 5. Reporting layer | SQLite database, `sql/views.sql`, `sql/extracts.sql` | SQL views and CSV extracts in `out/` | Creates reporting views and exports the datasets used by the annual report. |
| 6. Report rendering | `report/annual_report.qmd`, CSV extracts in `out/` | `report/annual_report.html`, report figures | Renders the annual report with Quarto. The report reads the SQL-generated extracts and reconciliation ledger, not the raw trip files or database directly. |
| 7. Public-site | Rendered report, report figure, `2025_bundle/report.md`, `2026_bundle/memo.md`, and `Final Project/docs/` source files | `Final Project/docs/` and repository-level `docs/` | Copies the report, lead figure, earlier project reports, and memo into the local publication directory, then copies its contents into the repository-level `docs/` directory to be used by GitHub Pages. |
| 8. Build summary | SQLite database, generated receipts, accepted and quarantined files | `out/build_summary.txt` | Counts warehouse trips, reportable trips, and weather records; lists accepted and quarantined files; identifies the receipt and extract locations. Prints the summary to the terminal. |

*** - see Intake policy notes below


## Intake policy and important data decisions from Stage table

The intake gate checks each trip file against the following defaults:

- At least 15,000 rows
- No more than 100 malformed rows
- No more than 1,000 duplicate rows
- The expected eight-column header

A file that fails a check is quarantined. A quarantine verdict is recorded as a data-quality decision; it does not, by itself, stop the build. The gate records the decision and the build continues with the files that were accepted, plus the explicitly released October file. Review the receipts even when the overall build succeeds.

The current build contains one explicit exception: trips_2026_10.csv is released from quarantine by release_quarantine.sh, with the reason recorded in the gate receipts. This reflects the documented decision to use the truncated October delivery while carrying its coverage limitations into the reporting process.

The older trips_2026_09.csv remains quarantined. The September resend is the accepted source for that period.

The preparation stage also repairs the Downtown station-name defect and removes structurally invalid rows. The loader then accounts for duplicate copies, previously loaded overlapping trips, unknown stations, and structural exclusions. A reconciliation failure stops the build.

These are deliberate pipeline policies. Do not bypass the gate, release additional files, or change thresholds without reviewing the resulting data-quality and coverage implications.


## Where the receipts and outputs live

All paths below are relative to `Final Project/`.

| File or directory | Contents |
|---|---|
| `out/build_summary.txt` | Final warehouse totals, accepted and quarantined file lists, and receipt locations |
| `out/gate_receipts.csv` | Intake gate decisions, reasons, and the explicit October release record |
| `out/prepare_receipts.csv` | Raw, repaired, structurally dropped, and staged row counts by accepted file |
| `out/system_reconciliation.csv` | Source-level accounting of raw, loaded, and excluded rows |
| `out/` | SQL reporting extracts, including `monthly_by_product.csv`, `daily_products.csv`, `weather_daily.csv`, `capacity_by_year.csv`, and `coverage.csv` |
| `out/ride_knox_wh.db` | Default SQLite warehouse database |
| `report/annual_report.qmd` | Editable Quarto report source |
| `report/annual_report.html` | Rendered annual report |
| `report/figs/` | Report figures, including the lead integration figure |
| `Final Project/docs/` | Local publication source and staged copies |
| Repository-level `docs/` | Files staged for GitHub Pages publication |

`expected_receipts/` contains reference receipt files; it is not the live output directory. The current run's receipts are written to `out/`.


## Publishing changes

The build stages the public site into the repository-level `docs/` directory. To publish a rebuilt site, review the generated files, then commit and push the updated repository-level `docs/` contents to the branch configured for GitHub Pages.


## Safe to re-run
Safe to re-run from the original, unchanged data/ directory: Since stage 0 removes the previous database, working directories, extracts, generated report copies, and repository-level docs/ publication output before rebuilding them, the build is safe to re-run.

If RIDE_KNOX_DB is set to a custom path, Stage 0 deletes the database file at that path as well. Do not point it at a database that must be preserved.


## Fails if

The build stops when a required command or stage returns a nonzero exit status. In practice, this includes:

- The configured DATA_DIR does not exist.
- A required input file or expected input pattern is missing. For example, the Stage 1 trip-file copy fails if no trips_*.csv files are present.
- A required program or dependency is unavailable, such as Python, a required Python package, sqlite3, Quarto, R, or a required R package.
- A pipeline script, SQL command, or Python loader fails.
- A per-file warehouse reconciliation check does not balance.
- Quarto fails to render the annual report or produces an empty report/annual_report.html.
- A required file for public-site staging is missing.


## Reflection + AI disclosure 

1.	Reflection: The handoff in my system that I believe is the most fragile is the one between Bash and Python where we load the warehouse from the files in the staged folder. It is the most fragile because any incorrect files that pass the previous checks in the build pipeline will affect all of the analyses, figures, and tables once they are loaded into the warehouse. Additionally, if the previous checks fail, a change in the file's structure (i.e., a column no longer contains the expected values), a missing reference file, or an unexpected column value could cause the loader to fail. If it fails, the downstream SQL extracts, R report, and GitHub Pages publication will also fail and may not happen at all. Real data teams spend much of their engineering effort validating inputs, standardizing formats, documenting assumptions, and reconciling outputs. Each tool working properly is not as important as having a pipeline with reliable handoffs between the tools.

2. AI disclosure: I used a generative AI tool to organize the structure of working through project, making the tables in R, connecting index.md to Pages, understanding what Python buys me over Bash and what other tools there are out there for the TOOL-DEFENSE.md, formatting and compilation for the README.md, and to get the x-axis tick labels to be staggered for the Part 2 two-year picture in annual_report.qmd. Because we havent visited some of these topics (since the Bash and R module projects were released), I needed help understanding some of the files. All architecture decisions, code, analysis, and conclusions are my own.
