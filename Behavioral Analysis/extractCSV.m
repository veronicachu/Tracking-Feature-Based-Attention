function extractCSV(subjnum)
% Note: subjnum is a string

%% Retrieve raw data
olddir = pwd;

% open subject's directory
newdir = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP HUD Analyses/Raw Data/Subj %s/ResponseData',subjnum);
cd(newdir);

% open Response Data file
filename = sprintf('Response Data.csv');
data = readtable(filename);

cd(olddir);

%% Get relevant data
correct = data.Correct;     % 1 = correct, 0 = incorrect
color = data.TargetColor;	% 1 = red, 0 = green
redfreq = data.RedFreq;
greenfreq = data.GreenFreq;

TrialData.Correct = correct;
TrialData.Color = color;
TrialData.RedFreq = redfreq;
TrialData.GreenFreq = greenfreq;

%% Save data
save(sprintf('%s_ColorData',subjnum),'TrialData')

end