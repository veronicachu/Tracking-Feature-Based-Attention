clear;
subjnum = '423';

file = sprintf('../Filtered Data Files/%s_FilteredEEG.mat',subjnum);
load(file)

pc = dataExp{1}.time_series(68,:)';

% Filter Photocell data
pcdata = filtereeg(pc,Fs,[1 30],[.25 60],10);

%% Segment the Photocell and EEG data using the Unity markers
% Set to take from start flicker to end flicker
[pc,eeg] = extractTrials(dataExp,filteredEEG,pcdata);

%% Find start/stop flicker using Photocell data
% Photocell numbers greater than 0 equal to 0
pc(pc>0) = 0;

% Find first number less than -25 for all trials
start = zeros(1,size(pc,3));
% for i = 1:size(pc,3)
%     temp = find(pc(:,:,i) < -12);
%     start(i) = temp(1)-500;
% end

%% Check Photocell segment code - all
% Graph all the segmented Photocell data
for i = 1:128
%     hold on
%     plot(pc(start(i):start(i)+1024*6,:, i))
    plot(pc(:,:,i))
    title(sprintf('Trial %d',i),'FontSize',20)
    pause
end

%% Load CSV
% estimate = estimate' + start;

for i = 1:128
    plot(pc(estimate(i):estimate(i)+1024*6-1,:,i))
    title(sprintf('Trial %d',i),'FontSize',20)
    pause
end

%% Check Photocell segment code - by freq
% Graph for one frequency
x = find(TrialData.GreenFreq == 7.5);
for i = 1:length(x)
    hold on
    j = x(i);
    plot(pc(estimate(j):estimate(j)+1024*6-1,:,j))
%     disp(i)
%     pause
end

% Find bad index
for i = 1:length(x)
    j = x(i);
    temp = pc(start(j):start(j)+1024*6-1,:,j);
    y(i) = temp(1983);
end

%% Trim EEG data using Photocell data (full 7 sec)
for i = 1:size(eeg,3)
    SegmentedEEG(:,:,i) = eeg(estimate(i):estimate(i)+1024*6-1,1:64,i);
    PCData(:,:,i) = pc(estimate(i):estimate(i)+1024*6-1,:,i);
end

badtrials = 0;
% SegmentedEEG(:,:,badtrials) = 0;

%% Save segmented EEG
save(sprintf('%s_SegmentedEEG',subjnum),...
   'nChan','Fs','SegmentedEEG','pc','start','badtrials')








