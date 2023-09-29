import jsonschema
import requests
import os
import json

if __name__ == "__main__":
    import sys
    indir = sys.argv[1]

    import glob
    files = glob.glob(indir + '/**/*.json', recursive=True)
    all_schemas = {}

    for fname in files:
        curdir = os.path.dirname(fname)
        dname = os.path.basename(curdir)
        bname = os.path.basename(fname)
        if dname[0] == "_": 
            continue

        print("Validating " + fname)
        with open(fname, "r") as f:
            out = json.load(f)

        schema = out["$schema"]
        if schema in all_schemas:
            metaschema = all_schemas[schema]
        else:
            metaschema = requests.get(schema).json()
            all_schemas[schema] = metaschema

        jsonschema.validate(out, metaschema)
