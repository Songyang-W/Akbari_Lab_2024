rat_path = uigetdir();
rat = TDTbin2mat(rat_path, 'T1', 0, 'T2', 3300);


% AC ECoG
ECoG_raw = rat.streams.EEGx.data;
ECoG_raw = (ECoG_raw').*1000;
ECoG_fs = rat.streams.EEGx.fs;
ECoG_time = (0:length(ECoG_raw(:,1)) - 1) / ECoG_fs;
%%
Asp = 11;
CA = 14 + 3/60;
CPR = 18+4/60;
ROSC = 19+23/60;

%Raw ECoG
figure;
subplot(4,1,1)
plot(ECoG_time / 60, ECoG_raw(:,1));
xlabel('time (min)');
ylabel('AC ECoG (microvolts)');
title('012323ICP Raw AC ECoG');
xline(Asp, '-', {'Asphyxia'}, 'FontSize', 13);
xline(CA, '-', {'CA'}, 'FontSize', 13);
xline(CPR, '-', {'CPR'}, 'FontSize', 13);
xline(ROSC, '-', {'ROSC'}, 'FontSize', 13);
ax1 = gca;


%60hz notch
notch_ECoG = bandstop(ECoG_raw, [59 61], ECoG_fs);
subplot(4,1,2)
plot(ECoG_time / 60, notch_ECoG(:,1));
xlabel('time (min)');
ylabel('AC ECoG (microvolts)');
title('60hz notch');
xline(Asp, '-', {'Asphyxia'}, 'FontSize', 13);
xline(CA, '-', {'CA'}, 'FontSize', 13);
xline(CPR, '-', {'CPR'}, 'FontSize', 13);
xline(ROSC, '-', {'ROSC'}, 'FontSize', 13);
ax2 = gca;

%bandpass
ECoG_band = bandpass(notch_ECoG, [0.1 0.4], ECoG_fs);

subplot(4,1,3)
plot(ECoG_time/60, ECoG_band(:,1));
xlabel('Time (min)');
ylabel('AC ECoG (microvolts)');
title('0.1-0.4hz bandpass');
xline(Asp, '-', {'Asphyxia'}, 'FontSize', 13);
xline(CA, '-', {'CA'}, 'FontSize', 13);
xline(CPR, '-', {'CPR'}, 'FontSize', 13);
xline(ROSC, '-', {'ROSC'}, 'FontSize', 13);
ax3 = gca;

%1 hz lowpass
ECoG_low = lowpass(notch_ECoG, 0.4, ECoG_fs);

subplot(4,1,4)
plot(ECoG_time/60, ECoG_low(:,1));
xlabel('Time (min)');
ylabel('AC ECoG (microvolts)');
title('0.4hz lowpass');
xline(Asp, '-', {'Asphyxia'}, 'FontSize', 13);
xline(CA, '-', {'CA'}, 'FontSize', 13);
xline(CPR, '-', {'CPR'}, 'FontSize', 13);
xline(ROSC, '-', {'ROSC'}, 'FontSize', 13);
ax4 = gca;


linkaxes([ax1, ax2, ax3, ax4], 'xy');
%% TODO
%{
use spectrogram function to check your filter performance
https://www.mathworks.com/help/signal/ref/spectrogram.html
check topic "Spectrogram and Instantaneous Frequency"
https://www.ee.columbia.edu/~ronw/adst-spring2010/lectures/matlab/lecture1.html

play with the 100,80,100 in the 
spectrogram(y,100,80,100,fs,'yaxis') 

it should be fine with 
spectrogram(ECoG_raw,100,80,[0:180],ECoG_fs,'yaxis') or any number you feel
reasonable (for [0:180] it means the range of the frequency output you want
I remember we used to have a 0-150 bandpass as standard procedure in the
lab but i forgot the exact number. Thus I wrote 180 here.

after learning how to use spectrogram, do this
subplot(411)
spectrogram(ECoG_raw,100,80,[0:180],ECoG_fs,'yaxis')
subplot(412)
spectrogram(notch_ECoG,100,80,[0:180],ECoG_fs,'yaxis')
subplot(413)
spectrogram(ECoG_band,100,80,[0:180],ECoG_fs,'yaxis')
subplot(414)
spectrogram(ECoG_low,100,80,[0:180],ECoG_fs,'yaxis')

you need to change the code to make sure it run properly, I don't have data
on my end to test if it is correct

you can send me the screenshot of your result if you are not sure before
the DSP meeting

%}
%%
%DC ECoG
tic
%SDKPATH=('V:\Signal Processing\Personnel\Sangwoo\DSP\TDTMatlabSDK\TDTSDK\TDTbin2mat');
addpath('N:\Sangwoo\DSP\Functions')
SDKPATH=('N:\Sangwoo\DSP\TDTMatlabSDK\TDTSDK\TDTbin2mat');
addpath(genpath(SDKPATH));
BLOCK=uipickfiles('FilterSpec','N:\TDT Tanks');

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
    cd 'N:\Sangwoo\DSP\Filters'
    load('LP0_1v2.mat')
for i=1:length(datacell)
%idstring={['ASX102821KO'],['ASX102921KO'],['ASX110421WT'],['ASX110521WT'],['ASX111221HET'],['ASX111821HET'],['ASX111921WT'],['ASX112421WT'],...
%    ['ASX120221WT'],['ASX120321WT'],['ASX120921HET'],['ASX010622KO'],['ASX011422HET'],['ASX012122HET'],['ASX012822KO'],['ASX020322KO'],['ASX030322NA']...
%    ,['ASX030422KO'],['ASX031022KO'],['ASX031122NA'],['ASX031722WT'],['ASX031822NA'],['ASX032222WT'],['ASX032422HE'],['ASX033122HE'],['ASX040122KO']};
idstring={['ASX012323ICP']};


    disp(sprintf('start %d',i))
    disp(sprintf('start %s',datacell{1,i}.info.blockname))
        DCfs=datacell{1,i}.streams.DCPt.fs;
    
    DCdata=datacell{1,i}.streams.DCPt.data(:,1:end);
    DCdata=(DCdata').*1000;    %transpose back to columns and convert to uV from V
    %DCdata45min=downsample(DCdata45min,40);
%     addpath('V:\Signal Processing\Personnel\Sangwoo\DSP\Filters')
%     load('LP0_1v2.mat')
    struct.(idstring{i}).DCdata=DCdata(:,1);
    DCLP=zeros(length(DCdata),2);
    %filteredEEG=zeros(length(id.EEGdata3hr),4);
     for L=1
         DCLP(:,L)=filtfilt(LP0_1.Numerator,1,double(DCdata(:,L)));   %bandpass filter from 1-50Hz. This is what Nikole did.
     end
%     save(sprintf('%s_35min',datacell{1,i}.info.blockname),'DCdata35min','-append')
    struct.(idstring{i}).DCLP=DCLP;
%     MichaelCohort.(idstring{i}).DCLP1detrend=detrend(DCLP(:,1));
%     MichaelCohort.(idstring{i}).DCLP2detrend=detrend(DCLP(:,2));
        
    disp(sprintf('end %d',i))
    disp(sprintf('end %s',(idstring{i})))
end

%fs = data.streams.RAWx.fs; 

TestReneeTime = (0:length(struct.ASX012323ICP.DCLP)-1)/305;

subplot(2,1,2);
plot(TestReneeTime, struct.ASX012323ICP.DCLP(:,1));
xlabel('Time (sec)');
ylabel('DC ECoG ');
title('ASX031423ICP');
xline(Asp*60, '-', {'Asphyxia'}, 'FontSize', 13);
xline(CA*60, '-', {'CA'}, 'FontSize', 13);
xline(CPR*60, '-', {'CPR'}, 'FontSize', 13);
xline(ROSC*60, '-', {'ROSC'}, 'FontSize', 13);