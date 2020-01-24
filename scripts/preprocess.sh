#/usr/bin/bash

# WARNING: CHECK ALL VARIABLES AND COMMANDS CAREFULLY

DATAPATH="data/mathematics_dataset-v1.0/train-easy-split/calculus__differentiate_"
EXPNAME="calculus__differentiate_10000"

# onmt_preprocess -train_src data/mathematics_dataset-v1.0/train-easy-split/algebra__linear_1d_src_train.txt -train_tgt data/mathematics_dataset-v1.0/train-easy-split/algebra__linear_1d_tgt_train.txt -valid_src data/mathematics_dataset-v1.0/train-easy-split/algebra__linear_1d_src_valid.txt -valid_tgt data/mathematics_dataset-v1.0/train-easy-split/algebra__linear_1d_tgt_valid.txt -save_data data/demo/algebra__linear_1d/data

# onmt_preprocess -train_src ${DATAPATH}src_train.txt -train_tgt ${DATAPATH}tgt_train.txt -valid_src ${DATAPATH}src_valid.txt -valid_tgt ${DATAPATH}tgt_valid.txt -save_data data/demo/$EXPNAME/data

onmt_preprocess -train_src ${DATAPATH}src_train_10000.txt -train_tgt ${DATAPATH}tgt_train_10000.txt -valid_src ${DATAPATH}src_valid_1000.txt -valid_tgt ${DATAPATH}tgt_valid_1000.txt -save_data data/demo/$EXPNAME/data
