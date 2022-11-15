#!/usr/bin/env python3

import csv
import itertools
import collections
from datetime import date
import sys

filename = sys.argv[1]

input = []

output = collections.defaultdict(dict)
output_rows = []
output_headers = []

collection_druid = "mt839rq8746"

with open(filename) as infile:
    reader = csv.DictReader(infile)
    output_headers = reader.fieldnames
    input = [row for row in reader]


def series_title(row):
    return row["dc:type"]


def subseries_title(row):
    return row["Subseries"]


def file_title(row):
    if row["dc:type"] == "Audio recordings of proceedings":
        return date.fromisoformat(row["dc:date"]).strftime("%B %-d, %Y")
    else:
        return row["dc:format"]


input.sort(key=series_title)
for series, series_items in itertools.groupby(input, series_title):

    series_items = list(series_items)
    output_rows.append({
        "Collection Druid": collection_druid,
        "dc:title (ASpace: column F)": series,
        "ref_id": series.replace(" ", ""),
        "hierarchy": 1,
        "level": "Series",
        "extent_type": "item(s)",
        "extent_number": len(series_items)
    })
    series_items.sort(key=subseries_title)
    for subseries, subseries_items in itertools.groupby(series_items, subseries_title):

        subseries_items = list(subseries_items)
        output_rows.append({
            "Collection Druid": collection_druid,
            "dc:title (ASpace: column F)": subseries,
            "ref_id": subseries.replace(" ", ""),
            "hierarchy": 2,
            "level": "Sub-Series",
            "extent_type": "item(s)",
            "extent_number": len(subseries_items)
        })

        subseries_items.sort(key=file_title)

        files = {file: list(items) for file, items in itertools.groupby(
            subseries_items, file_title)}

        if len(files.keys()) > 1:
            # what is difference with doing or file, file_items in files?
            for file, file_items in files.items():
                output_rows.append({
                    "Collection Druid": collection_druid,
                    "dc:title (ASpace: column F)": file,
                    "ref_id": file.replace(" ", ""),
                    "hierarchy": 3,
                    "level": "File",
                    "extent_type": "item(s)",
                    "extent_number": len(file_items)
                })
                for item in file_items:
                    item['hierarchy'] = 4
                    item['level'] = "Item"
                    output_rows.append(item)

        else:
            for item in subseries_items:
                item['hierarchy'] = 3
                item['level'] = "Item"
                output_rows.append(item)

output_headers += ['hierarchy', 'level']
sys.stdout.reconfigure(encoding='utf-8')
writer = csv.DictWriter(sys.stdout, fieldnames=output_headers)
writer.writeheader()
for row in output_rows:
    writer.writerow(row)
