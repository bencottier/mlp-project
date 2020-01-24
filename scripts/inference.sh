#/usr/bin/bash

# WARNING: CHECK ALL VARIABLES AND COMMANDS CAREFULLY

TASK="calculus__differentiate"
MODEL="size-100"
CHECKPOINT="85000"
EXPDIR="data/demo/calculus__differentiate"

# onmt_translate -model demo-model_step_250.pt -src data/mathematics_dataset-v1.0/interpolate-split/algebra__linear_1d_src_test.txt -output data/demo/pred.txt -replace_unk -verbose

# onmt_translate -model ${EXPDIR}/model-${MODEL}_step_${CHECKPOINT}.pt -src data/mathematics_dataset-v1.0/interpolate-split/${TASK}_src_test.txt -output data/demo/${TASK}/pred_${CHECKPOINT}.txt -replace_unk -verbose

# Rerun on training data
onmt_translate -model ${EXPDIR}/model-${MODEL}_step_${CHECKPOINT}.pt -src data/mathematics_dataset-v1.0/train-easy-split/${TASK}_src_valid_1000.txt -output data/demo/${TASK}/pred_valid_${CHECKPOINT}.txt -replace_unk -verbose
