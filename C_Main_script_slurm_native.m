function C_Main_script_slurm(iSubj)

addpath(genpath('/home/ignacio/vmp_pipelines_gastro/StomachBrain_2021'))
addpath('/home/ignacio/fieldtrip/');
ft_defaults
cfgMain=global_getcfgmain;


allSubjs=load('/home/ignacio/vmp_pipelines_gastro/list_clean_subjects.txt');
%allSubjs=load('/home/ignacio/vmp_pipelines_gastro/list_clean_subjects_redo.txt');

subj_idx=allSubjs(iSubj)


%timeseries_gastropipeline_native(subj_idx,cfgMain)
%timeseries_gastropipeline_acompcor_native(subj_idx,cfgMain)
timeseries_gastropipeline_3mm(subj_idx,cfgMain)

end