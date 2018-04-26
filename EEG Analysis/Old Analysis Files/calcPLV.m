clear;
subjnum = '402';

eegfile = sprintf('Segmented Data Files/%s_SegmentedEEG.mat',subjnum);
% eegfile = sprintf('Cleaned Data Files/%s_CleanedEEG.mat',subjnum);
load(eegfile)

behfile = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP HUD Analyses/Behavioral Analysis/%s_ColorData.mat',subjnum);
load(behfile);

actualfreq1 = 12.5;
actualfreq2 = 18.75;

EEG = SegmentedEEG(1024:end-1,:,:);
% EEG = eegica.data(1024:end-1,:,:);

%% Segment by condition
[redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEG,TrialData,actualfreq1,actualfreq2,badtrials);

%% Chunk trials in each  condition
% redF1 = ChunkTrials(redF1EEG,Fs);
% redF2 = ChunkTrials(redF2EEG,Fs);
% greenF1 = ChunkTrials(greenF1EEG,Fs);
% greenF2 = ChunkTrials(greenF2EEG,Fs);

% Reshape to channels, samples, trials
redF1 = permute(redF1EEG,[2 1 3]);
redF2 = permute(redF2EEG,[2 1 3]);
greenF1 = permute(greenF1EEG,[2 1 3]);
greenF2 = permute(greenF2EEG,[2 1 3]);

%% 
parietalChans = [29 55:58 63:64];
occpChans = 30:32;

%% Calc PLV
filtSpec1.range = [1 10];
filtSpec1.order = round((4/actualfreq1)*1024);

filtSpec2.range = [10 20];
filtSpec2.order = round((4/actualfreq2)*1024);

[plv_RF1] = pn_eegPLV(redF1, Fs, filtSpec1);
[plv_RF2] = pn_eegPLV(redF2, Fs, filtSpec2);
[plv_GF1] = pn_eegPLV(greenF1, Fs, filtSpec1);
[plv_GF2] = pn_eegPLV(greenF2, Fs, filtSpec2);

%% Plot PLV
time = (0:size(redF1, 2)-1)/Fs;

figure;
subplot(2,2,1)
plot(time, squeeze(plv_RF1(:, 29, 31)));
ylim([0 1])
xlabel('Time (s)'); ylabel('Plase Locking Value');
title('PLV for Oz and POz')

subplot(2,2,2)
plot(time, squeeze(plv_RF1(:, 29, 49)));
ylim([0 1])
xlabel('Time (s)'); ylabel('Plase Locking Value');
title('PLV for POz and CPz')

subplot(2,2,3)
plot(time, squeeze(plv_RF1(:, 30, 32)));
ylim([0 1])
xlabel('Time (s)'); ylabel('Plase Locking Value');
title('PLV for O1 and O2')

subplot(2,2,4)
plot(time, squeeze(plv_RF1(:, 55, 58)));
ylim([0 1])
xlabel('Time (s)'); ylabel('Plase Locking Value');
title('PLV for PO5 and PO6')

%% Find mean PLV
sprintf('Red Freq1 Oz and POz: %0.02f',mean(squeeze(plv_RF1(:, 29, 31))))
sprintf('Red Freq1 POz and CPz: %0.02f',mean(squeeze(plv_RF1(:, 29, 49))))
sprintf('Red Freq1 O1 and O2: %0.02f',mean(squeeze(plv_RF1(:, 30, 32))))
sprintf('Red Freq1 PO5 and PO6: %0.02f',mean(squeeze(plv_RF1(:, 55, 58))))

sprintf('Red Freq2 Oz and POz: %0.02f',mean(squeeze(plv_RF2(:, 29, 31))))
sprintf('Red Freq2 POz and CPz: %0.02f',mean(squeeze(plv_RF2(:, 29, 49))))
sprintf('Red Freq2 O1 and O2: %0.02f',mean(squeeze(plv_RF2(:, 30, 32))))
sprintf('Red Freq2 PO5 and PO6: %0.02f',mean(squeeze(plv_RF2(:, 55, 58))))

sprintf('Green Freq1 Oz and POz: %0.02f',mean(squeeze(plv_GF1(:, 29, 31))))
sprintf('Green Freq1 POz and CPz: %0.02f',mean(squeeze(plv_GF1(:, 29, 49))))
sprintf('Green Freq1 O1 and O2: %0.02f',mean(squeeze(plv_GF1(:, 30, 32))))
sprintf('Green Freq1 PO5 and PO6: %0.02f',mean(squeeze(plv_GF1(:, 55, 58))))

sprintf('Green Freq2 Oz and POz: %0.02f',mean(squeeze(plv_GF2(:, 29, 31))))
sprintf('Green Freq2 POz and CPz: %0.02f',mean(squeeze(plv_GF2(:, 29, 49))))
sprintf('Green Freq2 O1 and O2: %0.02f',mean(squeeze(plv_GF2(:, 30, 32))))
sprintf('Green Freq2 PO5 and PO6: %0.02f',mean(squeeze(plv_GF2(:, 55, 58))))











