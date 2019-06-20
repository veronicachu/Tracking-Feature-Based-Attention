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
RF1SNR = zeros(432,length(chanNames),length(names));
RF2SNR = zeros(432,length(chanNames),length(names));
GF1SNR = zeros(432,length(chanNames),length(names));
GF2SNR = zeros(432,length(chanNames),length(names));

for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    TrialData = Data.(names{i}).TrialData;
    
    % Split EEG data in half
    EEG1 = SegmentedEEG(1:Fs*8,:,:);
%     EEG2 = SegmentedEEG(Fs*4+1:Fs*8,:,:);
    badtrials = 0;
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG1,TrialData,actualfreq1,actualfreq2,badtrials);
%     [redF1EEG(:,:,33:64),redF2EEG(:,:,33:64),greenF1EEG(:,:,33:64),greenF2EEG(:,:,33:64)] = extractTrialType(EEG2,TrialData,actualfreq1,actualfreq2,badtrials);
    
    % Calculate SNR
    [bin,RF1SNR(:,:,i)] = plotSSR_mod2(redF1EEG,Fs,'snr',1,'snrwidth',4);
    [~,RF2SNR(:,:,i)] = plotSSR_mod2(redF2EEG,Fs,'snr',1,'snrwidth',4);
    [~,GF1SNR(:,:,i)] = plotSSR_mod2(greenF1EEG,Fs,'snr',1,'snrwidth',4);
    [~,GF2SNR(:,:,i)] = plotSSR_mod2(greenF2EEG,Fs,'snr',1,'snrwidth',4);
    
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

%% Average SNR

RF1SNR_mean = mean(RF1SNR,3);
RF2SNR_mean = mean(RF2SNR,3);
GF1SNR_mean = mean(GF1SNR,3);
GF2SNR_mean = mean(GF2SNR,3);

lowerlimit = 0.5;
upperlimit = 4;

%% Topo Graph - Blue Attended and Green Unattended
figure;
% Attend Blue 12.5Hz
subplot(4,2,1)
corttopo(RF1SNR_mean(freq1,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4],'channumbers',0)
caxis([lowerlimit upperlimit])
h = colorbar('FontSize',14);
ylabel(h,'SNR');
title(sprintf('Attended Blue at %s Hz',num2str(actualfreq1)),'FontSize',20)

% Unattend Green 18.75Hz
subplot(4,2,2)
corttopo(RF1SNR_mean(freq2,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4],'channumbers',0)
caxis([lowerlimit upperlimit])
h = colorbar('FontSize',14);
ylabel(h,'SNR');
title(sprintf('Unattended Green at %s Hz',num2str(actualfreq2)),'FontSize',20)

% Attend Blue 18.75Hz
subplot(4,2,3)
corttopo(RF2SNR_mean(freq2,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4],'channumbers',0)
caxis([lowerlimit upperlimit])
h = colorbar('FontSize',14);
ylabel(h,'SNR');
title(sprintf('Attended Blue at %s Hz',num2str(actualfreq2)),'FontSize',20)

% Unattend Green 12.5Hz
subplot(4,2,4)
corttopo(RF2SNR_mean(freq1,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4],'channumbers',0)
caxis([lowerlimit upperlimit])
h = colorbar('FontSize',14);
ylabel(h,'SNR');
title(sprintf('Unattended Green at %s Hz',num2str(actualfreq1)),'FontSize',20)


% Topo Graph - Green Attended and Blue Unattended
% figure;
% Attend Green 12.5Hz
subplot(4,2,5)
corttopo(GF1SNR_mean(freq1,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4],'channumbers',0)
caxis([lowerlimit upperlimit])
h = colorbar('FontSize',14);
ylabel(h,'SNR');
title(sprintf('Attended Green at %s Hz',num2str(actualfreq1)),'FontSize',20)

% Unattend Blue 18.75Hz
subplot(4,2,6)
corttopo(GF1SNR_mean(freq2,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4],'channumbers',0)
caxis([lowerlimit upperlimit])
h = colorbar('FontSize',14);
ylabel(h,'SNR');
title(sprintf('Unattended Blue at %s Hz',num2str(actualfreq2)),'FontSize',20)


% Attend Green 18.75Hz
subplot(4,2,7)
corttopo(GF2SNR_mean(freq2,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4],'channumbers',0)
caxis([lowerlimit upperlimit])
h = colorbar('FontSize',14);
ylabel(h,'SNR');
title(sprintf('Attended Green at %s Hz',num2str(actualfreq2)),'FontSize',20)

% Unattend Blue 12.5Hz
subplot(4,2,8)
corttopo(GF2SNR_mean(freq1,:),hm,'cmap','hot','drawcontours',1,'goodelectcolor',[.4,.4,.4],'channumbers',0)
caxis([lowerlimit upperlimit])
h = colorbar('FontSize',14);
ylabel(h,'SNR');
title(sprintf('Unattended Blue at %s Hz',num2str(actualfreq1)),'FontSize',20)

%% Highest channels
chanNames = ANTWAVE64.ChanNames;

[~,RF1ind] = sort(RF1SNR_mean(freq1,:),'descend');
RF1chan = chanNames(RF1ind);

[~,RF2ind] = sort(RF2SNR_mean(freq2,:),'descend');
RF2chan = chanNames(RF2ind);

[~,GF1ind] = sort(GF1SNR_mean(freq1,:),'descend');
GF1chan = chanNames(GF1ind);

[~,GF2ind] = sort(GF2SNR_mean(freq2,:),'descend');
GF2chan = chanNames(GF2ind);

sortedChans = [RF1chan RF2chan GF1chan GF2chan];
topChans = unique(sortedChans(1:6,:));














