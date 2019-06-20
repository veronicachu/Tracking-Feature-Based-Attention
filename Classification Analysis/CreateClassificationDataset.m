clear;
load('SNRDataTrials_fulllength_topchans.mat')

%% Properties
% Number of subjects
names = fieldnames(FFTData);
nSubjs = length(names);

% Target freqs
bin = FFTData.S102.bin;
freq1 = find(bin == 12.5);
% freq1_2nd = find(bin == 25);
freq2 = find(bin == 18.75);
% freq2_2nd = find(bin == 37.5);
freqs = [freq1 freq2];
% freqs = [freq1 freq1_2nd freq2 freq2_2nd];

%% Get all data
for i = 1:nSubjs
    % Get subject data
    RF1 = FFTData.(names{i}).RF1SNR(freqs,:,:);
    RF2 = FFTData.(names{i}).RF2SNR(freqs,:,:);
    GF1 = FFTData.(names{i}).GF1SNR(freqs,:,:);
    GF2 = FFTData.(names{i}).GF2SNR(freqs,:,:);
    
    % Pre-allocate subject's matrix
    RF1_trials.(names{i}) = NaN(size(RF1,3), size(RF1,1)*size(RF1,2)+1);
    RF2_trials.(names{i}) = NaN(size(RF2,3), size(RF2,1)*size(RF2,2)+1);
    GF1_trials.(names{i}) = NaN(size(GF1,3), size(GF1,1)*size(GF1,2)+1);
    GF2_trials.(names{i}) = NaN(size(GF2,3), size(GF2,1)*size(GF2,2)+1);
    
    % Make each trial a single row
    for j = 1:size(RF1,3)
        % Get trial data
        tempRF1 = squeeze(RF1(:,:,j));
        tempRF2 = squeeze(RF2(:,:,j));
        tempGF1 = squeeze(GF1(:,:,j));
        tempGF2 = squeeze(GF2(:,:,j));
        
        % Reshape chan/freq trial data into a single row
        RF1_trials.(names{i})(j,:) = [tempRF1(1,:) tempRF1(2,:) 12.5];
        RF2_trials.(names{i})(j,:) = [tempRF2(1,:) tempRF2(2,:) 18.75];
        GF1_trials.(names{i})(j,:) = [tempGF1(1,:) tempGF1(2,:) 12.5];
        GF2_trials.(names{i})(j,:) = [tempGF2(1,:) tempGF2(2,:) 18.75];
        
%         RF1_trials.(names{i})(j,:) = [tempRF1(1,:) tempRF1(2,:) tempRF1(3,:) tempRF1(4,:) 12.5];
%         RF2_trials.(names{i})(j,:) = [tempRF2(1,:) tempRF2(2,:) tempRF1(3,:) tempRF1(4,:) 18.75];
%         GF1_trials.(names{i})(j,:) = [tempGF1(1,:) tempGF1(2,:) tempRF1(3,:) tempRF1(4,:) 12.5];
%         GF2_trials.(names{i})(j,:) = [tempGF2(1,:) tempGF2(2,:) tempRF1(3,:) tempRF1(4,:) 18.75];
    end
end

%% Group each subject's dataset
for i = 1:nSubjs
    classifyData.(names{i}) = [RF1_trials.(names{i}); RF2_trials.(names{i}); GF1_trials.(names{i}); GF2_trials.(names{i})];
    [nanrow,nancol] = find(isnan(classifyData.(names{i})));
    classifyData.(names{i})(:,nancol) = [];
end

%% Combine all trials for all subjects
% data = classifyData.(names{1});
% 
% for i = 2:nSubjs
%     data = [data; classifyData.(names{i})];
% end

%% Save data file

save('TrialClassification_fulllength_topchans','classifyData')



