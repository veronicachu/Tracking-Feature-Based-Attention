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
RF1SNR = NaN(200,length(targChans),32);
RF2SNR = NaN(200,length(targChans),32);
GF1SNR = NaN(200,length(targChans),32);
GF2SNR = NaN(200,length(targChans),32);

for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    TrialData = Data.(names{i}).TrialData;
    
    % Split EEG data in half
%     EEG = SegmentedEEG(1:end-Fs*1,:,:);
    EEG = SegmentedEEG(Fs*2:end-Fs-1,:,:);
    badtrials = 0;
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);
    
    % Calculate SNR
    for j = 1:size(redF1EEG,3)
        [bin,RF1SNR(:,:,j)] = plotFFT_mod(redF1EEG(:,targChans,j),Fs,'snr',1,'snrwidth',4);
        [~,RF2SNR(:,:,j)] = plotFFT_mod(redF2EEG(:,targChans,j),Fs,'snr',1,'snrwidth',4);
        [~,GF1SNR(:,:,j)] = plotFFT_mod(greenF1EEG(:,targChans,j),Fs,'snr',1,'snrwidth',4);
        [~,GF2SNR(:,:,j)] = plotFFT_mod(greenF2EEG(:,targChans,j),Fs,'snr',1,'snrwidth',4);
    end
    
    FFTData.(names{i}).bin = bin;
    FFTData.(names{i}).RF1SNR = RF1SNR;
    FFTData.(names{i}).RF2SNR = RF2SNR;
    FFTData.(names{i}).GF1SNR = GF1SNR;
    FFTData.(names{i}).GF2SNR = GF2SNR;
    
end


%% Save as mat file
disp('Saving data...')
save('SNRDataTrials_topchan','FFTData','-v7.3')

%% Correct Trials Only
names = fieldnames(Data);
% Pre-allocate matricies
RF1SNR = NaN(200,length(targChans),32);
RF2SNR = NaN(200,length(targChans),32);
GF1SNR = NaN(200,length(targChans),32);
GF2SNR = NaN(200,length(targChans),32);

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
    
    % Calculate SNR
    for j = 1:size(redF1EEG,3)
        [bin,RF1SNR_correct(:,:,j)] = plotFFT_mod(redF1EEG(:,targChans,j),Fs,'snr',1,'snrwidth',4);
    end
    for j = 1:size(redF2EEG,3)
        [~,RF2SNR_correct(:,:,j)] = plotFFT_mod(redF2EEG(:,targChans,j),Fs,'snr',1,'snrwidth',4);
    end
    for j = 1:size(greenF1EEG,3)
        [~,GF1SNR_correct(:,:,j)] = plotFFT_mod(greenF1EEG(:,targChans,j),Fs,'snr',1,'snrwidth',4);
    end
    for j = 1:size(greenF2EEG,3)
        [~,GF2SNR_correct(:,:,j)] = plotFFT_mod(greenF2EEG(:,targChans,j),Fs,'snr',1,'snrwidth',4);
    end
    
    FFTData.(names{i}).bin = bin;
    FFTData.(names{i}).RF1SNR = RF1SNR_correct;
    FFTData.(names{i}).RF2SNR = RF2SNR_correct;
    FFTData.(names{i}).GF1SNR = GF1SNR_correct;
    FFTData.(names{i}).GF2SNR = GF2SNR_correct;
end

%% Save as mat file
disp('Saving data...')
save('SNRDataTrials_topchan_correct','FFTData','-v7.3')



