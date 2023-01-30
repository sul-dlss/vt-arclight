#!/usr/bin/env bash
set -e

rm -rf series/ uploaders/
python3 split_by_series.py
python3 add_hierarchy.py series/
python3 map_aspace_fields.py series/
python3 csv2xlsx.py series/
mkdir uploaders/
mv series/*.xlsx uploaders/ 
