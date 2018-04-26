clear;
subjnum = '402';

eegfile = sprintf('Segmented Data Files/%s_SegmentedEEG.mat',subjnum);
% eegfile = sprintf('Cleaned Data Files/%s_CleanedEEG.mat',subjnum);
load(eegfile)

behfile = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP HUD Analyses/Behavioral Analysis/%s_ColorData.mat',subjnum);
load(behfile);

% load the head model
load('ANTWAVE64');
hm = ANTWAVE64;

% get channel labels
EEGchanLabel = hm.ChanNames;

freq1 = 12.5;
freq2 = 18.75;

EEG = SegmentedEEG;
% EEG = eegica.data(1024:end-1,:,:);

%% Organize data by condition
nSamples = size(EEG,1);
EEGtime = linspace(0,Fs,nSamples);
[redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,freq1,freq2,badtrials);

%% Chunk trials in each  condition
redF1 = ChunkTrials(redF1EEG,Fs);
redF2 = ChunkTrials(redF2EEG,Fs);
greenF1 = ChunkTrials(greenF1EEG,Fs);
greenF2 = ChunkTrials(greenF2EEG,Fs);

%% Wavelet convolution
chanofinterest = find(horzcat(strcmp(EEGchanLabel,'Oz')));

% Convolution using range of wavelet frequencies
conv_RF1 = waveletConvTrials(redF1EEG,chanofinterest,freq1);
conv_RF2 = waveletConvTrials(redF2EEG,chanofinterest,freq2);
conv_GF1 = waveletConvTrials(greenF1EEG,chanofinterest,freq1);
conv_GF2 = waveletConvTrials(greenF2EEG,chanofinterest,freq2);

% Calculate phase angles
angle_RF1 = angle(conv_RF1);
angle_RF2 = angle(conv_RF2);
angle_GF1 = angle(conv_GF1);
angle_GF2 = angle(conv_GF2);

% Look at phase angles for a trial
% figure;
% hold on
% plot(EEGtime,redF1EEG(:,chanofinterest,10))
% plot(EEGtime,angle_GF1(10,:));

%% Check the convolution
Fs = 1024;
nyq = nSamples/2+1;
myfreqs = linspace(0,Fs/2,nyq);

convFFT_RF1 = abs(fft(conv_RF2(5,:)));
figure;
plot(myfreqs,convFFT_RF1(1:length(myfreqs)))
xlim([0 30])

figure;
hold on
plot(EEGtime,redF1EEG(:,chanofinterest,5))
plot(EEGtime,conv_RF1(5,:))
legend('Data','Conv')

%% Plot raster of phase angles
figure;
subplot(2,2,1)
imagesc(EEGtime,1:size(redF1EEG,3),angle_RF1)
set(gca,'ydir','normal')
title(sprintf('Red %s Hz',num2str(freq1)))
xlabel('Time (s)')
ylabel('Trials')

subplot(2,2,2)
imagesc(EEGtime,1:size(redF2EEG,3),angle_RF2)
set(gca,'ydir','normal')
title(sprintf('Red %s Hz',num2str(freq2)))
xlabel('Time (s)')
ylabel('Trials')

subplot(2,2,3)
imagesc(EEGtime,1:size(greenF1EEG,3),angle_GF1)
set(gca,'ydir','normal')
title(sprintf('Green %s Hz',num2str(freq1)))
xlabel('Time (s)')
ylabel('Trials')

subplot(2,2,4)
imagesc(EEGtime,1:size(greenF2EEG,3),angle_GF2)
set(gca,'ydir','normal')
title(sprintf('Green %s Hz',num2str(freq2)))
xlabel('Time (s)')
ylabel('Trials')

%% Calculate intertrial phase clustering
% Normalize vector lengths
normconv_RF1 = conv_RF1./abs(conv_RF1);
normconv_RF2 = conv_RF2./abs(conv_RF2);
normconv_GF1 = conv_GF1./abs(conv_GF1);
normconv_GF2 = conv_GF2./abs(conv_GF2);

% Calculate sum and magnitude
ITPC_RF1 = abs(sum(normconv_RF1)/size(normconv_RF1,1));
ITPC_RF2 = abs(sum(normconv_RF2)/size(normconv_RF2,1));
ITPC_GF1 = abs(sum(normconv_GF1)/size(normconv_GF1,1));
ITPC_GF2 = abs(sum(normconv_GF2)/size(normconv_GF2,1));

% Plot results
figure;
subplot(2,2,1)
plot(EEGtime, ITPC_RF1)
xlabel('Time (s)')
ylabel('ITPC')

subplot(2,2,2)
plot(EEGtime, ITPC_RF2)
xlabel('Time (s)')
ylabel('ITPC')

subplot(2,2,3)
plot(EEGtime, ITPC_GF1)
xlabel('Time (s)')
ylabel('ITPC')

subplot(2,2,4)
plot(EEGtime, ITPC_GF2)
xlabel('Time (s)')
ylabel('ITPC')

%% ITPC at a range of frequencies
chanofinterest = find(horzcat(strcmp(EEGchanLabel,'Oz')));

% Convolution using range of wavelet frequencies
wFreq = 4:30;

for i = 1:length(wFreq)
    conv_RF1 = waveletConvTrials(redF1EEG,chanofinterest,wFreq(i));
    
    % Calculate phase angles
    angle_RF1 = conv_RF1./abs(conv_RF1);
    
    % Calculate intertrial phase clustering
    ITPC_RF1(i,:) = abs(sum(conv_RF1))/size(conv_RF1,1);
    
end

% Plot results of ITPC over 4-30Hz
figure; 
imagesc(EEGtime, wFreq, ITPC_RF1)
set(gca,'ydir','normal','clim',[0 5e-4])
colorbar
title(sprintf('Red %s Hz',num2str(freq1)))
xlabel('Time (s)')
ylabel('Frequency (Hz)')

























