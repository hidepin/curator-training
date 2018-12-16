#!/bin/sh

CURATOR_INDEX_PATTERN="metricbeat|filebeat"
CURATOR_INDEX_AGE=${1:-10}
CURATOR_INDEX_DISKSPACE=${2:-400}
CURATOR_COMMAND=${3:-show_indices}

CURATOR_AGE_FILTER=$(cat <<EOF
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
CURATOR_SPACE_FILTER=$(cat <<EOF
                     {
                        "filtertype": "pattern",
                        "kind": "regex",
                        "value": "^${CURATOR_INDEX_PATTERN}.*\$"
                     },
                     {
                        "filtertype": "space",
                        "disk_space": ${CURATOR_INDEX_DISKSPACE},
                        "use_age": "True",
                        "source": "creation_date"
                     }
EOF
)

curator_cli ${CURATOR_COMMAND} --verbose --header --filter_list "[${CURATOR_AGE_FILTER}]"
curator_cli ${CURATOR_COMMAND} --verbose --header --filter_list "[${CURATOR_SPACE_FILTER}]"
