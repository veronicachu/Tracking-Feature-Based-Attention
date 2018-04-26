clear;
subjnum = '403';

% SSVEP frequencies
actualfreq1 = 12.5;
actualfreq2 = 18.75;

% get trial data
eegfile = sprintf('Segmented Data Files/%s_SegmentedEEG.mat',subjnum);
% eegfile = sprintf('Cleaned Data Files/%s_CleanedEEG.mat',subjnum);
behfile = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP HUD Analyses/Behavioral Analysis/%s_ColorData.mat',subjnum);
load(eegfile);
load(behfile);

% load the head model
load('ANTWAVE64');
hm = ANTWAVE64;

% get channel labels
EEGchanLabel = hm.ChanNames;

% select subtrial time period
EEG = SegmentedEEG(Fs*2:end-1,:,:);
% EEG = eegica.data(1024:end-1,:,:);

%% Organize and FFT EEG data by trial type
[redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);
[RF1fft,RF2fft,GF1fft,GF2fft] = FFTTrialType(redF1EEG,redF2EEG,greenF1EEG,greenF2EEG);

%% Find the target frequencies and surrounding frequencies
Fs = 1024;
nyq = size(RF1fft,1)/2+1;
myfreqs = linspace(0,Fs/2,nyq);

freq1 = 12.5;        % find closest numbers to freq 1
freq2 = 18.75;       % find closest numbers to freq 2

%% Find indicies in the frequency vector for frequencies of interest
if length(freq1) == 1
    freq1ind = find(round(myfreqs,2) == freq1);
    surroundfreq1ind = (freq1ind-4):(freq1ind+4);
elseif length(freq1) == 2
    freq1ind(1) = find(round(myfreqs,2) == freq1(1));
    freq1ind(2) = find(round(myfreqs,2) == freq1(2));
    surroundfreq1ind = (freq1ind(1)-4):(freq1ind(2)+4); % get surrounding
end

if length(freq2) == 1
    freq2ind = find(round(myfreqs,2) == freq2);
    surroundfreq2ind = (freq2ind-4):(freq2ind+4);
elseif length(freq2) == 2
    freq2ind(1) = find(round(myfreqs,2) == freq2(1));
    freq2ind(2) = find(round(myfreqs,2) == freq2(2));
    surroundfreq2ind = (freq2ind(1)-4):(freq2ind(2)+4); % get surrounding
end

disp(freq1ind)
disp(freq2ind)

%% Sum of all trials for each electrode - comparing target and nontarget trials
RF1fftsum = MeanAmpSpec(RF1fft);
RF2fftsum = MeanAmpSpec(RF2fft);
GF1fftsum = MeanAmpSpec(GF1fft);
GF2fftsum = MeanAmpSpec(GF2fft);

%% Find the SNR
% Cued
RF1SNRcued = calculateSNR(RF1fftsum,surroundfreq1ind);
RF2SNRcued = calculateSNR(RF2fftsum,surroundfreq2ind);
GF1SNRcued = calculateSNR(GF1fftsum,surroundfreq1ind);
GF2SNRcued = calculateSNR(GF2fftsum,surroundfreq2ind);

% Uncued
RF1SNRuncued = calculateSNR(RF1fftsum,surroundfreq2ind);
RF2SNRuncued = calculateSNR(RF2fftsum,surroundfreq1ind);
GF1SNRuncued = calculateSNR(GF1fftsum,surroundfreq2ind);
GF2SNRuncued = calculateSNR(GF2fftsum,surroundfreq1ind);

%% Make mastoids 0 again
% Cued
RF1SNRcued([13 19]) = 0;
RF2SNRcued([13 19]) = 0;
GF1SNRcued([13 19]) = 0;
GF2SNRcued([13 19]) = 0;

% Uncued
RF1SNRuncued([13 19]) = 0;
RF2SNRuncued([13 19]) = 0;
GF1SNRuncued([13 19]) = 0;
GF2SNRuncued([13 19]) = 0;

%% Plot cued vs. uncued topos
limits = 12;

figure;
subplot(4,2,1)
corttopo(RF1SNRcued,hm,'cmap','hotncold')
caxis([-limits limits])
colorbar
title(sprintf('Cued: Red at %s Hz',num2str(actualfreq1)))

subplot(4,2,2)
corttopo(RF1SNRuncued,hm,'cmap','hotncold')
caxis([-limits limits])
colorbar
title(sprintf('Uncued: Green at %s Hz',num2str(actualfreq2)))

subplot(4,2,3)
corttopo(RF2SNRcued,hm,'cmap','hotncold')
caxis([-limits limits])
colorbar
title(sprintf('Cued: Red at %s Hz',num2str(actualfreq2)))

subplot(4,2,4)
corttopo(RF2SNRuncued,hm,'cmap','hotncold')
caxis([-limits limits])
colorbar
title(sprintf('Uncued: Green at %s Hz',num2str(actualfreq1)))

subplot(4,2,5)
corttopo(GF1SNRcued,hm,'cmap','hotncold')
caxis([-limits limits])
colorbar
title(sprintf('Cued: Green at %s Hz',num2str(actualfreq1)))

subplot(4,2,6)
corttopo(GF1SNRuncued,hm,'cmap','hotncold')
caxis([-limits limits])
colorbar
title(sprintf('Uncued: Red at %s Hz',num2str(actualfreq2)))

subplot(4,2,7)
corttopo(GF2SNRcued,hm,'cmap','hotncold')
caxis([-limits limits])
colorbar
title(sprintf('Cued: Green at %s Hz',num2str(actualfreq2)))

subplot(4,2,8)
corttopo(GF2SNRuncued,hm,'cmap','hotncold')
caxis([-limits limits])
colorbar
title(sprintf('Uncued: Red at %s Hz',num2str(actualfreq1)))

%% Channel SNR values for target freqs
channelSNR = cell(nChan,5);
for i = 1:nChan
    channelSNR{i,1} = EEGchanLabel{i};
    channelSNR{i,2} = RF1SNRcued(i);
    channelSNR{i,3} = RF2SNRcued(i);
    channelSNR{i,4} = GF1SNRcued(i);
    channelSNR{i,5} = GF2SNRcued(i);
end

%% Sort SNR channels from highest to lowest
[sortedRFreq1,sortedindRFreq1] = sort(RF1SNRcued,'descend');
sortedChansRF1 = EEGchanLabel(sortedindRFreq1);

[sortedRFreq2,sortedindRFreq2] = sort(RF2SNRcued,'descend');
sortedChansRF2 = EEGchanLabel(sortedindRFreq2);

[sortedGFreq1,sortedindGFreq1] = sort(GF1SNRcued,'descend');
sortedChansGF1 = EEGchanLabel(sortedindGFreq1);

[sortedGFreq2,sortedindGFreq2] = sort(GF2SNRcued,'descend');
sortedChansGF2 = EEGchanLabel(sortedindGFreq2);

sortedSNR = cell(nChan,4);
for i = 1:nChan
    sortedSNR{i,1} = sortedChansRF1{i};
    sortedSNR{i,2} = sortedRFreq1(i);
    sortedSNR{i,3} = sortedChansRF2{i};
    sortedSNR{i,4} = sortedRFreq2(i);
    
    sortedSNR{i,5} = sortedChansGF1{i};
    sortedSNR{i,6} = sortedGFreq1(i);
    sortedSNR{i,7} = sortedChansGF2{i};
    sortedSNR{i,8} = sortedGFreq2(i);
end

%% Save SNR values for ANOVA
save(sprintf('%s_SNRValues',subjnum),'channelSNR','sortedSNR')














