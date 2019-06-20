clear;
% Classification File
% type = 'linear';
type = 'diagLinear';
load(sprintf('Car_Kfold_%s',type))

%% Accuracy
acc = mean(acc,2);
% bar(acc_linear)
% xlim([0 length(acc_linear)+1])

%% Confusion Matrix
names = fieldnames(confusionmatrix);
nSubjs = length(names);
for i = 1:nSubjs
    temp = confusionmatrix.(names{i});
    confusionmatrix2.(names{i}) = 0;
    for j = 1:length(temp)
        confusionmatrix2.(names{i}) = temp{j} + confusionmatrix2.(names{i});
    end
end

%% Get sensitivity and specificity measures
for i = 1:nSubjs
    % Get parts of confusion matrix
    truepositive = confusionmatrix2.(names{i})(1,1);
    falsepositive = confusionmatrix2.(names{i})(1,2);
    falsenegative = confusionmatrix2.(names{i})(2,1);
    truenegative = confusionmatrix2.(names{i})(2,2);
    
    % Calculate Sensitivity (true positive rate) = TP / (TP + FN)
    sensitivity(i) = truepositive / (truepositive + falsenegative);
    
    % Calculate Specificity (true negative rate) = TN / (TN + FP)
    specificity(i) = truenegative / (truenegative + falsepositive);
end

%% ROC Curve
% figure;
for i = 1:nSubjs
    labels = [];
    predictions = [];
    for j = 1:5
        labels = [labels; kTrials.(names{i}){j}(:,end)];
%         predictions = [predictions; class.(names{i}){j}(:,end)];
        predictions = [predictions; posterior.(names{i}){j}(:,end)];
    end
    
    [ROCx.(names{i}),ROCy.(names{i}),~,AUC(i)] = perfcurve(labels,predictions,'18.75');
    
%     subplot(4,5,i)
%     hold on
%     plot(ROCx.(names{i}),ROCy.(names{i}))
%     line([0 1],[0 1])
end

% xlabel('False positive rate')
% ylabel('True positive rate')
% 
% figure;
% bar(AUC)
% xlim([0 length(acc)+1])
% ylim([0 1])
% ylabel('AUC')

%% Matthew's Correlation Coefficient
for i = 1:nSubjs
    % Get parts of confusion matrix
    truepositive = confusionmatrix2.(names{i})(1,1);
    falsepositive = confusionmatrix2.(names{i})(1,2);
    falsenegative = confusionmatrix2.(names{i})(2,1);
    truenegative = confusionmatrix2.(names{i})(2,2);
    
    % Calculate MCC = (TP x TN - FP x FN) / sqrt((TP + FP)(TP + FN)(TN + FP)(TN + FN)
    MCC_top = truepositive * truenegative - falsepositive * falsenegative;
    MCC_bottom = sqrt((truepositive + falsepositive)*(truepositive + falsenegative) * ...
        (truenegative + falsepositive) * (truenegative + falsenegative));
    MCC(i) = MCC_top / MCC_bottom;
end

% figure;
% bar(MCC)
% xlim([0 length(acc_linear)+1])
% ylim([-1 1])
% ylabel('MCC')

%% Save data
save(sprintf('Car_summary_%s',type),'acc','confusionmatrix2','sensitivity','specificity',...
    'ROCx','ROCy','AUC','MCC')
