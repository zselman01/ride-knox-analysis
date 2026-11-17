## Part A - The architecture and the one command 
- build_all.sh Part 2 Exception: 
    - Based on the two quarantined files, I have decided to release October's file only because of the data team's December decision, with coverage caveats handled downstream in the report. The original September file, however, remains in quarantine because its header mismatch is not covered by this exception.

- build_all.sh Part 7 Exception: 
    - The site/ directory is the publication destination intended for Pages. The pipeline copies the annual report (from report/annual_report.qmd) into site/. The landing page (site/index.md) is also in site/ and will link to the annual report.

## Part E - Publish: the site and the rendered report 
- The rendered report (self-contained HTML, figures embedded or alongside) is committed and served by your live Pages site as the one deliberate exception to the no-generated-files rule, because it is being published on the live Pages site. The results and figures will not fully be viewable by users (like auditors) unless this report is committed. This decision costs potentially revealing source code, but it has been contained by build_all.sh (making the report reproducible only through the build which has measures in place to keep secret information from getting exposed).