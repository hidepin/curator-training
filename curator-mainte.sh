#!/bin/sh

CURATOR_INDEX_PATTERN="metricbeat|filebeat"
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
                        "unit_count": 10
                     }
EOF
)

curator_cli show_indices --verbose --header --filter_list "[${CURATOR_FILTER}]"
