clear;

%% Get all data
% LDA Summary
load('Car_summary_linear')
acc_all = acc;
AUC_all = AUC';
MCC_all = MCC';
ROCx_all = ROCx;
ROCy_all = ROCy;
sensitivity_all = sensitivity';
specificity_all = specificity';

% Naive Bayes Summary
load('Car_summary_diagLinear')
acc_all(:,2) = acc;
AUC_all(:,2) = AUC;
MCC_all(:,2) = MCC;
ROCx_all(:,2) = ROCx;
ROCy_all(:,2) = ROCy;
sensitivity_all(:,2) = sensitivity;
specificity_all(:,2) = specificity;

% SVM Summary
load('Car_summary_SVM')
acc_all(:,3) = acc;
AUC_all(:,3) = AUC;
MCC_all(:,3) = MCC;
ROCx_all(:,3) = ROCx;
ROCy_all(:,3) = ROCy;
sensitivity_all(:,3) = sensitivity;
specificity_all(:,3) = specificity;

% Behavior
Car_behavior = [83 91 75 64 73 72 75 79 74 55 73 61 50 83 80 63 87 67 70 90 85]';

%% Sort by accuracy data
[~,ind] = sort(acc_all(:,1)); 
acc_all_sorted = acc_all(ind,:);
AUC_all_sorted = AUC_all(ind,:);
MCC_all_sorted = MCC_all(ind,:);

%% Plot Accuracy
figure;
bar(acc_all_sorted)
colormap(gray)
xlim([0 length(acc_all)+1])
xlabel('Subjects','FontSize',18)
ylabel('Accuracy (%)','FontSize',18)
legend('LDA','NB','SVM')
title('Trial Classification (Accuracy)')
set(gca,'XTick',0:1:length(acc_all)+1,'FontSize',18)

%% Plot AUC
figure;
bar(AUC_all_sorted)
colormap(gray)
xlim([0 length(AUC_all)+1])
xlabel('Subjects','FontSize',18)
ylabel('Area Under Curve (AUC)','FontSize',18)
legend('LDA','NB','SVM')
title('Trial Classification (AUC)')
set(gca,'XTick',0:1:length(acc_all)+1,'FontSize',18)

%% Plot MCC
figure;
hold on
bar(MCC_all_sorted)
colormap(gray)
xlim([0 length(MCC_all)+1])
xlabel('Subjects','FontSize',18)
ylabel('Matthews Correlation Coefficient','FontSize',18)
legend('LDA','NB','SVM')
title('Trial Classification (MCC)')
set(gca,'XTick',0:1:length(acc_all)+1,'YTick',-0.2:0.1:1,'FontSize',18)

%% Plot ROC
names = fieldnames(ROCx);
figure;
for i = 1:length(acc)
    subj = ind(i);
    subplot(3,7,i)
    hold on
    plot(ROCx_all(1).(names{subj}),ROCy_all(1).(names{subj}),'k-')
    plot(ROCx_all(2).(names{subj}),ROCy_all(2).(names{subj}),'k:')
    plot(ROCx_all(3).(names{subj}),ROCy_all(3).(names{subj}),'k-.')
    
    line([0 1],[0 1],'color','k','LineStyle','--')
    title(sprintf('S%d',i),'FontSize',24)
    set(gca,'XTick',0:0.2:1,'YTick',0:0.2:1)
end
subplot(3,7,1)
legend('LDA','NB','SVM')
% xlabel('False positive rate')
% ylabel('True positive rate')

%%
% save('Car_summary_all','acc_all','AUC_all','MCC_all','ROCx_all','ROCy_all',...
%     'sensitivity_all','specificity_all')







