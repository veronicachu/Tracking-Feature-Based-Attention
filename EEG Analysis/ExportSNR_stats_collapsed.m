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

%% All Trials
names = fieldnames(Data);
for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    TrialData = Data.(names{i}).TrialData;
    
    % Split each trial's EEG data into two 4s chunks
    EEG1 = SegmentedEEG(1:Fs*4,:,:);
    EEG2 = SegmentedEEG(Fs*4+1:Fs*8,:,:);
    badtrials = 0;
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG1,TrialData,actualfreq1,actualfreq2,badtrials);
    F1EEG(:,:,1:32) = redF1EEG;
    F1EEG(:,:,33:64) = greenF1EEG;
    F2EEG(:,:,1:32) = redF2EEG;
    F2EEG(:,:,33:64) = greenF2EEG;
    
    [redF1EEG(:,:,33:64),redF2EEG(:,:,33:64),greenF1EEG(:,:,33:64),greenF2EEG(:,:,33:64)] = extractTrialType(EEG2,TrialData,actualfreq1,actualfreq2,badtrials);
    F1EEG(:,:,65:96) = redF1EEG(:,:,33:64);
    F1EEG(:,:,97:128) = greenF1EEG(:,:,33:64);
    F2EEG(:,:,65:96) = redF2EEG(:,:,33:64);
    F2EEG(:,:,97:128) = greenF2EEG(:,:,33:64);
    
    % SNR
    [bin,F1SNR] = plotSSR_mod(F1EEG(:,[occpChans parietalChans],:),Fs,'snr',1,'snrwidth',4);
    [~,F2SNR] = plotSSR_mod(F2EEG(:,[occpChans parietalChans],:),Fs,'snr',1,'snrwidth',4);
    
    % Find freqs
    binF1 = find(bin == actualfreq1);
    binF1_2nd = find(bin == actualfreq1*2);
    
    binF2 = find(bin == actualfreq2);
    binF2_2nd = find(bin == actualfreq2*2);
    
    % Create subject's SNR table
    % Channel Column
    allChans = [occpChans parietalChans];
    for j = 1:length(allChans)
        chans{j,1} = chanNames{allChans(j)};
    end
    
    snrdata = table;
    snrdata.Subj = repmat(names{i},length(allChans),1);
    snrdata.Channels = chans;
    
    snrdata.F1Attended = F1SNR(binF1,:)';
    snrdata.F1Attended2 = F1SNR(binF1_2nd,:)';
    snrdata.F1Unattended = F1SNR(binF2,:)';
    snrdata.F1Unattended2 = F1SNR(binF2_2nd,:)';
    
    snrdata.F2Attended = F2SNR(binF2,:)';
    snrdata.F2Attended2 = F2SNR(binF2_2nd,:)';
    snrdata.F2Unattended = F2SNR(binF1,:)';
    snrdata.F2Unattended2 = F2SNR(binF1_2nd,:)';
    
    % Add subject's SNR table to all subject's struct
    SNRdata.(names{i}) = snrdata;
end

close all

%% Combine Tables from Each Struct
names = fieldnames(SNRdata);
allSNR = SNRdata.(names{1});
for i = 2:length(names)
    allSNR = [allSNR;SNRdata.(names{i})];
end

%% Save as mat file
disp('Saving data...')
save('SNRDataStats_collapsed','SNRdata','allSNR','-v7.3')

%% Save as CSV file
writetable(allSNR,'Final Data Files/SNRData_collapsed.csv')





