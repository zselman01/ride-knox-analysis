### DATA 501; Module 2 Project Worklog

**Name:** Zaharia Selman

**NetID:** zselman

**Log Commit Policy:** Committed on whatever branch is open



#### Part 0: Starting State

###### **Output**

*After git status*

* On branch master
* Your branch is up to date with 'origin/master'.
* 
* nothing to commit, working tree clean

\----------

# *After git log --oneline **(NOT COMPLETE!)***

* 0b766e4 (HEAD -> master, origin/master, origin/HEAD) Added PROJECT-LOG.md for Module 2 Project
* 591a6c5 Added 2026 data files to .gitignore for Module 2 Project
* 017c4da Updated WORKLOG.md
* 692d227 Added the period back in throw-away branch to diverge from master branch
* dd2eee2 Made a change in the throw-away branch (removed a period in a sentence) to complete Part 9:Challenge
* 50441a2 Commit from cloned branch merged with master branch
* 7cf5029 Updated WORKLOG.md
* f1f8ae4 Add recovery test performed
* a5c3a76 Conflict resolved and wording of limitations from master branch was chosen
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







#### Part A: The release plan, written as issues

###### **Issues can be found in GitHub (**https://github.com/zselman01/ride-knox-analysis.git**)**



Q-A1: One issue that has to be resolved in moving the 2026 files into the repository before committing the changes is to ensure that the files that should never be made public (API token file, raw data, etc.) do not get committed. This requires us to add these files to the .gitignore file before anything is staged or committed in order to avoid the hazard of having information leaked/released that should not be given out.







#### Part B: Integrate 2026 (through pull requests)

###### **Layout for two years**

* I have chosen to include each year in its own folder within the repository.
* Also, I note here that the 2026 report and files are already in the repository from the outset of this project. For this part, I will brought in the 2025 bundle from the Module 4 Assignment.

###### **Output**

*Output for keeping out what must stay out (git status --ignored):*

&#x09;2025\_bundle/analysis.ipynb

&#x09;2025\_bundle/charts/

&#x09;2025\_bundle/report.md





Q-B1: **The ride\_knox\_api\_token file in the 2026 hand-off must never be committed. We can make sure that this file doesn't get committed by running git status --ignored in Git terminal. The information in this file is like a password and detrimental to the company so would result in a data breach if it reached a public repo.**



Q-B2: **The repository reorganization changed the path that the data files and scratch folder depended on (the .gitignore file). I thought of this before making the folders for 2025 and 2026, but if I didn't the files would not have been ignored and would show up as needing to be staged and committed. Before staging or committing anything, I created a .gitignore file for both folders.**







#### Part C: Co-author the front page with Riley (two clones, one branch)

###### **Full Transcript of Commands and Outputs**

* ***git switch -c 2-add-shared-README \[me]***

&#x09;Switched to a new branch '2-add-shared-README'



* ***git push -u origin 2-add-shared-README \[me]***

&#x09;Total 0 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)

remote:

remote: Create a pull request for '2-add-shared-README' on GitHub by visiting:

remote:      https://github.com/zselman01/ride-knox-analysis/pull/new/2-add-shared-README

remote:

To https://github.com/zselman01/ride-knox-analysis.git

&#x20;\* \[new branch]      2-add-shared-README -> 2-add-shared-README

branch '2-add-shared-README' set up to track 'origin/2-add-shared-README'.



* ***git add PROJECT-LOG.md README.md \[me]***



* ***git commit -m "Rewrite README.md as the two-year story" \[me]***

\[2-add-shared-README 9143a28] Rewrite README.md as the two-year story

&#x20;2 files changed, 81 insertions(+), 5 deletions(-)

&#x20;create mode 100644 README.md



* ***git push -u origin 2-add-shared-README \[me]***

Enumerating objects: 6, done.

Counting objects: 100% (6/6), done.

Delta compression using up to 8 threads

Compressing objects: 100% (4/4), done.

Writing objects: 100% (4/4), 2.30 KiB | 2.30 MiB/s, done.

Total 4 (delta 1), reused 0 (delta 0), pack-reused 0 (from 0)

remote: Resolving deltas: 100% (1/1), completed with 1 local object.

To https://github.com/zselman01/ride-knox-analysis.git

&#x20;  f6083c9..9143a28  2-add-shared-README -> 2-add-shared-README

branch '2-add-shared-README' set up to track 'origin/2-add-shared-README'.



* ***git clone C:\\Users\\selma\\ride-knox-analysis C:\\Users\\selma\\ride-knox-riley \[me]***

Cloning into 'C:\\Users\\selma\\ride-knox-riley'...

done.



* ***git add README.md \[Riley]***



* ***git commit -m "Added Riley's updates to README.md including edits to headline and added limitations section" \[Riley]***

\[2-add-shared-README 4e076ab] Added Riley's updates to README.md including edits to headline and added limitations section

1 file changed, 13 insertions(+), 3 deletions(-)



* ***git add README.md \[me]***



* ***git commit -m "Added my updates to headline" \[me]***

\[2-add-shared-README f085a5f] Added my updates to headline

&#x20;1 file changed, 3 insertions(+), 5 deletions(-)



* ***git push -u origin 2-add-shared-README \[me]***

Enumerating objects: 5, done.

Counting objects: 100% (5/5), done.

Delta compression using up to 8 threads

Compressing objects: 100% (3/3), done.

Writing objects: 100% (3/3), 357 bytes | 357.00 KiB/s, done.

Total 3 (delta 2), reused 0 (delta 0), pack-reused 0 (from 0)

remote: Resolving deltas: 100% (2/2), completed with 2 local objects.

To https://github.com/zselman01/ride-knox-analysis.git

&#x20;  4581d9f..f085a5f  2-add-shared-README -> 2-add-shared-README

branch '2-add-shared-README' set up to track 'origin/2-add-shared-README'.

To https://github.com/zselman01/ride-knox-analysis.git

&#x20;  4581d9f..f085a5f  2-add-shared-README -> 2-add-shared-README

branch '2-add-shared-README' set up to track 'origin/2-add-shared-README'.



* ***git push -u origin 2-add-shared-README \[Riley]***

To https://github.com/zselman01/ride-knox-analysis.git

&#x20;! \[rejected]        2-add-shared-README -> 2-add-shared-README (fetch first)

error: failed to push some refs to 'https://github.com/zselman01/ride-knox-analysis.git'

hint: Updates were rejected because the remote contains work that you do not

hint: have locally. This is usually caused by another repository pushing to

hint: the same ref. If you want to integrate the remote changes, use

hint: 'git pull' before pushing again.

hint: See the 'Note about fast-forwards' in 'git push --help' for details.



* ***git pull \[Riley]***

Auto-merging README.md

CONFLICT (content): Merge conflict in README.md

Automatic merge failed; fix conflicts and then commit the result.



**CONFLICT MARKERS**

* <<<<<<< HEAD
* \# \*The Day Pass Brought the Casual Riders Back and Campus Pressure was Relieved.\*
* =======
* \# \*2026 Update: The Day Pass Brought the Casual Riders Back; Kept Member Riders unaffected\*
* >>>>>>> f085a5f632b4619272dcc3b6e652f9f05fa7ddc0









### Limitations

\- Our data for a few variables is only over a short period of time. There are stations that have been excluded because they were missing both end station IDs and end times. We should collect information from our rider that could be influencing their riding (e.g., reasons for riding, etc.). The one minute cutoff rule implemented in the analysis causes us to lose data points that may otherwise influence our analysis. We excluded trips longer than 24 hours (bikes likely never docked properly).









**RESOLUTIONS**

* Updated Headliner sentence --> 2026 Update: The Day Pass Brought the Casual Riders Back, Campus Pressure was Relieved, and Member Riders Were Unaffected.
* Kept full Limitations section (see above).



* ***git add README.md \[Riley]***



* ***git commit -m "Resolved bug with me and Riley's edits to the two-year README.md" \[Riley]***

\[2-add-shared-README 3a04546] Resolved bug with me and Riley's edits to the two-year README.md



* ***git push -u origin 2-add-shared-README \[Riley]***





Q-C1: **In Assignment 5, Part 8, my push from the clone succeeded on the first try. Riley's didn't. The difference between the state of the remote in Assignment 5 vs this project is that we were pushing from the same branch which caused the push conflict.**



Q-C2: **I obeyed "main is sacred" perfectly, and still hit a conflict. However, the conflict lives on a separate branch in the workflow and main/master is not touched. If the experiment on a separate branch succeeds, we merge it back; if it fails, we delete it. Keeping experiments separate from main and checking them often are workflow habits from class that keep the conflicts small.** 



Q-C3: **In Riley's conflict, HEAD marks Riley's changes (branch we're on) that need to be merged with my changes (incoming changes on same branch). Git automatically marks these conflicts starting with HEAD, so neither author has to try to find where the conflict is.**







#### Part D: Publish the two-year story

###### **Subsection goes here**







Q-D1:

