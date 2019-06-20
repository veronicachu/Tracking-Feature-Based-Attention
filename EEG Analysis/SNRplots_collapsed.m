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
F1SNR = zeros(216,length(targChans),length(names));
F2SNR = zeros(216,length(targChans),length(names));

for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    TrialData = Data.(names{i}).TrialData;
    
    % Split EEG data in half
    EEG1 = SegmentedEEG(1:Fs*4,:,:);
    EEG2 = SegmentedEEG(Fs*4+1:Fs*8,:,:);
    badtrials = 0;
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG1,TrialData,actualfreq1,actualfreq2,badtrials);
    F1EEG(:,:,1:32) = redF1EEG;
    F1EEG(:,:,33:64) = greenF1EEG;
    F2EEG(:,:,1:32) = redF2EEG;
    F2EEG(:,:,33:64) = greenF2EEG;
    
    [redF1EEG(:,:,33:64),redF2EEG(:,:,33:64),greenF1EEG(:,:,33:64),greenF2EEG(:,:,33:64)] = extractTrialType(EEG2,TrialData,actualfreq1,actualfreq2,badtrials);
    F1EEG(:,:,65:96) = redF1EEG(:,:,33:64);
    F1EEG(:,:,97:128) = greenF1EEG(:,:,33:64);
    F2EEG(:,:,65:96) = redF2EEG(:,:,33:64);
    F2EEG(:,:,97:128) = greenF2EEG(:,:,33:64);
    
    % Plot SNR
    h = figure('units','normalized','outerposition',[0 0 1 1]);
    title(names{i})
    
    % Blue 12.5 Hz
    subplot(2,1,1)
    [bin,F1SNR(:,:,i)] = plotSSR_mod(F1EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    title(sprintf('Blue Freq %s SNR',num2str(actualfreq1)))
    xlim([4 40])
    ylim([0 10])
    line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 10],'LineStyle','--','Color','k')
    
    % Blue 18.75 Hz
    subplot(2,1,2)
    [~,F2SNR(:,:,i)] = plotSSR_mod(F2EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    title(sprintf('Blue Freq %s SNR',num2str(actualfreq2)))
    xlim([4 40])
    ylim([0 10])
    line([12.5 12.5],[0 10],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 10],'LineStyle','--','Color','k')
    
%     saveas(h,sprintf('Figures/%s SNR.png', names{i}))
end

close all

%% Chan/Subj Chan Average SNR Graph
F1SNR_mean = squeeze(nanmean(F1SNR,2));
F2SNR_mean = squeeze(nanmean(F2SNR,2));

figure;
subplot(2,1,1)
hold on
plot(bin,mean(F1SNR_mean,2),'k','LineWidth',1)
shadedErrorBar(bin,mean(F1SNR_mean,2),std(F1SNR_mean,[],2))
line([12.5 12.5],[0 12],'LineStyle',':','Color','k')
line([18.75 18.75],[0 12],'LineStyle',':','Color','k')
xlim([10 40])
ylim([0 9])
xlabel('Frequencies','FontSize',12)
ylabel('SNR','FontSize',12)
title(sprintf('Attended at %sHz',num2str(actualfreq1)),'FontSize',16)


subplot(2,1,2)
hold on
plot(bin,mean(F2SNR_mean,2),'k','LineWidth',1)
shadedErrorBar(bin,mean(F2SNR_mean,2),std(F2SNR_mean,[],2))
line([12.5 12.5],[0 12],'LineStyle',':','Color','k')
line([18.75 18.75],[0 12],'LineStyle',':','Color','k')
line([25 25],[0 12],'LineStyle',':','Color','k')
line([37.5 37.5],[0 12],'LineStyle',':','Color','k')
xlim([10 40])
ylim([0 9])
xlabel('Frequencies','FontSize',12)
ylabel('SNR','FontSize',12)
title(sprintf('Attended at %sHz',num2str(actualfreq2)),'FontSize',16)























