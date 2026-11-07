# Final Project — Starter Pack (read this first)

This pack is a **known-good version of every upstream component** the Final
Project integrates — the intake gate, the staging repair, the warehouse
loader, the SQL reporting layer, a report skeleton, and a site skeleton —
each one executed and verified against the real course files. Use any part of
it, or none of it: **your own module-project artifacts and the pack's earn
equal credit.** The Git project's rule applies unchanged.

What the pack is **not**: the project. The orchestration (`build_all` is a
skeleton that exits 1 on purpose), the Integration Question analysis, the
tool-selection defense, the memo, and the site's story are absent by design —
they are the graded work.

**Read every file before you commit anything.** This hand-off, like every
hand-off this semester, contains things that must never enter version
control. Deciding what those are is part of the project. Nothing in this pack
is safe to `git add .` blindly.

## Contents

| Item | What it is |
| --- | --- |
| `pipeline/intake_gate.sh` | The Bash-project gate, promoted to guard the full history: header contract, row floor, malformed-row and duplicate checks, env-configurable thresholds, receipts, verdict-by-movement. Verified verdicts on all seven trip files. |
| `pipeline/release_quarantine.sh` | Policy-as-code: an explicit, receipted override for releasing a quarantined file (you will need a policy for October; this is one way to make it visible). |
| `pipeline/prepare_accepted.sh` | Staging repair (the August `sed`) + structural filter (`awk NF==8`) with receipts — including the row `wc -l` cannot see. |
| `pipeline/load_warehouse.py` | The only code that writes trips: stage → normalize in SQL → migrate with the PK doing identity work, `OR IGNORE`'s silences counted out loud, closure enforced per file, ledger written. |
| `sql/schema.sql` | The warehouse: stations, `dock_history` (the "number moved" answer), `products` lookup (Module 9's question, resolved), trips, audited weather. |
| `sql/views.sql` | `trips_reportable` — one definition of a countable trip — and `docks_by_year`. |
| `sql/extracts.sql` | The SQL→R handoff, literal: five CSVs into `out/` that the report reads and nothing else. |
| `report/annual_report_skeleton.qmd` | The report frame: extract reads, audit section, ledger table, join-safety proof — with the analysis marked TODO, because it is yours. |
| `build_all_skeleton.sh` | The shape of the one command; the wiring is the assignment. |
| `site/index_skeleton.md` | Front-page skeleton. |
| `ANCHORS.md` + `expected_receipts/` | Every verified number, and the full receipts from the verified run, so you can check yourself file by file. |
| `handover/` | Everything else that arrived in the data team's hand-off, as it arrived. |

## Numbers you can rely on

With the pack's components and policies: the warehouse holds **484,845
trips** (2025: 249,737; 2026: **235,108** — exactly `rides_2026.csv`, which
your pipeline has now rebuilt from raw deliveries); **481,770** reportable;
system-wide closure **515,536 raw = 485,540 loaded + 29,996 named
exclusions**. Full table in `ANCHORS.md`. The Integration Question's answer
is not in this pack — that's the point of the project.
