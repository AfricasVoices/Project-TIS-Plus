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
    "TIS_Plus_rqa_s09e03_break"
    "TIS_Plus_rqa_s09e04"
    "TIS_Plus_rqa_s09e05"
    "TIS_Plus_rqa_s09e06"
    "TIS_Plus_rqa_s09e07"
    "TIS_Plus_rqa_s09e08"

    "TIS_Plus_facebook_s09e01"
    "TIS_Plus_facebook_s09e02"
    "TIS_Plus_facebook_s09e03"

    "TIS_Plus_s09_have_voice"
    "TIS_Plus_s09_suggestions"

    "CSAP_age"
    "CSAP_gender"
    "CSAP_location"
    "CSAP_recently_displaced"
    "CSAP_in_idp_camp"
)

cd "$CODA_V2_ROOT/data_tools"
git checkout "f97d0865c3ffa1d36e94b6fc4bb740bf3b3af66c"  # (master which supports add_messages_content_batch)

for DATASET in ${DATASETS[@]}
do
    FILE="$DATA_ROOT/Outputs/Coda Files/$DATASET.json"

    if [ -e "$FILE" ]; then  # Stop-gap workaround for supporting multiple pipelines until we have a Coda library
        echo "Pushing messages data to ${DATASET}..."
        pipenv run python add.py "$AUTH" "${DATASET}" messages "$FILE"
    fi
done
