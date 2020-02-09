#/usr/bin/bash

# WARNING: CHECK ALL VARIABLES AND COMMANDS CAREFULLY

TASK="calculus__differentiate"
MODEL=""
CHECKPOINT="10000"
EXPDIR="exp/${TASK}"

# Validation
onmt_translate -model ${EXPDIR}/model/model${MODEL}_step_${CHECKPOINT}.pt -src data/mathematics_dataset-v1.0/train-easy-split/${TASK}_src_valid.txt -output data/demo/${TASK}/pred_valid_${CHECKPOINT}.txt -replace_unk -verbose

# Test
# onmt_translate -model ${EXPDIR}/model${MODEL}_step_${CHECKPOINT}.pt -src data/mathematics_dataset-v1.0/interpolate-split/${TASK}_src_test.txt -output data/demo/${TASK}/pred_test_${CHECKPOINT}.txt -replace_unk -verbose
