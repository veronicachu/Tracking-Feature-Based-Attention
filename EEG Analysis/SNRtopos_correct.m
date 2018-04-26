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

% Topo Limits
limits = 6;

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
    EEG = SegmentedEEG(Fs*2:end-Fs-1,:,:);
    
    % Separate out incorrect trials
    badtrials = find(TrialData.Correct == 0);
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);
    
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
    h = figure('units','normalized','outerposition',[0 0 1 1]);
    
    % Blue 12.5 Hz
    subplot(2,2,1)
    corttopo(RF1SNR(freq1,:,i),hm,'cmap','jet')
    caxis([0 limits])
    colorbar
    title(sprintf('Blue at %s Hz',num2str(actualfreq1)))
    
    % Blue 18.75 Hz
    subplot(2,2,2)
    corttopo(RF2SNR(freq2,:,i),hm,'cmap','jet')
    caxis([0 limits])
    colorbar
    title(sprintf('Blue at %s Hz',num2str(actualfreq2)))
    
    % Green 12.5 Hz
    subplot(2,2,3)
    corttopo(GF1SNR(freq1,:,i),hm,'cmap','jet')
    caxis([0 limits])
    colorbar
    title(sprintf('Green at %s Hz',num2str(actualfreq1)))
    
    % Green 18.75 Hz
    subplot(2,2,4)
    corttopo(GF2SNR(freq2,:,i),hm,'cmap','jet')
    caxis([0 limits])
    colorbar
    title(sprintf('Green at %s Hz',num2str(actualfreq2)))
    
%     saveas(h,sprintf('Figures/%s SNR topo.png', names{i}))
end

close all

%% Average SNR Graph

RF1SNR_mean = mean(RF1SNR,3);
RF2SNR_mean = mean(RF2SNR,3);
GF1SNR_mean = mean(GF1SNR,3);
GF2SNR_mean = mean(GF2SNR,3);

limits = 5;

figure;
% Blue 12.5Hz
subplot(4,2,1)
corttopo(RF1SNR_mean(freq1,:),hm,'cmap','jet')
caxis([0 limits])
colorbar
title(sprintf('Attended Blue at %s Hz',num2str(actualfreq1)))

subplot(4,2,2)
corttopo(RF1SNR_mean(freq2,:),hm,'cmap','jet')
caxis([0 limits])
colorbar
title(sprintf('Unattended Green at %s Hz',num2str(actualfreq2)))

% Blue at 18.75Hz
subplot(4,2,3)
corttopo(RF2SNR_mean(freq2,:),hm,'cmap','jet')
caxis([0 limits])
colorbar
title(sprintf('Attended Blue at %s Hz',num2str(actualfreq2)))

subplot(4,2,4)
corttopo(RF2SNR_mean(freq1,:),hm,'cmap','jet')
caxis([0 limits])
colorbar
title(sprintf('Unattended Green at %s Hz',num2str(actualfreq1)))

% Green at 12.5Hz
subplot(4,2,5)
corttopo(GF1SNR_mean(freq1,:),hm,'cmap','jet')
caxis([0 limits])
colorbar
title(sprintf('Green at %s Hz',num2str(actualfreq1)))

subplot(4,2,6)
corttopo(GF1SNR_mean(freq2,:),hm,'cmap','jet')
caxis([0 limits])
colorbar
title(sprintf('Blue at %s Hz',num2str(actualfreq2)))

% Green at 18.75Hz
subplot(4,2,7)
corttopo(GF2SNR_mean(freq2,:),hm,'cmap','jet')
caxis([0 limits])
colorbar
title(sprintf('Green at %s Hz',num2str(actualfreq2)))

subplot(4,2,8)
corttopo(GF2SNR_mean(freq1,:),hm,'cmap','jet')
caxis([0 limits])
colorbar
title(sprintf('Blue at %s Hz',num2str(actualfreq1)))














