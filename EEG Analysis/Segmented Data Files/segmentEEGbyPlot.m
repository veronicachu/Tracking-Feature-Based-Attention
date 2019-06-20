clear;
subjnum = '123';
trialnum = '123-4';

file = sprintf('../Filtered Data Files/Subj %s/%s_FilteredEEG.mat',subjnum,trialnum);
load(file)

% Settings for Segmented Data
SecBeforeOnset = 2;
SecAfterOnset = 9;
SecAfterTrial = 2;
startMod = Fs*SecBeforeOnset;
endMod = Fs*SecAfterOnset-1;
endBuffer = endMod + Fs*SecAfterTrial;

% Get Photocell data
pc = dataExp{1}.time_series(68,:)';

% Filter PC data
pcdata = filtereeg(pc,Fs,[1 30],[.25 60],10);

% Zero out negative values from PC data
pcdata(pcdata<0) = 0;

% Plot PC Data
% plot(pcdata)

%% Filter out actual trials
start = zeros(length(cursor_info),1);

for i = 1:length(cursor_info)
    start(i) = cursor_info(i).DataIndex;
end

start = sort(start);

%% Check
x = pcdata(start);
y = pcdata(start+1);

%% Segment Data Exactly at Onset
for i = 1:length(start) 
    plot(pcdata(start(i):start(i)+endMod))
    PCData(:,:,i) = pcdata(start(i):start(i)+endMod);
    SegmentedEEG(:,:,i) = filteredEEG(start(i):start(i)+endMod,:);
    
    title(sprintf('Trial %d',i),'FontSize',20)
    pause
end
close all

%% Segmented Data with Time Before Onset
 
for i = 1:length(start)
    plot(pcdata(start(i)-startMod:start(i)+endBuffer))
    PrePCData(:,:,i) = pcdata(start(i)-startMod:start (i)+endBuffer);
    PreSegmentedEEG(:,:,i) = filteredEEG(start(i)-startMod:start(i)+endBuffer,:);
    
    title(sprintf('Trial %d',i),'FontSize',20)
    pause
end
close all

%% Save segmented EEG
save(sprintf('%s_SegmentedEEG',trialnum),...
   'nChan','Fs','start','SecBeforeOnset','SecAfterOnset','SecAfterTrial',...
   'PCData','SegmentedEEG','PrePCData','PreSegmentedEEG')






