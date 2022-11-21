import csv
import itertools
import pathlib

# load the csv file containing all the items
with open("items_only.csv", encoding="utf-8") as items_file:
    reader = csv.DictReader(items_file)
    output_headers = reader.fieldnames
    items = [row for row in reader]

# create output directory if it doesn't exist
outpath = pathlib.Path("series")
if not outpath.exists():
    outpath.mkdir()

# group the items by the value of the "dc:type" column (series)
# write out one csv file for each series
for series, series_items in itertools.groupby(items, lambda row: row["dc:type"]):
    series_items = list(series_items)
    file = outpath / f"{series}.csv"
    print(file)
    with file.open("w", encoding="utf-8") as series_file:
        writer = csv.DictWriter(series_file, fieldnames=output_headers)
        writer.writeheader()
        writer.writerows(series_items)
