clear;
load('TrialClassification_2freq_topchans.mat')

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

%% holdout cross validation

for i = 1:nSubjs
    % Create training dataset - all subjects except target
    for j = 1:nSubjs
        if j ~= i
            otherSubjData.(names{j}) = classifyData.(names{j});
        end
    end
    trainnames = fieldnames(otherSubjData);
    trainData = otherSubjData.(trainnames{1});
    for j = 2:length(trainnames)
        startInd = size(trainData,1) + 1;
        endInd = size(trainData,1) + 128;
        trainData(startInd:endInd,:) = otherSubjData.(trainnames{j});
    end
    
    % Create test dataset - target subject
    testData = classifyData.(names{i});
    
    % Classify Linear Model
    [ldaClass_linear,err_linear(i),P_linear,logp_linear,coeff_linear] = classify(testData(:,1:end-1),trainData(:,1:end-1),...
        trainData(:,end),'Linear');
    [ldaResubCM_linear{i}, grpOrder_linear] = confusionmat(testData(:,end),ldaClass_linear);
    
    % Calculate accuracy
    acc(i) = trace(ldaResubCM_linear{i})/sum(sum(ldaResubCM_linear{i})) * 100;
end

%% 
bar(acc)
xlim([0 21])
ylim([0 100])
mean(acc)
