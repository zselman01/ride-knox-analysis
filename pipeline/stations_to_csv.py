import pandas as pd

# Load the Excel file
excel_file = "stations.xlsx"
df = pd.read_excel(excel_file)  # sheet_name=0 loads the first sheet

# Save it as a CSV file
df.to_csv("./out_assignment11/stations.csv", index=False)  # index=False prevents writing row numbers

print(f"Successfully converted stations.xlsx to stations.csv")
