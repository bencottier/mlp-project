#/usr/bin/bash

TASK="algebra__linear_1d"
MODEL="size-50"
CHECKPOINT="demo-model-size-50_step_10000.pt"
EXPDIR="data/demo/${TASK}"

# Test 1: ~10M parameters
# onmt_train -data data/demo/demo -save_model demo-model -train_steps 250

# Test 2: ~300k parameters
# onmt_train -data data/demo/demo -save_model demo-model-size-50 -train_steps 10000 -valid_steps 1000 -enc_rnn_size 50 -dec_rnn_size 50

onmt_train -data ${EXPDIR}/data -train_from ${EXPDIR}/${CHECKPOINT} -save_model ${EXPDIR}/model-${MODEL} -train_steps 20000 -valid_steps 5000 -enc_rnn_size 50 -dec_rnn_size 50
