clear;
load('FullFFTData.mat')

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
for j = 1:nSubjs
RF1 = FFTData.(names{j}).RF1SNR(freqs,:,:);
RF2 = FFTData.(names{j}).RF2SNR(freqs,:,:);
GF1 = FFTData.(names{j}).GF1SNR(freqs,:,:);
GF2 = FFTData.(names{j}).GF2SNR(freqs,:,:);

% Remove subject dimension from training data
clear RF1train2 RF2train2 GF1train2 GF2train2
startInd = 1;
endInd = startInd+9;
for i = 1:size(RF1,3)
    RF12(startInd:endInd,:) = squeeze(RF1(:,:,i))';  
    RF22(startInd:endInd,:) = squeeze(RF2(:,:,i))';
    GF12(startInd:endInd,:) = squeeze(GF1(:,:,i))';
    GF22(startInd:endInd,:) = squeeze(GF2(:,:,i))';
    
    startInd = size(RF12,1)+1 ;
    endInd = startInd+9;
end

% Create full training dataset
data = [RF12;RF22;GF12;GF22];

%% Create group labels
RF1label = repmat(12.5,size(RF12,1),1);
RF2label = repmat(18.75,size(RF22,1),1);
GF1label = repmat(12.5,size(GF12,1),1);
GF2label = repmat(18.75,size(GF22,1),1);

% Create group indicator for training dataset
group = [RF1label;RF2label;GF1label;GF2label];

%% Create full test dataset
classification = [data group];

[nanrow,nancol] = find(isnan(classification));
classification(nanrow,:) = [];

%% Separate training and testing data
% Randomly select 80% of data to use for training
nObs = size(classification,1);
nTrain = round(nObs * .8);
trainSubjs = randsample(nObs,nTrain);

% Create training dataset
trainData = classification(trainSubjs,:);

% Find the 20% not in training dataset
temp = 1:nObs;
testSubjs = setdiff(temp,trainSubjs);

% Create test dataset
testData = classification(testSubjs,:);

%% Classify
% Linear model
[ldaClass_linear,err_linear(j),P_linear,logp_linear,coeff_linear] = classify(testData(:,1:4),trainData(:,1:4),trainData(:,5),'Linear');
[ldaResubCM_linear, grpOrder_linear] = confusionmat(testData(:,5),ldaClass_linear);

% Quadratic model
[ldaClass_quad,err_quad(j),P_quad,logp_quad,coeff_quad] = classify(testData(:,1:4),trainData(:,1:4),trainData(:,5),'Quadratic');
[ldaResubCM_quad, grpOrder_quad] = confusionmat(testData(:,5),ldaClass_quad);

end





