clear;
subjnum = 201;

% eegfile = sprintf('Segmented Data Files/S%d/S%d-Cond%d_SegmentedEEG.mat',subjnum,subjnum,condnum);
eegfile = sprintf('Segmented Data Files/S%d/S%d_SegmentedEEG.mat',subjnum,subjnum);
load(eegfile)

% behfile = sprintf('../Behavioral Analysis/%d_TrialData_Cond%d.mat',subjnum,condnum);
behfile = sprintf('../Behavioral Analysis/S%d_TrialData.mat',subjnum);
load(behfile);

freqs = [12.5 18.75];
Fs = 1024;

%%
EEG = PreSegmentedEEG(Fs*1:Fs*3-1,:,:);
badtrials = 0;

%% Separate by condition
[trialsepData] = extractTrialType(EEG,TrialData,freqs);

%% 
oChans = 30:32;
poChans = [29 55:58 63:64];
pChans = [24:28 51:54];
cpChans = [20:23 48:50];
cChans = [15:17 44:47];

%% 
rrERP = trialsepData.rightRF1EEG;
rrERP(:,:,33:64) = trialsepData.rightRF2EEG;
rrERP = mean(rrERP,3);

llERP = trialsepData.leftLF1EEG;
llERP(:,:,33:64) = trialsepData.leftLF2EEG;
llERP = mean(llERP,3);

rlERP = trialsepData.rightLF1EEG;
rlERP(:,:,33:64) = trialsepData.rightLF2EEG;
rlERP = mean(rlERP,3);

lrERP = trialsepData.leftRF1EEG;
lrERP(:,:,33:64) = trialsepData.leftRF2EEG;
lrERP = mean(lrERP,3);

%% Plot Congruent ERP
time = linspace(-1,1,Fs*2);
oChans = 30:32;
poChans = [29 55:58 63:64];
pChans = [24:28 51:54];
cpChans = [20:23 48:50];
cChans = [15:17 44:47];

figure;
subplot(2,2,1)
hold on
plot(time,mean(rrERP(:,oChans),2))
plot(time,mean(rrERP(:,poChans),2))
plot(time,mean(rrERP(:,pChans),2))
plot(time,mean(rrERP(:,cpChans),2))
plot(time,mean(rrERP(:,cChans),2))
xlim([-.5 1])
line([0 0],[-8 6],'LineStyle','--')
legend('OChans','POChans','PChans','CPChans','CChans')
title('Right Congruent')

subplot(2,2,2)
hold on
plot(time,mean(llERP(:,oChans),2))
plot(time,mean(llERP(:,poChans),2))
plot(time,mean(llERP(:,pChans),2))
plot(time,mean(llERP(:,cpChans),2))
plot(time,mean(llERP(:,cChans),2))
xlim([-.5 1])
line([0 0],[-8 6],'LineStyle','--')
legend('OChans','POChans','PChans','CPChans','CChans')
title('Left Congruent')

subplot(2,2,3)
hold on
plot(time,mean(rlERP(:,oChans),2))
plot(time,mean(rlERP(:,poChans),2))
plot(time,mean(rlERP(:,pChans),2))
plot(time,mean(rlERP(:,cpChans),2))
plot(time,mean(rlERP(:,cChans),2))
xlim([-.5 1])
line([0 0],[-8 6],'LineStyle','--')
legend('OChans','POChans','PChans','CPChans','CChans')
title('Right Incongruent')

subplot(2,2,4)
hold on
plot(time,mean(lrERP(:,oChans),2))
plot(time,mean(lrERP(:,poChans),2))
plot(time,mean(lrERP(:,pChans),2))
plot(time,mean(lrERP(:,cpChans),2))
plot(time,mean(lrERP(:,cChans),2))
xlim([-.5 1])
line([0 0],[-8 6],'LineStyle','--')
legend('OChans','POChans','PChans','CPChans','CChans')
title('Left Incongruent')











%%
% ERP = mean(EEG,3);
% occERP = mean(ERP(:,occpChans),2);
% parERP = mean(ERP(:,parietalChans),2);
% 
% figure;
% subplot(3,1,1);
% plotx(ERP);
% title('Overall Channels ERP')
% 
% subplot(3,1,2);
% plotx(occERP);
% title('Occipital Channels ERP')
% 
% subplot(3,1,3);
% plotx(parERP);
% title('Parietal Channels ERP')