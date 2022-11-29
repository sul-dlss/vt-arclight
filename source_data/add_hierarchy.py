#!/usr/bin/env python3

import csv
import itertools
from datetime import date
import sys
import pathlib

COLLECTION_DRUID = "mt839rq8746"

def series_title(row):
    return row["dc:type"]


def subseries_title(row):
    return row["Subseries"]


def record_group_title(row):
    if row["dc:type"] == "Audio recordings of proceedings":
        return date.fromisoformat(row["dc:date"]).strftime("%B %-d, %Y")
    else:
        return row["dc:format"]

def convert_file(input_file):
    # read the csv input_file
    output_rows = []
    output_headers = []
    with input_file.open(encoding="utf-8") as infile:
        reader = csv.DictReader(infile)
        output_headers = reader.fieldnames
        input = [row for row in reader]

    input.sort(key=series_title)
    for series, series_items in itertools.groupby(input, series_title):
        series_items = list(series_items)
        output_rows.append({
            "Collection Druid": COLLECTION_DRUID,
            "dc:title (ASpace: column F)": series,
            "ref_id": series.replace(" ", ""),
            "hierarchy": 1,
            "level": "Series",
            "extent_type": "item(s)",
            "extent_number": len(series_items),
            "publish": 1,
        })
        series_items.sort(key=subseries_title)
        for subseries, subseries_items in itertools.groupby(series_items, subseries_title):

            subseries_items = list(subseries_items)
            output_rows.append({
                "Collection Druid": COLLECTION_DRUID,
                "dc:title (ASpace: column F)": subseries,
                "ref_id": subseries.replace(" ", ""),
                "hierarchy": 2,
                "level": "Sub-Series",
                "extent_type": "item(s)",
                "extent_number": len(subseries_items),
                "publish": 1,
            })

            subseries_items.sort(key=record_group_title)

            record_groups = {group: list(items) for group, items in itertools.groupby(
                subseries_items, record_group_title)}

            if len(record_groups.keys()) > 1:
                for record_group, record_group_items in record_groups.items():
                    output_rows.append({
                        "Collection Druid": COLLECTION_DRUID,
                        "dc:title (ASpace: column F)": record_group,
                        "ref_id": record_group.replace(" ", ""),
                        "hierarchy": 3,
                        "level": "Record Group",
                        "extent_type": "item(s)",
                        "extent_number": len(record_group_items),
                        "publish": 1,
                    })
                    for item in record_group_items:
                        item['hierarchy'] = 4
                        item['level'] = "Item"
                        output_rows.append(item)
            else:
                for item in subseries_items:
                    item['hierarchy'] = 3
                    item['level'] = "Item"
                    output_rows.append(item)

    output_headers += ['hierarchy', 'level']
    output_file = input_file.parent / (input_file.stem + "_hierarchy.csv")
    print(output_file)
    with output_file.open("w", encoding="utf-8") as outfile:
        writer = csv.DictWriter(outfile, fieldnames=output_headers)
        writer.writeheader()
        for row in output_rows:
            writer.writerow(row)
    
    # remove the input file
    input_file.unlink()


def main():
    # get path to the directory or a single file
    input_path = pathlib.Path(sys.argv[1])
    if input_path.is_dir():
        for input_file in input_path.glob("*.csv"):
            convert_file(input_file)
    else:
        convert_file(input_path)

if __name__ == "__main__":
    main()
