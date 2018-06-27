function extractRaw(subjnum,blocknum)
% Note: subjname is an int, blocknum is an int

%% Retrieve raw data
olddir = pwd;

% open subject's directory
newdir = sprintf('D:/Grad School/Research/CNS Lab/Projects/Basic Motion SSVEP/3_Data Analysis/Raw Data/S%d/EEG',subjnum);
cd(newdir);

% open Experiment file
Expfilename = sprintf('Basic Motion SSVEP_S%d-%d.xdf',subjnum,blocknum);
LSLData = load_xdf(Expfilename);

cd(olddir);

%% Save raw data
savename = sprintf('S%d-%d_RawData.mat',subjnum,blocknum);
save(savename,'LSLData')

end