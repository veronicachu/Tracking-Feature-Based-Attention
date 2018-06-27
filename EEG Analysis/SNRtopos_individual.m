clear;
subjnum = 302;

% eegfile = sprintf('Segmented Data Files/S%d/S%d-Cond%d_SegmentedEEG.mat',subjnum,subjnum,condnum);
eegfile = sprintf('Segmented Data Files/S%d/S%d_SegmentedEEG.mat',subjnum,subjnum);
load(eegfile)

% behfile = sprintf('../Behavioral Analysis/%d_TrialData_Cond%d.mat',subjnum,condnum);
behfile = sprintf('../Behavioral Analysis/S%d_TrialData.mat',subjnum);
load(behfile);

% Frequencies of Interest
freqs = [12 15];
Fs = 1024;

%%
load('ANTWAVE64')
hm = ANTWAVE64;
chanNames = ANTWAVE64.ChanNames;
Fs = 1024;

%% Individual SNR Graphs
% Collect subject's data
EEG = SegmentedEEG(Fs*1:Fs*5-1,:,:);
badtrials = 0;

% Segment by condition
[trialsepData] = extractTrialType(EEG,TrialData,freqs);

% Collect data
rightRF1EEG = trialsepData.rightRF1EEG;
rightRF2EEG = trialsepData.rightRF2EEG;
leftLF1EEG = trialsepData.leftLF1EEG;
leftLF2EEG = trialsepData.leftLF2EEG;

rightLF1EEG = trialsepData.rightLF1EEG;
rightLF2EEG = trialsepData.rightLF2EEG;
leftRF1EEG = trialsepData.leftRF1EEG;
leftRF2EEG = trialsepData.leftRF2EEG;

% Calculate SNR
[bin,rightRF1SNR] = plotSSR_mod(rightRF1EEG,Fs,'snr',1);
[~,rightRF2SNR] = plotSSR_mod(rightRF2EEG,Fs,'snr',1);
[~,leftLF1SNR] = plotSSR_mod(leftLF1EEG,Fs,'snr',1);
[~,leftLF2SNR] = plotSSR_mod(leftLF2EEG,Fs,'snr',1);

[~,rightLF1SNR] = plotSSR_mod(rightLF1EEG,Fs,'snr',1);
[~,rightLF2SNR] = plotSSR_mod(rightLF2EEG,Fs,'snr',1);
[~,leftRF1SNR] = plotSSR_mod(leftRF1EEG,Fs,'snr',1);
[~,leftRF2SNR] = plotSSR_mod(leftRF2EEG,Fs,'snr',1);
close all

% Remove NaNs
rightRF1SNR(isnan(rightRF1SNR)) = 0;
rightRF2SNR(isnan(rightRF2SNR)) = 0;
leftLF1SNR(isnan(leftLF1SNR)) = 0;
leftLF2SNR(isnan(leftLF2SNR)) = 0;

rightLF1SNR(isnan(rightLF1SNR)) = 0;
rightLF2SNR(isnan(rightLF2SNR)) = 0;
leftRF1SNR(isnan(leftRF1SNR)) = 0;
leftRF2SNR(isnan(leftRF2SNR)) = 0;

% Find index of target freqs
freq1 = find(bin == freqs(1));
freq2 = find(bin == freqs(2));

%% Plot Congruent SNR
h = figure('units','normalized','outerposition',[0 0 1 1]);
limits = 4;

% Right Target Congruent at 12.5 Hz
subplot(2,2,1)
corttopo_mod(rightRF1SNR(freq1,:,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4])
caxis([0 limits])
colorbar
title(sprintf('Right Congruent at %s Hz',num2str(freqs(1))))

% Right Target Congruent at 18.75 Hz
subplot(2,2,2)
corttopo_mod(rightRF2SNR(freq2,:,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4])
caxis([0 limits])
colorbar
title(sprintf('Right Congruent at %s Hz',num2str(freqs(2))))

% Left Target Congruent at 12.5 Hz
subplot(2,2,3)
corttopo_mod(leftLF1SNR(freq1,:,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4])
caxis([0 limits])
colorbar
title(sprintf('Left Congruent at %s Hz',num2str(freqs(1))))

% Left Target Congruent at 18.75 Hz
subplot(2,2,4)
corttopo_mod(leftLF2SNR(freq2,:,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4])
caxis([0 limits])
colorbar
title(sprintf('Left Congruent at %s Hz',num2str(freqs(2))))

%% Plot Incongruent SNR
h = figure('units','normalized','outerposition',[0 0 1 1]);

% Right Target Incongruent at 12.5 Hz
subplot(2,2,1)
corttopo_mod(rightLF1SNR(freq1,:,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4])
caxis([0 limits])
colorbar
title(sprintf('Right Incongruent at %s Hz',num2str(freqs(1))))

% Right Target Incongruent at 18.75 Hz
subplot(2,2,2)
corttopo_mod(rightLF2SNR(freq2,:,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4])
caxis([0 limits])
colorbar
title(sprintf('Right Incongruent at %s Hz',num2str(freqs(2))))

% Left Target Incongruent at 12.5 Hz
subplot(2,2,3)
corttopo_mod(leftRF1SNR(freq1,:,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4])
caxis([0 limits])
colorbar
title(sprintf('Left Incongruent at %s Hz',num2str(freqs(1))))

% Left Target Incongruent at 18.75 Hz
subplot(2,2,4)
corttopo_mod(leftRF2SNR(freq2,:,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4])
caxis([0 limits])
colorbar
title(sprintf('Left Incongruent at %s Hz',num2str(freqs(2))))




