#!/usr/bin/env bash

set -e

if [[ $# -ne 3 ]]; then
    echo "Usage: ./4_coda_add.sh <coda-auth-file> <coda-v2-root> <data-root>"
    echo "Uploads coded messages datasets from '<data-root>/Outputs/Coda Files' to Coda"
    exit
fi

AUTH=$1
CODA_V2_ROOT=$2
DATA_ROOT=$3

./checkout_coda_v2.sh "$CODA_V2_ROOT"

DATASETS=(
    "TIS_Plus_rqa_s09e01"
    "TIS_Plus_rqa_s09e02"
    "TIS_Plus_rqa_s09e03"

    "TIS_Plus_facebook_s09e01"

    "CSAP_age"
    "CSAP_gender"
    "CSAP_location"
    "CSAP_recently_displaced"
    "CSAP_in_idp_camp"
)

cd "$CODA_V2_ROOT/data_tools"
git checkout "e895887b3abceb63bab672a262d5c1dd73dcad92"  # (master which supports incremental get)

for DATASET in ${DATASETS[@]}
do
    FILE="$DATA_ROOT/Outputs/Coda Files/$DATASET.json"

    if [ -e "$FILE" ]; then  # Stop-gap workaround for supporting multiple pipelines until we have a Coda library
        echo "Pushing messages data to ${DATASET}..."
        pipenv run python add.py "$AUTH" "${DATASET}" messages "$FILE"
    fi
done
