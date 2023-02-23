#!/bin/bash
subjects=(`echo {0022..0639}`)  # Set the subject ID to process here 
BIDS_path="/mnt/scratch/BIDS/"

for sub in ${subjects[@]}; do

    echo "${BIDS_path}sub-${sub}"
    sbatch mpms-singleSubject.sh $sub

done