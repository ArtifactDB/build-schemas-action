FROM python:3.9

RUN pip install json-schema-for-humans==0.46 check-jsonschema==0.27.0

COPY scripts /scripts

RUN wget http://json-schema.org/draft-07/schema -O schema-07.json

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
