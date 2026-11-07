# Starter Pack — Anchors You Can Check Yourself Against

Every number below was produced by executing the starter pack's components
end-to-end against the real course files. If your system uses the pack's
components unmodified with the exemplified policies (repair August; release
the October fragment with a coverage policy; warehouse philosophy: refuse
identity problems, store the implausible, judge in the view), you should be
able to reproduce these exactly. If your policies differ, your numbers will
differ — and must reconcile with YOUR written ledger instead.

| Anchor | Value |
|---|---|
| Gate verdicts on the seven trip files | accept ×5; quarantine `trips_2026_09.csv` (header-mismatch); quarantine `trips_2026_10.csv` (too-few-rows) |
| Warehouse trips (2025 + 2026) | **484,845** |
| ... of which 2025 | 249,737 (250,600 raw − 600 duplicate copies − 263 unknown-station S99) |
| ... of which 2026 | **235,108** — cross-check: exactly the row count of `rides_2026.csv` from the R module. Your pipeline just rebuilt the warehouse extract from raw deliveries. |
| Reportable trips (house view: recorded start; duration 1–1440 min when an end exists) | **481,770** |
| System raw rows across all sources (incl. the quarantined September file and the weather file) | 515,536 = 485,540 loaded + 29,996 excluded, all named |
| Weather | 698 rows → 695 loaded (3 duplicate dates) ; 6 precip sentinels stored as NULL |
| October fragment closure | 8,247 raw = 8,067 loaded + 1 structural (the severed row — `wc -l` cannot see it; `awk` can) + 39 duplicate copies + 140 September-overlap |
| June non-member YoY (reportable) | 2025: 13,816 → 2026: 15,461 = **+11.9%** (matches the Python-project answer key) |

The Integration Question's model results are deliberately **not** listed —
that analysis is yours. The `expected_receipts/` folder holds the full gate
receipts and reconciliation ledger from the verified run for line-by-line
comparison.

Known defensible variations and their totals: excluding August's 45 malformed
rows instead of repairing them → warehouse 484,800; refusing end≤start
timestamps at load (the SQL-project philosophy) instead of storing them →
smaller totals with more refusal categories. Both fine **with the cost named
and the ledger closing.**
