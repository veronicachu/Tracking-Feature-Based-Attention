function [pc,eeg] = extractTrials(dataExp,filteredEEG,pcdata)

[beginMkr,~,~,~,~,~,endMkr] = extractMarkerTimes(dataExp);
amptime = dataExp{1}.time_stamps;
nTime = length(amptime);

%% Find indices that match Unity time to amp time
a = 1;
beginIdx = zeros(1,128);
for i = 2:nTime-1
    if a > 128
        continue
    elseif a == 1 && round(amptime(i-1),3) ~= round(beginMkr(a),3) && round(amptime(i),3) == round(beginMkr(a),3)
        beginIdx(a) = i; 
        a = a + 1;
    elseif round(amptime(i-1),3) ~= round(beginMkr(a),3) && round(amptime(i),3) == round(beginMkr(a),3)
        beginIdx(a) = i-2000; 
        a = a + 1;
    end
end

a = 1;
endIdx = zeros(1,128);
for i = 2:nTime-1
    if a > 128
        continue
    elseif round(amptime(i-1),3) ~= round(endMkr(a),3) && round(amptime(i),3) == round(endMkr(a),3)
        endIdx(a) = i+3500;
        a = a + 1;
    end
end

%% Find size of photocell matrix
differences = ones(1,128);
for i = 1:length(beginIdx)
    differences(i) = endIdx(i) - beginIdx(i);
end

lowest = min(differences);  % time
nChan = size(pcdata,2);     % channel
nTrials = length(beginIdx); % trials

%% Segment photocell data
a = 1;
pc = ones(lowest,nChan,nTrials);

for k = 1:nTrials
    pc(:,:,k) = pcdata(beginIdx(a):(beginIdx(a)+lowest)-1,:);
    a = a + 1;
end

%% Find size of EEG matrix
differences = ones(1,128);
for i = 1:length(beginIdx)
    differences(i) = endIdx(i) - beginIdx(i);
end

lowest = min(differences);  % time
nChan = size(filteredEEG,2);% channel
nTrials = length(beginIdx); % trials

%% Segment EEG data
a = 1;
eeg = ones(lowest,nChan,nTrials);

for k = 1:nTrials
    eeg(:,:,k) = filteredEEG(beginIdx(a):(beginIdx(a)+lowest)-1,:);
    a = a + 1;
end

end




















