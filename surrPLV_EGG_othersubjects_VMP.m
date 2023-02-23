function surrPLV_EGG_othersubjects_VMP(iSubj)
    

addpath(genpath('/home/ignacio/vmp_pipelines_gastro/StomachBrain_2021'))
addpath('/home/ignacio/fieldtrip/');
ft_defaults
    
tic

cfgMain = global_getcfgmain;
subject_list = load('/home/ignacio/vmp_pipelines_gastro/list_clean_subjects.txt');
subj_idx = subject_list(iSubj)
dataDir=[global_path2root,'fMRI_timeseries/sub-',sprintf('%.4d',subj_idx),'/']
plotDir = dataDir;

filename_brain_mask = [dataDir,'sub-',sprintf('%.4d',subj_idx),'_brainmask_3mmV.nii']
insideBrain= logical(niftiread(filename_brain_mask));


% subjects which are not this subject
surrogatePLVmatrix = zeros(length(subject_list)-1,sum(insideBrain(:)==1));

% load BOLD of subject unfiltered
filename_bold_input = [dataDir,'sub-',sprintf('%.4d',subj_idx),'BOLD_filtered_fullband_CSFREGRESSED']; 

load(filename_bold_input)

%% Start loop randomization
subjListForAnalysis = subject_list~= subj_idx;
SurrogateSubjectList = subject_list(subjListForAnalysis);
for iSurrogateSubject = 1:(length(subject_list)-1)

    currentSurrogateSubject = SurrogateSubjectList(iSurrogateSubject)
% load EGG first other subject

% SubjectDataRoot = [global_path2root,'subject',sprintf('%.4d',subj_idx),filesep,'Timeseries',filesep];
EGGPhaseXVolumeFilename = ['/mnt/fast_scratch/StomachBrain/data/EGG_preproc/'...
    ,sprintf('%.4d',currentSurrogateSubject),'_EGGPhaseXVolume.mat'];
load(EGGPhaseXVolumeFilename)
mostPowerfullFrequency = logEGGpreprocessing.mostPowerfullFrequency;
EGGPhaseXVolumeFilename
mostPowerfullFrequency
%{
%Filter
centerFrequency = mostPowerfullFrequency; %
filter_frequency_spread=cfgMain.frequencySpread/1000; % In hz
sr = 0.5; % 1 TR = 2s
filterOrder=(cfgMain.fOrder*fix(sr/(centerFrequency-filter_frequency_spread))-1);%in nsamples
transition_width= cfgMain.transitionWidth/100; % in normalised units
filteredMRI=tools_bpFilter(error_csf_z,sr,filterOrder,centerFrequency,filter_frequency_spread,transition_width,cfgMain.filterType);
phaseMRI = hilbert(filteredMRI);
phaseMRI = angle(phaseMRI(cfgMain.beginCut:cfgMain.endCut,:)); % Cut data to have the same length as EGG (cut this way to get rid of fmri edge artifact on EGG)

clear filteredMRI
empPLV = abs (mean (exp (1i* (bsxfun (@minus , phaseMRI, angle (phaseXVolume)'))))); % get PLV
% clear other variables
clear  phaseMRI
% store PLV in surrogate PLV matrix
surrogatePLVmatrix(iSurrogateSubject,:) = empPLV;

%}
end




%% store
filename_allSurrogates = strcat(dataDir,'distribution_sPLV_s',sprintf('%.4d',subj_idx),'.mat')
save(filename_allSurrogates,'surrogatePLVmatrix')
median_sPLV = median(surrogatePLVmatrix);
surrPLV = zeros (66,78,66); % empty 3d Volume for storing empirical PLV
surrPLV = surrPLV(:); % transformed into a vector
surrPLV(insideBrain) = median_sPLV; % get PLV
PLV3D = reshape(surrPLV,66,78,66); % reshape it from vector to matrix
filename_medianSurrogate  = strcat(dataDir,'median_sPLV_s',sprintf('%.4d',subj_idx),'.nii')

tools_writeMri(PLV3D,filename_medianSurrogate)

toc


if cfgMain.savePlots == 1
    plotFilename = strcat(plotDir,'median_sPLV_s',sprintf('%.4d',subj_idx));
    voxelCoordinates = sub2ind([66,78,66],34,17,29);
    voxelCoordinates_inside = zeros(66*78*66,1);
    voxelCoordinates_inside(voxelCoordinates)=1;
    voxelCoordinates_inside = voxelCoordinates_inside(insideBrain);
    ind_voxelCoordinates_inside = find(voxelCoordinates_inside);
    
    if cfgMain.plotFigures == 0;
        SanityPlot = figure('visible','off');
    else
        SanityPlot = figure('visible','on');
    end
    
    % Plot histogram of PLV across the brain
    
    nhist(median_sPLV(insideBrain))
    xlabel('PLV')
    title(['S',sprintf('%.2d',subj_idx),32,'surrogatePLV across bain. Mean:' num2str(mean(median_sPLV(insideBrain))) ' rSS voxel:' 32 num2str(median_sPLV(insideBrain(ind_voxelCoordinates_inside)))],'fontsize',18)
    
    
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    set(gcf, 'PaperPositionMode', 'auto');
    print ('-dpng', '-painters', eval('plotFilename'))

      
    end
    
end