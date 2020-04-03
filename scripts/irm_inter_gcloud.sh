#!/bin/bash

# export DATA_FOLDER="/home/ff/txt_files/baseline_inter_src"
export DATA_FOLDER="/home/ff/txt_files/baseline_inter_src_ns"
export CHECKPOINT="40000"
export EXPERIMENT_FOLDER="/home/ff/experiments/risk_irm_ns_20200328_inter_${CHECKPOINT}"

mkdir -p ${EXPERIMENT_FOLDER}

declare -a TASKS=("algebra__polynomial_roots_src_test.txt"
"arithmetic__add_or_sub_src_test.txt"
"arithmetic__add_sub_multiple_src_test.txt"
"arithmetic__div_src_test.txt"
"arithmetic__mixed_src_test.txt"
"arithmetic__mul_div_multiple_src_test.txt"
"arithmetic__mul_src_test.txt"
"comparison__closest_src_test.txt"
"comparison__kth_biggest_src_test.txt"
"comparison__sort_src_test.txt"
"measurement__conversion_src_test.txt"
"numbers__place_value_src_test.txt"
"numbers__round_number_src_test.txt"
"probability__swr_p_level_set_src_test.txt"
"probability__swr_p_sequence_src_test.txt")

for i in "${TASKS[@]}"
do
    echo "$i"
    # onmt_translate -model ~/models/risk_full_20200314/risk_full/experiments/risk_irm/model/model_step_${CHECKPOINT}.pt \
    # onmt_translate -model ~/models/ns_20200316/ns/experiments/ns/model/model_step_${CHECKPOINT}.pt \
    # onmt_translate -model ~/models/risk_len_20200323/risk_len/experiments/risk_irm_len/model/model_step_${CHECKPOINT}.pt \
    # onmt_translate -model ~/models/baseline_norm_tok_20200328/experiments/baseline_norm_tok/model/model_step_${CHECKPOINT}.pt \
    onmt_translate -model ~/models/risk_irm_ns_20200328/experiments/risk_irm_ns/model/model_step_${CHECKPOINT}.pt \
                -src ${DATA_FOLDER}/${i} \
                -output ${EXPERIMENT_FOLDER}/pred_valid_${i}_${CHECKPOINT}.txt \
                -replace_unk -verbose -gpu 0

done
