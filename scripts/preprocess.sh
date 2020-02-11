#/usr/bin/bash

# WARNING: CHECK ALL VARIABLES AND COMMANDS CAREFULLY

TASK="extrapolate"
DATAPATH="data/mathematics_dataset-v1.0/train-combined-split/combined_extrapolate_char_"
BINDIR="data/bin/${TASK}"

mkdir -p $BINDIR

#onmt_preprocess -train_src ${DATAPATH}src_train.txt -train_tgt ${DATAPATH}tgt_train.txt -valid_src ${DATAPATH}src_valid.txt -valid_tgt ${DATAPATH}tgt_valid.txt -save_data ${BINDIR}/data -overwrite

onmt_preprocess -train_src ${DATAPATH}dummy_train.txt -train_tgt ${DATAPATH}dummy_train.txt -valid_src ${DATAPATH}src_valid_66667.txt -valid_tgt ${DATAPATH}tgt_valid_66667.txt -save_data ${BINDIR}/data -overwrite

