#!/bin/sh
#SBATCH -N 1      # nodes requested
#SBATCH -n 1      # tasks requested
#SBATCH --partition=Teach-Standard
#SBATCH --gres=gpu:1
#SBATCH --mem=12000  # memory in Mb
#SBATCH --time=0-3:00:00

set -e #terminate the script if error occurs



# These need to be changed before running the script
export EXPERIMENT_NAME="extrapolation_rmi_12032020"
export MODEL_FOLDER="/home/s1556895"
export MODEL_ARCHIVE="risk_irm_12032020"
export PROJECT_FILE="project-dir.tar.gz"
export CHECKPOINT="40000"
export MODEL="model"

declare -a TASKS=("algebra__polynomial_roots_big_src_test.txt"
"arithmetic__mixed_longer_src_test.txt"
"comparison__kth_biggest_more_src_test.txt"
"numbers__round_number_big_src_test.txt"
"arithmetic__add_or_sub_big_src_test.txt"           
"arithmetic__mul_big_src_test.txt"          
"comparison__sort_more_src_test.txt"
"probability__swr_p_level_set_more_samples_src_test.txt"
"arithmetic__add_sub_multiple_longer_src_test.txt"
"arithmetic__mul_div_multiple_longer_src_test.txt"
"measurement__conversion_src_test.txt"
"probability__swr_p_sequence_more_samples_src_test.txt"
"arithmetic__div_big_src_test.txt"
"comparison__closest_more_src_test.txt"
"numbers__place_value_big_src_test.txt")

echo ""
echo "EXPERIMENT_NAME=${EXPERIMENT_NAME}"
echo "MODEL_FOLDER=${MODEL_FOLDER}"
echo "MODEL_ARCHIVE=${MODEL_ARCHIVE}"
echo "PROJECT_FILE=${PROJECT_FILE}"
echo "CHECKPOINT=${CHECKPOINT}"
echo "MODEL=${MODEL}"
echo "DIFFICULTY=${DIFFICULTY}"
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
mkdir -p ${NODE_EXPERIMENT_DIR}/results
export NODE_TXT_DIR=${NODE_EXPERIMENT_DIR}/txt_folder
export NODE_DATA_DIR=${NODE_EXPERIMENT_DIR}/data
export NODE_RESULTS_DIR=${NODE_EXPERIMENT_DIR}/results

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
rsync -ua --progress ${CLUSTER_HOME_DIR}/baseline_extra_src.tar.gz ${NODE_TXT_DIR}

cd ${CLUSTER_HOME_DIR}
rsync -ua --progress ${MODEL_ARCHIVE}.tar.gz ${NODE_EXPERIMENT_DIR}


echo ""
echo "### Unzip files and merge them"
echo ""

# Move to scratch directory
cd ${NODE_TXT_DIR}
# Unzip and delete zip file
tar -zxvf baseline_extra_src.tar.gz


echo "hereeeee"

cd ${NODE_EXPERIMENT_DIR}
tar -zxvf ${MODEL_ARCHIVE}.tar.gz
ls ${NODE_EXPERIMENT_DIR}

echo "here x2a"

tree ${NODE_TXT_DIR}

for i in "${TASKS[@]}"
do
    echo "$i"
    onmt_translate -model ${NODE_EXPERIMENT_DIR}/risk_irm/model/${MODEL}_step_${CHECKPOINT}.pt \
                -src ${NODE_TXT_DIR}/${i} \
                -output ${NODE_RESULTS_DIR}/pred_valid_${i}_${CHECKPOINT}.txt \
                -replace_unk -verbose

    tar -zcvf ${i}.saved.tar.gz ${NODE_RESULTS_DIR}/pred_valid_${i}_${CHECKPOINT}.txt 
    rsync -ua --progress ${i}.saved.tar.gz  ${CLUSTER_EXPERIMENT_DIR}
done
