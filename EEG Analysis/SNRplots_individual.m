clear;
subjnum = '102';

% eegfile = sprintf('Segmented Data Files/Subj %s/Old Data 2/%s_SegmentedEEG.mat',subjnum,subjnum);
% eegfile = sprintf('Segmented Data Files/Subj %s/%s_SegmentedEEG.mat',subjnum,subjnum);
eegfile = sprintf('Cleaned Data Files/%s_CleanedEEG.mat',subjnum);
load(eegfile)

behfile = sprintf('D:/Grad School/Research//CNS Lab/Projects/SSVEP Car/3_Data Analysis/Task/Behavioral Analysis/%s_ColorData.mat',subjnum);
load(behfile);

actualfreq1 = 12.5;
actualfreq2 = 18.75;
Fs = 1024;

% EEG1 = SegmentedEEG(1:Fs*4,:,:);
% EEG2 = SegmentedEEG(Fs*4+1:end,:,:);
EEG1 = data(1:Fs*4,:,:);
EEG2 = data(Fs*4+1:Fs*8,:,:);

badtrials = 0;
%% Segment by condition
[redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG1,TrialData,actualfreq1,actualfreq2,badtrials);
[redF1EEG(:,:,33:64),redF2EEG(:,:,33:64),greenF1EEG(:,:,33:64),greenF2EEG(:,:,33:64)] = extractTrialType(EEG2,TrialData,actualfreq1,actualfreq2,badtrials);

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
line([12.5 12.5],[0 1.5],'LineStyle','--','Color','k')
line([18.75 18.75],[0 1.5],'LineStyle','--','Color','k')

subplot(2,2,2)
[~,RF2] = plotSSR_mod(redF2EEG(:,[occpChans parietalChans],:),Fs);
title(sprintf('Blue Freq %s SSR',num2str(actualfreq2)))
xlim([0 40])
ylim([0 1.5])
line([12.5 12.5],[0 1.5],'LineStyle','--','Color','k')
line([18.75 18.75],[0 1.5],'LineStyle','--','Color','k')

subplot(2,2,3)
[~,GF1] = plotSSR_mod(greenF1EEG(:,[occpChans parietalChans],:),Fs);
title(sprintf('Green Freq %s SSR',num2str(actualfreq1)))
xlim([0 40])
ylim([0 1.5])
line([12.5 12.5],[0 1.5],'LineStyle','--','Color','k')
line([18.75 18.75],[0 1.5],'LineStyle','--','Color','k')

subplot(2,2,4)
[~,GF2] = plotSSR_mod(greenF2EEG(:,[occpChans parietalChans],:),Fs);
title(sprintf('Green Freq %s SSR',num2str(actualfreq2)))
xlim([0 40])
ylim([0 1.5])
line([12.5 12.5],[0 1.5],'LineStyle','--','Color','k')
line([18.75 18.75],[0 1.5],'LineStyle','--','Color','k')

%% Plot SSR Chan means
figure;

subplot(2,2,1)
meanRF1 = mean(RF1,2);
plot(bin,meanRF1);
title(sprintf('Blue Freq %s SSR',num2str(actualfreq1)))
xlim([0 40])
ylim([0 1])
line([12.5 12.5],[0 1.5],'LineStyle','--','Color','k')
line([18.75 18.75],[0 1.5],'LineStyle','--','Color','k')

subplot(2,2,2)
meanRF2 = mean(RF2,2);
plot(bin,meanRF2);
title(sprintf('Blue Freq %s SSR',num2str(actualfreq2)))
xlim([0 40])
ylim([0 1])
line([12.5 12.5],[0 1.5],'LineStyle','--','Color','k')
line([18.75 18.75],[0 1.5],'LineStyle','--','Color','k')

subplot(2,2,3)
meanGF1 = mean(GF1,2);
plot(bin,meanGF1);
title(sprintf('Green Freq %s SSR',num2str(actualfreq1)))
xlim([0 40])
ylim([0 1])
line([12.5 12.5],[0 1.5],'LineStyle','--','Color','k')
line([18.75 18.75],[0 1.5],'LineStyle','--','Color','k')

subplot(2,2,4)
meanGF2 = mean(GF2,2);
plot(bin,meanGF2);
title(sprintf('Green Freq %s SSR',num2str(actualfreq2)))
xlim([0 40])
ylim([0 1])
line([12.5 12.5],[0 1.5],'LineStyle','--','Color','k')
line([18.75 18.75],[0 1.5],'LineStyle','--','Color','k')


%% Plot SNR
figure;

subplot(2,2,1)
plotSSR(redF1EEG(:,[occpChans parietalChans],:),Fs,'snr',1,'snrwidth',4)
title(sprintf('Blue Freq %s SNR',num2str(actualfreq1)))
xlim([4 40])
ylim([0 10])
line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
line([18.75 18.75],[0 10],'LineStyle','--','Color','k')

subplot(2,2,2)
plotSSR(redF2EEG(:,[occpChans parietalChans],:),Fs,'snr',1,'snrwidth',4)
title(sprintf('Blue Freq %s SNR',num2str(actualfreq2)))
xlim([4 40])
ylim([0 10])
line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
line([18.75 18.75],[0 10],'LineStyle','--','Color','k')

subplot(2,2,3)
plotSSR(greenF1EEG(:,[occpChans parietalChans],:),Fs,'snr',1,'snrwidth',4)
title(sprintf('Green Freq %s SNR',num2str(actualfreq1)))
xlim([4 40])
ylim([0 10])
line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
line([18.75 18.75],[0 10],'LineStyle','--','Color','k')

subplot(2,2,4)
plotSSR(greenF2EEG(:,[occpChans parietalChans],:),Fs,'snr',1,'snrwidth',4)
title(sprintf('Green Freq %s SNR',num2str(actualfreq2)))
xlim([4 40])
ylim([0 10])
line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
line([18.75 18.75],[0 10],'LineStyle','--','Color','k')
















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









