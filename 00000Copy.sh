# Set the source and destination directories
#!/bin/bash

# Set the source and destination directories
src_dir='/mnt/slow_scratch/BIDS/derivatives/fmriprep/'
dst_dir='/mnt/fast_scratch/StomachBrain/data/allpreprocRest'

# Read the list of clean subjects from the file and add the "sub-" prefix to each subject
subjects=$(sed 's/^/sub-/' list_clean_subjects.txt)

# Find all files matching the pattern *desc-preproc_bold.nii.gz in the source directory, filtered by the list of clean subjects
bold_files=$(find $src_dir -name "*ses-session1_task-rest_run-001_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz" | grep -F "$subjects")

# Print the list of bold files found matching the pattern and filtered by the list of clean subjects
echo "Found the following bold files:"
echo "$bold_files"

# Find all files matching the pattern *desc-brain_mask.nii.gz in the source directory, filtered by the list of clean subjects
mask_files=$(find $src_dir -name "*ses-session1_task-loc_run-001_space-MNI152NLin2009cAsym_desc-brain_mask.nii.gz" | grep -F "$subjects")

# Print the list of mask files found matching the pattern and filtered by the list of clean subjects
echo "Found the following mask files:"
echo "$mask_files"

# Find all files matching the pattern *confounds_timeseries.tsv in the source directory, filtered by the list of clean subjects
conf_files=$(find $src_dir -name "*ses-session1_task-rest_run-001_desc-confounds_timeseries.tsv" | grep -F "$subjects")

# Print the list of confounds files found matching the pattern and filtered by the list of clean subjects
echo "Found the following confounds files:"
echo "$conf_files"

# Print the total number of files found
num_files=$(echo "$bold_files" "$mask_files" "$conf_files" | tr ' ' '\n' | wc -l)
echo "Total number of files: $num_files"

# Define the rsync command
rsync_cmd="rsync -a --progress --compress-level=9 --partial --partial-dir=${dst_dir}/.rsync-tmp"

# Copy each file to the destination directory using rsync
for file in $bold_files $mask_files $conf_files; do
  if [ ! -f "$dst_dir/$(basename $file)" ]; then
    echo "Copying $(basename $file) to $dst_dir"
    $rsync_cmd $file $dst_dir &
  else
    echo "File $(basename $file) already exists in $dst_dir"
  fi
done

# Wait for all rsync processes to finish
wait

# Print a message indicating that the files have been copied
echo "All files have been copied to $dst_dir"
