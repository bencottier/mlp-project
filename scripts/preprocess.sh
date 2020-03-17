#!/usr/bin/bash

# WARNING: CHECK ALL VARIABLES AND COMMANDS CAREFULLY

TASK="merged-ns"
BINDIR="dataset/bin/${TASK}"
CONFIG="config/config-preprocess"

mkdir -p $BINDIR

cp ${CONFIG}.yml ${CONFIG}.${TASK}.yml
sed -i 's,{{task}},'"${TASK}"',g' ${CONFIG}.${TASK}.yml

onmt_preprocess --config ${CONFIG}.${TASK}.yml

# TASK=$1
# ENV=$2
# DATAPATH="data/mathematics_dataset-v1.0/train-${ENV}-split/${TASK}_"
# BINDIR="data/bin/${TASK}"

# onmt_preprocess -train_src ${DATAPATH}src_train.txt -train_tgt ${DATAPATH}tgt_train.txt -valid_src ${DATAPATH}src_valid.txt -valid_tgt ${DATAPATH}tgt_valid.txt -save_data ${BINDIR}/data.${ENV}

