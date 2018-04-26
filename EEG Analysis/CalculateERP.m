clear;
load('AllSubjData')

%% Setup Parameters
Fs = 1024;

% Set up target freqs
freq1 = 12.5;
freq2 = 18.75;

% Set up target channels
parietalChans = [29 55:58 63:64];
occpChans = 30:32;
targChans = [29 occpChans];

%% Plot Individual Overall ERPs

% Grab all subjects in struct
subjs = fieldnames(Data);
nSamp = size(Data.S401.PreSegmentedEEG,1);

% Pre-allocate matrices
ERP = zeros(nSamp,length(targChans),length(subjs));
filteredERP = zeros(nSamp,length(targChans),length(subjs));
meanERP = zeros(nSamp,length(subjs));

figure;
for i = 1:length(subjs)
    disp(subjs{i})
    
    % Grab individual subject data
    tempSubj = Data.(subjs{i});
    EEG = tempSubj.PreSegmentedEEG;
    
    % Calculate ERPs
    ERP(:,:,i) = mean(EEG(:,targChans),3);
    
    % Filter out high frequencies in ERP
    filteredERP(:,:,i) = filtereeg(ERP(:,:,i),Fs,[1 10],[.25 60],10);
    
    % Calculate Mean Chan ERP
    meanERP(:,i) = mean(filteredERP(:,:,i),2);
    
    % Create figure
    subplot(3,7,i)
    time = linspace(-1,1,Fs*2);
    plot(time,meanERP(Fs+1:Fs*3,i),'LineWidth',1.5,'Color','k');
    
    % Reference line
    xax = refline(0,0);
    xax.LineStyle = '--';
    xax.Color = 'k';
    
    % Figure properties
    ylim([-20 20])
    title(sprintf('%s ERP',subjs{i}))
end

%% Plot Grand Averaged Overall ERP

% Calculate grand averaged ERP
grandERP = mean(filteredERP,3);
% grandERP = mean(meanERP,2);

% Create figure
figure;
time = linspace(0,600,round(Fs*.6));
plot(time,grandERP(round(Fs*2+1):round(Fs*2.6),:),'LineWidth',1.5)

% Reference line
xax = refline(0,0);
xax.LineStyle = '--';
xax.Color = 'k';

% Figure properties
% set(gca,'YDir','reverse')
title('Grand Averaged ERP','FontSize',18)
xlabel('Time (ms)','FontSize',14)
ylabel('Amplitude (mV)','FontSize',14)


%% Plot Individual ERPs by Condition

% Grab all subjects in struct
subjs = fieldnames(Data);
nSamp = size(Data.S401.SegmentedEEG,1);

% Pre-allocate matrices
meanERP_RF1 = zeros(nSamp,length(subjs));
meanERP_RF2 = zeros(nSamp,length(subjs));
meanERP_GF1 = zeros(nSamp,length(subjs));
meanERP_GF2 = zeros(nSamp,length(subjs));

for i = 1:length(subjs)
    disp(subjs{i})
    
    % Grab individual subject data
    tempSubj = Data.(subjs{i});
    EEG = tempSubj.SegmentedEEG;
    TrialData = tempSubj.TrialData;
    badtrials = tempSubj.badtrials;
    
    % Segment by condition
    [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,freq1,freq2,badtrials);
    
    % Calculate ERPs
    ERP_RF1 = mean(redF1EEG(:,targChans),3);
    ERP_RF2 = mean(redF2EEG(:,targChans),3);
    ERP_GF1 = mean(greenF1EEG(:,targChans),3);
    ERP_GF2 = mean(greenF2EEG(:,targChans),3);
    
    % Filter out high frequencies in ERP
    filteredERP_RF1 = filtereeg(ERP_RF1,Fs,[1 10],[.25 60],10);
    filteredERP_RF2 = filtereeg(ERP_RF2,Fs,[1 10],[.25 60],10);
    filteredERP_GF1 = filtereeg(ERP_GF1,Fs,[1 10],[.25 60],10);
    filteredERP_GF2 = filtereeg(ERP_GF2,Fs,[1 10],[.25 60],10);
    
    % Calculate Mean Chan ERP
    meanERP_RF1(:,i) = mean(filteredERP_RF1,2);
    meanERP_RF2(:,i) = mean(filteredERP_RF2,2);
    meanERP_GF1(:,i) = mean(filteredERP_GF1,2);
    meanERP_GF2(:,i) = mean(filteredERP_GF2,2);
    
    % Create figure
    figure;
    
    %---- Blue F1 ----
    subplot(2,2,1)
    time = linspace(0,1,Fs);
    plot(time,meanERP_RF1(1:Fs,i),'LineWidth',1.5,'Color','k');
    
    % Reference line
    xax = refline(0,0);
    xax.LineStyle = '--';
    xax.Color = 'k';
    
    % Figure properties
    ylim([-20 20])
    title(sprintf('%s ERP - Blue 12.5Hz',subjs{i}))
    
    %---- Blue F2 ----
    subplot(2,2,2)
    time = linspace(0,1,Fs);
    plot(time,meanERP_RF2(1:Fs,i),'LineWidth',1.5,'Color','k');
    
    % Reference line
    xax = refline(0,0);
    xax.LineStyle = '--';
    xax.Color = 'k';
    
    % Figure properties
    ylim([-20 20])
    title(sprintf('%s ERP - Blue 18.75Hz',subjs{i}))
    
    %---- Green F1 ----
    subplot(2,2,3)
    time = linspace(0,1,Fs);
    plot(time,meanERP_GF1(1:Fs,i),'LineWidth',1.5,'Color','k');
    
    % Reference line
    xax = refline(0,0);
    xax.LineStyle = '--';
    xax.Color = 'k';
    
    % Figure properties
    ylim([-20 20])
    title(sprintf('%s ERP - Green 12.5Hz',subjs{i}))
    
    %---- Green F2 ----
    subplot(2,2,4)
    time = linspace(0,1,Fs);
    plot(time,meanERP_GF2(1:Fs,i),'LineWidth',1.5,'Color','k');
    
    % Reference line
    xax = refline(0,0);
    xax.LineStyle = '--';
    xax.Color = 'k';
    
    % Figure properties
    ylim([-20 20])
    title(sprintf('%s ERP - Green 18.75Hz',subjs{i}))
end

%% Plot Grand Averaged ERP by Condition

% Calculate grand averaged ERP
grandERP_RF1 = mean(meanERP_RF1,2);
grandERP_RF2 = mean(meanERP_RF2,2);
grandERP_GF1 = mean(meanERP_GF1,2);
grandERP_GF2 = mean(meanERP_GF2,2);

% Create figure
figure;
time = linspace(0,600,round(Fs*.6));

%---- Blue F1 ----
subplot(2,2,1)
plot(time,grandERP_RF1(1:round(Fs*.6)),'LineWidth',1.5,'Color','k')

% Reference line
xax = refline(0,0);
xax.LineStyle = '--';
xax.Color = 'k';

% Figure properties
title('Grand Averaged ERP - Blue 12.5Hz','FontSize',18)
xlabel('Time (ms)','FontSize',14)
ylabel('Amplitude (mV)','FontSize',14)

%---- Blue F2 ----
subplot(2,2,2)
plot(time,grandERP_RF2(1:round(Fs*.6)),'LineWidth',1.5,'Color','k')

% Reference line
xax = refline(0,0);
xax.LineStyle = '--';
xax.Color = 'k';

% Figure properties
title('Grand Averaged ERP - Blue 18.75Hz','FontSize',18)
xlabel('Time (ms)','FontSize',14)
ylabel('Amplitude (mV)','FontSize',14)


%---- Green F1 ----
subplot(2,2,3)
plot(time,grandERP_GF1(1:round(Fs*.6)),'LineWidth',1.5,'Color','k')

% Reference line
xax = refline(0,0);
xax.LineStyle = '--';
xax.Color = 'k';

% Figure properties
title('Grand Averaged ERP - Green 12.5Hz','FontSize',18)
xlabel('Time (ms)','FontSize',14)
ylabel('Amplitude (mV)','FontSize',14)


%---- Green F2 ----
subplot(2,2,4)
plot(time,grandERP_GF2(1:round(Fs*.6)),'LineWidth',1.5,'Color','k')

% Reference line
xax = refline(0,0);
xax.LineStyle = '--';
xax.Color = 'k';

% Figure properties
title('Grand Averaged ERP - Green 18.75Hz','FontSize',18)
xlabel('Time (ms)','FontSize',14)
ylabel('Amplitude (mV)','FontSize',14)


