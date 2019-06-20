data = xlsread('Holdout Results.xlsx');

actualcorrect = data(:,4)*100;
classifyacc = data(:,3);

[rho,p] = corr(actualcorrect,classifyacc);

scatter(actualcorrect,classifyacc,'k')
xlim([0 100])
ylim([0 100])
xlabel('Behavioral Accuracy (%)')
ylabel('Classification Accuracy (%)')