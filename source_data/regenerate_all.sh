#!/usr/bin/env bash
set -e

rm -rf series/ uploaders/
python split_by_series.py
python add_hierarchy.py series/
python map_aspace_fields.py series/
python csv2xlsx.py series/
mkdir uploaders/
mv series/*.xlsx uploaders/ 
