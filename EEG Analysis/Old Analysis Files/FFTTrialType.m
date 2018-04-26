function [RF1fft,RF2fft,GF1fft,GF2fft] = FFTTrialType(redF1EEG,redF2EEG,greenF1EEG,greenF2EEG)
nChan = 64;

%% Red target, freq 1
RF1numsamples = size(redF1EEG,1);
RF1numtrials = size(redF1EEG,3);
RF1fft = zeros(RF1numsamples,nChan,RF1numtrials);
for i = 1:nChan
    for j = 1:RF1numtrials
        temp = squeeze(redF1EEG(:,i,j));
        RF1fft(:,i,j) = abs(fft(temp));
    end
end

%% Red target, freq 2
RF2numsamples = size(redF2EEG,1);
RF2numtrials = size(redF2EEG,3);
RF2fft = zeros(RF2numsamples,nChan,RF2numtrials);
for i = 1:nChan
    for j = 1:RF2numtrials
        temp = squeeze(redF2EEG(:,i,j));
        RF2fft(:,i,j) = abs(fft(temp));
    end
end

%% Green target, freq 1
GF1numsamples = size(greenF1EEG,1);
GF1numtrials = size(greenF1EEG,3);
GF1fft = zeros(GF1numsamples,nChan,GF1numtrials);
for i = 1:nChan
    for j = 1:GF1numtrials
        temp = squeeze(greenF1EEG(:,i,j));
        GF1fft(:,i,j) = abs(fft(temp));
    end
end

%% Green target, freq 2
GF2numsamples = size(greenF2EEG,1);
GF2numtrials = size(greenF2EEG,3);
GF2fft = zeros(GF2numsamples,nChan,GF2numtrials);
for i = 1:nChan
    for j = 1:GF2numtrials
        temp = squeeze(greenF2EEG(:,i,j));
        GF2fft(:,i,j) = abs(fft(temp));
    end
end
end
