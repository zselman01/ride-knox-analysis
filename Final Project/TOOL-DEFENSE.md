## Part A
- build_all.sh Part 2 Exception: 
    - Based on the two quarantined files, I have decided to release October's file only because of the data team's December decision, with coverage caveats handled downstream in the report. The original September file, however, remains in quarantine because its header mismatch is not covered by this exception.

- build_all.sh Part 7 Exception: 
    - The site/ directory is the publication destination intended for Pages. The pipeline copies the annual report (from report/annual_report.qmd) into site/. The landing page (site/index.md) is also in site/ and will link to the annual report.