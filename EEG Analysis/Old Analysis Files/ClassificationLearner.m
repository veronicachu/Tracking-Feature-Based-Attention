clear;
load('SNRDataTrials.mat')

%% Properties
% Number of subjects
names = fieldnames(FFTData);
nSubjs = length(names);

% Target freqs
bin = FFTData.S402.bin;
freq1 = find(bin == 12.5);
freq1_2nd = find(bin == 25);
freq2 = find(bin == 18.75);
freq2_2nd = find(bin == 37.5);
freqs = [freq1 freq1_2nd freq2 freq2_2nd];

%% Get all data
j = 1;
RF1 = FFTData.(names{j}).RF1SNR(freqs,:,:);
RF2 = FFTData.(names{j}).RF2SNR(freqs,:,:);
GF1 = FFTData.(names{j}).GF1SNR(freqs,:,:);
GF2 = FFTData.(names{j}).GF2SNR(freqs,:,:);

% Remove subject dimension from training data
tempRF1 = squeeze(RF1(:,:,1))';
tempRF2 = squeeze(RF2(:,:,1))';
tempGF1 = squeeze(GF1(:,:,1))';
tempGF2 = squeeze(GF2(:,:,1))';

RF1_2 = tempRF1;
RF2_2 = tempRF2;
GF1_2 = tempGF1;
GF2_2 = tempGF2;

for i = 2:size(RF1,3)
    tempRF1 = squeeze(RF1(:,:,i))';
    tempRF2 = squeeze(RF2(:,:,i))';
    tempGF1 = squeeze(GF1(:,:,i))';
    tempGF2 = squeeze(GF2(:,:,i))';
    
    RF1_2 = [RF1_2; tempRF1];
    RF2_2 = [RF2_2; tempRF2];
    GF1_2 = [GF1_2; tempGF1];
    GF2_2 = [GF2_2; tempGF2];
end

for j = 2:nSubjs
    RF1 = FFTData.(names{j}).RF1SNR(freqs,:,:);
    RF2 = FFTData.(names{j}).RF2SNR(freqs,:,:);
    GF1 = FFTData.(names{j}).GF1SNR(freqs,:,:);
    GF2 = FFTData.(names{j}).GF2SNR(freqs,:,:);
    
    % Remove subject dimension from training data
    
    for i = 1:size(RF1,3)
        tempRF1 = squeeze(RF1(:,:,i))';
        tempRF2 = squeeze(RF2(:,:,i))';
        tempGF1 = squeeze(GF1(:,:,i))';
        tempGF2 = squeeze(GF2(:,:,i))';
        
        RF1_2 = [RF1_2; tempRF1];
        RF2_2 = [RF2_2; tempRF2];
        GF1_2 = [GF1_2; tempGF1];
        GF2_2 = [GF2_2; tempGF2];
    end
end

%% Create group labels
RF1label = repmat(12.5,size(RF1_2,1),1);
RF2label = repmat(18.75,size(RF2_2,1),1);
GF1label = repmat(12.5,size(GF1_2,1),1);
GF2label = repmat(18.75,size(GF2_2,1),1);

% Create group indicator for training dataset
group = [RF1label;RF2label;GF1label;GF2label];

%% Group dataset and labels
data = [RF1_2;RF2_2;GF1_2;GF2_2];
classification = [data group];

[nanrow,nancol] = find(isnan(classification));
classification(nanrow,:) = [];









