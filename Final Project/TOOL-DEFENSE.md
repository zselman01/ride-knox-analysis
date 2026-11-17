## Part A - The architecture and the one command
### Justification for each tool in the system
- Stage 1:
    - Bash was used here to keep all files separate. Bash is responsible for where files go. Here, instead of manipulating and cleaning the raw files (major rule learned from class - raw files never get modified), copies were created to have a copy to compare the changes with. The gate has to determine if the delivered files belong in the system at all.
    - Bash ("worse") was used here instead of Python ("better", e.g., pandas) to keep data analysis separate from data loading. This is an example where I chose a "worse" tool because Python would have added unnecessary dependencies for the simple task of moving files. However, using Python would have bought more sophisticated file validation and error handling.

- Stage 2:
    - Bash was also used here to because it is responsible for where files go. This stage moves all files out of the incoming/ folder and into either the accepted/ or quarantine/ folders. The gate has to determine if the delivered files are acceptable based on predetermined rules or not. Bash was used here to save storage by counting rows in a 22 MB file versus hundreds of MB for one integer.
    - Part 2 Exception: 
        - Based on the two quarantined files, I have decided to release October's file only because of the data team's December decision, with coverage caveats handled downstream in the report. The original September file, however, remains in quarantine because its header mismatch is not covered by this exception.

- Stage 3:
    - Bash was used here for similar reasons to Stages 1 and 2 to move files from accepted/ to staging/.

- Stage 4:
    - Python was used here to manipulate the actual files (rows of data) that make it to the staging/ folder. Bash (build_all.sh) was then used to chain these scripts. The gate has to determine what, if any, rows survive the cleaning process and under what name if not (e.g., removed from dataset, flagged for further investigation, etc.).
    - Python was used here instead of SQL's .import because SQL is fast, silent, and doesn't provide a ledger which are all important for reading and naming every exclusion explicitly thrown while loading the data into the warehouse.

- Stage 5:
    - SQL was used here to setup the schema of various tables where the data will be housed, define what counts as a valid trip, and extract various queries that will be used to answer the board's questions (into out/).
    - SQL was used instead of functions from Python to prevent users from having to rerun any code, import anything before viewing the analysis, or having incorrect values (wrong dock history from being constant instead of changing with the dock expansions).

- Stage 6:
    - Quarto (via R) was used here to present the data in an easy to understand way. It answers questions like how big was the decline in ridership after the price increase, how uncertain are we about these estimates, and what does it bundle (i.e., what counts as a non-member)?
    - R was used here instead of Python (i.e., matplotlib) because we want the visualizations to update as the data in incoming/ changes. This way we can also ensure that the data and the visualizations match by using inline R code as well. 

- Stage 7: 
    - Git was used here to make the data public and accessible in an HTML format. It defines what is true, who approved it, and what is public. Git was used here instead of Google or OneDrive to track changes (history) with comments and pull request descriptions.
    - Part 7 Exception: 
        - The site/ directory is the publication destination intended for Pages. The pipeline copies the annual report (from report/annual_report.qmd) into site/. The landing page (site/index.md) is also in site/ and will link to the annual report.

- Stage 8:
    - Here, a combination of Bash and SQL was used to extract data straight from the queried tables to summarize key points from the build.

**Honest Account Of What A Handoff Cost You**

My Bash-to-Python handoff is a good example.
- Cost: Data moves between directories and changes processing environments. Bash manages file delivery and changing locations, while Python reads and processes those files.
- Risk: A file could be copied successfully but still contain malformed records or unexpected data.
- Containment: My intake gate in Stage 2 validates files before acceptance, and the loader performs additional structural and database checks.


**What I Would Change With A Sixth Tool**

I have had only beginners experience with it, but I would use (or switch R out) with Tableau/Power BI as a sixth tool. Tableau can be used to build interactive dashboards. The course's kit can't do this, but I believe it would be useful for Ride Knox management and stakeholders. It would provide an easier to understand and interpret way of viewing the data without knowing technical or coding languages. Using the dashboard functionality, I could also add more information in one-place but also in a more digestible format.



## Part E - Publish: the site and the rendered report 
- The rendered report (self-contained HTML, figures embedded or alongside) is committed and served by your live Pages site as the one deliberate exception to the no-generated-files rule, because it is being published on the live Pages site. The results and figures will not fully be viewable by users (like auditors) unless this report is committed. This decision costs potentially revealing source code, but it has been contained by build_all.sh (making the report reproducible only through the build which has measures in place to keep secret information from getting exposed).