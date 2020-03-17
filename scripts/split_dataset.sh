# First run 
#     export MATH_DATASET=<absolute path to dataset>
export MATH_DATASET="/home/ben/projects/mlp-project/mlp-project/dataset"

# python split_dataset.py -i ${MATH_DATASET}/train-easy -o ${MATH_DATASET}/train-easy-split --train_split 0.9 --token char
# python split_dataset.py -i ${MATH_DATASET}/train-medium -o ${MATH_DATASET}/train-medium-split --train_split 0.9 --token char
# python split_dataset.py -i ${MATH_DATASET}/train-hard -o ${MATH_DATASET}/train-hard-split --train_split 0.9 --token char
# python split_dataset.py -i ${MATH_DATASET}/interpolate -o ${MATH_DATASET}/interpolate-split --token char
# python split_dataset.py -i ${MATH_DATASET}/extrapolate -o ${MATH_DATASET}/extrapolate-split --token char

python split_dataset.py -i ${MATH_DATASET}/train-easy -o ${MATH_DATASET}/train-easy-split-ns --train_split 0.9 --token hybrid
python split_dataset.py -i ${MATH_DATASET}/train-medium -o ${MATH_DATASET}/train-medium-split-ns --train_split 0.9 --token hybrid
python split_dataset.py -i ${MATH_DATASET}/train-hard -o ${MATH_DATASET}/train-hard-split-ns --train_split 0.9 --token hybrid
python split_dataset.py -i ${MATH_DATASET}/interpolate -o ${MATH_DATASET}/interpolate-split-ns --token hybrid
python split_dataset.py -i ${MATH_DATASET}/extrapolate -o ${MATH_DATASET}/extrapolate-split-ns --token hybrid
