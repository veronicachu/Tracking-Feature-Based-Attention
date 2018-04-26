clear;
subjnum = '301';

eegfile = sprintf('Segmented Data Files/%s_SegmentedEEG.mat',subjnum);
% eegfile = sprintf('Cleaned Data Files/%s_CleanedEEG.mat',subjnum);
load(eegfile)

behfile = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP HUD Analyses/Behavioral Analysis/%s_ColorData.mat',subjnum);
load(behfile);

actualfreq1 = 7.5;
actualfreq2 = 12.5;

EEG = SegmentedEEG;
% EEG = eegica.data(1024:end-1,:,:);

%% Segment by condition
[redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);

%% 
parietalChans = [29 55:58 63:64];
occpChans = 30:32;

% Find # of bins
nsamps=size(redF1EEG,1);
tlength=nsamps/Fs;
xlabs=(1/tlength:1/tlength:50);
nbins=length(xlabs);

%% FFT each trial

ntrials = size(greenF2EEG,3);
RF1 = zeros(ntrials,nbins);

for i = 1:size(greenF2EEG,3)
    [bins,amps] = plotFFT_mod(greenF2EEG(:,parietalChans,i),Fs);
    avgamp = mean(amps,2);
    RF1(i,:) = avgamp;
end

figure;
surf(bins,1:ntrials,RF1)
% xlim([0 30])








%% Plot SSR for single trials
figure;

subplot(2,2,1)
[bins,rf1] = plotSSR_mod(redF1(:,parietalChans,:),Fs);
title(sprintf('Red Freq %s SSR',num2str(actualfreq1)))
xlim([0 40])
ylim([0 0.7])

subplot(2,2,2)
[~,rf2] = plotSSR_mod(redF2(:,parietalChans,:),Fs);
title(sprintf('Red Freq %s SSR',num2str(actualfreq2)))
xlim([0 40])
ylim([0 0.7])

subplot(2,2,3)
[~,gf1] = plotSSR_mod(greenF1(:,parietalChans,:),Fs);
title(sprintf('Green Freq %s SSR',num2str(actualfreq1)))
xlim([0 40])
ylim([0 0.7])

subplot(2,2,4)
[~,gf2] = plotSSR_mod(greenF2(:,parietalChans,:),Fs);
title(sprintf('Green Freq %s SSR',num2str(actualfreq2)))
xlim([0 40])
ylim([0 0.7])

%% Plot SNR for single trials
figure;

subplot(2,2,1)
plotSSR(redF1(:,occpChans,:),Fs,'snr',1)
title(sprintf('Red Freq %s SNR',num2str(actualfreq1)))
xlim([2 40])
ylim([0 12])

subplot(2,2,2)
plotSSR(redF2(:,occpChans,:),Fs,'snr',1)
title(sprintf('Red Freq %s SNR',num2str(actualfreq2)))
xlim([2 40])
ylim([0 12])

subplot(2,2,3)
plotSSR(greenF1(:,occpChans,:),Fs,'snr',1)
title(sprintf('Green Freq %s SNR',num2str(actualfreq1)))
xlim([2 40])
ylim([0 12])

subplot(2,2,4)
plotSSR(greenF2(:,occpChans,:),Fs,'snr',1)
title(sprintf('Green Freq %s SNR',num2str(actualfreq2)))
xlim([2 40])
ylim([0 12])

%% Plot ERP

ERP = mean(EEG,3);
occERP = mean(ERP(:,occpChans),2);
parERP = mean(ERP(:,parietalChans),2);

figure;
subplot(3,1,1);
plotx(ERP);
title('Overall Channels ERP')

subplot(3,1,2);
plotx(occERP);
title('Occipital Channels ERP')

subplot(3,1,3);
plotx(parERP);
title('Parietal Channels ERP')
