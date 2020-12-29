#!/usr/bin/env bash

set -e

if [[ $# -ne 3 ]]; then
    echo "Usage: ./1_coda_get.sh <coda-auth-file> <coda-v2-root> <data-root>"
    echo "Downloads coded messages datasets from Coda to '<data-root>/Coded Coda Files'"
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

mkdir -p "$DATA_ROOT/Coded Coda Files"

for DATASET in ${DATASETS[@]}
do
    FILE="$DATA_ROOT/Coded Coda Files/$DATASET.json"

    if [ -e "$FILE" ]; then
        echo "Getting messages data from ${DATASET} (incremental update)..."
        MESSAGES=$(pipenv run python get.py --previous-export-file-path "$FILE" "$AUTH" "${DATASET}" messages)
        echo "$MESSAGES" >"$FILE"
    else
        echo "Getting messages data from ${DATASET} (full download)..."
        pipenv run python get.py "$AUTH" "${DATASET}" messages >"$FILE"
    fi

done
