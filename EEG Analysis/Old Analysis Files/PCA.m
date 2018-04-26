% Check if the SSVEP phases are aligned
clear;
subjnum = '402';

% SSVEP frequencies
freq1 = 12.5;
freq2 = 18.75;

% get trial data
eegfile = sprintf('Segmented Data Files/%s_SegmentedEEG.mat',subjnum);
behfile = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP HUD Analyses/Behavioral Analysis/%s_ColorData.mat',subjnum);
load(eegfile);
load(behfile);

% load the head model
load('ANTWAVE64');
hm = ANTWAVE64;

% get channel labels
EEGchanLabel = hm.ChanNames;

% select subtrial time period
EEG = SegmentedEEG;

%% Organize data by condition
nSamples = size(EEG,1);
EEGtime = linspace(0,Fs,nSamples);
[redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,freq1,freq2,badtrials);

%% Covariance matrix for all channels
% Find mean of all trials in each condition
trialmean_RF1 = mean(redF1EEG,3)';
trialmean_RF2 = mean(redF2EEG,3)';
trialmean_GF1 = mean(greenF1EEG,3)';
trialmean_GF2 = mean(greenF2EEG,3)';

% Find ERPs for each condition
ERP_RF1 = trialmean_RF1 - repmat(mean(trialmean_RF1,2),1,nSamples);
ERP_RF2 = trialmean_RF2 - repmat(mean(trialmean_RF2,2),1,nSamples);
ERP_GF1 = trialmean_GF1 - repmat(mean(trialmean_GF1,2),1,nSamples);
ERP_GF2 = trialmean_GF2 - repmat(mean(trialmean_GF2,2),1,nSamples);

% Find covariance for each condition
cov_RF1 = (ERP_RF1*ERP_RF1')./(nSamples-1);
cov_RF2 = (ERP_RF2*ERP_RF2')./(nSamples-1);
cov_GF1 = (ERP_GF1*ERP_GF1')./(nSamples-1);
cov_GF2 = (ERP_GF2*ERP_GF2')./(nSamples-1);

%% Plot Covariances
figure;
subplot(2,2,1)
imagesc(real(cov_RF1))
colorbar
colormap('jet')
title(sprintf('Red %s Hz',num2str(freq1)))
xlabel('Channel')
ylabel('Channel')

subplot(2,2,2)
imagesc(real(cov_RF2))
colorbar
colormap('jet')
title(sprintf('Red %s Hz',num2str(freq2)))
xlabel('Channel')
ylabel('Channel')

subplot(2,2,3)
imagesc(real(cov_GF1))
colorbar
colormap('jet')
title(sprintf('Green %s Hz',num2str(freq1)))
xlabel('Channel')
ylabel('Channel')

subplot(2,2,4)
imagesc(real(cov_GF2))
colorbar
colormap('jet')
title(sprintf('Green %s Hz',num2str(freq2)))
xlabel('Channel')
ylabel('Channel')

%% Calculate eigenvectors and eigenvalues
% get PCs and eigenvectors
[pc_RF1,eigvals_RF1] = eig(cov_RF1);
[pc_RF2,eigvals_RF2] = eig(cov_RF2);
[pc_GF1,eigvals_GF1] = eig(cov_GF1);
[pc_GF2,eigvals_GF2] = eig(cov_GF2);

% order PCs (reverse the order; largest eigenvalues first)
pc_RF1 = pc_RF1(:,end:-1:1);
pc_RF2 = pc_RF2(:,end:-1:1);
pc_GF1 = pc_GF1(:,end:-1:1);
pc_GF2 = pc_GF2(:,end:-1:1);

% get eigenvalues from eigenvectors
eigvals_RF1 = diag(eigvals_RF1);
eigvals_RF2 = diag(eigvals_RF2);
eigvals_GF1 = diag(eigvals_GF1);
eigvals_GF2 = diag(eigvals_GF2);

% convert to percent change
eigvals_RF1 = 100*eigvals_RF1(end:-1:1)./sum(eigvals_RF1);
eigvals_RF2 = 100*eigvals_RF2(end:-1:1)./sum(eigvals_RF2);
eigvals_GF1 = 100*eigvals_GF1(end:-1:1)./sum(eigvals_GF1);
eigvals_GF2 = 100*eigvals_GF2(end:-1:1)./sum(eigvals_GF2);

%% Plot Eigenvalues
figure; 
subplot(2,2,1)
plot(eigvals_RF1, 'k.-')
title(sprintf('Red %s Hz',num2str(freq1)))
xlabel('Principal component number')
ylabel('Percent variance explained')

subplot(2,2,2)
plot(eigvals_RF2, 'k.-')
title(sprintf('Red %s Hz',num2str(freq2)))
xlabel('Principal component number')
ylabel('Percent variance explained')

subplot(2,2,3)
plot(eigvals_GF1, 'k.-')
title(sprintf('Green %s Hz',num2str(freq1)))
xlabel('Principal component number')
ylabel('Percent variance explained')

subplot(2,2,4)
plot(eigvals_GF2, 'k.-')
title(sprintf('Green %s Hz',num2str(freq2)))
xlabel('Principal component number')
ylabel('Percent variance explained')

%% Plot first 6 principal components
figure;
for i=1:6
    subplot(2,3,i)
    corttopo(double(pc_RF1(:,i)),hm);
    title(['Principal component ' num2str(i) ', eigval=' num2str(eigvals_RF1(i))])
end

figure;
for i=1:6
    subplot(2,3,i)
    corttopo(double(pc_RF2(:,i)),hm);
    title(['Principal component ' num2str(i) ', eigval=' num2str(eigvals_RF2(i))])
end

figure;
for i=1:6
    subplot(2,3,i)
    corttopo(double(pc_GF1(:,i)),hm);
    title(['Principal component ' num2str(i) ', eigval=' num2str(eigvals_GF1(i))])
end

figure;
for i=1:6
    subplot(2,3,i)
    corttopo(double(pc_GF2(:,i)),hm);
    title(['Principal component ' num2str(i) ', eigval=' num2str(eigvals_GF2(i))])
end
















