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

%% Create dataset with attended-freq used as features
% Pull out from each condition
RF1eeg = RF1SNR(freqs,:,:);
RF2eeg = RF2SNR(freqs,:,:);
GF1eeg = GF1SNR(freqs,:,:);
GF2eeg = GF2SNR(freqs,:,:);

% Remove subject dimension from test data
clear RF1data RF2data GF1data GF2data
startInd = 1;
endInd = startInd+9;
for i = 1:size(RF1eeg,3)
    RF1data(startInd:endInd,:) = squeeze(RF1eeg(:,:,i))';
    RF2data(startInd:endInd,:) = squeeze(RF2eeg(:,:,i))';
    GF1data(startInd:endInd,:) = squeeze(GF1eeg(:,:,i))';
    GF2data(startInd:endInd,:) = squeeze(GF2eeg(:,:,i))';
    
    startInd = size(RF1data,1)+1 ;
    endInd = startInd+9;
end

% Create full dataset
training = [RF1data; RF2data; GF1data; GF2data];

% Remove NaNs
[nanrow,nancol] = find(isnan(training));
training(nanrow,:) = [];

%% Create group labels
RF1label = repmat(12.5,size(RF1data,1),1);
RF2label = repmat(18.75,size(RF2data,1),1);
GF1label = repmat(12.5,size(GF1data,1),1);
GF2label = repmat(18.75,size(GF2data,1),1);

% Create group indicator for training dataset
group = [RF1label;RF2label;GF1label;GF2label];
group(nanrow,:) = [];

%% Create boxplot
figure;
subplot(2,2,1)
boxplot(RF1data)

xticklabels({'12.5Hz','18.75Hz','25Hz','37.5Hz'});
ylabel('SNR Values','FontSize',14)
ylim([-0.5 18])
title('Blue Freq 12.5Hz','FontSize',20)

subplot(2,2,2)
boxplot(RF2data)

xticklabels({'12.5Hz','18.75Hz','25Hz','37.5Hz'});
ylabel('SNR Values','FontSize',14)
ylim([-0.5 18])
title('Blue Freq 18.75Hz','FontSize',20)

subplot(2,2,3)
boxplot(GF1data)

xticklabels({'12.5Hz','18.75Hz','25Hz','37.5Hz'});
ylabel('SNR Values','FontSize',14)
ylim([-0.5 18])
title('Green Freq 12.5Hz','FontSize',20)

subplot(2,2,4)
boxplot(GF2data)

xticklabels({'12.5Hz','18.75Hz','25Hz','37.5Hz'});
ylabel('SNR Values','FontSize',14)
ylim([-0.5 18])
title('Green Freq 18.75Hz','FontSize',20)


%% Create scatter plot
figure;
hold on
gscatter(training(:,1),training(:,2),group,'bg','s',7,'off')    % 12.5 and 18.75
% gscatter(training(:,3),training(:,4),group,'bg','s',7,'off')

legend('12.5Hz','18.75Hz',...
       'Location','NE')

xlim([0 18])
ylim([0 18])
xlabel('SNR at 12.5Hz ','FontSize',14)
ylabel('SNR at 18.75Hz','FontSize',14)
title('Frequency Classification','FontSize',20)




