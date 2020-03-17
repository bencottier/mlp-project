#!/usr/bin/bash

# Generic
# paste -d '|' src_train.txt tgt_train.txt | shuf | awk -v FS="|" '{ print $1 > "src_train_shuf.txt" ; print $2 > "tgt_train_shuf.txt" }'

paste -d '|' dataset/merged-train-easy-split-ns/merged_src_train.txt dataset/merged-train-easy-split-ns/merged_tgt_train.txt | shuf | awk -v FS="|" '{ print $1 > "dataset/merged-train-easy-split-ns/merged_src_train_shuf.txt" ; print $2 > "dataset/merged-train-easy-split-ns/merged_tgt_train_shuf.txt" }'

paste -d '|' dataset/merged-train-medium-split-ns/merged_src_train.txt dataset/merged-train-medium-split-ns/merged_tgt_train.txt | shuf | awk -v FS="|" '{ print $1 > "dataset/merged-train-medium-split-ns/merged_src_train_shuf.txt" ; print $2 > "dataset/merged-train-medium-split-ns/merged_tgt_train_shuf.txt" }'

paste -d '|' dataset/merged-train-hard-split-ns/merged_src_train.txt dataset/merged-train-hard-split-ns/merged_tgt_train.txt | shuf | awk -v FS="|" '{ print $1 > "dataset/merged-train-hard-split-ns/merged_src_train_shuf.txt" ; print $2 > "dataset/merged-train-hard-split-ns/merged_tgt_train_shuf.txt" }'

paste -d '|' dataset/merged-valid-split-ns/merged_src_valid.txt dataset/merged-valid-split-ns/merged_tgt_valid.txt | shuf | awk -v FS="|" '{ print $1 > "dataset/merged-valid-split-ns/merged_src_valid_shuf.txt" ; print $2 > "dataset/merged-valid-split-ns/merged_tgt_valid_shuf.txt" }'

head -270000 dataset/merged-valid-split-ns/merged_src_valid_shuf.txt > dataset/merged-valid-split-ns/merged_src_valid_small.txt

head -270000 dataset/merged-valid-split-ns/merged_tgt_valid_shuf.txt > dataset/merged-valid-split-ns/merged_tgt_valid_small.txt

# After manually combining the files for each difficulty
# paste -d '|' dataset/merged-train-split-ns/merged_src_train.txt dataset/merged-train-split-ns/merged_tgt_train.txt | shuf | awk -v FS="|" '{ print $1 > "dataset/merged-train-split-ns/merged_src_train_shuf.txt" ; print $2 > "dataset/merged-train-split-ns/merged_tgt_train_shuf.txt" }'
