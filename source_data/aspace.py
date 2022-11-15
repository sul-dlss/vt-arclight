#!/usr/bin/env python3

import csv
import sys
import pandas as pd
from datetime import date

template_file = sys.argv[1] if len(
    sys.argv) >= 2 else 'bulk_import_template.csv'
data_file = sys.argv[2] if len(sys.argv) >= 3 else 'items_with_hierarchy.csv'

data_rows = []

key_map = {
    "ead": "Collection Druid",
    "title": "dc:title (ASpace: column F)",
    "unit_id": "dc:identifier (column G)",
    "ref_id": "ref_id",
    "hierarchy": "hierarchy",
    "level": "level",
    "begin_2": "dc:date2",
    "begin_3": "dc:date3",
    "begin_4": "dc:date4",
    "end": "dcterms:temporal 2",
    "number": "extent_number",
    "extent_type": "extent_type",
    "container_summary": "dcterms:extent",
    "physical_details": "dc:format",
    "type_1": "type_1",
    "indicator_1": "Box number",
    "digital_object_link": "digital_object_link",
    "subject_1_record_id": "subject_1_record_id",
    "subject_1_term": "subject_1_term",
    "subject_1_type": "subject_1_type",
    "subject_1_source": "subject_1_source",
    "subject_2_record_id": "subject_2_record_id",
    "subject_2_term": "subject_2_term",
    "subject_2_type": "subject_2_type",
    "subject_2_source": "subject_2_source",
    "subject_3_record_id": "subject_3_record_id",
    "subject_3_term": "subject_3_term",
    "subject_3_type": "subject_3_type",
    "subject_3_source": "subject_3_source",
    "subject_4_record_id": "subject_4_record_id",
    "subject_4_term": "subject_4_term",
    "subject_4_type": "subject_4_type",
    "subject_4_source": "subject_4_source",
    "subject_5_record_id": "subject_5_record_id",
    "subject_5_term": "subject_5_term",
    "subject_5_type": "subject_5_type",
    "subject_5_source": "subject_5_source",
    "subject_6_record_id": "subject_6_record_id",
    "subject_6_term": "subject_6_term",
    "subject_6_type": "subject_6_type",
    "subject_6_source": "subject_6_source",
    "n_arrangement": "dc:description4",
    "n_odd": "dc:description3",
    "n_scopecontent": "dc:alternative (column",
}

edm_type_map = {
    "Sound": "audio",
    "Moving Image": "moving_images",
    "Text": "text",
    "Image": "graphic_materials",
}

with open(template_file) as infile:
    reader = csv.DictReader(infile)
    output_headers = reader.fieldnames

with open(data_file) as infile:
    reader = csv.DictReader(infile)
    for row in reader:
        row["begin"] = row.get("dcterms:temporal 1", row["dc:date"])
        row["publish"] = "True"
        row["digital_object_link_publish"] = "True"
        row["p_arrangement"] = "True"
        row["p_odd"] = "True"
        row["p_scopecontent"] = "True"

        if row["edm:type"] in edm_type_map:
            row["cont_instance_type"] = edm_type_map[row["edm:type"]]

        # Do the mapping of fields to ASpace keys
        for aspace_key, aspace_val in key_map.items():
            row[aspace_key] = row[aspace_val]

        data_rows.append(row)


with open('aspace.csv', mode='w', encoding='utf8') as outfile:
    writer = csv.DictWriter(
        outfile, fieldnames=output_headers, extrasaction='ignore')
    writer.writeheader()
    # ASpace requires this blank row
    writer.writerow({})
    for row in data_rows:
        writer.writerow(row)

# ASpace only accepts .xlsx in the uploader; generate that format
df = pd.read_csv('aspace.csv', dtype="str")
df.to_excel('aspace.xlsx', index=False)
