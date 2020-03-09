#!/usr/bin/bash

# Generic
# paste -d '|' src_train.txt tgt_train.txt | shuf | awk -v FS="|" '{ print $1 > "src_train_shuf.txt" ; print $2 > "tgt_train_shuf.txt" }'

# paste -d '|' dataset/merged-train-easy-split-reduced/merged_src_train.txt dataset/merged-train-easy-split-reduced/merged_tgt_train.txt | shuf | awk -v FS="|" '{ print $1 > "dataset/merged-train-easy-split-reduced/merged_src_train_shuf.txt" ; print $2 > "dataset/merged-train-easy-split-reduced/merged_tgt_train_shuf.txt" }'

# paste -d '|' dataset/merged-train-medium-split-reduced/merged_src_train.txt dataset/merged-train-medium-split-reduced/merged_tgt_train.txt | shuf | awk -v FS="|" '{ print $1 > "dataset/merged-train-medium-split-reduced/merged_src_train_shuf.txt" ; print $2 > "dataset/merged-train-medium-split-reduced/merged_tgt_train_shuf.txt" }'

# paste -d '|' dataset/merged-train-hard-split-reduced/merged_src_train.txt dataset/merged-train-hard-split-reduced/merged_tgt_train.txt | shuf | awk -v FS="|" '{ print $1 > "dataset/merged-train-hard-split-reduced/merged_src_train_shuf.txt" ; print $2 > "dataset/merged-train-hard-split-reduced/merged_tgt_train_shuf.txt" }'

paste -d '|' dataset/merged-valid-split-reduced/merged_src_valid.txt dataset/merged-valid-split-reduced/merged_tgt_valid.txt | shuf | awk -v FS="|" '{ print $1 > "dataset/merged-valid-split-reduced/merged_src_valid_shuf.txt" ; print $2 > "dataset/merged-valid-split-reduced/merged_tgt_valid_shuf.txt" }'
