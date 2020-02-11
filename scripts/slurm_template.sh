#!/bin/sh
#SBATCH -N 1      # nodes requested
#SBATCH -n 1      # tasks requested
#SBATCH --partition=Teach-Standard
#SBATCH --gres=gpu:1
#SBATCH --mem=12000  # memory in Mb
#SBATCH --time=0-1:00:00

set -e #terminate the script if error occurs

# These need to be changed before running the script
export EXPERIMENT_NAME="test_experiment"
export TASK="calculus__differentiate"
export PROJECT_FILE="project-dir.zip"
export CONFIG_FILE="super-small-test.yml"

echo ""
echo "EXPERIMENT_NAME: ${EXPERIMENT_NAME}"
echo "TASK: ${TASK}"
echo "PROJECT_FILE: ${PROJECT_FILE}"
echo "CONFIG_FILE: ${CONFIG_FILE}"
echo ""

export CUDA_HOME=/opt/cuda-9.0.176.1/

export CUDNN_HOME=/opt/cuDNN-7.0/

export STUDENT_ID=$(whoami)

export LD_LIBRARY_PATH=${CUDNN_HOME}/lib64:${CUDA_HOME}/lib64:$LD_LIBRARY_PATH

export LIBRARY_PATH=${CUDNN_HOME}/lib64:$LIBRARY_PATH

export CPATH=${CUDNN_HOME}/include:$CPATH

export PATH=${CUDA_HOME}/bin:${PATH}

export PYTHON_PATH=$PATH

mkdir -p /disk/scratch/${STUDENT_ID}

# Student folder in the scratch space
export TMPDIR=/disk/scratch/${STUDENT_ID}

# Each experiment has its own folder
# This might change with future usage
mkdir -p ${TMPDIR}/datasets/${EXPERIMENT_NAME}
export NODE_EXPERIMENT_DIR=${TMPDIR}/datasets/${EXPERIMENT_NAME}
mkdir -p ${NODE_EXPERIMENT_DIR}/txt_folder
mkdir -p ${NODE_EXPERIMENT_DIR}/data
export NODE_TXT_DIR=${NODE_EXPERIMENT_DIR}/txt_folder
export NODE_DATA_DIR=${NODE_EXPERIMENT_DIR}/data

# Home directory of the user
export CLUSTER_HOME_DIR=/home/${STUDENT_ID}/
# Dataset folder in the central node file system
# This folder contains interpolate-split, extrapolate-split,
#  train-simple-split, train-medium-split, train-hard-split
export CLUSTER_DATASET_DIR=${CLUSTER_HOME_DIR}/dataset


# Folder on the cluster central node for the experiment
mkdir -p /home/${STUDENT_ID}/experiments/${EXPERIMENT_NAME}
export CLUSTER_EXPERIMENT_DIR=/home/${STUDENT_ID}/experiments/${EXPERIMENT_NAME}

# Folder with the repo and the scripts
export REPO_FOLDER=${CLUSTER_HOME_DIR}/mlp-project
export SCRIPTS_FOLDER=${CLUSTER_HOME_DIR}/mlp-project/scripts
export CONFIG_FOLDER=${CLUSTER_HOME_DIR}/mlp-project/config

# Activate the relevant virtual environment:
source /home/${STUDENT_ID}/miniconda3/bin/activate mlp


echo ""
echo "### Zip files and send them to node"
echo ""

cd ${CLUSTER_DATASET_DIR}
# Transfer data from cluster to scratch dataset directory
# Regex only takes the task specified (several tasks have the "composed" version)
find . \( -name ${TASK}_src* -or -name ${TASK}_tgt* \) -exec zip -r ${PROJECT_FILE} {} +
rsync -ua --progress ${CLUSTER_DATASET_DIR}/${PROJECT_FILE} ${NODE_TXT_DIR}
rm ${PROJECT_FILE}


echo ""
echo "### Unzip files and merge them"
echo ""

# Move to scratch directory
cd ${NODE_TXT_DIR}
# Unzip and delete zip file
unzip -o ${PROJECT_FILE}
rm ${PROJECT_FILE}


# Merge together the files selected for the task for preprocessing
cd ${NODE_EXPERIMENT_DIR}
python ${SCRIPTS_FOLDER}/merge_for_processing.py -i ${TASK} -f ${NODE_TXT_DIR} -o ${NODE_TXT_DIR}
ls ${NODE_DATA_DIR}

# Shuffle the data - Done in the iterators
# cd ${NODE_DATA_DIR}
#paste -d '|' merged_src_train.txt merged_tgt_train.txt | shuf | awk -v FS="|" '{ print $1 > "src_train_shuf.txt" ; print $2 > "tgt_train_shuf.txt" }'

echo ""
echo "### Preprocess files"
echo ""
cd ${NODE_EXPERIMENT_DIR}
onmt_preprocess -train_src ${NODE_TXT_DIR}/merged_src_train.txt \
                -train_tgt ${NODE_TXT_DIR}/merged_tgt_train.txt \
                -valid_src ${NODE_TXT_DIR}/merged_src_valid.txt \
                -valid_tgt ${NODE_TXT_DIR}/merged_tgt_valid.txt \
                -save_data ${NODE_DATA_DIR}/data \
                -overwrite


echo ""
echo "### Train network"
echo ""
# Get config file and add current experiment information
rsync -ua --progress ${CONFIG_FOLDER}/${CONFIG_FILE} ${NODE_EXPERIMENT_DIR}/config.yml
sed -i 's,{{exp_dir}},'"${NODE_EXPERIMENT_DIR}"',g' ${NODE_EXPERIMENT_DIR}/config.yml
sed -i 's,{{data_dir}},'"${NODE_DATA_DIR}"',g' ${NODE_EXPERIMENT_DIR}/config.yml

onmt_train -config ${NODE_EXPERIMENT_DIR}/config.yml

echo ""
echo ""
ls ${NODE_EXPERIMENT_DIR}

# Transfer saved models from scratch dataset directory to cluster
# -FS only is useful in case the zip already exists in the folder 
zip -FS ${EXPERIMENT_NAME}.saved.zip ${NODE_EXPERIMENT_DIR}/*
rsync -ua --progress ${EXPERIMENT_NAME}.saved.zip ${CLUSTER_EXPERIMENT_DIR}
rm -r ${NODE_EXPERIMENT_DIR}