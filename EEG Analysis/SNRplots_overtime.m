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

%% Individual SNR Graphs
names = fieldnames(Data);

% Pre-allocate matricies
RF1SNR1 = zeros(216,length(targChans),length(names));
RF2SNR1 = zeros(216,length(targChans),length(names));
GF1SNR1 = zeros(216,length(targChans),length(names));
GF2SNR1 = zeros(216,length(targChans),length(names));

for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    TrialData = Data.(names{i}).TrialData;
    
    % Split EEG data in half
%     EEG = SegmentedEEG(1:end-Fs*1,:,:);
    EEG1 = SegmentedEEG(Fs*2:end-Fs-1,:,1:32);
    EEG2 = SegmentedEEG(Fs*2:end-Fs-1,:,33:64);
    EEG3 = SegmentedEEG(Fs*2:end-Fs-1,:,65:96);
    EEG4 = SegmentedEEG(Fs*2:end-Fs-1,:,97:128);
    badtrials = 0;
    
    % Segment by condition
    [redF1EEG1,redF2EEG1,greenF1EEG1,greenF2EEG1] = extractTrialType(EEG1,TrialData,actualfreq1,actualfreq2,badtrials);
    [redF1EEG2,redF2EEG2,greenF1EEG2,greenF2EEG2] = extractTrialType(EEG2,TrialData,actualfreq1,actualfreq2,badtrials);
    [redF1EEG3,redF2EEG3,greenF1EEG3,greenF2EEG3] = extractTrialType(EEG3,TrialData,actualfreq1,actualfreq2,badtrials);
    [redF1EEG4,redF2EEG4,greenF1EEG4,greenF2EEG4] = extractTrialType(EEG4,TrialData,actualfreq1,actualfreq2,badtrials);
    
    % Plot SNR
    % Blue 12.5 Hz
    [bin,RF1SNR1(:,:,i)] = plotSSR_mod(redF1EEG1(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,RF1SNR2(:,:,i)] = plotSSR_mod(redF1EEG2(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,RF1SNR3(:,:,i)] = plotSSR_mod(redF1EEG3(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,RF1SNR4(:,:,i)] = plotSSR_mod(redF1EEG4(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    
    % Blue 18.75 Hz
    [~,RF2SNR1(:,:,i)] = plotSSR_mod(redF2EEG1(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,RF2SNR2(:,:,i)] = plotSSR_mod(redF2EEG2(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,RF2SNR3(:,:,i)] = plotSSR_mod(redF2EEG3(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,RF2SNR4(:,:,i)] = plotSSR_mod(redF2EEG4(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    
    % Green 12.5 Hz
    [~,GF1SNR1(:,:,i)] = plotSSR_mod(greenF1EEG1(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF1SNR2(:,:,i)] = plotSSR_mod(greenF1EEG2(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF1SNR3(:,:,i)] = plotSSR_mod(greenF1EEG3(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF1SNR4(:,:,i)] = plotSSR_mod(greenF1EEG4(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    
    % Green 18.75 Hz
    [~,GF2SNR1(:,:,i)] = plotSSR_mod(greenF2EEG1(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF2SNR2(:,:,i)] = plotSSR_mod(greenF2EEG2(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF2SNR3(:,:,i)] = plotSSR_mod(greenF2EEG3(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF2SNR4(:,:,i)] = plotSSR_mod(greenF2EEG4(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    
end

close all

%% Chan/Subj Chan Average SNR Graph
RF1SNR_mean1 = squeeze(mean(RF1SNR1,2));
RF1SNR_mean2 = squeeze(mean(RF1SNR2,2));
RF1SNR_mean3 = squeeze(mean(RF1SNR3,2));
RF1SNR_mean4 = squeeze(mean(RF1SNR4,2));

RF2SNR_mean1 = squeeze(mean(RF2SNR1,2));
RF2SNR_mean2 = squeeze(mean(RF2SNR2,2));
RF2SNR_mean3 = squeeze(mean(RF2SNR3,2));
RF2SNR_mean4 = squeeze(mean(RF2SNR4,2));

GF1SNR_mean1 = squeeze(mean(GF1SNR1,2));
GF1SNR_mean2 = squeeze(mean(GF1SNR2,2));
GF1SNR_mean3 = squeeze(mean(GF1SNR3,2));
GF1SNR_mean4 = squeeze(mean(GF1SNR4,2));

GF2SNR_mean1 = squeeze(mean(GF2SNR1,2));
GF2SNR_mean2 = squeeze(mean(GF2SNR2,2));
GF2SNR_mean3 = squeeze(mean(GF2SNR3,2));
GF2SNR_mean4 = squeeze(mean(GF2SNR4,2));

%%
freq1bin = find(bin == 12.5);
freq2bin = find(bin == 18.75);

RF1att_Block1 = mean(RF1SNR_mean1(freq1bin,:)) / mean(RF1SNR_mean1(freq2bin,:));
RF1att_Block2 = mean(RF1SNR_mean2(freq1bin,:)) / mean(RF1SNR_mean2(freq2bin,:));
RF1att_Block3 = mean(RF1SNR_mean3(freq1bin,:)) / mean(RF1SNR_mean3(freq2bin,:));
RF1att_Block4 = mean(RF1SNR_mean4(freq1bin,:)) / mean(RF1SNR_mean4(freq2bin,:));

RF2att_Block1 = mean(RF2SNR_mean1(freq2bin,:)) / mean(RF2SNR_mean1(freq1bin,:));
RF2att_Block2 = mean(RF2SNR_mean2(freq2bin,:)) / mean(RF2SNR_mean2(freq1bin,:));
RF2att_Block3 = mean(RF2SNR_mean3(freq2bin,:)) / mean(RF2SNR_mean3(freq1bin,:));
RF2att_Block4 = mean(RF2SNR_mean4(freq2bin,:)) / mean(RF2SNR_mean4(freq1bin,:));

GF1att_Block1 = mean(GF1SNR_mean1(freq1bin,:)) / mean(GF1SNR_mean1(freq2bin,:));
GF1att_Block2 = mean(GF1SNR_mean2(freq1bin,:)) / mean(GF1SNR_mean2(freq2bin,:));
GF1att_Block3 = mean(GF1SNR_mean3(freq1bin,:)) / mean(GF1SNR_mean3(freq2bin,:));
GF1att_Block4 = mean(GF1SNR_mean4(freq1bin,:)) / mean(GF1SNR_mean4(freq2bin,:));

GF2att_Block1 = mean(GF2SNR_mean1(freq2bin,:)) / mean(GF2SNR_mean1(freq1bin,:));
GF2att_Block2 = mean(GF2SNR_mean2(freq2bin,:)) / mean(GF2SNR_mean2(freq1bin,:));
GF2att_Block3 = mean(GF2SNR_mean3(freq2bin,:)) / mean(GF2SNR_mean3(freq1bin,:));
GF2att_Block4 = mean(GF2SNR_mean4(freq2bin,:)) / mean(GF2SNR_mean4(freq1bin,:));

figure;
subplot(2,2,1)
bar([RF1att_Block1 RF1att_Block2 RF1att_Block3 RF1att_Block4])
subplot(2,2,2)
bar([RF2att_Block1 RF2att_Block2 RF2att_Block3 RF2att_Block4])
subplot(2,2,3)
bar([GF1att_Block1 GF1att_Block2 GF1att_Block3 GF1att_Block4])
subplot(2,2,4)
bar([GF2att_Block1 GF2att_Block2 GF2att_Block3 GF2att_Block4])








