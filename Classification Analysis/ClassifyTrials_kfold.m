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
        [ldaClass_linear,err_linear(i,j),P_linear,logp_linear,coeff_linear] = ...
            classify(testData(:,1:end-1),trainData(:,1:end-1),...
            trainData(:,end),'diaglinear');
        [ldaResubCM_linear{i}, grpOrder_linear] = confusionmat(testData(:,end),ldaClass_linear);
    
    % Calculate accuracy
    acc(i,j) = trace(ldaResubCM_linear{i})/sum(sum(ldaResubCM_linear{i})) * 100;
    end
end

% disp(mean(acc))

% scatter(1:20,(1-err_linear)*100)
% ylim([0 100])

%% Combine all trials for all subjects
% data = classifyData.(names{1});
% 
% for i = 2:nSubjs
%     data = [data; classifyData.(names{i})];
% end

%%
figure;
bar(1:20,acc')
ylim([0 100])
xlabel('Subject','FontSize',14)
ylabel('Accuracy (%)','FontSize',14)
title('Trial Classification','FontSize',16)
% line([0 20],[70 70],'Color',[0.7 0.7 0.7],'LineStyle',':')

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







