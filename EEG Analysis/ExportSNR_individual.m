clear;
subjnum = '123';

eegfile = sprintf('Segmented Data Files/Subj %s/%s_SegmentedEEG.mat',subjnum,subjnum);
% eegfile = sprintf('Cleaned Data Files/%s_CleanedEEG.mat',subjnum);
load(eegfile)

behfile = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP Car Analyses/Behavioral Analysis/%s_ColorData.mat',subjnum);
load(behfile);

load('ANTWAVE64')
chanNames = ANTWAVE64.ChanNames;

actualfreq1 = 12.5;
actualfreq2 = 18.75;

EEG1 = SegmentedEEG(1:Fs*4,:,:);
EEG2 = SegmentedEEG(Fs*4+1:end,:,:);

%% Segment by condition
[redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG1,TrialData,actualfreq1,actualfreq2,badtrials);
[redF1EEG(:,:,33:64),redF2EEG(:,:,33:64),greenF1EEG(:,:,33:64),greenF2EEG(:,:,33:64)] = extractTrialType(EEG2,TrialData,actualfreq1,actualfreq2,badtrials);

%% 
parietalChans = [29 55:58 63:64];
occpChans = 30:32;

%% SNR
[bin,RF1SNR] = plotSSR_mod(redF1EEG(:,[occpChans parietalChans],:),Fs,'snr',1,'snrwidth',4);
[~,RF2SNR] = plotSSR_mod(redF2EEG(:,[occpChans parietalChans],:),Fs,'snr',1,'snrwidth',4);
[~,GF1SNR] = plotSSR_mod(greenF1EEG(:,[occpChans parietalChans],:),Fs,'snr',1,'snrwidth',4);
[~,GF2SNR] = plotSSR_mod(greenF2EEG(:,[occpChans parietalChans],:),Fs,'snr',1,'snrwidth',4);
close all

%% Find freqs
binF1 = find(bin == actualfreq1);
binF1_2nd = find(bin == actualfreq1*2);

binF2 = find(bin == actualfreq2);
binF2_2nd = find(bin == actualfreq2*2);

%% Create SNR results table
% Channel Column
allChans = [occpChans parietalChans];
for i = 1:length(allChans)
    chans{i,1} = chanNames{allChans(i)};
end

snrdata = table;
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

%% Write CSV
% writetable(ssrdata,sprintf('Final Data Files/%s_SSRData.csv',subjnum))
writetable(snrdata,sprintf('Final Data Files/%s_SNRData.csv',subjnum))



