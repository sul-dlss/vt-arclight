#!/usr/bin/env python3

import csv
import sys
import pathlib

KEY_MAP = {
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

INSTANCE_TYPE_MAP = {
    "Sound": "audio",
    "Moving Image": "moving_images",
    "Text": "text",
    "Image": "graphic_materials",
}


def convert_file(data_file, template_file):
    data_rows = []

    with open(template_file) as infile:
        reader = csv.DictReader(infile)
        output_headers = reader.fieldnames

    with open(data_file) as infile:
        reader = csv.DictReader(infile)
        for row in reader:
            new_row = {}

            # Do the mapping of fields to ASpace keys
            for aspace_key, aspace_val in KEY_MAP.items():
                new_row[aspace_key] = row[aspace_val]

            new_row["begin"] = row.get("dcterms:temporal 1", row["dc:date"])
            new_row["publish"] = "1"
            new_row["portion"] = "whole"
            new_row["p_odd"] = "1"
            new_row["p_arrangement"] = "1"
            new_row["p_scopecontent"] = "1"

            if row.get("digital_object_link"):
                new_row["digital_object_link_publish"] = "1"

            if row["level"] == "Item":
                new_row["cont_instance_type"] = INSTANCE_TYPE_MAP.get(row["edm:type"])
                new_row["type_1"] = "disc" if new_row["cont_instance_type"] == "audio" else "box"
                new_row["indicator_1"] = row["Box number"]

            data_rows.append(new_row)

    output_file = data_file.parent / (data_file.stem + "_aspace.csv")
    print(output_file)
    with output_file.open("w", encoding="utf-8") as outfile:
        writer = csv.DictWriter(
            outfile, fieldnames=output_headers, extrasaction='ignore')
        writer.writeheader()
        # ASpace requires this blank row
        writer.writerow({})
        for row in data_rows:
            writer.writerow(row)

    # remove the input file
    data_file.unlink()


def main():
    template_file = sys.argv[2] if len(
        sys.argv) >= 3 else 'bulk_import_template.csv'
    # get path to the directory or a single file
    input_path = pathlib.Path(sys.argv[1])
    if input_path.is_dir():
        for input_file in input_path.glob("*.csv"):
            convert_file(input_file, pathlib.Path(template_file))
    else:
        convert_file(input_path, pathlib.Path(template_file))


if __name__ == "__main__":
    main()
