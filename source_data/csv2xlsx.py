"""Convert a directory of CSV files to XLSX files."""

import pathlib
import sys
import pandas as pd

# get the path to the directory containing the CSV files
input_path = pathlib.Path(sys.argv[1])


def convert_file(file: pathlib.Path):
    """Convert a single CSV file to an XLSX file."""
    # read the CSV file into a pandas DataFrame
    df = pd.read_csv(file, dtype="str")

    # create an XLSX file from the DataFrame
    xlsx_file = file.with_suffix(".xlsx")
    df.to_excel(xlsx_file, index=False)
    print(xlsx_file)


if input_path.is_dir():
    for csv_file in input_path.glob("*.csv"):
        convert_file(csv_file)
else:
    convert_file(input_path)
