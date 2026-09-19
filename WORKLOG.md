\# DATA 501; Assignment 5 Worklog

\*\*Name: Zaharia Selman\*\*

\*\*NetID: zselman\*\*



\## Part 0

\*\*Output\*\*

* git version 2.55.0.windows.5

\----------

* zselman

\----------

* zselman01@gmail.com (Personal email address)



\*\*Q0: Git needs your name and email before your first commit to ensure there is an author that goes along with every saved version/change (also with a timestamp and message explaining why the commit is happening).\*\* 





\## Part 1

\*\*Output\*\*

* On branch master
* 
* No commits yet
* 
* Untracked files:
* &#x20; (use "git add <file>..." to include in what will be committed)
* &#x20;       WORKLOG.md
* &#x20;       analysis.ipynb
* &#x20;       charts/
* &#x20;       report.md
* 
* nothing added to commit but untracked files present (use "git add" to track)

\----------

* On branch master
* nothing to commit, working tree clean



\*\*Q1: One concrete future situation where splitting tasks between commits often pays off is when we want to make changes to different files. If all the files are committed at the same time then all files will be affected even if we only need to make a minor change to one file.\*\*





\## Part 2

\*\*Output\*\*

* On branch master
* Untracked files:
* &#x20; (use "git add <file>..." to include in what will be committed)
* &#x20;       scratch/
* &#x20;       stations.xlsx
* &#x20;       trips\_2025.csv
* 
* nothing added to commit but untracked files present (use "git add" to track)

\----------

* On branch master
* Untracked files:
* &#x20; (use "git add <file>..." to include in what will be committed)
* &#x20;       .gitignore
* 
* nothing added to commit but untracked files present (use "git add" to track)



\*\*Q2: From class we learned that code, text, and small outputs are committed, but not raw data, secrets, or machine-generated clutter. The charts are a valuable output from our analysis so should be committed but not our large data files that we used to produce the charts.\*\*





\## Part 3

\*\*Output\*\*

* &#x20;\\## Limitations
* &#x20;
* \-\\- Our data for a few variables is only over a short period of time. There are stations that have been excluded because they were missing both end station IDs and end times. We should collect information from our rider that could be influencing their riding (e.g., reasons for riding, etc.). 



* +\\- Our data for a few variables is only over a short period of time. There are stations that have been excluded because they were missing both end station IDs and end times. We should collect information from our rider that could be influencing their riding (e.g., reasons for riding, etc.).
* \+
* +\* The one minute cutoff rule implemented in the analysis causes us to lose data points that may otherwise influence our analysis.



\*\*Q3: Git diff would have shown no changes to the report.md file if I had run it after committing instead of before.\*\*





\## Part 4

\*\*Output\*\*

* Command used: git restore report.md
* Output: On branch master nothing to commit, working tree clean

\----------

* On branch master
* Changes to be committed:
* &#x20; (use "git restore --staged <file>..." to unstage)
* &#x20;       new file:   WORKLOG.md

\----------

* f0a6ee5 (HEAD -> master) Revert "Added exaggerated claim (on purpose for Part 4)"
* 2a71a5a Added exaggerated claim (on purpose for Part 4)
* e3bf2ab Added updated and correct WORKLOG.md file
* 9686273 Removed extra WORKLOG.md file
* c1caefd Add rewording of a limitation in report.md file
* 0ae202d Add gitignore file that excludes the raw data files from the analysis, Jupyter's autosave files, and scratch/throwaway experiments
* 05315aa Add worklog of current backing up process
* 4590767 Add analysis and charts to support answers to ridership questions
* 37a3231 Add manager's report answering ridership questions



\*\*Q4: 4c left two extra commits in my history instead of making the bad one vanish so that it is still recorded as an action that was done to the repository. History in Git is append only by default and everything that happens is a part of the full data timeline (not just the good things added).\*\*





\## Part 5

\*\*Output\*\*

* &#x20; master
* \* min-cutoff-2min

\----------

* Even though in one branch we changed the code and the report.md file, I observed both files (the code is also open in VS Code), go back to the original version when I switched back to the master branch. Very cool!

\----------

* Updating f0a6ee5..623826e
* Fast-forward
* &#x20;analysis.ipynb | 6 +++---
* &#x20;report.md      | 4 ++++
* &#x20;2 files changed, 7 insertions(+), 3 deletions(-)

\----------

* \* master



\*\*Q5a: One commit is the right call here because we are making these edits together. They "depend" on each other.\*\*



\*\*Q5b: Main/Master can fast forward because it hasn't moved since I branched off to min-cutoff-2min. The merge just slides the branch into the main seamlessly.\*\*





\## Part 6

\*\*Output\*\*

* Auto-merging report.md
* CONFLICT (content): Merge conflict in report.md
* Automatic merge failed; fix conflicts and then commit the result.

\----------

* <<<<<<< HEAD
* \* We excluded trips longer than 24 hours (bikes likely never docked properly).
* =======
* \* Trips over 24 hours were excluded as never-docked outliers.
* >>>>>>> reword-limitations

\----------

* a5c3a76 (HEAD -> master) Conflict resolved and wording of limitations from master branch was chosen
* a38c0fb Add rewording again for limitation about the maximum duration cutoff
* 738a546 (reword-limitations) Add rewording for limitation about the maximum duration cutoff
* 623826e Added analysis code and report file updated to reflect a new minimum duration cutoff for trips
* f0a6ee5 Revert "Added exaggerated claim (on purpose for Part 4)"
* 2a71a5a Added exaggerated claim (on purpose for Part 4)
* e3bf2ab Added updated and correct WORKLOG.md file
* 9686273 Removed extra WORKLOG.md file
* c1caefd Add rewording of a limitation in report.md file
* 0ae202d Add gitignore file that excludes the raw data files from the analysis, Jupyter's autosave files, and scratch/throwaway experiments
* 05315aa Add worklog of current backing up process
* 4590767 Add analysis and charts to support answers to ridership questions
* 37a3231 Add manager's report answering ridership questions



\*\*Q6a: The wording that we added to the master/main branch is the one in the HEAD section because we were in the master branch when we merged the reword-limitations branch to the master.\*\*



\*\*Q6b: A merge conflict is not Git failing; it is Git ensuring that all tracked changes are purposeful and recognized.\*\*



\## Part 7

\*\*Output\*\*

* git remote add origin https://github.com/zselman01/ride-knox-analysis.git
* git push -u origin master

\----------

* info: please complete authentication in your browser...
* Enumerating objects: 43, done.
* Counting objects: 100% (43/43), done.
* Delta compression using up to 8 threads
* Compressing objects: 100% (42/42), done.
* Writing objects: 100% (43/43), 873.63 KiB | 10.28 MiB/s, done.
* Total 43 (delta 17), reused 0 (delta 0), pack-reused 0 (from 0)
* remote: Resolving deltas: 100% (17/17), done.
* To https://github.com/zselman01/ride-knox-analysis.git
* &#x20;\* \[new branch]      master -> master
* branch 'master' set up to track 'origin/master'.

\----------

* All commits appear in the online browser commit history
* Report.md and charts/ are visible in the browser
* trips\_2025.csv and scratch/ are not in the browser



\*\*Q7: Origin means this will be GitHub's (vs Git's) copy and -u sets up the connection between our local machine's master and the online GitHub's master so future pushes are just done with git push.\*\*





\## Part 8

\*\*Output\*\*

* a5c3a76 (HEAD -> master, origin/master, origin/HEAD) Conflict resolved and wording of limitations from master branch was chosen
* a38c0fb Add rewording again for limitation about the maximum duration cutoff
* 738a546 Add rewording for limitation about the maximum duration cutoff
* 623826e Added analysis code and report file updated to reflect a new minimum duration cutoff for trips
* f0a6ee5 Revert "Added exaggerated claim (on purpose for Part 4)"
* 2a71a5a Added exaggerated claim (on purpose for Part 4)
* e3bf2ab Added updated and correct WORKLOG.md file
* 9686273 Removed extra WORKLOG.md file
* c1caefd Add rewording of a limitation in report.md file
* 0ae202d Add gitignore file that excludes the raw data files from the analysis, Jupyter's autosave files, and scratch/throwaway experiments
* 05315aa Add worklog of current backing up process
* 4590767 Add analysis and charts to support answers to ridership questions
* 37a3231 Add manager's report answering ridership questions

\----------

* 



\*\*Q:\*\*





\## Part 9

\*\*Output\*\*

* 



\*\*Q:\*\*



