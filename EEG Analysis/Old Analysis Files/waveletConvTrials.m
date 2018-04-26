function convEEG = waveletConvTrials(EEGData,chan,wFreq)
fs = 1024;
numtrial = size(EEGData,3);
EEGData = squeeze(EEGData(:,chan,:));

% Set wavelet parameters
wTime = -1:(1/fs):1;        % time vector for wavelet
n = 10;                     % number of wavelet cycles

% Initialize a matrix for the convolution output
convEEG = zeros(numtrial,size(EEGData,1));

for i = 1:numtrial
    % Create the complex Morelet
    f = wFreq;
    s = n/(2*pi*f);
    A = 1/sqrt(s*sqrt(pi));
    wavelet = A*exp(1i*2*pi*f*wTime).*exp(-(wTime.^2)/(2*s^2));
    
    % Do the convolution
    convEEG(i,:) = conv(EEGData(:,i)', wavelet, 'same');
end

end