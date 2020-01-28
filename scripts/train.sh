#/usr/bin/bash

# WARNING: CHECK ALL VARIABLES AND COMMANDS CAREFULLY

TASK="calculus__differentiate"
EXPDIR="exp/${TASK}"

echo "TASK: "$TASK
echo "EXPDIR: "$EXPDIR

mkdir -p $EXPDIR

onmt_train -config config/config-transformer-small.yml

# onmt_train -config config/config-transformer-base-4GPU.yml

# Test 1: ~10M parameters
# onmt_train -data data/demo/demo -save_model demo-model -train_steps 250

# Test 2: ~300k parameters
# onmt_train -data data/demo/demo -save_model demo-model-size-50 -train_steps 10000 -valid_steps 1000 -enc_rnn_size 50 -dec_rnn_size 50

# onmt_train -data ${EXPDIR}/data -train_from ${EXPDIR}/${CHECKPOINT} -save_model ${EXPDIR}/model-${MODEL} -train_steps 20000 -valid_steps 5000 -enc_rnn_size 50 -dec_rnn_size 50

# Test 3: 762543 parameters
# onmt_train -data ${EXPDIR}/data -train_from ${EXPDIR}/${CHECKPOINT} -save_model ${EXPDIR}/model-${MODEL} -train_steps 100000 -valid_steps 10000 -enc_rnn_size 100 -dec_rnn_size 100

# Test 4: can it memorise?
# onmt_train -data ${EXPDIR}/data -save_model ${EXPDIR}/model-${MODEL} -train_steps 10000 -valid_steps 1000 -enc_rnn_size 100 -dec_rnn_size 100 -early_stopping 4 -early_stopping_criteria ppl

# Test 5: Transformer
# onmt_train -data ${EXPDIR}/data -save_model ${EXPDIR}/model_${MODEL} \
#         -layers 2 -rnn_size 128 -word_vec_size 128 -transformer_ff 512 -heads 2  \
#         -encoder_type transformer -decoder_type transformer -position_encoding \
#         -train_steps 200000  -max_generator_batches 2 -dropout 0.1 \
#         -batch_size 4096 -batch_type tokens -normalization tokens  -accum_count 2 \
#         -optim adam -adam_beta2 0.995 -decay_method noam -warmup_steps 8000 -learning_rate 2 \
#         -max_grad_norm 0.1 -param_init 0  -param_init_glorot \
#         -label_smoothing 0.1 -valid_steps 10000 -save_checkpoint_steps 10000 \
#         -world_size 4 -gpu_ranks 0 1 2 3
