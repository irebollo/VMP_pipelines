

addpath(genpath('/home/ignacio/vmp_pipelines_gastro/StomachBrain_2021'))
addpath('/home/ignacio/fieldtrip/');
ft_defaults

cfgMain=global_getcfgmain
%% cfgMain parameters used in the script 
subjects=load('/home/ignacio/vmp_pipelines_gastro/list_prepro_subjects.txt')

numrandomization =cfgMain.numberofrandomizations;
clusterAlpha = cfgMain.clusterAlpha;

empirical = zeros(length(subjects),339768); % Preallocate
surrogate = empirical; % for calculating t value

for iS=1:length(subjects)
    subj_idx = subjects(iS);


    dataDir=[global_path2root,'fMRI_timeseries/sub-',sprintf('%.4d',subj_idx),'/']

    filenamePLV = strcat(dataDir,'sub-',sprintf('%.4d',subj_idx),'_PLVxVoxel_3mm.nii.gz');

    % Load empirical PLV  
    
    PLVGroupEmpirical{iS} = ft_read_mri(filenamePLV); % Put into cell
    PLVGroupEmpirical{iS}.Nsubject = subjects(iS);
    
    % Preparing the FieldTrip structure needed for randomization     
    PLVGroupEmpirical{iS}.coh = PLVGroupEmpirical{iS}.anatomy; 
    PLVGroupEmpirical{iS} = rmfield(PLVGroupEmpirical{iS},'anatomy');
      
    empirical(iS,:) = PLVGroupEmpirical{iS}.coh(:);
    
end

empirical_mean=mean(empirical,1);
empirical_3d=reshape(empirical_mean,66,78,66);
niftiwrite(empirical_3d,'/mnt/fast_scratch/StomachBrain/data/groupresults/empirical_mean.nii.gz')