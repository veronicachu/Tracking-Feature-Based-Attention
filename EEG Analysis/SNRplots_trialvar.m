clear;
load('SNRDataTrials.mat')

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
names = fieldnames(FFTData);

% Pre-allocate matricies
RF1SNR = zeros(216,length(targChans),length(names));
RF2SNR = zeros(216,length(targChans),length(names));
GF1SNR = zeros(216,length(targChans),length(names));
GF2SNR = zeros(216,length(targChans),length(names));

for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    bin = FFTData.(names{i}).bin;
    RF1 = FFTData.(names{i}).RF1SNR(:,7,:);
    RF2 = FFTData.(names{i}).RF2SNR(:,7,:);
    GF1 = FFTData.(names{i}).GF1SNR(:,7,:);
    GF2 = FFTData.(names{i}).GF2SNR(:,7,:);
    
    % Channel Mean
    meanRF1 = squeeze(mean(RF1,2));
    meanRF2 = squeeze(mean(RF2,2));
    meanGF1 = squeeze(mean(GF1,2));
    meanGF2 = squeeze(mean(GF2,2));
    
    % Plot SNR
    h = figure('units','normalized','outerposition',[0 0 1 1]);
    title(names{i})
    
    % Blue 12.5 Hz
    subplot(2,2,1)
    shadedErrorBar(bin,mean(meanRF1,2),std(meanRF1,[],2))
    title(sprintf('Blue Freq %s SNR',num2str(actualfreq1)),'FontSize',14)
    xlim([4 40])
    ylim([0 5])
    line([12.5 12.5],[0 5],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 5],'LineStyle','--','Color','k')
    
    % Blue 18.75 Hz
    subplot(2,2,2)
    shadedErrorBar(bin,mean(meanRF2,2),std(meanRF2,[],2))
    title(sprintf('Blue Freq %s SNR',num2str(actualfreq2)),'FontSize',14)
    xlim([4 40])
    ylim([0 5])
    line([12.5 12.5],[0 5],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 5],'LineStyle','--','Color','k')
    
    % Green 12.5 Hz
    subplot(2,2,3)
    shadedErrorBar(bin,mean(meanGF1,2),std(meanGF1,[],2))
    title(sprintf('Green Freq %s SNR',num2str(actualfreq1)),'FontSize',14)
    xlim([4 40])
    ylim([0 5])
    line([12.5 12.5],[0 5],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 5],'LineStyle','--','Color','k')
    
    % Green 18.75 Hz
    subplot(2,2,4)
    shadedErrorBar(bin,mean(meanGF2,2),std(meanGF2,[],2))
    title(sprintf('Green Freq %s SNR',num2str(actualfreq2)),'FontSize',14)
    xlim([4 40])
    ylim([0 5])
    line([12.5 12.5],[0 5],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 5],'LineStyle','--','Color','k')
    
    saveas(h,sprintf('Figures/%s SNR_Oz.png', names{i}))
end

close all