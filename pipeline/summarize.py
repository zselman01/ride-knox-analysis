import sys
import pandas as pd

file = sys.argv[1]

df = pd.read_csv(file)

if df.empty:
    print("Error: The CSV provided has no rows.")
    sys.exit(1)

total_trips = df['total_departures'].sum()

station_pressure = df[['start_station_id', 'trips_per_dock']]
station_count = df['start_station_id'].value_counts()

high_stations = station_pressure.sort_values(['trips_per_dock','start_station_id'], ascending=[False, True]).head(3)
low_stations = station_pressure.sort_values(['trips_per_dock', 'start_station_id'], ascending=[True, True]).head(3)

print(f"Total Stations Read: {len(station_count)}")
print(f"\nTotal Trips Read: {total_trips}")

# print(station_pressure)

print("\n--- 3 Most Pressured Stations ---")
for station, count in high_stations.values:
    print(f"Station: {station} | Pressure: {count}")

print("\n--- 3 Least Pressured Stations ---")
for station, count in low_stations.values:
    print(f"Station: {station} | Pressure: {count}")