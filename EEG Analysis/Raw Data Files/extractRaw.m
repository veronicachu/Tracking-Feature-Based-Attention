function extractRaw(subjnum)
% Note: subjname is a string

%% Retrieve raw data
olddir = pwd;

% open subject's directory
newdir = sprintf('D:/Veronica/Documents/Data Analysis/SSVEP HUD Analyses/Raw Data/Subj %s',subjnum);
cd(newdir);

% % open Eyes Open file
% EOfilename = sprintf('EO_%s.xdf',subjnum);
% dataEO = load_xdf(EOfilename);
% 
% % open Eyes Close file
% ECfilename = sprintf('EC_%s.xdf',subjnum);
% dataEC = load_xdf(ECfilename);

% open Experiment file
Expfilename = sprintf('SSVEP HUD_%s.xdf',subjnum);
dataExp = load_xdf(Expfilename);

cd(olddir);

%% Save raw data
savename = sprintf('%s_RawData.mat',subjnum);
save(savename,'dataExp')

end