clear;
subjnum = '421';

eegfile = sprintf('Segmented Data Files/%s_SegmentedEEG.mat',subjnum);
% eegfile = sprintf('Cleaned Data Files/%s_CleanedEEG.mat',subjnum);
load(eegfile)

behfile = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP HUD Analyses/Behavioral Analysis/%s_ColorData.mat',subjnum);
load(behfile);

% load the head model
load('ANTWAVE64');
hm = ANTWAVE64;

% get channel labels
EEGchanLabel = hm.ChanNames;

actualfreq1 = 12.5;
actualfreq2 = 18.75;

EEG = SegmentedEEG(Fs*2:end-1,:,:);
% EEG = eegica.data(1024:end-1,:,:);

%% Segment by condition
[redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);

%% 
parietalChans = [29 55:58 63:64];
occpChans = 30:32;

%%
% [avgPS, totalFFT, psdx, freq, avgEncFFT] = calcPLI(permute(greenF2EEG(:,[occpChans parietalChans],:), [3,2,1]), Fs, 0, 1); % Normalized FFT
% 
% plot(freq,psdx)
% title(sprintf('Blue Freq %s PLI',num2str(actualfreq1)))
% xlim([0 40])
% ylim([0 1])

%% Plot PLI
% [xfreqs, outpli, fourier] = eegPLI(redF1EEG(:,[occpChans parietalChans],:),Fs);

figure;

subplot(2,2,1)
eegPLI(redF1EEG(:,[occpChans parietalChans],:),Fs);

subplot(2,2,2)
eegPLI(redF2EEG(:,[occpChans parietalChans],:),Fs);

subplot(2,2,3)
eegPLI(greenF1EEG(:,[occpChans parietalChans],:),Fs);

subplot(2,2,4)
eegPLI(greenF2EEG(:,[occpChans parietalChans],:),Fs);




















