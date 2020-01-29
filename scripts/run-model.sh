#!/bin/sh
#SBATCH -N 1	  # nodes requested
#SBATCH -n 1	  # tasks requested
#SBATCH --partition=Teach-Standard
#SBATCH --gres=gpu:4
#SBATCH --mem=12000  # memory in Mb
#SBATCH --time=0-26:00:00

set -e #terminate the script if error occurs

export CUDA_HOME=/opt/cuda-9.0.176.1/

export CUDNN_HOME=/opt/cuDNN-7.0/

export STUDENT_ID=$(whoami)	

export LD_LIBRARY_PATH=${CUDNN_HOME}/lib64:${CUDA_HOME}/lib64:$LD_LIBRARY_PATH

export LIBRARY_PATH=${CUDNN_HOME}/lib64:$LIBRARY_PATH

export CPATH=${CUDNN_HOME}/include:$CPATH

export PATH=${CUDA_HOME}/bin:${PATH}

export PYTHON_PATH=$PATH

mkdir -p /disk/scratch/${STUDENT_ID}

export TMPDIR=/disk/scratch/${STUDENT_ID}

mkdir -p ${TMPDIR}/datasets/
export DATASET_DIR=${TMPDIR}/datasets

# Activate the relevant virtual environment:
source /home/${STUDENT_ID}/miniconda3/bin/activate mlp

#Change following variable according to your system or run with project in current directory
export CLUSTER_PROJECT_DIR=`pwd`
export PROJECT_FILE="project-dir.tar.gz"

cd $DATASET_DIR

#Transfer data from cluster to scratch dataset directory
rsync -ua --progress ${CLUSTER_PROJECT_DIR}/${PROJECT_FILE} ${DATASET_DIR}/
tar -zxvf ${PROJECT_FILE}
rm ${PROJECT_FILE}

export SCRATCH_PROJECT_DIR=${DATASET_DIR}/project-dir
cd $SCRATCH_PROJECT_DIR

#Run training file
sh train.sh
cd ..

#Transfer saved models from scratch dataset directory to cluster 
tar -zcvf ${PROJECT_FILE}.saved.tar.gz $SCRATCH_PROJECT_DIR
rsync -ua --progress ${PROJECT_FILE}.saved_base.tar.gz $CLUSTER_PROJECT_DIR
rm -r $DATASET_DIR
