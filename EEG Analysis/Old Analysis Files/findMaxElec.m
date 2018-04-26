clear;
subjnum = '301';

eegfile = sprintf('Segmented Data Files/%s_SegmentedEEG.mat',subjnum);
% eegfile = sprintf('Cleaned Data Files/%s_CleanedEEG.mat',subjnum);
load(eegfile)

behfile = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP HUD Analyses/Behavioral Analysis/%s_ColorData.mat',subjnum);
load(behfile);

actualfreq1 = 7.5;
actualfreq2 = 12.5;

EEG = SegmentedEEG;
% EEG = eegica.data(1024:end-1,:,:);

%% Segment by condition
[redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);

%% Chunk trials in each  condition
redF1 = ChunkTrials(redF1EEG,Fs);
redF2 = ChunkTrials(redF2EEG,Fs);
greenF1 = ChunkTrials(greenF1EEG,Fs);
greenF2 = ChunkTrials(greenF2EEG,Fs);

%% 
parietalChans = [29 55:58 63:64];
occpChans = 30:32;

%%

for i = 1:length(occpChans)
    a = occpChans(i);
    plotSSR(EEG(:,a,:),Fs)
    disp(a)
    pause;
end

for i = 1:length(parietalChans)
    a = parietalChans(i);
    plotSSR(EEG(:,a,:),Fs)
    disp(a)
    pause;
end

%% 
