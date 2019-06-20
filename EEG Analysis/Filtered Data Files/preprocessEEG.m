clear;
subjnum = '122';
trialnum = '122-4';

file = sprintf('../Raw Data Files/Subj %s/%s_RawData.mat',subjnum,trialnum);
load(file)

% load the EEG data
eeg = dataExp{1}.time_series;
eeg = eeg(1:64,:)';

% load the head model
load('../ANTWAVE64');
hm = ANTWAVE64;
nChan = 64;

% get channel labels
EEGchanLabel = hm.ChanNames;

% sampling rate of the amp
Fs = 1024;

%% DC shift and detrend the data
% find(horzcat(strcmp(EEGchanLabel,'PO7')))

% zero out the mastoids
eeg(:,[13 19]) = 0;

% Filter the data from 1 to 60Hz and detrend
% filteredEEG = filtereeg(eeg,Fs,[1 30],[.25 60],10);
filteredEEG = filtereeg(eeg,Fs);

% % reference to mastoids
% ref = mean(filteredEEG(:,[13 19]),2);
% filteredEEG = filteredEEG - repmat(ref,1,64);

% check data
figure;
plot(eeg(:,64))
figure;
plot(filteredEEG(:,64))

%% Save the filtered EEG data

save(sprintf('%s_FilteredEEG',trialnum),'dataExp',...
   'nChan','Fs','filteredEEG')






