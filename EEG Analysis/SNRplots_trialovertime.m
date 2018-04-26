clear;
load('AllSubjData.mat')

%%
load('ANTWAVE64')
chanNames = ANTWAVE64.ChanNames;
Fs = 1024;

% Frequencies of Interest
actualfreq1 = 12.5;
actualfreq2 = 18.75;

% Channels of Interest
parietalChans = [29 55:58 63:64];
occpChans = 30:32;
topChans = [49 16 30:32 28 58 64 29 26];
targChans = [topChans];

%% All Trials
names = fieldnames(Data);
% Pre-allocate matricies
SNR = NaN(200,length(targChans),32);

for i = 1:length(names)
    fprintf('Calculating SNR for %s...\n', names{i})
    
    % Collect subject's data
    SegmentedEEG = Data.(names{i}).SegmentedEEG;
    
    % Split EEG data in half
    EEG = SegmentedEEG(Fs*2:end-Fs-1,:,:);
    
    % Calculate SNR
    for j = 1:size(EEG,3)
        [bin,SNR(:,:,j)] = plotFFT_mod(EEG(:,targChans,j),Fs,'snr',1,'snrwidth',4);
    end
    
    FFTData.(names{i}).bin = bin;
    FFTData.(names{i}).SNR = SNR;
end

%% SNR over time

% for i = 1:length(names)
   bin = FFTData.(names{i}).bin;
   subjdata = FFTData.(names{i}).SNR;
   TrialData = Data.(names{i}).TrialData;
   
   for j = 1:size(EEG,3)
       targcolor = TrialData.Color{j};
       if strcmp(targcolor,'Red')
           unattbinind = find(bin == TrialData.RedFreq(j));
           if unattbinind == 12.5
               attbinind = find(bin == 18.75);
           else
               attbinind = find(bin == 12.5);
           end
           
           attSNR.(names{i})(j,:) = subjdata(attbinind,:,j);
           unattSNR.(names{i})(j,:) = subjdata(unattbinind,:,j);
           
       end
       if strcmp(targcolor,'Green')
           unattbinind = find(bin == TrialData.RedFreq(j));
           if unattbinind == 12.5
               attbinind = find(bin == 18.75);
           else
               attbinind = find(bin == 12.5);
           end
           
           attSNR.(names{i})(j,:) = subjdata(attbinind,:,j);
           unattSNR.(names{i})(j,:) = subjdata(unattbinind,:,j);
       end
   end
   
   
% end

%% 

plot(1:128,mean(attSNR.(names{i}),2) ./ mean(unattSNR.(names{i}),2))






