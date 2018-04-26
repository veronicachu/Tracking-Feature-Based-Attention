clear;
subjnum = '402';

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

EEG = SegmentedEEG;
% EEG = eegica.data(1024:end-1,:,:);

%% Segment by condition
[redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);

%% Chunk trials in each  condition
redF1 = ChunkTrials(redF1EEG,Fs);
redF2 = ChunkTrials(redF2EEG,Fs);
greenF1 = ChunkTrials(greenF1EEG,Fs);
greenF2 = ChunkTrials(greenF2EEG,Fs);

%%
data = greenF2;

nSamples = size(data,1);
nTrials = size(data,3);
EEGtime = 0:1/Fs:nSamples/Fs-1/Fs;
waveletTime = -nSamples/Fs/2:1/Fs:nSamples/Fs/2-1/Fs;

% center frequency
centerfreq = 12.5; % in Hz

% definte convolution parameters
n_wavelet     = nSamples;
n_data        = nSamples*nTrials;
n_convolution = n_wavelet+n_data-1;
n_conv_pow2   = pow2(nextpow2(n_convolution));  

% get FFT of data
eegfft = fft(reshape(data(:,29,:),1,[]),n_conv_pow2);

% ITPC at one frequency band
wavelet = exp(2*1i*pi*centerfreq.*waveletTime) .* exp(-waveletTime.^2./(2*((4/(2*pi*centerfreq))^2)))/centerfreq;

% convolution
eegconv = ifft(fft(wavelet,n_conv_pow2).*eegfft);
eegconv = eegconv(1:n_convolution);
eegconv = reshape(eegconv(floor((nSamples-1)/2):end-1-ceil((nSamples-1)/2)),nSamples,nTrials);

figure;
plot(EEGtime,abs(mean(exp(1i*angle(eegconv)),2)))
% set(gca,'xlim',[-200 1000])
xlabel('Time (ms)')
ylabel('ITPC')


%% TF plot of ITPC
frequencies = logspace(log10(4),log10(40),20);
s = logspace(log10(3),log10(10),length(frequencies))./(2*pi*frequencies);
itpc = zeros(length(frequencies),nSamples);

for fi=1:length(frequencies)
    % create wavelet
    wavelet = exp(2*1i*pi*frequencies(fi).*waveletTime) .* exp(-waveletTime.^2./(2*(s(fi)^2)))/frequencies(fi);
    
    % convolution
    eegconv = ifft(fft(wavelet,n_conv_pow2).*eegfft);
    eegconv = eegconv(1:n_convolution);
    eegconv = reshape(eegconv(floor((nSamples-1)/2):end-1-ceil((nSamples-1)/2)),nSamples,nTrials);
    
    % extract ITPC
    itpc(fi,:) = abs(mean(exp(1i*angle(eegconv)),2));
end

figure;
contourf(EEGtime,frequencies,itpc,40,'linecolor','none')
% set(gca,'clim',[0 .6],'xlim',[-200 1000])
xlabel('Time (ms)'), ylabel('Frequencies (Hz)')