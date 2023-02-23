#!/bin/bash
#SBATCH --nodes=1					                            # Requires a single node
#SBATCH --ntasks=1					                            # Run a single serial task
#SBATCH --cpus-per-task=8
#SBATCH --mem=16gb
#SBATCH --time=01:00:00				                            # Time limit hh:mm:ss
#SBATCH -e /mnt/scratch/jobs/mpm/error_mpm_maps-%A.log	            # Log error
#SBATCH -o /mnt/scratch/jobs/mpm/output_mpm_maps-%A.log	            # Lg output
#SBATCH --job-name=mpm_maps      			                    # Descriptive job name
##### END OF JOB DEFINITION  #####


matlab -batch "mpm_analysis_batch_nonpar_singleSub(${1})"
