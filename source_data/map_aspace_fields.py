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
    "begin": "begin",
    "end": "end",
    "begin_2": "begin_2",
    "begin_3": "begin_3",
    "begin_4": "begin_4",
    "date_type": "date_type",
    "date_type_2": "date_type_2",
    "date_type_3": "date_type_3",
    "date_type_4": "date_type_4",
    "dates_label": "dates_label",
    "dates_label_2": "dates_label_2",
    "dates_label_3": "dates_label_3",
    "dates_label_4": "dates_label_4",
    "date_certainty": "date_certainty",
    "date_certainty_2": "date_certainty_2",
    "date_certainty_3": "date_certainty_3",
    "date_certainty_4": "date_certainty_4",
    "expression": "expression",
    "number": "extent_number",
    "extent_type": "extent_type",
    "container_summary": "dcterms:extent",
    "physical_details": "dc:format",
    "indicator_1": "indicator_1",
    "type_1": "type_1",
    "cont_instance_type": "cont_instance_type",
    "digital_object_link": "digital_object_link",
    "digital_object_link_publish": "digital_object_link_publish",
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
    "extent_portion": "extent_portion",
    "publish": "publish",
    "p_arrangement": "p_arrangement",
    "p_odd": "p_odd",
    "p_scopecontent": "p_scopecontent",
}

INSTANCE_TYPE_MAP = {
    "Sound": "audio",
    "Moving Image": "moving_images",
    "Text": "text",
    "Image": "graphic_materials",
}


def convert_file(data_file, template_file):
    data_rows = []

    with template_file.open() as infile:
        reader = csv.reader(infile)
        output_headers = [row for row in reader]
        output_columns = output_headers[3]

    with data_file.open() as infile:
        reader = csv.DictReader(infile)
        for row in reader:
            new_row = {}

            # Do the mapping of fields to ASpace keys
            for aspace_key, aspace_val in KEY_MAP.items():
                new_row[aspace_key] = row[aspace_val]

            # reorder output according to uploader template and save
            output_row = [new_row.get(field_code, None)
                          for field_code in output_columns]
            data_rows.append(output_row)

    output_file = data_file.parent / (data_file.stem + "_aspace.csv")
    with output_file.open("w", encoding="utf-8") as outfile:
        writer = csv.writer(outfile)
        # write the ASpace uploader template headers first
        for row in output_headers:
            writer.writerow(row)
        for row in data_rows:
            writer.writerow(row)

    print(output_file)
    # remove the input file
    data_file.unlink()


def main():
    template_file = pathlib.Path(sys.argv[2]) if len(
        sys.argv) >= 3 else pathlib.Path('bulk_import_template.csv')
    # get path to the directory or a single file
    input_path = pathlib.Path(sys.argv[1])
    if input_path.is_dir():
        for input_file in input_path.glob("*.csv"):
            convert_file(input_file, pathlib.Path(template_file))
    else:
        convert_file(input_path, pathlib.Path(template_file))


if __name__ == "__main__":
    main()
