# GitHub Action for building schemas

This action provides a "one-click" method for preparing JSON schemas for use in an ArtifactDB instance.

- It resolves `$ref` statements by merging together properties from all referenced subschemas.
  This produces a schema that has a single `properties`, which is easier to parse by both humans and machines.
  The centralization of properties also allows us to set `additionalProperties: false`, which allows for stricter validation.
  (This would not be possible if properties are fragmented into different `allOf` subschemas.
- It validates the schemas against the JSON schema specification using the [`jsonschema`](https://pypi.org/project/jsonschema/) package.
  We currently use [draft 7](https://json-schema.org/draft-07/json-schema-release-notes.html) of the specification.
- It converts the schemas into human-readable webpages using the [`json-schema-for-humans`](https://github.com/coveooss/json-schema-for-humans) packge.
  It also creates an index page in preparation for publication to GitHub Pages.

To use, simply add the following step to your GitHub Actions workflow:

```yaml
    - name: Build schemas
      uses: ArtifactDB/build-schemas-action@0.1.0
      with:
        title: 'My schema overview'
```

The following optional arguments can be specified:

|Option|Default|Description|
|---|---|---|
|`do_resolve`|true|Whether to resolve subschema references in the raw schemas.|
|`do_validate`|true|Whether to validate the resolved schemas.|
|`do_prettify`|true|Whether to prettify the resolved schemas.|
|`path_raw`|raw|Path to the input directory containing the raw schemas. Only used if `do_resolve = true`.|
|`path_resolved`|resolved|Path to the directory containing the resolved schemas. This is an output directory if `do_resolve = true`, otherwise it is an input directory that already contains resolved schemas.|
|`path_docs`|public|Path to the output directory containing the human-readable schemas. Only used if `do_prettify = true`.|
|`docs_title`|Schema overview|Title for the landing page. Only required `do_prettify = true`.|
|`path_tarball`||Path to an output tarball containing all resolved schemas. If this is empty, no tarball is created.|c
