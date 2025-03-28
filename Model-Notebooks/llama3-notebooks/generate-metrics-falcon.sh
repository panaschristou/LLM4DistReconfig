#!/bin/bash

#SBATCH --output="/path/to/LLM-Reconfiguration/AutoTrain/llama3/output_file_name.out"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --time=12:00:00
#SBATCH --mem=200GB
#SBATCH --gres=gpu:v100:1
#SBATCH --job-name=job_name
#SBATCH --account=account_name


module purge
module load intel/19.1.2
module load anaconda3/2020.07
module load python/intel/3.8.6

cd /path/to/LLM-Reconfiguration/AutoTrain/Finetuned-Models/

# Print the SLURM job configurations
echo "SLURM Job Configuration:"
echo "Job ID: $SLURM_JOB_ID"
echo "Job Name: $SLURM_JOB_NAME"
echo "Node List: $SLURM_NODELIST"
echo "Number of Nodes: $SLURM_JOB_NUM_NODES"
echo "Number of Tasks: $SLURM_NTASKS"
echo "CPUs per Task: $SLURM_CPUS_PER_TASK"
echo "Memory per Node: $SLURM_MEM_PER_NODE"
echo "Time Limit: $SLURM_TIMELIMIT"
echo "Partition: $SLURM_JOB_PARTITION"
echo "Output File: $SLURM_JOB_OUT"

echo "Hardware Configuration"
echo "Processor: $(lscpu | grep 'Model name' | awk -F ':' '{print $2}' | xargs)"
echo "RAM: $(free -h | grep Mem: | awk '{print $4}')"
echo "GPU: $(nvidia-smi -q | grep 'Product Name')"

singularity exec --nv --overlay /path/to/pytorch-example/my_pytorch.ext3:ro /scratch/work/public/singularity/cuda12.3.2-cudnn9.0.0-ubuntu-22.04.4.sif /bin/bash -c \
            "source /ext3/env.sh;  python /path/toLLM-Reconfiguration/Model-Notebooks/llama3-notebooks/generate-metrics.py \
            --data_path /path/to/LLM-Reconfiguration/Dataset-Notebooks/train_files/train_33_69_84_nodes.csv \
            --model_id tiiuae/falcon-7b-instruct \
            --model_for_generation_path tiiuae/falcon-7b-instruct \
            --max_new_tokens 1200 \
            --filename_txt /path/to/LLM-Reconfiguration/Dataset-Notebooks/evaluations/metrics/metrics_file_name.txt\
            --filename_csv /path/to/LLM-Reconfiguration/Dataset-Notebooks/evaluations/responses/responses_file_name.csv\
            --num_samples 500 \
            --untrained True"
