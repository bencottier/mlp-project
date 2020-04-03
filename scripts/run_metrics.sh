export MLP_FOLDER=/Users/ff/dev/mlp-project

export INTER_SRC=/Users/ff/dev/mathematics_dataset-v1.0/interpolate-split
export INTER_TGT=/Users/ff/results_20200303/results_interpolation_100k

export EXTRA_SRC=/Users/ff/dev/mathematics_dataset-v1.0/extrapolate-split
export EXTRA_TGT=/Users/ff/results_20200303/results_extrapolation_100k

export CHECKPOINT=100000

# Interpolation
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/algebra__polynomial_roots_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_algebra__polynomial_roots_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/arithmetic__add_or_sub_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_arithmetic__add_or_sub_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/arithmetic__add_sub_multiple_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_arithmetic__add_sub_multiple_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/arithmetic__div_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_arithmetic__div_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/arithmetic__mixed_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_arithmetic__mixed_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/arithmetic__mul_div_multiple_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_arithmetic__mul_div_multiple_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/arithmetic__mul_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_arithmetic__mul_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/comparison__closest_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_comparison__closest_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/comparison__kth_biggest_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_comparison__kth_biggest_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/comparison__sort_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_comparison__sort_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/measurement__conversion_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_measurement__conversion_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/numbers__place_value_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_numbers__place_value_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/numbers__round_number_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_numbers__round_number_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/probability__swr_p_level_set_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_probability__swr_p_level_set_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${INTER_SRC}/probability__swr_p_sequence_tgt_test.txt -hyp ${INTER_TGT}/pred_valid_probability__swr_p_sequence_src_test.txt_${CHECKPOINT}.txt


# Extrapolation
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/algebra__polynomial_roots_big_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_algebra__polynomial_roots_big_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/arithmetic__add_or_sub_big_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_arithmetic__add_or_sub_big_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/arithmetic__add_sub_multiple_longer_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_arithmetic__add_sub_multiple_longer_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/arithmetic__div_big_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_arithmetic__div_big_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/arithmetic__mixed_longer_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_arithmetic__mixed_longer_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/arithmetic__mul_big_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_arithmetic__mul_big_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/arithmetic__mul_div_multiple_longer_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_arithmetic__mul_div_multiple_longer_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/comparison__closest_more_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_comparison__closest_more_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/comparison__kth_biggest_more_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_comparison__kth_biggest_more_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/comparison__sort_more_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_comparison__sort_more_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/measurement__conversion_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_measurement__conversion_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/numbers__place_value_big_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_numbers__place_value_big_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/numbers__round_number_big_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_numbers__round_number_big_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/probability__swr_p_level_set_more_samples_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_probability__swr_p_level_set_more_samples_src_test.txt_${CHECKPOINT}.txt
python ${MLP_FOLDER}/scripts/metrics.py -ref ${EXTRA_SRC}/probability__swr_p_sequence_more_samples_tgt_test.txt -hyp ${EXTRA_TGT}/pred_valid_probability__swr_p_sequence_more_samples_src_test.txt_${CHECKPOINT}.txt