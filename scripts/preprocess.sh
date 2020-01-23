#/usr/bin/bash

onmt_preprocess -train_src data/mathematics_dataset-v1.0/train-easy-split/algebra__linear_1d_src_train.txt -train_tgt data/mathematics_dataset-v1.0/train-easy-split/algebra__linear_1d_tgt_train.txt -valid_src data/mathematics_dataset-v1.0/train-easy-split/algebra__linear_1d_src_valid.txt -valid_tgt data/mathematics_dataset-v1.0/train-easy-split/algebra__linear_1d_tgt_valid.txt -save_data data/demo/algebra__linear_1d/data
