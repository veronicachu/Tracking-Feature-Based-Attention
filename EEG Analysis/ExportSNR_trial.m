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
topChans = [21 22 49 16 30 32 31 29 26 53];
targChans = [topChans];

%% All Trials
names = fieldnames(Data);
% Pre-allocate matricies
RF1SNR = NaN(400,length(targChans),32);
RF2SNR = NaN(400,length(targChans),32);
GF1SNR = NaN(400,length(targChans),32);
GF2SNR = NaN(400,length(targChans),32);

for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    TrialData = Data.(names{i}).TrialData;
    
    % Split EEG data in half
    EEG = SegmentedEEG(1:Fs*8,:,:);
%     EEG1 = SegmentedEEG(1:Fs*4,:,:);
%     EEG2 = SegmentedEEG(Fs*4+1:Fs*8,:,:);
    badtrials = 0;
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);
%     [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG1,TrialData,actualfreq1,actualfreq2,badtrials);
%     [redF1EEG(:,:,33:64),redF2EEG(:,:,33:64),greenF1EEG(:,:,33:64),greenF2EEG(:,:,33:64)] = extractTrialType(EEG2,TrialData,actualfreq1,actualfreq2,badtrials);
    
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
save('SNRDataTrials_fulllength_topchans','FFTData','-v7.3')

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
    EEG1 = SegmentedEEG(1:Fs*4,:,:);
    EEG2 = SegmentedEEG(Fs*4+1:Fs*8,:,:);
    
    % Separate out incorrect trials
    badtrials = find(TrialData.Correct == 0);
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG1,TrialData,actualfreq1,actualfreq2,badtrials);
    sizeRF1 = size(redF1EEG,3);
    sizeRF2 = size(redF2EEG,3);
    sizeGF1 = size(greenF1EEG,3);
    sizeGF2 = size(greenF2EEG,3);
    
    [redF1EEG(:,:,sizeRF1+1:sizeRF1*2),redF2EEG(:,:,sizeRF2+1:sizeRF2*2),greenF1EEG(:,:,sizeGF1+1:sizeGF1*2),greenF2EEG(:,:,sizeGF2+1:sizeGF2*2)]...
        = extractTrialType(EEG2,TrialData,actualfreq1,actualfreq2,badtrials);
    
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
save('SNRDataTrials_fulllength_topchans_correct','FFTData','-v7.3')



