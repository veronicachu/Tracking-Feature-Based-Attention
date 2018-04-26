function chunkedData = ChunkTrials(data,Fs)

% Segmented into 2 sec chunks
chunk1 = zeros(Fs*2,64,7);
chunk2 = zeros(Fs*2,64,7);
chunk3 = zeros(Fs*2,64,7);
 
 for i = 1:size(data,3) %trials
     chunk1(:,:,i) = data(1:Fs*2,:,i);
     chunk2(:,:,i) = data(Fs*2+1:Fs*4,:,i);
     chunk3(:,:,i) = data(Fs*4+1:Fs*6,:,i);
 end

% Combine segments
chunkedData = chunk1;
chunkedData(:,:,size(data,3):size(data,3)*2-1) = chunk2;
chunkedData(:,:,size(data,3)*2:size(data,3)*3-1) = chunk3;

end