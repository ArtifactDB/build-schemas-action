#!/bin/bash

set -e
set -u

raw=$1
resolved=$2
docs=$3
title=$4

echo "Raw schema directory is $raw"
echo "Resolved schema directory is $resolved"
echo "Documentation directory is $docs"
echo "Landing page title is $title"

# Resolving the schemas.
mkdir -p $resolved
python3 /scripts/resolve_allOf.py $raw $resolved

all_json=$(find $resolved -type f -name "*.json")
for x in ${all_json}
do
    echo "Validating $x"
    jsonschema -i $x /schema-07.json
done

# Generating pretty HTMLs.
mkdir -p $docs

for x in ${all_json}
do
    base=$(basename $x | sed "s/.json/.html/")
    dir=$(dirname $x | xargs basename)
    mkdir -p $docs/$dir
    tmp=${docs}/${dir}/tmp-${base}.json

    echo "Prettifying $x"
    python3 /scripts/nest_allOf.py ${x} ${tmp}
    generate-schema-doc ${tmp} ${docs}/${dir}/${base}
    cp $x ${docs}/${dir}
    rm ${tmp}
done

# Creating a landing page.
python3 /scripts/create_landing_page.py "$title" $docs > $docs/index.html
