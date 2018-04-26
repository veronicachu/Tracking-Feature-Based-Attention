function datasum = MeanAmpSpec(fftdata)
% Input: FFTed EEG data in the form of: data(samples,elec,trials)
% Output: sum of FFTed data across trials

nChan = 64;
numTrials = size(fftdata,3);
nyq = size(fftdata,1)/2+1;

datasum = zeros(size(fftdata,1)/2+1,nChan);
for electrode = 1:nChan
    temp = zeros(size(fftdata,1)/2+1,1);
    for j = 1:numTrials
       temp(:,1) = temp + squeeze(fftdata(1:nyq,electrode,j));
    end
    
    datasum(:,electrode) = temp(:,1);
end
end