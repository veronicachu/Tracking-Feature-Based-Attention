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
topChans = [21 22 49 16 30 32 31 29 26 53];
targChans = [topChans];

%% Individual SNR Graphs
names = fieldnames(Data);

% Pre-allocate matricies
RF1SNR = zeros(400,length(targChans),length(names));
RF2SNR = zeros(400,length(targChans),length(names));
GF1SNR = zeros(400,length(targChans),length(names));
GF2SNR = zeros(400,length(targChans),length(names));

for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    TrialData = Data.(names{i}).TrialData;
    
    % Split EEG data in half
    EEG = SegmentedEEG(1:Fs*8,:,:);
%     EEG1 = SegmentedEEG(1:Fs*4,:,:);
%     EEG2 = SegmentedEEG(Fs*4+1:Fs*8,:,:);
    badtrials = 0;
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);
%     [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG1,TrialData,actualfreq1,actualfreq2,badtrials);
%     [redF1EEG(:,:,33:64),redF2EEG(:,:,33:64),greenF1EEG(:,:,33:64),greenF2EEG(:,:,33:64)] = extractTrialType(EEG2,TrialData,actualfreq1,actualfreq2,badtrials);
    
    % Plot SNR
    h = figure('units','normalized','outerposition',[0 0 1 1]);
    title(names{i})
    
    % Blue 12.5 Hz
    subplot(2,2,1)
    [bin,RF1SNR(:,:,i)] = plotSSR_mod(redF1EEG(:,targChans,:),Fs);
    title(sprintf('Blue Freq %s SNR',num2str(actualfreq1)))
    xlim([4 40])
    ylim([0 10])
    line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 10],'LineStyle','--','Color','k')
    
    % Blue 18.75 Hz
    subplot(2,2,2)
    [~,RF2SNR(:,:,i)] = plotSSR_mod(redF2EEG(:,targChans,:),Fs);
    title(sprintf('Blue Freq %s SNR',num2str(actualfreq2)))
    xlim([4 40])
    ylim([0 10])
    line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 10],'LineStyle','--','Color','k')
    
    % Green 12.5 Hz
    subplot(2,2,3)
    [~,GF1SNR(:,:,i)] = plotSSR_mod(greenF1EEG(:,targChans,:),Fs);
    title(sprintf('Green Freq %s SNR',num2str(actualfreq1)))
    xlim([4 40])
    ylim([0 10])
    line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 10],'LineStyle','--','Color','k')
    
    % Green 18.75 Hz
    subplot(2,2,4)
    [~,GF2SNR(:,:,i)] = plotSSR_mod(greenF2EEG(:,targChans,:),Fs);
    title(sprintf('Green Freq %s SNR',num2str(actualfreq2)))
    xlim([4 40])
    ylim([0 10])
    line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 10],'LineStyle','--','Color','k')
    
%     saveas(h,sprintf('Figures/%s SNR.png', names{i}))
end

close all

%% Chan/Subj Chan Average SNR Graph
RF1SNR_mean = squeeze(nanmean(RF1SNR,2));
RF2SNR_mean = squeeze(nanmean(RF2SNR,2));
GF1SNR_mean = squeeze(nanmean(GF1SNR,2));
GF2SNR_mean = squeeze(nanmean(GF2SNR,2));

figure;
subplot(2,2,1)
hold on
plot(bin,mean(RF1SNR_mean,2),'k','LineWidth',1)
shadedErrorBar(bin,mean(RF1SNR_mean,2),std(RF1SNR_mean,[],2))
title(sprintf('Attend Blue at %sHz',num2str(actualfreq1)),'FontSize',14)
xlim([4 40])
ylim([0 0.7])
line([12.5 12.5],[0 14],'LineStyle',':','Color','k')
line([18.75 18.75],[0 14],'LineStyle',':','Color','k')
ylabel('Amplitude (\muV)')

subplot(2,2,2)
hold on
plot(bin,mean(RF2SNR_mean,2),'k','LineWidth',1)
shadedErrorBar(bin,mean(RF2SNR_mean,2),std(RF2SNR_mean,[],2))
title(sprintf('Attend Blue at %sHz',num2str(actualfreq2)),'FontSize',14)
xlim([4 40])
ylim([0 0.7])
line([12.5 12.5],[0 14],'LineStyle',':','Color','k')
line([18.75 18.75],[0 14],'LineStyle',':','Color','k')

subplot(2,2,3)
hold on
plot(bin,mean(GF1SNR_mean,2),'k','LineWidth',1)
shadedErrorBar(bin,mean(GF1SNR_mean,2),std(GF1SNR_mean,[],2))
title(sprintf('Attend Green at %sHz',num2str(actualfreq1)),'FontSize',14)
xlim([4 40])
ylim([0 0.7])
line([12.5 12.5],[0 14],'LineStyle',':','Color','k')
line([18.75 18.75],[0 14],'LineStyle',':','Color','k')
xlabel('Frequency (Hz)')
ylabel('Amplitude (\muV)')

subplot(2,2,4)
hold on
plot(bin,mean(GF2SNR_mean,2),'k','LineWidth',1)
shadedErrorBar(bin,mean(GF2SNR_mean,2),std(GF2SNR_mean,[],2))
title(sprintf('Attend Green at %sHz',num2str(actualfreq2)),'FontSize',14)
xlim([4 40])
ylim([0 0.7])
line([12.5 12.5],[0 14],'LineStyle',':','Color','k')
line([18.75 18.75],[0 14],'LineStyle',':','Color','k')
xlabel('Frequency (Hz)')













