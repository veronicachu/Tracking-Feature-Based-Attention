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

%% trainClassifier_linearsvm_kfold_2freq.m
acc = NaN(length(nSubjs));
for i = 1:nSubjs
    [~, acc(i),validationScores] = trainClassifier_linearsvm_kfold_2freq(classifyData.(names{i}));
end

disp(mean(acc*100))






