function SNR = calculateSNR(ampspecdata,freqInd)
% Input: FFTed data and the frequency indicies vector (4 before target, 
% target, 4 after target)

% Output: signal to noise ratio value at every electrode

nChan = 64;
n = length(freqInd);

SNR = zeros(nChan,1);

for myelectrode = 1:nChan
    detrendampspec = zeros(n,1);
    
    % Detrended amp spec data
    detrendampspec(1:n) = detrend(squeeze(ampspecdata(freqInd,myelectrode)));
    
    if n == 10
        detrendampspec(5) = detrendampspec(5) + detrendampspec(6);
        detrendampspec(6) = [];
    end
    
    % Compute the sum of the amplitudes at neighboring frequencies (4 lower and 4 higher)
    sumamp = 0;
    for i = 1:4
        sumamp = sumamp + detrendampspec(i);
    end
    for i = 6:9
        sumamp = sumamp + detrendampspec(i);
    end
    
    % Average of the eight surround values
    avgamp = sumamp/8;
    
    % Difference between the signal amplitude and the average amplitude
    % of the 8 surrounding values
    sigdiff = detrendampspec(5) - avgamp;
    
    % Compute the variance of the 8 surrounding values
    varsurround = zeros(8,1);
    
    % Find the value of the eight deviates
    for i = 1:4
        varsurround(i) = detrendampspec(i) - avgamp;
    end
    for i = 6:9
        varsurround(i-1) = detrendampspec(i) - avgamp;
    end
    
    % Find the standard deviation of the surround values
    stdsurround = 0;
    
    for i = 1:8
        stdsurround = stdsurround + (varsurround(i)*varsurround(i));
    end
    
    stdsurround = stdsurround/8.0;
    stdsurround = sqrt(stdsurround);
    
    % Find the SNR: signal divided by std of surrounding
    SNR(myelectrode) = sigdiff/stdsurround;
    
end