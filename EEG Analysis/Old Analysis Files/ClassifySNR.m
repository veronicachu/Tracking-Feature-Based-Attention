clear;
load('SNRData.mat')

%% Properties
% Number of subjects
nSubjs = size(RF1SNR,3);

% Target freqs
freq1 = find(bin == 12.5);
freq1_2nd = find(bin == 25);
freq2 = find(bin == 18.75);
freq2_2nd = find(bin == 37.5);
freqs = [freq1 freq2 freq1_2nd freq2_2nd];

%% Get all data
RF1 = RF1SNR(freqs,:,:);
RF2 = RF2SNR(freqs,:,:);
GF1 = GF1SNR(freqs,:,:);
GF2 = GF2SNR(freqs,:,:);

% Remove subject dimension from training data
clear RF1train2 RF2train2 GF1train2 GF2train2
startInd = 1;
endInd = startInd+9;
for i = 1:nSubjs
    RF1data(startInd:endInd,:) = squeeze(RF1(:,:,i))';  
    RF2data(startInd:endInd,:) = squeeze(RF2(:,:,i))';
    GF1data(startInd:endInd,:) = squeeze(GF1(:,:,i))';
    GF2data(startInd:endInd,:) = squeeze(GF2(:,:,i))';
    
    startInd = size(RF1data,1)+1 ;
    endInd = startInd+9;
end

% Create full training dataset
data = [RF1data;RF2data;GF1data;GF2data];

%% Create group labels
RF1label = repmat(12.5,size(RF1data,1),1);
RF2label = repmat(18.75,size(RF2data,1),1);
GF1label = repmat(12.5,size(GF1data,1),1);
GF2label = repmat(18.75,size(GF2data,1),1);

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

%% Classify Linear Model - 2 features
% Linear model
[ldaClass_linear,err_linear,P_linear,logp_linear,coeff_linear] = classify(testData(:,1:2),trainData(:,1:2),trainData(:,5),'Linear');
[ldaResubCM_linear, grpOrder_linear] = confusionmat(testData(:,5),ldaClass_linear);

% Plot Scatter
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
h = ezplot(f,[0 18 0 18]);

% Figure Properties
xlim([0 18])
ylim([0 18])
legend('12.5Hz','18.75Hz','Location','NE')
xlabel('SNR at 12.5Hz ','FontSize',14)
ylabel('SNR at 18.75Hz','FontSize',14)
title('Frequency Classification','FontSize',20)

%% Classify Linear Model - 4 features
% Linear model
[ldaClass_linear2,err_linear2,P_linear2,logp_linear2,coeff_linear2] = classify(testData(:,1:4),trainData(:,1:4),trainData(:,5),'Linear');
[ldaResubCM_linear2, grpOrder_linear2] = confusionmat(testData(:,5),ldaClass_linear2);

%% Classify Quadratic model
% [ldaClass_quad,err_quad,P_quad,logp_quad,coeff_quad] = classify(testData(:,1:4),trainData(:,1:4),trainData(:,5),'Quadratic');
% [ldaResubCM_quad, grpOrder_quad] = confusionmat(testData(:,5),ldaClass_quad);






