clear;
subjnum = '401';

eegfile = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP HUD Analyses/EEG Analysis/Segmented Data Files/%s_SegmentedEEG.mat',subjnum);
% eegfile = sprintf('Cleaned Data Files/%s_CleanedEEG.mat',subjnum);
load(eegfile)

behfile = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP HUD Analyses/Behavioral Analysis/%s_ColorData.mat',subjnum);
load(behfile);

load('ANTWAVE64')
chanNames = ANTWAVE64.ChanNames;

actualfreq1 = 12.5;
actualfreq2 = 18.75;

EEG = SegmentedEEG(Fs*2:end-1,:,:);
% EEG = eegica.data;

%% Segment by condition
[redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);

%% 
parietalChans = [29 55:58 63:64];
occpChans = 30:32;

%% SSR
[bin,RF1SSR] = plotSSR_mod(redF1EEG(:,[occpChans parietalChans],:),Fs);
[~,RF2SSR] = plotSSR_mod(redF2EEG(:,[occpChans parietalChans],:),Fs);
[~,GF1SSR] = plotSSR_mod(greenF1EEG(:,[occpChans parietalChans],:),Fs);
[~,GF2SSR] = plotSSR_mod(greenF2EEG(:,[occpChans parietalChans],:),Fs);

%% SNR
[~,RF1SNR] = plotSSR_mod(redF1EEG(:,[occpChans parietalChans],:),Fs,'snr',1);
[~,RF2SNR] = plotSSR_mod(redF2EEG(:,[occpChans parietalChans],:),Fs,'snr',1);
[~,GF1SNR] = plotSSR_mod(greenF1EEG(:,[occpChans parietalChans],:),Fs,'snr',1);
[~,GF2SNR] = plotSSR_mod(greenF2EEG(:,[occpChans parietalChans],:),Fs,'snr',1);

%% Find freqs
binF1 = find(bin == actualfreq1);
binF2 = find(bin == actualfreq2);

%% Create SSR results table
% Channel Column
allChans = [occpChans parietalChans];
for i = 1:length(allChans)
    chans{i,1} = chanNames{allChans(i)};
end

% Data
RF1Attended = RF1SSR(binF1,:)';
RF1Unattended = RF1SSR(binF2,:)';

RF2Attended = RF2SSR(binF2,:)';
RF2Unattended = RF2SSR(binF1,:)';

GF1Attended = GF1SSR(binF1,:)';
GF1Unattended = GF1SSR(binF2,:)';

GF2Attended = GF2SSR(binF2,:)';
GF2Unattended = GF2SSR(binF1,:)';

% Create Table
ssrdata = table;
ssrdata.Channels = chans;
ssrdata.RF1Attended = RF1SSR(binF1,:)';
ssrdata.RF1Unattended = RF1SSR(binF2,:)';
ssrdata.RF2Attended = RF2SSR(binF2,:)';
ssrdata.RF2Unattended = RF2SSR(binF1,:)';
ssrdata.GF1Attended = GF1SSR(binF1,:)';
ssrdata.GF1Unattended = GF1SSR(binF2,:)';
ssrdata.GF2Attended = GF2SSR(binF2,:)';
ssrdata.GF2Unattended = GF2SSR(binF1,:)';

%% Create SNR results table
% Data
RF1Attended = RF1SNR(binF1,:)';
RF1Unattended = RF1SNR(binF2,:)';

RF2Attended = RF2SNR(binF2,:)';
RF2Unattended = RF2SNR(binF1,:)';

GF1Attended = GF1SNR(binF1,:)';
GF1Unattended = GF1SNR(binF2,:)';

GF2Attended = GF2SNR(binF2,:)';
GF2Unattended = GF2SNR(binF1,:)';

% Create Table
snrdata = table;
snrdata.Channels = chans;
snrdata.RF1Attended = RF1SNR(binF1,:)';
snrdata.RF1Unattended = RF1SNR(binF2,:)';
snrdata.RF2Attended = RF2SNR(binF2,:)';
snrdata.RF2Unattended = RF2SNR(binF1,:)';
snrdata.GF1Attended = GF1SNR(binF1,:)';
snrdata.GF1Unattended = GF1SNR(binF2,:)';
snrdata.GF2Attended = GF2SNR(binF2,:)';
snrdata.GF2Unattended = GF2SNR(binF1,:)';

%% Write CSV
writetable(ssrdata,sprintf('Final Data Files/%s_SSRData.csv',subjnum))
writetable(snrdata,sprintf('Final Data Files/%s_SNRData.csv',subjnum))




