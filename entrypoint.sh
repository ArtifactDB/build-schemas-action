#!/bin/bash

set -e
set -u

do_resolve=$1
do_validate=$2
do_prettify=$3
raw=$4
resolved=$5
docs=$6
title=$7
bundle=$8

# Resolving the schemas.
if [[ $do_resolve == "true" ]]
then
    echo "[LOG] Resolving schemas from $raw to $resolved"
    mkdir -p $resolved
    python3 /scripts/resolve_allOf.py $raw $resolved
    echo ""
fi

# Validating the schemas.
all_json=$(find $resolved -type f -name "*.json")
if [[ $do_validate == "true" ]]
then
    echo "[LOG] Validating schemas from $resolved"
    for x in ${all_json}
    do
        echo "Validating $x"
        jsonschema -i $x /schema-07.json
    done
    echo ""
fi

# Generating pretty HTMLs.
if [[ $do_prettify == "true" ]]
then
    echo "[LOG] Prettifying schemas from $resolved to $docs"
    mkdir -p $docs

    for x in ${all_json}
    do
        base=$(basename $x | sed "s/.json/.html/")
        dir=$(dirname $x | xargs basename)
        mkdir -p $docs/$dir
        tmp=${docs}/${dir}/tmp-${base}.json

        echo "Prettifying $x"
        python3 /scripts/nest_allOf.py ${x} ${tmp}
        generate-schema-doc \
            --config description_is_markdown=true \
            --config collapse_long_descriptions=false \
            ${tmp} ${docs}/${dir}/${base}
        cp $x ${docs}/${dir}
        rm ${tmp}
    done

    # Creating a landing page.
    python3 /scripts/create_landing_page.py "$title" $docs > $docs/index.html

    echo ""
fi

# Creating a bundle at the target.
if [[ $bundle != "" ]]
then
    echo "[LOG] Bundling schemas from $resolved to $bundle"
    tar -czvf $bundle $resolved
    echo ""
fi
