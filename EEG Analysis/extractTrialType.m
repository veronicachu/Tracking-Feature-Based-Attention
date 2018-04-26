function [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialType(EEGData,TrialData,freq1,freq2,badtrials)
% Organizes the EEG data for different trial types into four different
% variables that contains EEG data related to that trial type

% Input: subject number (ex. Subj1)

% Output: red freq 1 trials, red freq 2 trials, green freq 1 trials, 
% green freq 2 trials

% get trial data
color = TrialData.Color;
redfreq = TrialData.RedFreq;
greenfreq = TrialData.GreenFreq;
numtrials = size(EEGData,3);

% Split trials according to target color and target freq
r1 = 1;
r2 = 1;
g1 = 1;
g2 = 1;

n = length(badtrials);
badtrials(n+1) = 0;
a = 1;
for i = 1:numtrials
    j = badtrials(a);
    if i ~= j
        if strcmp(color(i),'Red')       % red
            if redfreq(i) == freq2      % red = freq 1
                redF1EEG(:,:,r1) = EEGData(:,:,i);
                r1 = r1 + 1;
            end
            if redfreq(i) == freq1      % red = freq 2
                redF2EEG(:,:,r2) = EEGData(:,:,i);
                r2 = r2 + 1;
            end
        end
        
        if strcmp(color(i),'Green')     % green
            if redfreq(i) == freq2	% green = freq 1
                greenF1EEG(:,:,g1) = EEGData(:,:,i);
                g1 = g1 + 1;
            end
            if redfreq(i) == freq1	% green = freq 2
                greenF2EEG(:,:,g2) = EEGData(:,:,i);
                g2 = g2 + 1;
            end
        end
    else
        a = a + 1;
        continue
    end
end
end