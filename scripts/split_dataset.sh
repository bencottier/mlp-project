# First run 
#     export MATH_DATASET=<absolute path to dataset>

python split_dataset.py -i ${MATH_DATASET}/train-easy -o ${MATH_DATASET}/train-easy-split
python split_dataset.py -i ${MATH_DATASET}/train-medium -o ${MATH_DATASET}/train-medium-split
python split_dataset.py -i ${MATH_DATASET}/train-hard -o ${MATH_DATASET}/train-hard-split