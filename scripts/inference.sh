#/usr/bin/bash

TASK="algebra__linear_1d"
MODEL="size-50"
CHECKPOINT="20000"
EXPDIR="data/demo/${TASK}"

# onmt_translate -model demo-model_step_250.pt -src data/mathematics_dataset-v1.0/interpolate-split/algebra__linear_1d_src_test.txt -output data/demo/pred.txt -replace_unk -verbose

onmt_translate -model ${EXPDIR}/model-${MODEL}_step_${CHECKPOINT}.pt -src data/mathematics_dataset-v1.0/interpolate-split/${TASK}_src_test.txt -output data/demo/${TASK}/pred_${CHECKPOINT}.txt -replace_unk -verbose
