% load eeglab
addpath('/Users/au704655/Documents/Packages/eeglab14_0_0b')
eeglab; close all

%% import raw exg physio file & segment into rest/tasks
vmp1_filenames = dir('/Volumes/Seagate/Physio_VMP/data/Physio_data/EXG/VMP1/*.vhdr');
vmp2_filenames = dir('/Volumes/Seagate/Physio_VMP/data/Physio_data/EXG/VMP2/*.vhdr');
save_filepath = '/Volumes/Seagate/Physio_VMP/data/Physio_data/EXG/SegmentedEXG/';

%% separate first cohort (vmp1) into rest, loc & cwt
for n = 1:length(vmp1_filenames)
    % load brainvision data (EGG, respiration & plux) (vmp1)
    EEG = pop_loadbv(vmp1_filenames(n).folder, vmp1_filenames(n).name);

    % R128 trigger is sent regularly while scanning... use this to
    % determine the break between the resting-state scan, localiser & cwt
    % task scan 
    vol_events = [];
    for nn = 1:length(EEG.event)
        if EEG.event(nn).type == "R128"
            vol_events(end+1) = EEG.event(nn).latency; %find time of each R128 trigger
        end
    end
    idx = diff(vol_events) ~= 1400; % find when difference is not 1400 (indicates a gap between scans)
    [value,rest_loc_end_idx] = find(idx==1); 
    
    % for vmp1 rest, loc then cwt
    if length(rest_loc_end_idx) == 2
        rest_end_idx = rest_loc_end_idx(1); %indices of first break (end of resting state)
        loc_end_idx = rest_loc_end_idx(2); %indices of second break (end of localiser)
    
        % time of start/end of rest, localiser & cwt recordings
        rest_start = vol_events(1)/EEG.srate;
        rest_end = vol_events(rest_end_idx)/EEG.srate;
        loc_start = vol_events(rest_end_idx+1)/EEG.srate;
        loc_end = vol_events(loc_end_idx)/EEG.srate; 
        cwt_start = vol_events(loc_end_idx+1)/EEG.srate;
        cwt_end = vol_events(end)/EEG.srate;
        
        % select rest, localiser & cwt task separately
        EEG_rest = pop_select( EEG,'time',[rest_start rest_end] );
        EEG_loc = pop_select( EEG,'time',[loc_start loc_end] );
        EEG_cwt= pop_select( EEG,'time',[cwt_start cwt_end] );
        
        % save each recording
        EEG_rest.setname = sprintf('%s',extractBefore(vmp1_filenames(n).name,'.vhdr'));
        EEG_rest.filename = sprintf('%s_rest.set',extractBefore(vmp1_filenames(n).name,'.vhdr'));
        EEG_rest.filepath = convertCharsToStrings(save_filepath);
        pop_saveset(EEG_rest,'filename', EEG_rest.filename, 'filepath', save_filepath);
    
        EEG_loc.setname = sprintf('%s',extractBefore(vmp1_filenames(n).name,'.vhdr'));
        EEG_loc.filename = sprintf('%s_loc.set',extractBefore(vmp1_filenames(n).name,'.vhdr'));
        EEG_loc.filepath = convertCharsToStrings(save_filepath);
        pop_saveset(EEG_loc, 'filename', EEG_loc.filename, 'filepath', save_filepath);
    
        EEG_cwt.setname = sprintf('%s',extractBefore(vmp1_filenames(n).name,'.vhdr'));
        EEG_cwt.filename = sprintf('%s_cwt.set',extractBefore(vmp1_filenames(n).name,'.vhdr'));
        EEG_cwt.filepath = convertCharsToStrings(save_filepath);
        pop_saveset(EEG_cwt, 'filename', EEG_cwt.filename, 'filepath', save_filepath);

    else
        sprintf('%s cannot separate into 3 segments (more of less timing gaps)', vmp1_filenames(n).name)
    end

    clearvars -except n vmp1_filenames vmp2_filenames save_filepath
end

%% separate second cohort (vmp2) into rest & film
for n = 1:length(vmp2_filenames)
    % load brainvision data (EGG, respiration & plux) (vmp1)
    EEG = pop_loadbv(vmp2_filenames(n).folder, vmp2_filenames(n).name);
    
    % R128 trigger is sent regularly while scanning... use this to
    % determine the break between the resting-state scan, localiser & cwt
    % task scan 
    vol_events = [];
    for nn = 1:length(EEG.event)
        if EEG.event(nn).type == "R128"
            vol_events(end+1) = EEG.event(nn).latency; %find time of each R128 trigger
        end
    end
    idx = diff(vol_events) ~= 1400; % find when difference is not 1400 (indicates a gap between scans)
    [value,rest_loc_end_idx] = find(idx==1); 

    % for vmp2 rest then movie 
    if length(rest_loc_end_idx) == 1
        rest_end_idx = rest_loc_end_idx(1); %indices of first break (end of resting state)

        % time of start/end of rest, & movie recordings
        rest_start = vol_events(1)/EEG.srate;
        rest_end = vol_events(rest_end_idx)/EEG.srate;
        movie_start = vol_events(rest_end_idx+1)/EEG.srate;
        movie_end = vol_events(end)/EEG.srate; 

        % select rest & movie task separately
        EEG_rest = pop_select( EEG,'time',[rest_start rest_end] );
        EEG_movie = pop_select( EEG,'time',[movie_start movie_end] );
        
        % save each recording
        EEG_rest.setname = sprintf('%s',extractBefore(vmp2_filenames(n).name,'.vhdr'));
        EEG_rest.filename = sprintf('%s_rest.set',extractBefore(vmp2_filenames(n).name,'.vhdr'));
        EEG_rest.filepath = convertCharsToStrings(save_filepath);
        pop_saveset(EEG_rest,'filename', EEG_rest.filename, 'filepath', save_filepath);
    
        EEG_movie.setname = sprintf('%s',extractBefore(vmp2_filenames(n).name,'.vhdr'));
        EEG_movie.filename = sprintf('%s_movie.set',extractBefore(vmp2_filenames(n).name,'.vhdr'));
        EEG_movie.filepath = convertCharsToStrings(save_filepath);
        pop_saveset(EEG_movie, 'filename', EEG_movie.filename, 'filepath', save_filepath);
        
        else
        sprintf('%s cannot separate into 2 segments (more of less timing gaps)', vmp2_filenames(n).name)
    end

    clearvars -except n vmp1_filenames vmp2_filenames save_filepath
end
