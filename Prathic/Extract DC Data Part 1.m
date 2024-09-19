%% Run this section to select a rat's midCA file
tic
%SDKPATH=('V:\Signal Processing\Personnel\Sangwoo\DSP\TDTMatlabSDK\TDTSDK\TDTbin2mat');
addpath('N:\Sangwoo\DSP\Functions')
SDKPATH=('N:\Sangwoo\DSP\TDTMatlabSDK\TDTSDK\TDTbin2mat');
addpath(genpath(SDKPATH));
BLOCK=uipickfiles('FilterSpec','N:\TDT Tanks');

%% Run this section to extract all the data from that animal
length(BLOCK)
for j = 1:length(BLOCK)
    j
    data=TDTbin2mat(BLOCK{j});
    %fscell(j)=data.streams.RAWx.fs;
    datacell{j}=data;
    %auto get filename folder
    %wholefilename=strsplit(TANK,'\');
    %tempfilename=wholefilename{end};
    %ratID=strcat('R',tempfilename);
    %filenamecell{j}=ratID;
    disp(sprintf('%s',data.info.blockname))
    disp('done')
end

toc
%fs = data.streams.RAWx.fs; 
