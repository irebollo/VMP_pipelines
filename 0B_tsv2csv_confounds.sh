cd /mnt/fast_scratch/StomachBrain/data/allpreprocRest/
for file in *.tsv
do
    python /home/ignacio/vmp_pipelines_gastro/0B_tsv2csv.py < $file > ${file%.*}.csv
done