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

%% Classify Linear Model - 2 features
% Linear model
[ldaClass_linear,err_linear,P_linear,logp_linear,coeff_linear] = classify(testData(:,1:2),trainData(:,1:2),trainData(:,5),'Linear');
[ldaResubCM_linear, grpOrder_linear] = confusionmat(testData(:,5),ldaClass_linear);

%% Plot Scatter
figure;
hold on
gscatter(data(:,1),data(:,2),group,'bg','s',7,'off')

% Plot Line
K = coeff_linear(1,2).const;
L = coeff_linear(1,2).linear;
x = testData(:,1:2);
y = trainData(:,1:2);
% Function to compute K + L*v for multiple vectors
% v=[x;y]. Accepts x and y as scalars or column vectors.
f = @(x,y) K + [x y]*L;
h = ezplot(f,[0 8 0 8]);

% Figure Properties
xlim([0 8])
ylim([0 8])
legend('12.5Hz','18.75Hz','Location','NE')
xlabel('SNR at 12.5Hz ','FontSize',14)
ylabel('SNR at 18.75Hz','FontSize',14)
title('Frequency Classification','FontSize',20)

%% Classify Linear Model - 4 features
% Linear model
[ldaClass_linear2,err_linear2,P_linear2,logp_linear2,coeff_linear2] = classify(testData(:,1:4),trainData(:,1:4),trainData(:,5),'Linear');
[ldaResubCM_linear2, grpOrder_linear2] = confusionmat(testData(:,5),ldaClass_linear2);





















