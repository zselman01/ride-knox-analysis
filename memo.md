**TO:** Director of Operations

**FROM:** Zaharia Selman, Ride Knox Data Scientist

**DATE:** September 21, 2026

**SUBJECT:** Ride Knox Goes Upstream for Good

---

## Bottom Line

*After investigating the one-year anniversary of the price increase, the Day Pass does seem to have brought casual riders back and the dock expansion and new station fix the campus crunch.*


## Evidence

- The Anniversary Verdict:

Trips taken by casual riders decreased steeply by 30.03% from July 2025 (made up 33.8% of total trips (26,552) in July) vs July 2026 (made up 23.65% of total trips (31,733) in July).

The decline in trips taken by member riders was less steep (7.21%) from July 2025 (made up 66.2% of total trips (26,552)) vs July 2026 (made up 61.43% of total trips (31,733)).

The average duration (in minutes) for casual (M=22.9 min) and member (M=13.5 min) stayed consistent between July 2025 and July 2026.

However, we cannot make any comparative analyses for the day pass rider when just comparing July 2025 and July 2026 (Day Pass didn't start until March 2026), so the following analyses compare the rider types from March - July across both years. In comparing March - July 2025 vs March - July 2026, we can still show how it's addition successfully offsets the trips that may have been lost after the price increase in July 2025 (see Figure 1 in project.ipynb). From March to July 2026, day pass riders increase by 170.47% (5.52% (19,587 total trips) in March 2026 to 14.93% (31,733 total trips) in July 2026). Additionally, adding Casual and Day Pass riders together (as non-members; 38.58%) in 2026 exceeds the percentage of Casual riders alone, showing the success of the Day Pass rider option offered in 2026 (see Figure 1 in project.ipynb).

- The Capacity Verdict:

Increasing the dock count at two (S06 and S08) out of the five stations leadership acted on, worked well for the pressure question. Pressure (trips/dock) decreased by 31% (2,746 vs 2,528 total trips) at S06 and pressure decreased by 29.3% (2,546 vs 2,408 total trips). The low pressure sites had little growth, but S23 increased more than S24. Lastly, S25 shows the highest increase in pressure (increase by 132.75%), but this is because that station did not exist in 2025 (so had 0 trips and 0 docks to compare with; see Figure 2 in project.ipynb).


## Interpretation

- Our data provides evidence that the Day Pass helped recover lost Casual riders and seem to be a distinct/valuable rider group in comparison to the other rider types. The efforts to decrease on-campus pressure were met by the addition of more docks and the new station is increasing consistently.


## Limitations

- Our data for a few variables is only over a short period of time. There are stations that have been excluded because they were missing both end station IDs and end times. We should collect information from our rider that could be influencing their riding (e.g., reasons for riding, etc.). We have an operational issue (trips longer than 24 hours, trips with no end station id, etc.) that still need to be addressed or confirmed if these trips need to be removed from the analysis. No analyses were completed on the *cargo* bike type as there is a lack of data and no information about this bike type from leadership.


## Recommendation/Next Steps

- Continue to monitor the impact of the Day Pass on riders for longer, especially with the new advantage of the vendor. Continue watching for sites that may need dock expansions in areas outside of campus because of the success at the current stations.