#!/usr/bin/bash

PROJECT_DIR="/home/ben/projects/mlp-project/mlp-project"
FOLDER="${PROJECT_DIR}/dataset"
OUTPUT="${PROJECT_DIR}/dataset/merged"
POSTFIX="-ns"

declare -a DATASETS=("easy"
    "medium"
    "hard")

declare -a TASKS=("algebra__polynomial_roots"
    "arithmetic__add_or_sub"
    "arithmetic__add_sub_multiple"
    "arithmetic__div"
    "arithmetic__mixed"
    "arithmetic__mul"
    "arithmetic__mul_div_multiple"
    "comparison__closest"
    "comparison__kth_biggest"
    "comparison__sort"
    "measurement__conversion"
    "numbers__place_value"
    "numbers__round_number"
    "probability__swr_p_level_set"
    "probability__swr_p_sequence")

VALID_DIR="${OUTPUT}-valid-split${POSTFIX}"

mkdir -p ${VALID_DIR}

for DATASET in "${DATASETS[@]}"
do
    echo "Dataset: $DATASET"
    NAME="train-$DATASET-split${POSTFIX}"
    python $PROJECT_DIR/scripts/merge_for_processing.py -i "" -f $FOLDER/$NAME -o ${OUTPUT}-$NAME
    cat "${OUTPUT}-${NAME}/merged_src_valid.txt" >> "${VALID_DIR}/merged_src_valid.txt"
    cat "${OUTPUT}-${NAME}/merged_tgt_valid.txt" >> "${VALID_DIR}/merged_tgt_valid.txt"
    rm "${OUTPUT}-${NAME}/merged_src_valid.txt"
    rm "${OUTPUT}-${NAME}/merged_tgt_valid.txt"
done
