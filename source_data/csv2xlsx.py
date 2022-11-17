"""Convert a directory of CSV files to XLSX files."""

import pathlib
import sys
import pandas as pd

# get the path to the directory containing the CSV files
input_dir = sys.argv[1]

for csv_file in pathlib.Path(input_dir).glob("*.csv"):
    # read the CSV file into a pandas DataFrame
    df = pd.read_csv(csv_file, dtype="str")

    # create an XLSX file from the DataFrame
    xlsx_file = csv_file.with_suffix(".xlsx")
    df.to_excel(xlsx_file, index=False)
    print(xlsx_file)
