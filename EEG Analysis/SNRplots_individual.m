clear;
subjnum = '423';

eegfile = sprintf('Segmented Data Files/%s_SegmentedEEG.mat',subjnum);
% eegfile = sprintf('Cleaned Data Files/%s_CleanedEEG.mat',subjnum);
load(eegfile)

behfile = sprintf('D:/Grad School/Research/CNS Lab/Projects/SSVEP HUD/3_Data Analysis/Task/Behavioral Analysis/%s_ColorData.mat',subjnum);
load(behfile);

actualfreq1 = 12.5;
actualfreq2 = 18.75;

EEG = SegmentedEEG(Fs*2:end-Fs-1,:,:);
% EEG = eegica.data(Fs*2:end-1,:,:);

%% Segment by condition
[redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);

%% 
parietalChans = [29 55:58 63:64];
occpChans = 30:32;

%% Plot SSR
figure;

subplot(2,2,1)
[bin,RF1] = plotSSR_mod(redF1EEG(:,[occpChans parietalChans],:),Fs);
title(sprintf('Blue Freq %s SSR',num2str(actualfreq1)))
xlim([0 40])
ylim([0 1.5])

subplot(2,2,2)
[~,RF2] = plotSSR_mod(redF2EEG(:,[occpChans parietalChans],:),Fs);
title(sprintf('Blue Freq %s SSR',num2str(actualfreq2)))
xlim([0 40])
ylim([0 1.5])

subplot(2,2,3)
[~,GF1] = plotSSR_mod(greenF1EEG(:,[occpChans parietalChans],:),Fs);
title(sprintf('Green Freq %s SSR',num2str(actualfreq1)))
xlim([0 40])
ylim([0 1.5])

subplot(2,2,4)
[~,GF2] = plotSSR_mod(greenF2EEG(:,[occpChans parietalChans],:),Fs);
title(sprintf('Green Freq %s SSR',num2str(actualfreq2)))
xlim([0 40])
ylim([0 1.5])

%% Plot SSR Chan means
figure;

subplot(2,2,1)
meanRF1 = mean(RF1,2);
plot(bin,meanRF1);
title(sprintf('Blue Freq %s SSR',num2str(actualfreq1)))
xlim([0 40])
ylim([0 1])

subplot(2,2,2)
meanRF2 = mean(RF2,2);
plot(bin,meanRF2);
title(sprintf('Blue Freq %s SSR',num2str(actualfreq2)))
xlim([0 40])
ylim([0 1])

subplot(2,2,3)
meanGF1 = mean(GF1,2);
plot(bin,meanGF1);
title(sprintf('Green Freq %s SSR',num2str(actualfreq1)))
xlim([0 40])
ylim([0 1])

subplot(2,2,4)
meanGF2 = mean(GF2,2);
plot(bin,meanGF2);
title(sprintf('Green Freq %s SSR',num2str(actualfreq2)))
xlim([0 40])
ylim([0 1])


%% Plot SNR
figure;

subplot(2,2,1)
plotSSR(redF1EEG(:,[occpChans parietalChans],:),Fs,'snr',4)
title(sprintf('Blue Freq %s SNR',num2str(actualfreq1)))
xlim([4 40])
ylim([0 15])

subplot(2,2,2)
plotSSR(redF2EEG(:,[occpChans parietalChans],:),Fs,'snr',4)
title(sprintf('Blue Freq %s SNR',num2str(actualfreq2)))
xlim([4 40])
ylim([0 15])

subplot(2,2,3)
plotSSR(greenF1EEG(:,[occpChans parietalChans],:),Fs,'snr',4)
title(sprintf('Green Freq %s SNR',num2str(actualfreq1)))
xlim([4 40])
ylim([0 15])

subplot(2,2,4)
plotSSR(greenF2EEG(:,[occpChans parietalChans],:),Fs,'snr',4)
title(sprintf('Green Freq %s SNR',num2str(actualfreq2)))
xlim([4 40])
ylim([0 15])
















%% cortspectra
% RF1data = eegica;
% RF2data = eegica;
% GF1data = eegica;
% GF2data = eegica;
% 
% RF1data.data = RF1data.data(:,:,RF1);
% RF2data.data = RF2data.data(:,:,RF2);
% GF1data.data = GF1data.data(:,:,GF1);
% GF2data.data = GF2data.data(:,:,GF2);
% 
% %
% cohdata = cortspectra(RF1data);
% 
% % x = squeeze(cohdata.bandcoherence(2,31,:));
% % figure;corttopo(x,cohdata.hm)
% 
% figure;plot(cohdata.freqs,cohdata.normpower)
% 
% x = find(round(cohdata.freqs,2) == 12.57);
% y = squeeze(cohdata.coherence(x,[occpChans parietalChans],[occpChans parietalChans]));
% figure;imagesc(y)









