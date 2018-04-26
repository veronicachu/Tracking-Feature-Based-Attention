clear;
load('AllSubjData.mat')

%%
load('ANTWAVE64')
chanNames = ANTWAVE64.ChanNames;
Fs = 1024;

% Frequencies of Interest
actualfreq1 = 12.5;
actualfreq2 = 18.75;

% Channels of Interest
parietalChans = [29 55:58 63:64];
occpChans = 30:32;
topChans = [49 16 30:32 28 58 64 29 26];
targChans = [topChans];

%% All Trials
names = fieldnames(Data);

% Pre-allocate matricies
RF1SNR = zeros(216,length(targChans),length(names));
RF2SNR = zeros(216,length(targChans),length(names));
GF1SNR = zeros(216,length(targChans),length(names));
GF2SNR = zeros(216,length(targChans),length(names));

for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    TrialData = Data.(names{i}).TrialData;
    
    % Split EEG data in half
    EEG = SegmentedEEG(Fs*2:end-Fs-1,:,:);
    badtrials = 0;
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);
    
    % Calculate SNR
    [bin,RF1SNR(:,:,i)] = plotSSR_mod(redF1EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,RF2SNR(:,:,i)] = plotSSR_mod(redF2EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF1SNR(:,:,i)] = plotSSR_mod(greenF1EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF2SNR(:,:,i)] = plotSSR_mod(greenF2EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
end

close all

%% Save as mat file
disp('Saving data...')
save('SNRData_topchan','bin','targChans','RF1SNR','RF2SNR','GF1SNR','GF2SNR')

%% Correct Trials Only
names = fieldnames(Data);
for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    TrialData = Data.(names{i}).TrialData;
    
    % Split each trial's EEG data into two 4s chunks
    EEG = SegmentedEEG(Fs*2:end-Fs-1,:,:);
    
    % Separate out incorrect trials
    badtrials = find(TrialData.Correct == 0);
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);
    
    % SNR
    [bin,RF1SNR(:,:,i)] = plotSSR_mod(redF1EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,RF2SNR(:,:,i)] = plotSSR_mod(redF2EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF1SNR(:,:,i)] = plotSSR_mod(greenF1EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF2SNR(:,:,i)] = plotSSR_mod(greenF2EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
end

close all

%% Save as mat file
disp('Saving data...')
save('SNRData_topchan_correct','bin','targChans','RF1SNR','RF2SNR','GF1SNR','GF2SNR')



