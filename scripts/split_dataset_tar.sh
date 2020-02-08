#/usr/bin/bash

python split_dataset.py -i ${DATA_PATH}/mathematics_dataset-v1.0.tar.gz -o ${DATA_PATH} --train_split 0.9 --token char
