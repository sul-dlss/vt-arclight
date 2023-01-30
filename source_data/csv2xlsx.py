#!/usr/bin/env python3

"""Convert a directory of CSV files to XLSX files."""

import pathlib
import sys
import openpyxl
import csv

# get the path to the directory containing the CSV files
input_path = pathlib.Path(sys.argv[1])


def convert_file(file: pathlib.Path):
    """Convert a single CSV file to an XLSX file."""
    # read the CSV file into a list of rows
    with file.open("r", encoding="utf-8") as infile:
        reader = csv.reader(infile)
        data_rows = [row for row in reader]

    # create a new workbook and add a worksheet
    wb = openpyxl.Workbook()
    ws = wb.active

    # write the data to the sheet and save it
    for row in data_rows:
        ws.append(row)
    output_file = file.parent / (file.stem + ".xlsx")
    wb.save(output_file)
    print(output_file)


if input_path.is_dir():
    for csv_file in input_path.glob("*.csv"):
        convert_file(csv_file)
else:
    convert_file(input_path)
