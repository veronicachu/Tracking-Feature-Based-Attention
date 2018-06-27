function CombineBlocks(subjnum)
%% Block 1
disp('Getting data from Block A...')
file = sprintf('S%d-1_SegmentedEEG.mat',subjnum);
load(file)

% Exact onset
Block1_EEG = SegmentedEEG;
Block1_PC = PCData;

% Pre onset
Block1_preEEG = PreSegmentedEEG;
Block1_prePC = PrePCData;

%% Block 2
disp('Getting data from Block B...')
file = sprintf('S%d-2_SegmentedEEG.mat',subjnum);
load(file)

% Exact onset
Block2_EEG = SegmentedEEG;
Block2_PC = PCData;

% Pre onset
Block2_preEEG = PreSegmentedEEG;
Block2_prePC = PrePCData;

%% Block 3
disp('Getting data from Block 3...')
file = sprintf('S%d-3_SegmentedEEG.mat',subjnum);
load(file)

% Exact onset
Block3_EEG = SegmentedEEG;
Block3_PC = PCData;

% Pre onset
Block3_preEEG = PreSegmentedEEG;
Block3_prePC = PrePCData;

%% Block 4
disp('Getting data from Block 4...')
file = sprintf('S%d-4_SegmentedEEG.mat',subjnum);
load(file)

% Exact onset
Block4_EEG = SegmentedEEG;
Block4_PC = PCData;

% Pre onset
Block4_preEEG = PreSegmentedEEG;
Block4_prePC = PrePCData;

%% Combine Blocks
disp('Combining Blocks...')
clear PCData SegmentedEEG PrePCData PreSegmentedEEG

% Exact onset EEG
SegmentedEEG = Block1_EEG;
SegmentedEEG(:,:,65:128) = Block2_EEG;
SegmentedEEG(:,:,129:192) = Block3_EEG;
SegmentedEEG(:,:,193:256) = Block4_EEG;

% Exact onset PC
PCData = Block1_PC;
PCData(:,:,65:128) = Block2_PC;
PCData(:,:,129:192) = Block3_PC;
PCData(:,:,193:256) = Block4_PC;

% Pre onset EEG
PreSegmentedEEG = Block1_preEEG;
PreSegmentedEEG(:,:,65:128) = Block2_preEEG;
PreSegmentedEEG(:,:,129:192) = Block3_preEEG;
PreSegmentedEEG(:,:,193:256) = Block4_preEEG;

% Exact onset PC
PrePCData = Block1_prePC;
PrePCData(:,:,65:128) = Block2_prePC;
PrePCData(:,:,129:192) = Block3_prePC;
PrePCData(:,:,193:256) = Block4_prePC;


%% Save file
disp('Saving data...')
save(sprintf('S%d_SegmentedEEG',subjnum),...
   'nChan','Fs','SecBeforeOnset','SecAfterOnset','SecAfterTrial',...
   'PCData','SegmentedEEG','PrePCData','PreSegmentedEEG')

end
