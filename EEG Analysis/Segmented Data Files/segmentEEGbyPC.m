clear;
subjnum = '417';

file = sprintf('../Filtered Data Files/%s_FilteredEEG.mat',subjnum);
load(file)

pc = dataExp{1}.time_series(68,:)';

% Filter Photocell data
pcdata = filtereeg(pc,Fs,[1 30],[.25 60],10);
% pcdata = filtereeg(pc,Fs);

%% Find start/stop flicker using Photocell data
pcdata(pcdata > 0) = 0;
% plot(pcdata)

% find when flicker starts
pc = zeros(Fs*6,1,128);
eeg = zeros(Fs*6,64,128);
for i = 1:128
    pc(:,:,i) = pcdata(estimate(i):estimate(i)+Fs*6-1);
    eeg(:,:,i) = filteredEEG(estimate(i):estimate(i)+Fs*6-1,:);
end

% Check
% for i = 1:128
%     plot(pc(:,:,i))
%     disp(i)
%     pause
% end

%% Find first number less than -25 for all trials
start = zeros(1,size(pc,3));
for i = 1:size(pc,3)
    temp = find(pc(:,:,i) < -25);
    temp2 = find(pc(1:temp(1),:,i) == 0);
    last = length(temp2);
    
    start(i) = temp2(last);
end

% Check
for i = 1:128
%     hold on
    plot(pc(:,:,i))
    title(sprintf('Trial %d',i),'FontSize',20)
    pause
end

% Check for one frequency
x = find(TrialData.GreenFreq == 7.5);
for i = 1:length(x)
    hold on
    j = x(i);
    plot(pc(start(j):start(j)+1024*6-1,:,j))
    disp(i)
%     pause
end

% start(9) = start(9) + 755;

%% Trim EEG data using Photocell data (full 6 sec)
for i = 1:size(eeg,3)
    SegmentedEEG(:,:,i) = eeg(start(i):start(i)+1024*6-1,1:64,i);
end

% % Segment for before trial - 3 sec before
% for i = 1:size(eeg,3)
%     BaslineEEG(:,:,i) = eeg(start(i)-Fs*3:start(i)-1,1:64,i);
% end

%% Save segmented EEG
save(sprintf('%s_SegmentedEEG',subjnum),...
   'nChan','Fs','SegmentedEEG','pc','start','badtrials')











