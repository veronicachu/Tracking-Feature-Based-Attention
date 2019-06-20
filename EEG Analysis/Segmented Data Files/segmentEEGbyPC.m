% !!Warning!! Is not accurate in determining start

clear;
subjnum = '102';
trialnum = '102-1';

file = sprintf('../Filtered Data Files/Subj %s/%s_FilteredEEG.mat',subjnum,trialnum);
load(file)

% Settings for Segmented Data
SecBeforeOnset = 3;
SecAfterOnset = 8;
startMod = Fs*SecBeforeOnset;
endMod = Fs*SecAfterOnset-1;

% Get Photocell data
pc = dataExp{1}.time_series(68,:)';

% Filter PC data
pcdata = filtereeg(pc,Fs,[1 30],[.25 60],10);

% Zero out negative values from PC data
pcdata(pcdata<0) = 0;

%% Find exact start of PC
start = extractbyPC(pcdata,200,64);     % pcdata, expected buffer, # of trials x 2

%% Find actual trials
clc
for i = 1:length(start)-1
    plot(pcdata(start(i):start(i)+Fs*8))
    
    uicontrol('Style','pushbutton','String','Yes',...
        'Position', [20 140 50 40],...
        'Callback',{@pushbutton_callback,i});
    title(sprintf('Start #%d',i),'FontSize',20)
    pause
end
close all

%% Filter out actual trials
actual = xlsread(sprintf('Subj %s Actual Start',trialnum));
start2 = start(actual);

%% Segment Data Exactly at Onset
for i = 1:length(start2)
    plot(pcdata(start2(i):start2(i)+endMod))
    PCData(:,:,i) = pcdata(start2(i):start2(i)+endMod);
    SegmentedEEG(:,:,i) = filteredEEG(start2(i):start2(i)+endMod,:);
    
    title(sprintf('Trial %d',i),'FontSize',20)
    pause 
end
close all

%% Segmented Data with Time Before Onset
 
for i = 1:length(start2)
    plot(pcdata(start2(i)-startMod:start2(i)+endMod))
    PrePCData(:,:,i) = pcdata(start2(i)-startMod:start2 (i)+endMod);
    PreSegmentedEEG(:,:,i) = filteredEEG(start2(i)-startMod:start2(i)+endMod,:);
    
    title(sprintf('Trial %d',i),'FontSize',20)
    pause
end
close all

badtrials = 0;
% SegmentedEEG(:,:,badtrials) = 0;

%% Save segmented EEG
save(sprintf('%s_SegmentedEEG',trialnum),...
   'nChan','Fs','start','startMod','endMod','badtrials',...
   'PCData','SegmentedEEG','PrePCData','PreSegmentedEEG')









