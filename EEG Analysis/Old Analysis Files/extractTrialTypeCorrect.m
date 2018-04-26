function [redF1EEG,redF2EEG,greenF1EEG,greenF2EEG] = extractTrialTypeCorrect(EEGData,TrialData,freq1,freq2,badtrials)
% Organizes the EEG data for different trial types into four different
% variables that contains EEG data related to that trial type

% Input: subject number (ex. Subj1)

% Output: red freq 1 trials, red freq 2 trials, green freq 1 trials, 
% green freq 2 trials

% get trial data
color = TrialData.Color;
redfreq = TrialData.RedFreq;
greenfreq = TrialData.GreenFreq;
correct = TrialData.Correct;
numtrials = size(EEGData,3);

% Split trials according to target color and target freq
r1_correct = 1;
r1_incorrect = 1;
r2_correct = 1;
r2_incorrect = 1;
g1_correct = 1;
g1_incorrect = 1;
g2_correct = 1;
g2_incorrect = 1;

n = length(badtrials);
badtrials(n+1) = 0;
a = 1;
for i = 1:numtrials
    j = badtrials(a);
    if i ~= j
        % Correct Trials
        if correct(i) == 1
            if strcmp(color(i),'Red')       % red
                if redfreq(i) == freq2      % red = freq 1
                    redF1EEG.correct(:,:,r1_correct) = EEGData(:,:,i);
                    r1_correct = r1_correct + 1;
                end
                if redfreq(i) == freq1      % red = freq 2
                    redF2EEG.correct(:,:,r2_correct) = EEGData(:,:,i);
                    r2_correct = r2_correct + 1;
                end
            end
            
            if strcmp(color(i),'Green')     % green
                if redfreq(i) == freq2	% green = freq 1
                    greenF1EEG.correct(:,:,g1_correct) = EEGData(:,:,i);
                    g1_correct = g1_correct + 1;
                end
                if redfreq(i) == freq1	% green = freq 2
                    greenF2EEG.correct(:,:,g2_correct) = EEGData(:,:,i);
                    g2_correct = g2_correct + 1;
                end
            end
        end
        
        % Incorrect Trials
        if correct(i) == 0
            if strcmp(color(i),'Red')       % red
                if redfreq(i) == freq2      % red = freq 1
                    redF1EEG.incorrect(:,:,r1_incorrect) = EEGData(:,:,i);
                    r1_incorrect = r1_incorrect + 1;
                end
                if redfreq(i) == freq1      % red = freq 2
                    redF2EEG.incorrect(:,:,r2_incorrect) = EEGData(:,:,i);
                    r2_incorrect = r2_incorrect + 1;
                end
            end
            
            if strcmp(color(i),'Green')     % green
                if redfreq(i) == freq2	% green = freq 1
                    greenF1EEG.incorrect(:,:,g1_incorrect) = EEGData(:,:,i);
                    g1_incorrect = g1_incorrect + 1;
                end
                if redfreq(i) == freq1	% green = freq 2
                    greenF2EEG.incorrect(:,:,g2_incorrect) = EEGData(:,:,i);
                    g2_incorrect = g2_incorrect + 1;
                end
            end
        end
    else
        a = a + 1;
        continue
    end
end
end