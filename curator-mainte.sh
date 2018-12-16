#!/bin/sh

CURATOR_INDEX_PATTERN="metricbeat|filebeat"
CURATOR_INDEX_AGE=${1:-10}
CURATOR_FILTER=$(cat <<EOF
                     {
                        "filtertype": "pattern",
                        "kind": "regex",
                        "value": "^${CURATOR_INDEX_PATTERN}.*\$"
                     },
                     {
                        "filtertype": "age",
                        "source": "creation_date",
                        "direction": "older",
                        "unit": "days",
                        "unit_count": ${CURATOR_INDEX_AGE}
                     }
EOF
)

curator_cli show_indices --verbose --header --filter_list "[${CURATOR_FILTER}]"
