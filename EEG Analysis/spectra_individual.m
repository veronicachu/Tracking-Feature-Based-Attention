clear;
subjnum = 302;

% eegfile = sprintf('Segmented Data Files/S%d/S%d-Cond%d_SegmentedEEG.mat',subjnum,subjnum,condnum);
eegfile = sprintf('Segmented Data Files/S%d/S%d_SegmentedEEG.mat',subjnum,subjnum);
load(eegfile)

% behfile = sprintf('../Behavioral Analysis/%d_TrialData_Cond%d.mat',subjnum,condnum);
behfile = sprintf('../Behavioral Analysis/S%d_TrialData.mat',subjnum);
load(behfile);

freqs = [12 15];
Fs = 1024;

%%
EEG = SegmentedEEG(Fs*1:Fs*5-1,:,:);
badtrials = 0;

%% Separate by condition
[trialsepData] = extractTrialType(EEG,TrialData,freqs);

%% 
rightRF1.data = trialsepData.rightRF1EEG;
rightRF1.sr = Fs;
RRF1 = cortspectra(rightRF1);

rightRF2.data = trialsepData.rightRF2EEG;
rightRF2.sr = Fs;
RRF2 = cortspectra(rightRF2);

leftLF1.data = trialsepData.leftLF1EEG;
leftLF1.sr = Fs;
LLF1 = cortspectra(leftLF1);

leftLF2.data = trialsepData.leftLF2EEG;
leftLF2.sr = Fs;
LLF2 = cortspectra(leftLF2);





