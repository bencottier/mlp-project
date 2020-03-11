#!/usr/bin/bash

export PROJECT_DIR="/home/ben/projects/mlp-project/mlp-project"
export FOLDER="${PROJECT_DIR}/dataset"
export OUTPUT="${PROJECT_DIR}/dataset/merged"

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

for DATASET in "${DATASETS[@]}"
do
    mkdir -p "${FOLDER}/train-${DATASET}-split-reduced"
    for i in "${TASKS[@]}"
    do
        echo "$i"
        cp "${FOLDER}/train-${DATASET}-split/${i}_src_train.txt" "$FOLDER/train-$DATASET-split-reduced/"
        cp "${FOLDER}/train-${DATASET}-split/${i}_tgt_train.txt" "$FOLDER/train-$DATASET-split-reduced/"
        cp "${FOLDER}/train-${DATASET}-split/${i}_src_valid.txt" "$FOLDER/train-$DATASET-split-reduced/"
        cp "${FOLDER}/train-${DATASET}-split/${i}_tgt_valid.txt" "$FOLDER/train-$DATASET-split-reduced/"
    done
done

mkdir -p $FOLDER/"merged-valid-split-reduced"

for DATASET in "${DATASETS[@]}"
do
    echo "Dataset: $DATASET"
    NAME="train-$DATASET-split-reduced"
    python $PROJECT_DIR/scripts/merge_for_processing.py -i "" -f $FOLDER/$NAME -o ${OUTPUT}-$NAME
    cat "${OUTPUT}-${NAME}/merged_src_valid.txt" >> ${FOLDER}/"merged-valid-split-reduced/merged_src_valid.txt"
    cat "${OUTPUT}-${NAME}/merged_tgt_valid.txt" >> ${FOLDER}/"merged-valid-split-reduced/merged_tgt_valid.txt"
done
