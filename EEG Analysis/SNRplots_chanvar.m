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
    EEG1 = SegmentedEEG(1:Fs*4,:,:);
    EEG2 = SegmentedEEG(Fs*4+1:Fs*8,:,:);
    badtrials = 0;
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG1,TrialData,actualfreq1,actualfreq2,badtrials);
    [redF1EEG(:,:,33:64),redF2EEG(:,:,33:64),greenF1EEG(:,:,33:64),greenF2EEG(:,:,33:64)] = extractTrialType(EEG2,TrialData,actualfreq1,actualfreq2,badtrials);
    
    % Calculate SNR by condition
    [bin,RF1SNR(:,:,i)] = plotSSR_mod(redF1EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,RF2SNR(:,:,i)] = plotSSR_mod(redF2EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF1SNR(:,:,i)] = plotSSR_mod(greenF1EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    [~,GF2SNR(:,:,i)] = plotSSR_mod(greenF2EEG(:,targChans,:),Fs,'snr',1,'snrwidth',4);
    
    % Plot SNR
    h = figure('units','normalized','outerposition',[0 0 1 1]);
    title(names{i})
    
    % Blue 12.5 Hz
    subplot(2,2,1)
    shadedErrorBar(bin,mean(RF1SNR(:,:,i),2),std(RF1SNR(:,:,i),[],2))
    title(sprintf('Blue Freq %s SNR',num2str(actualfreq1)),'FontSize',14)
    xlim([4 40])
    ylim([0 14])
    line([12.5 12.5],[0 14],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 14],'LineStyle','--','Color','k')
    
    % Blue 18.75 Hz
    subplot(2,2,2)
    shadedErrorBar(bin,mean(RF2SNR(:,:,i),2),std(RF1SNR(:,:,i),[],2))
    title(sprintf('Blue Freq %s SNR',num2str(actualfreq2)),'FontSize',14)
    xlim([4 40])
    ylim([0 14])
    line([12.5 12.5],[0 14],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 14],'LineStyle','--','Color','k')
    
    % Green 12.5 Hz
    subplot(2,2,3)
    shadedErrorBar(bin,mean(GF1SNR(:,:,i),2),std(GF1SNR(:,:,i),[],2))
    title(sprintf('Green Freq %s SNR',num2str(actualfreq1)),'FontSize',14)
    xlim([4 40])
    ylim([0 14])
    line([12.5 12.5],[0 14],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 14],'LineStyle','--','Color','k')
    
    % Green 18.75 Hz
    subplot(2,2,4)
    shadedErrorBar(bin,mean(GF2SNR(:,:,i),2),std(GF2SNR(:,:,i),[],2))
    title(sprintf('Green Freq %s SNR',num2str(actualfreq2)),'FontSize',14)
    xlim([4 40])
    ylim([0 14])
    line([12.5 12.5],[0 14],'LineStyle','--','Color','k')
    line([18.75 18.75],[0 14],'LineStyle','--','Color','k')
    
%     saveas(h,sprintf('Figures/%s SNR.png', names{i}))
end

close all