clear;
subjnum = '401';

eegfile = sprintf('Segmented Data Files/%s_SegmentedEEG.mat',subjnum);
% eegfile = sprintf('Cleaned Data Files/%s_CleanedEEG.mat',subjnum);
load(eegfile)

% behfile = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP HUD Analyses/Behavioral Analysis/%s_ColorData.mat',subjnum);
% load(behfile);

EEG = SegmentedEEG;

%% 
parietalChans = [29 55:58 63:64];
occpChans = 30:32;

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