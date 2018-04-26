clear;

%% Grab each subject's EEG data
cd ('Segmented Data Files')
files = dir;
nFiles = length(files);
subfiles = {files.name};

% Find all subfolders in 'Segmented Data Files'
a = 1;
for i = 1:length(subfiles)
    if ~isempty(cell2mat(strfind(subfiles(i),'SegmentedEEG')))
        subjs{a} = subfiles{i};
        a = a + 1;
    end
end

% Go into each subfolder to get subject's data and place into struct
disp('Creating EEG struct...')
for i = 1:length(subjs)
    fprintf('Grabbing %s...\n',subjs{i})
    subjnum = subjs{i}(1:end-17);
    load(sprintf('%s_SegmentedEEG.mat',subjnum));
    name = sprintf('S%s',subjnum);
    Data.(name).SegmentedEEG = SegmentedEEG;
    Data.(name).PCData = PCData;
    Data.(name).PreSegmentedEEG = PreSegmentedEEG;
    Data.(name).PrePCData = PrePCData;
    Data.(name).badtrials = badtrials;
end
cd ..

%% Grab each subject's Behavioral data
cd ('../Behavioral Analysis')
files = dir;
subfiles = {files.name};

% Find all subfolders in 'Segmented Data Files'
a = 1;
subjs = cell(1,length(subfiles)-3);     % -3 hard coded
for i = 1:length(subfiles)
    if ~isempty(cell2mat(strfind(subfiles(i),'ColorData')))
        subjs{a} = subfiles{i};
        a = a + 1;
    end
end

% Get subject's data and place into struct
disp('Creating Behavioral struct...')
for i = 1:length(subjs)
    fprintf('Grabbing %s...\n',subjs{i})
    subjnum = subjs{i}(1:3);
    load(sprintf('%s_ColorData.mat',subjnum));
    name = sprintf('S%s',subjnum);
    Data.(name).TrialData = TrialData;
end

cd ('../EEG Analysis')

%%

disp('Saving data...')
save('AllSubjData2','Data','-v7.3')