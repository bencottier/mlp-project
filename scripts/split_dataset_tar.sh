#/usr/bin/bash

DATA_PATH=`pwd`/data
NAME="mathematics_dataset-v1.0"

# python split_dataset.py -i ${DATA_PATH}/mathematics_dataset-v1.0.tar.gz -o ${DATA_PATH} --train_split 0.9 --token char

python scripts/split_dataset.py \
    -i ${DATA_PATH}/${NAME}.tar.gz \
    -o ${DATA_PATH}/${NAME}/train-combined-split \
    -c combined_extrapolate_char.txt \
    $NAME/train-easy/algebra__polynomial_roots.txt \
    $NAME/train-easy/arithmetic__add_or_sub.txt \
    $NAME/train-easy/arithmetic__add_sub_multiple.txt \
    $NAME/train-easy/arithmetic__div.txt \
    $NAME/train-easy/arithmetic__mixed.txt \
    $NAME/train-easy/arithmetic__mul.txt \
    $NAME/train-easy/arithmetic__mul_div_multiple.txt \
    $NAME/train-easy/comparison__closest.txt \
    $NAME/train-easy/comparison__kth_biggest.txt \
    $NAME/train-easy/comparison__sort.txt \
    $NAME/train-easy/measurement__conversion.txt.txt \
    $NAME/train-easy/numbers__place_value.txt \
    $NAME/train-easy/numbers__round_number.txt \
    $NAME/train-easy/probability__swr_p_level_set.txt \
    $NAME/train-easy/probability__swr_p_sequence.txt \
    $NAME/train-medium/algebra__polynomial_roots.txt \
    $NAME/train-medium/arithmetic__add_or_sub.txt \
    $NAME/train-medium/arithmetic__add_sub_multiple.txt \
    $NAME/train-medium/arithmetic__div.txt \
    $NAME/train-medium/arithmetic__mixed.txt \
    $NAME/train-medium/arithmetic__mul.txt \
    $NAME/train-medium/arithmetic__mul_div_multiple.txt \
    $NAME/train-medium/comparison__closest.txt \
    $NAME/train-medium/comparison__kth_biggest.txt \
    $NAME/train-medium/comparison__sort.txt \
    $NAME/train-medium/measurement__conversion.txt.txt \
    $NAME/train-medium/numbers__place_value.txt \
    $NAME/train-medium/numbers__round_number.txt \
    $NAME/train-medium/probability__swr_p_level_set.txt \
    $NAME/train-medium/probability__swr_p_sequence.txt \
    $NAME/train-hard/algebra__polynomial_roots.txt \
    $NAME/train-hard/arithmetic__add_or_sub.txt \
    $NAME/train-hard/arithmetic__add_sub_multiple.txt \
    $NAME/train-hard/arithmetic__div.txt \
    $NAME/train-hard/arithmetic__mixed.txt \
    $NAME/train-hard/arithmetic__mul.txt \
    $NAME/train-hard/arithmetic__mul_div_multiple.txt \
    $NAME/train-hard/comparison__closest.txt \
    $NAME/train-hard/comparison__kth_biggest.txt \
    $NAME/train-hard/comparison__sort.txt \
    $NAME/train-hard/measurement__conversion.txt.txt \
    $NAME/train-hard/numbers__place_value.txt \
    $NAME/train-hard/numbers__round_number.txt \
    $NAME/train-hard/probability__swr_p_level_set.txt \
    $NAME/train-hard/probability__swr_p_sequence.txt \
    --train_split 0.9 --token char
