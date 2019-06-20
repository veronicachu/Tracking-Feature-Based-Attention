clear;
load('TrialClassification_fulllength_topchans.mat')

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

%% trainClassifier_linearsvm_kfold_2freq.m
for i = 2:nSubjs
    [trainedClassifier{i}, partitionedModel{i}, validationAccuracy{i}, validationPredictions{i}, validationScores{i}]...
        = trainClassifier_linearsvm_kfold_2freq(classifyData.(names{i}));
    
    % Create confusion matrix for classification results
    [confusionmatrix.(names{i}), grpOrder] = confusionmat(classifyData.(names{i})(:,end),validationPredictions{i});
    
    % Calculate accuracy
    acc(i) = trace(confusionmatrix.(names{i}))/sum(sum(confusionmatrix.(names{i}))) * 100;
end

disp(mean(cell2mat(validationAccuracy)*100))

%%
save('Car_Kfold_SVM','trainedClassifier','partitionedModel','validationAccuracy',...
    'validationPredictions','validationScores','confusionmatrix','acc')





