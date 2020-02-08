#/usr/bin/bash

# WARNING: CHECK ALL VARIABLES AND COMMANDS CAREFULLY

TASK="calculus__differentiate"
DATAPATH="data/mathematics_dataset-v1.0/train-easy-split/${TASK}_"
BINDIR="data/bin/${TASK}"

mkdir -p $BINDIR

onmt_preprocess -train_src ${DATAPATH}src_train.txt -train_tgt ${DATAPATH}tgt_train.txt -valid_src ${DATAPATH}src_valid.txt -valid_tgt ${DATAPATH}tgt_valid.txt -save_data ${BINDIR}/data
