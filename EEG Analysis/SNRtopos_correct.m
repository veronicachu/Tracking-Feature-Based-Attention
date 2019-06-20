clear;
load('AllSubjData.mat')

%%
load('ANTWAVE64')
hm = ANTWAVE64;
chanNames = ANTWAVE64.ChanNames;
Fs = 1024;

% Frequencies of Interest
actualfreq1 = 12.5;
actualfreq2 = 18.75;

%% Individual SNR Graphs
names = fieldnames(Data);

% Pre-allocate matricies
RF1SNR = zeros(216,length(chanNames),length(names));
RF2SNR = zeros(216,length(chanNames),length(names));
GF1SNR = zeros(216,length(chanNames),length(names));
GF2SNR = zeros(216,length(chanNames),length(names));

for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    TrialData = Data.(names{i}).TrialData;
    
    % Split EEG data in half
    EEG1 = SegmentedEEG(1:Fs*4,:,:);
    EEG2 = SegmentedEEG(Fs*4+1:Fs*8,:,:);
    
    % Separate out incorrect trials
    badtrials = find(TrialData.Correct == 0);
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG1,TrialData,actualfreq1,actualfreq2,badtrials);
    sizeRF1 = size(redF1EEG,3);
    sizeRF2 = size(redF2EEG,3);
    sizeGF1 = size(greenF1EEG,3);
    sizeGF2 = size(greenF2EEG,3);
    
    [redF1EEG(:,:,sizeRF1+1:sizeRF1*2),redF2EEG(:,:,sizeRF2+1:sizeRF2*2),greenF1EEG(:,:,sizeGF1+1:sizeGF1*2),greenF2EEG(:,:,sizeGF2+1:sizeGF2*2)]...
        = extractTrialType(EEG2,TrialData,actualfreq1,actualfreq2,badtrials);
    
    % Calculate SNR
    [bin,RF1SNR(:,:,i)] = plotSSR_mod(redF1EEG,Fs,'snr',1,'snrwidth',4);
    [~,RF2SNR(:,:,i)] = plotSSR_mod(redF2EEG,Fs,'snr',1,'snrwidth',4);
    [~,GF1SNR(:,:,i)] = plotSSR_mod(greenF1EEG,Fs,'snr',1,'snrwidth',4);
    [~,GF2SNR(:,:,i)] = plotSSR_mod(greenF2EEG,Fs,'snr',1,'snrwidth',4);
    
    % Remove NaNs
    RF1SNR(isnan(RF1SNR)) = 0;
    RF2SNR(isnan(RF2SNR)) = 0;
    GF1SNR(isnan(GF1SNR)) = 0;
    GF2SNR(isnan(GF2SNR)) = 0;
    
    % Find index of target freqs
    freq1 = find(bin == actualfreq1);
    freq2 = find(bin == actualfreq2);
    
    % Plot SNR
%     h = figure('units','normalized','outerposition',[0 0 1 1]);
%     
%     % Blue 12.5 Hz
%     subplot(2,2,1)
%     corttopo(RF1SNR(freq1,:,i),hm,'cmap','jet')
%     caxis([0 limits])
%     colorbar
%     title(sprintf('Blue at %s Hz',num2str(actualfreq1)))
%     
%     % Blue 18.75 Hz
%     subplot(2,2,2)
%     corttopo(RF2SNR(freq2,:,i),hm,'cmap','jet')
%     caxis([0 limits])
%     colorbar
%     title(sprintf('Blue at %s Hz',num2str(actualfreq2)))
%     
%     % Green 12.5 Hz
%     subplot(2,2,3)
%     corttopo(GF1SNR(freq1,:,i),hm,'cmap','jet')
%     caxis([0 limits])
%     colorbar
%     title(sprintf('Green at %s Hz',num2str(actualfreq1)))
%     
%     % Green 18.75 Hz
%     subplot(2,2,4)
%     corttopo(GF2SNR(freq2,:,i),hm,'cmap','jet')
%     caxis([0 limits])
%     colorbar
%     title(sprintf('Green at %s Hz',num2str(actualfreq2)))
    
%     saveas(h,sprintf('Figures/%s SNR topo.png', names{i}))
end

close all

%% Average SNR Graph

RF1SNR_mean = nanmean(RF1SNR,3);
RF2SNR_mean = nanmean(RF2SNR,3);
GF1SNR_mean = nanmean(GF1SNR,3);
GF2SNR_mean = nanmean(GF2SNR,3);

lowerlimit = 1;
upperlimit = 3;

figure;
% Blue 12.5Hz
subplot(2,2,1)
corttopo(RF1SNR_mean(freq1,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4])
caxis([lowerlimit upperlimit])
h = colorbar('FontSize',18);
ylabel(h,'SNR');
title(sprintf('Attend Blue at %s Hz',num2str(actualfreq1)),'FontSize',22)

% Blue at 18.75Hz
subplot(2,2,2)
corttopo(RF2SNR_mean(freq2,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4])
caxis([lowerlimit upperlimit])
h = colorbar('FontSize',18);
ylabel(h,'SNR');
title(sprintf('Attend Blue at %s Hz',num2str(actualfreq2)),'FontSize',22)

% Green at 12.5Hz
subplot(2,2,3)
corttopo(GF1SNR_mean(freq1,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4])
caxis([lowerlimit upperlimit])
h = colorbar('FontSize',18);
ylabel(h,'SNR');
title(sprintf('Attend Green at %s Hz',num2str(actualfreq1)),'FontSize',22)

% Green at 18.75Hz
subplot(2,2,4)
    corttopo(GF2SNR_mean(freq2,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4])
caxis([lowerlimit upperlimit])
h = colorbar('FontSize',18);
ylabel(h,'SNR');
title(sprintf('Attend Green at %s Hz',num2str(actualfreq2)),'FontSize',22)

%--------------------------------------------------------------------------

% % Blue 12.5 Diff
% subplot(2,4,5)
% corttopo(RF1SNR_mean(freq1,:)-RF1SNR_mean(freq2,:),hm,'cmap','hot','drawcontours',1)
% caxis([-5 5])
% h = colorbar('FontSize',18);
% ylabel(h,'SNR');
% 
% % Blue 18.75 Diff
% subplot(2,4,6)
% corttopo(RF2SNR_mean(freq2,:)-RF2SNR_mean(freq1,:),hm,'cmap','hot','drawcontours',1)
% caxis([-5 5])
% h = colorbar('FontSize',18);
% ylabel(h,'SNR');
% 
% % Green 12.5 Diff
% subplot(2,4,7)
% corttopo(GF1SNR_mean(freq1,:)-GF1SNR_mean(freq2,:),hm,'cmap','hot','drawcontours',1)
% caxis([-5 5])
% colorbar
% 
% % Green 18.75 Diff
% subplot(2,4,8)
% corttopo(GF2SNR_mean(freq2,:)-GF2SNR_mean(freq1,:),hm,'cmap','hot','drawcontours',1)
% caxis([-5 5])
% colorbar














