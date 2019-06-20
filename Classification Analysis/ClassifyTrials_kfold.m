clear;
load('TrialClassification_fulllength_topchans.mat')

% Classification Type
% type = 'linear';
type = 'diagLinear';

% Number of subjects
names = fieldnames(classifyData);
nSubjs = length(names);

%% Feature normalization
% for i = 1:nSubjs
%     temp = classifyData.(names{i});
%     
%     for j = 1:size(temp,2)-1
%         classifyData.(names{i})(:,j) = (temp(:,j) - mean(temp(:,i)))./std(temp(:,j));
%     end
% end

%% k-fold cross validation
k = 5;

for i = 1:nSubjs
    % Create k-folds
    ind = crossvalind('Kfold',classifyData.(names{i})(:,end),k);
    for j = 1:k
        kTrials.(names{i}){j} = classifyData.(names{i})(j==ind,:);
    end
end

% Classify Linear Model
for i = 1:nSubjs
    for j = 1:k
        % Create training dataset for current k-fold
        trainData = [];
        for a = 1:k
            if a ~= j
                trainData = [trainData; kTrials.(names{i}){a}];
            end
        end
        
        % Create training dataset for current k-fold
        testData = kTrials.(names{i}){j};
        
        % Classify test dataset for current k-fold
        [class.(names{i}){j}, err.(names{i}){j}, posterior.(names{i}){j}, logp.(names{i}){j}, coeff.(names{i}){j}] = ...
            classify(testData(:,1:end-1),trainData(:,1:end-1),...
            trainData(:,end),type);
        
        % Create confusion matrix for classification results
        [confusionmatrix.(names{i}){j}, grpOrder] = confusionmat(testData(:,end),class.(names{i}){j});
        
        % Calculate accuracy
        acc(i,j) = trace(confusionmatrix.(names{i}){j})/sum(sum(confusionmatrix.(names{i}){j})) * 100;
    end
end

%% Save data
save(sprintf('Car_Kfold_%s',type),'kTrials','class','err','posterior','logp','coeff',...
    'confusionmatrix','grpOrder','acc')


%% Plot Scatter
% for i = 1:nSubjs
%     figure;
%     hold on
%     gscatter(classifyData.(names{i})(:,1),classifyData.(names{i})(:,2),classifyData.(names{i})(:,3),'bg','s',7,'off')
%     
%     % Plot Line
%     K = coeff_linear(1,2).const;
%     L = coeff_linear(1,2).linear;
%     x = testData.(names{i})(:,1:2);
%     y = trainData.(names{i})(:,1:2);
%     % Function to compute K + L*v for multiple vectors
%     % v=[x;y]. Accepts x and y as scalars or column vectors.
%     f = @(x,y) K + [x y]*L;
%     h = ezplot(f,[0 3 0 3]);
%     
%     % Figure Properties
%     xlim([0 3])
%     ylim([0 3])
%     legend('12.5Hz','18.75Hz','Location','NE')
%     xlabel('SNR at 12.5Hz ','FontSize',14)
%     ylabel('SNR at 18.75Hz','FontSize',14)
%     title('Frequency Classification','FontSize',20)
% end







