#!/bin/bash  
#SBATCH --array=0-38 #specify how many times you want a job to run, we have a total of 7 array spaces
# everything below this line is optional, but are nice to have quality of life things  
#SBATCH --output=logs/Slice%A_%a.out
#SBATCH --error=logs/Slice%A_%a.err
#SBATCH --job-name=Slice  # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers

# under this line, we can load any modules if necessary
#Make slurm launch jobs in parallel
#SBATCH --ntasks=10
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0-00:30:00
#below this line is where we can place our commands, in this case it will just simply output the task ID of the array  
echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
python reslice_brainmask_redo.py $SLURM_ARRAY_TASK_ID
