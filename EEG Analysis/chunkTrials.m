function chunkedData = chunkTrials(data, Fs, chunkSec, nChunks)

% Pre-allocate chunkedData
nLength = chunkSec*Fs;
nChans = size(data,2);
nTrials = size(data,3);
chunkedData = zeros(nLength,nChans,nTrials*nChunks);

% First chunk
chunkedData(:,:,1:nTrials) = data(1:Fs*chunkSec,:,:);

% Remaining chunks
for i = 2:nChunks
    startChunk = Fs*(chunkSec*(i-1)) + 1;       % start sample
    endChunk = Fs * chunkSec * i;               % end sample
    
    startNum = nTrials*(i-1) + 1;               % start matrix num
    endNum = nTrials * i;                       % end matrix num
    
    chunkedData(:,:,startNum:endNum) = data(startChunk:endChunk,:,:);
end

end

