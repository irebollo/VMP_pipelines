#!/bin/bash

# Set the source and destination directories
src_dir='/mnt/slow_scratch/BIDS/derivatives/fmriprep/'
dst_dir='/mnt/fast_scratch/StomachBrain/data/allpreprocRest'

# Find all files matching the pattern *desc-preproc_bold.nii.gz in the source directory
files=$(find $src_dir -name "*ses-session1_task-rest_run-001_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz")

# Print the list of files found matching the pattern
echo "Found the following files:"
echo "$files"

# Print the total number of files found
num_files=$(echo "$files" | wc -l)
echo "Total number of files: $num_files"

# Copy each file to the destination directory
for file in $files; do
  if [ ! -f "$dst_dir/$(basename $file)" ]; then
    echo "Copying $(basename $file) to $dst_dir"
    cp -v $file $dst_dir
  else
    echo "File $(basename $file) already exists in $dst_dir"
  fi
done

# Print a message indicating that the files have been copied
echo "All files have been copied to $dst_dir"



files=$(find $src_dir -name "*ses-session1_task-loc_run-001_space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz")

# Print the list of files found matching the pattern
echo "Found the following files:"
echo "$files"

# Print the total number of files found
num_files=$(echo "$files" | wc -l)
echo "Total number of files: $num_files"

# Copy each file to the destination directory
for file in $files; do
  if [ ! -f "$dst_dir/$(basename $file)" ]; then
    echo "Copying $(basename $file) to $dst_dir"
    cp -v $file $dst_dir
  else
    echo "File $(basename $file) already exists in $dst_dir"
  fi
#  echo "Copying $(basename $file) to $dst_dir"
#  cp -v $file $dst_dir
done

# Print a message indicating that the files have been copied
echo "All files have been copied to $dst_dir"


# Find all files matching the pattern *desc-preproc_bold.nii.gz in the source directory
#files=$(find $src_dir -name "*ses-session1_task-rest_run-001_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz")
files=$(find $src_dir -name "*task-rest_run-001_desc-confounds_timeseries.tsv")
# Print the list of files found matching the pattern
echo "Found the following files:"
echo "$files"

# Print the total number of files found
num_files=$(echo "$files" | wc -l)
echo "Total number of files: $num_files"

# Copy each file to the destination directory
for file in $files; do
  if [ ! -f "$dst_dir/$(basename $file)" ]; then
    echo "Copying $(basename $file) to $dst_dir"
    cp -v $file $dst_dir
  else
    echo "File $(basename $file) already exists in $dst_dir"
  fi
  echo "Copying $(basename $file) to $dst_dir"
  cp -v $file $dst_dir
done

# Print a message indicating that the files have been copied
echo "All files have been copied to $dst_dir"