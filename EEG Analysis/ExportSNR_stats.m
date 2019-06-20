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
for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    TrialData = Data.(names{i}).TrialData;
    
    % Split each trial's EEG data into two 4s chunks
    EEG1 = SegmentedEEG(1:Fs*8,:,:);
%     EEG1 = SegmentedEEG(1:Fs*4,:,:);
%     EEG2 = SegmentedEEG(Fs*4+1:Fs*8,:,:);
    
    % Segment by condition
    badtrials = 0;
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG1,TrialData,actualfreq1,actualfreq2,badtrials);
%     [redF1EEG(:,:,33:64),redF2EEG(:,:,33:64),greenF1EEG(:,:,33:64),greenF2EEG(:,:,33:64)] = extractTrialType(EEG2,TrialData,actualfreq1,actualfreq2,badtrials);

    % SNR
    [bin,RF1SNR] = plotSSR_mod(redF1EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,RF2SNR] = plotSSR_mod(redF2EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF1SNR] = plotSSR_mod(greenF1EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF2SNR] = plotSSR_mod(greenF2EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    
    % Find freqs
    binF1 = find(bin == actualfreq1);
    binF1_2nd = find(bin == actualfreq1*2);
    
    binF2 = find(bin == actualfreq2);
    binF2_2nd = find(bin == actualfreq2*2);
    
    % Create subject's SNR table
    % Channel Column
    for j = 1:length(targChans)
        chans{j,1} = chanNames{targChans(j)};
    end
    
    snrdata = table;
    snrdata.Subj = repmat(names{i},length(targChans),1);
    snrdata.Channels = chans;
    
    snrdata.RF1BinMean = mean(RF1SNR(17:200,:),1)';
    snrdata.RF1Attended = RF1SNR(binF1,:)';
    snrdata.RF1Attended2 = RF1SNR(binF1_2nd,:)';
    snrdata.RF1Unattended = RF1SNR(binF2,:)';
    snrdata.RF1Unattended2 = RF1SNR(binF2_2nd,:)';
    
    snrdata.RF2BinMean = mean(RF2SNR(17:200,:),1)';
    snrdata.RF2Attended = RF2SNR(binF2,:)';
    snrdata.RF2Attended2 = RF2SNR(binF2_2nd,:)';
    snrdata.RF2Unattended = RF2SNR(binF1,:)';
    snrdata.RF2Unattended2 = RF2SNR(binF1_2nd,:)';
    
    snrdata.GF1Mean = mean(GF1SNR(17:200,:),1)';
    snrdata.GF1Attended = GF1SNR(binF1,:)';
    snrdata.GF1Attended2 = GF1SNR(binF1_2nd,:)';
    snrdata.GF1Unattended = GF1SNR(binF2,:)';
    snrdata.GF1Unattended2 = GF1SNR(binF2_2nd,:)';
    
    snrdata.GF2Mean = mean(GF2SNR(17:200,:),1)';
    snrdata.GF2Attended = GF2SNR(binF2,:)';
    snrdata.GF2Attended2 = GF2SNR(binF2_2nd,:)';
    snrdata.GF2Unattended = GF2SNR(binF1,:)';
    snrdata.GF2Unattended2 = GF2SNR(binF1_2nd,:)';
    
    % Add subject's SNR table to all subject's struct
    SNRdata.(names{i}) = snrdata;
end

%% Correct Trials Only
names = fieldnames(Data);
for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    TrialData = Data.(names{i}).TrialData;
    
    % Split each trial's EEG data into two 4s chunks
    EEG1 = SegmentedEEG(1:Fs*8,:,:);
%     EEG1 = SegmentedEEG(1:Fs*4,:,:);
%     EEG2 = SegmentedEEG(Fs*4+1:Fs*8,:,:);
    
    % Separate out incorrect trials
    badtrials = find(TrialData.Correct == 0);
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG1,TrialData,actualfreq1,actualfreq2,badtrials);
%     sizeRF1 = size(redF1EEG,3);
%     sizeRF2 = size(redF2EEG,3);
%     sizeGF1 = size(greenF1EEG,3);
%     sizeGF2 = size(greenF2EEG,3);
%     
%     [redF1EEG(:,:,sizeRF1+1:sizeRF1*2),redF2EEG(:,:,sizeRF2+1:sizeRF2*2),greenF1EEG(:,:,sizeGF1+1:sizeGF1*2),greenF2EEG(:,:,sizeGF2+1:sizeGF2*2)]...
%         = extractTrialType(EEG2,TrialData,actualfreq1,actualfreq2,badtrials);
    
    % SNR
    [bin,RF1SNR] = plotSSR_mod(redF1EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,RF2SNR] = plotSSR_mod(redF2EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF1SNR] = plotSSR_mod(greenF1EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF2SNR] = plotSSR_mod(greenF2EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    
    % Find freqs
    binF1 = find(bin == actualfreq1);
    binF1_2nd = find(bin == actualfreq1*2);
    
    binF2 = find(bin == actualfreq2);
    binF2_2nd = find(bin == actualfreq2*2);
    
    % Create subject's SNR table
    % Channel Column
    for j = 1:length(targChans)
        chans{j,1} = chanNames{targChans(j)};
    end
    
    snrdata_correct = table;
    snrdata_correct.Subj = repmat(names{i},length(targChans),1);
    snrdata_correct.Channels = chans;
    
    snrdata_correct.RF1BinMean = mean(RF1SNR(17:200,:),1)';
    snrdata_correct.RF1Attended = RF1SNR(binF1,:)';
    snrdata_correct.RF1Attended2 = RF1SNR(binF1_2nd,:)';
    snrdata_correct.RF1Unattended = RF1SNR(binF2,:)';
    snrdata_correct.RF1Unattended2 = RF1SNR(binF2_2nd,:)';
    
    snrdata_correct.RF2BinMean = mean(RF2SNR(17:200,:),1)';
    snrdata_correct.RF2Attended = RF2SNR(binF2,:)';
    snrdata_correct.RF2Attended2 = RF2SNR(binF2_2nd,:)';
    snrdata_correct.RF2Unattended = RF2SNR(binF1,:)';
    snrdata_correct.RF2Unattended2 = RF2SNR(binF1_2nd,:)';
    
    snrdata_correct.GF1Mean = mean(GF1SNR(17:200,:),1)';
    snrdata_correct.GF1Attended = GF1SNR(binF1,:)';
    snrdata_correct.GF1Attended2 = GF1SNR(binF1_2nd,:)';
    snrdata_correct.GF1Unattended = GF1SNR(binF2,:)';
    snrdata_correct.GF1Unattended2 = GF1SNR(binF2_2nd,:)';
    
    snrdata_correct.GF2Mean = mean(GF2SNR(17:200,:),1)';
    snrdata_correct.GF2Attended = GF2SNR(binF2,:)';
    snrdata_correct.GF2Attended2 = GF2SNR(binF2_2nd,:)';
    snrdata_correct.GF2Unattended = GF2SNR(binF1,:)';
    snrdata_correct.GF2Unattended2 = GF2SNR(binF1_2nd,:)';
    
    % Add subject's SNR table to all subject's struct
    SNRdata_correct.(names{i}) = snrdata_correct;
end

%% Combine Tables from Each Struct
names = fieldnames(SNRdata);
allSNR = SNRdata.(names{1});
for i = 2:length(names)
    allSNR = [allSNR;SNRdata.(names{i})];
end

names = fieldnames(SNRdata_correct);
allSNR_correct = SNRdata_correct.(names{1});
for i = 2:length(names)
    allSNR_correct = [allSNR_correct;SNRdata_correct.(names{i})];
end


%% Save as mat file
disp('Saving data...')
% save('SNRDataStats','SNRdata','SNRdata_correct','allSNR','allSNR_correct','-v7.3')

%% Save as CSV file
writetable(allSNR,'Final Data Files/SNRData_fulllength_topchans.csv')
writetable(allSNR_correct,'Final Data Files/SNRData_fulllength_topchans_correct.csv')





