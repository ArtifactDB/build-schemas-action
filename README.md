# GitHub Action for building schemas

This action provides a "one-click" method for preparing JSON schemas for use in an ArtifactDB instance.

- It resolves `allOf` statements by merging together `properties` from all referenced subschemas.
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
|`raw`|raw|Input directory containing the raw JSON schemas.|
|`resolved`|resolved|Output directory containing the resolved JSON schemas.|
|`docs`|public|Output directory containing the prettified documentation. This can be directly used for upload to GitHub Pages.| 
|`title`|Schema overview|Title to use for the index page.|
|`tarball`||Output tarball containing the resolved JSON schemas. If an empty string, no tarball is created.|
