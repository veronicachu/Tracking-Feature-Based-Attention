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
targChans = [parietalChans occpChans];

%% Individual SNR Graphs
names = fieldnames(Data);

% Pre-allocate matricies
RF1SNR = zeros(216,length(targChans),length(names));
RF2SNR = zeros(216,length(targChans),length(names));
GF1SNR = zeros(216,length(targChans),length(names));
GF2SNR = zeros(216,length(targChans),length(names));

for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    TrialData = Data.(names{i}).TrialData;
    
    % Split EEG data in half
    EEG = SegmentedEEG(Fs*2:end-Fs-1,:,:);
    
    % Separate out incorrect trials
    badtrials = find(TrialData.Correct == 0);
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);
    
    % Plot SNR
    h = figure('units','normalized','outerposition',[0 0 1 1]);
    title(names{i})
    
    % Blue 12.5 Hz
    subplot(2,2,1)
    [bin,RF1SNR(:,:,i)] = plotSSR_mod(redF1EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    title(sprintf('Blue Freq %s SNR',num2str(actualfreq1)))
    xlim([4 40])
    ylim([0 10])
    line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 10],'LineStyle','--','Color','k')
    
    % Blue 18.75 Hz
    subplot(2,2,2)
    [~,RF2SNR(:,:,i)] = plotSSR_mod(redF2EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    title(sprintf('Blue Freq %s SNR',num2str(actualfreq2)))
    xlim([4 40])
    ylim([0 10])
    line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 10],'LineStyle','--','Color','k')
    
    % Green 12.5 Hz
    subplot(2,2,3)
    [~,GF1SNR(:,:,i)] = plotSSR_mod(greenF1EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    title(sprintf('Green Freq %s SNR',num2str(actualfreq1)))
    xlim([4 40])
    ylim([0 10])
    line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 10],'LineStyle','--','Color','k')
    
    % Green 18.75 Hz
    subplot(2,2,4)
    [~,GF2SNR(:,:,i)] = plotSSR_mod(greenF2EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    title(sprintf('Green Freq %s SNR',num2str(actualfreq2)))
    xlim([4 40])
    ylim([0 10])
    line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 10],'LineStyle','--','Color','k')
    
%     saveas(h,sprintf('Figures/%s SNR_correct.png', names{i}))
end

close all

%% Average SNR Graph

RF1SNR_mean = mean(RF1SNR,3);
RF2SNR_mean = mean(RF2SNR,3);
GF1SNR_mean = mean(GF1SNR,3);
GF2SNR_mean = mean(GF2SNR,3);

figure;
subplot(2,2,1)
plot(bin,RF1SNR_mean)
title(sprintf('Blue Freq %s SNR',num2str(actualfreq1)))
xlim([4 40])
ylim([0 8])
line([12.5 12.5],[0 8],'LineStyle',':','Color','k')
line([18.75 18.75],[0 8],'LineStyle',':','Color','k')

subplot(2,2,2)
plot(bin,RF2SNR_mean)
title(sprintf('Blue Freq %s SNR',num2str(actualfreq2)))
xlim([4 40])
ylim([0 8])
line([12.5 12.5],[0 8],'LineStyle',':','Color','k')
line([18.75 18.75],[0 8],'LineStyle',':','Color','k')

subplot(2,2,3)
plot(bin,GF1SNR_mean)
title(sprintf('Green Freq %s SNR',num2str(actualfreq1)))
xlim([4 40])
ylim([0 8])
line([12.5 12.5],[0 8],'LineStyle',':','Color','k')
line([18.75 18.75],[0 8],'LineStyle',':','Color','k')

subplot(2,2,4)
plot(bin,GF2SNR_mean)
title(sprintf('Green Freq %s SNR',num2str(actualfreq2)))
xlim([4 40])
ylim([0 8])
line([12.5 12.5],[0 8],'LineStyle',':','Color','k')
line([18.75 18.75],[0 8],'LineStyle',':','Color','k')
















