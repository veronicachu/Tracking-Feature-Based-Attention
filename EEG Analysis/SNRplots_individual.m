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

%% Calculate SNR
% Congruent
rightRF1EEG = trialsepData.rightRF1EEG;
rightRF2EEG = trialsepData.rightRF2EEG;
leftLF1EEG = trialsepData.leftLF1EEG;
leftLF2EEG = trialsepData.leftLF2EEG;

[bin,rightRF1SNR] = plotSSR_mod(rightRF1EEG,Fs,'snr',1);
[~,rightRF2SNR] = plotSSR_mod(rightRF2EEG,Fs,'snr',1);
[~,leftLF1SNR] = plotSSR_mod(leftLF1EEG,Fs,'snr',1);
[~,leftLF2SNR] = plotSSR_mod(leftLF2EEG,Fs,'snr',1);

% Incongruent
rightLF1EEG = trialsepData.rightLF1EEG;
rightLF2EEG = trialsepData.rightLF2EEG;
leftRF1EEG = trialsepData.leftRF1EEG;
leftRF2EEG = trialsepData.leftRF2EEG;

[~,rightLF1SNR] = plotSSR_mod(rightLF1EEG,Fs,'snr',1);
[~,rightLF2SNR] = plotSSR_mod(rightLF2EEG,Fs,'snr',1);
[~,leftRF1SNR] = plotSSR_mod(leftRF1EEG,Fs,'snr',1);
[~,leftRF2SNR] = plotSSR_mod(leftRF2EEG,Fs,'snr',1);

close all;

%% 
oChans = 30:32;
poChans = [29 55:58 63:64];
pChans = [24:28 51:54];
cpChans = [20:23 48:50];
targChans = [oChans poChans cpChans];

%% Congruent Channel Mean
limit = 8;

figure;
subplot(2,2,1)
hold on
plot(bin,mean(rightRF1SNR(:,targChans),2),'k','LineWidth',1)
shadedErrorBar(bin,mean(rightRF1SNR(:,targChans),2),std(rightRF1SNR(:,targChans),[],2))
xlim([4 40])
ylim([0 limit])
title(sprintf('Congruent Right at %sHz',num2str(freqs(1))),'FontSize',24)

subplot(2,2,2)
hold on 
plot(bin,mean(rightRF2SNR(:,targChans),2),'k','LineWidth',1)
shadedErrorBar(bin,mean(rightRF2SNR(:,targChans),2),std(rightRF2SNR(:,targChans),[],2))
xlim([4 40])
ylim([0 limit])
title(sprintf('Congruent Right at %sHz',num2str(freqs(2))),'FontSize',24)

subplot(2,2,3)
hold on
plot(bin,mean(leftLF1SNR(:,targChans),2),'k','LineWidth',1)
shadedErrorBar(bin,mean(leftLF1SNR(:,targChans),2),std(leftLF1SNR(:,targChans),[],2))
xlim([4 40])
ylim([0 limit])
title(sprintf('Congruent Left at %sHz',num2str(freqs(1))),'FontSize',24)

subplot(2,2,4)
hold on
plot(bin,mean(leftLF2SNR(:,targChans),2),'k','LineWidth',1)
shadedErrorBar(bin,mean(leftLF2SNR(:,targChans),2),std(leftLF2SNR(:,targChans),[],2))
xlim([4 40])
ylim([0 limit])
title(sprintf('Congruent Left at %sHz',num2str(freqs(2))),'FontSize',24)

%% Incongruent Channel Mean
figure;
subplot(2,2,1)
hold on
plot(bin,mean(rightLF1SNR(:,targChans),2),'k','LineWidth',1)
shadedErrorBar(bin,mean(rightLF1SNR(:,targChans),2),std(rightLF1SNR(:,targChans),[],2))
xlim([4 40])
ylim([0 limit])
title(sprintf('Incongruent Right at %sHz',num2str(freqs(1))),'FontSize',24)

subplot(2,2,2)
hold on
plot(bin,mean(rightLF2SNR(:,targChans),2),'k','LineWidth',1)
shadedErrorBar(bin,mean(rightLF2SNR(:,targChans),2),std(rightLF2SNR(:,targChans),[],2))
xlim([4 40])
ylim([0 limit])
title(sprintf('Incongruent Right at %sHz',num2str(freqs(2))),'FontSize',24)

subplot(2,2,3)
hold on
plot(bin,mean(leftRF1SNR(:,targChans),2),'k','LineWidth',1)
shadedErrorBar(bin,mean(leftRF1SNR(:,targChans),2),std(leftRF1SNR(:,targChans),[],2))
xlim([4 40])
ylim([0 limit])
title(sprintf('Incongruent Left at %sHz',num2str(freqs(1))),'FontSize',24)

subplot(2,2,4)
hold on
plot(bin,mean(leftRF2SNR(:,targChans),2),'k','LineWidth',1)
shadedErrorBar(bin,mean(leftRF2SNR(:,targChans),2),std(leftRF2SNR(:,targChans),[],2))
xlim([4 40])
ylim([0 limit])
title(sprintf('Incongruent Left at %sHz',num2str(freqs(2))),'FontSize',24)







