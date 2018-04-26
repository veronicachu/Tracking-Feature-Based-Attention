clear;
subjnum = '03';

% SSVEP frequencies
freq1 = 7.5;
freq2 = 12.5;

% get trial data
eegfile = sprintf('Segmented Data Files/%s_SegmentedEEG.mat',subjnum);
behfile = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP HUD Analyses/Behavioral Analysis/%s_ColorData.mat',subjnum);
load(eegfile);
load(behfile);

% load the head model
load('ANTWAVE64');
hm = ANTWAVE64;

% get channel labels
EEGchanLabel = hm.ChanNames;

% select subtrial time period
EEG = SegmentedEEG(1024:end-1,:,:);

%% organize and FFT EEG data by trial type
[redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,freq1,freq2);
[RF1fft,RF2fft,GF1fft,GF2fft] = FFTTrialType(redF1EEG,redF2EEG,greenF1EEG,greenF2EEG);

%% Sum of all trials for each electrode - comparing target and nontarget trials
RF1fftsum = MeanAmpSpec(RF1fft);
RF2fftsum = MeanAmpSpec(RF2fft);
GF1fftsum = MeanAmpSpec(GF1fft);
GF2fftsum = MeanAmpSpec(GF2fft);

%% Plot mean amp spec for each color-freq
Fs = 1024;
nyq = size(RF1fft,1)/2+1;
myfreqs = linspace(0,Fs/2,nyq);

figure;
for myelectrode = 1:nChan
    clf
    subplot(1,2,1)
    hold on
    plot(myfreqs,RF1fftsum(:,myelectrode));
    line([freq1 freq1],[0 max(RF1fftsum(:,myelectrode))])
    line([freq2 freq2],[0 max(RF1fftsum(:,myelectrode))])
    title(sprintf('Red Freq 1 - Elec %s (%d)', EEGchanLabel{myelectrode},myelectrode));
    xlim([0 30])
    
    subplot(1,2,2)
    hold on
    plot(myfreqs,RF2fftsum(:,myelectrode));
    line([freq1 freq1],[0 max(RF2fftsum(:,myelectrode))])
    line([freq2 freq2],[0 max(RF2fftsum(:,myelectrode))])
    title(sprintf('Red Freq 2 - Elec %s (%d)', EEGchanLabel{myelectrode},myelectrode));
    xlim([0 30])
    
    pause; 
end

figure;
for myelectrode = 1:nChan
    clf
    subplot(1,2,1)
    hold on
    plot(myfreqs,GF1fftsum(:,myelectrode));
    line([freq1 freq1],[0 max(GF1fftsum(:,myelectrode))])
    line([freq2 freq2],[0 max(GF1fftsum(:,myelectrode))])
    title(sprintf('Green Freq 1 - Elec %s (%d)', EEGchanLabel{myelectrode},myelectrode));
    xlim([0 30])
    
    subplot(1,2,2)
    hold on
    plot(myfreqs,GF2fftsum(:,myelectrode));
    line([freq1 freq1],[0 max(GF2fftsum(:,myelectrode))])
    line([freq2 freq2],[0 max(GF2fftsum(:,myelectrode))])
    title(sprintf('Green Freq 2 - Elec %s (%d)', EEGchanLabel{myelectrode},myelectrode));
    xlim([0 30])
    
    pause; 
end