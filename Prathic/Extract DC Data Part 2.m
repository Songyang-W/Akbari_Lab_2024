    cd 'N:\Sangwoo\DSP\Filters'
    load('LP0_1v2.mat')
for i=1:length(datacell)
%idstring={['ASX102821KO'],['ASX102921KO'],['ASX110421WT'],['ASX110521WT'],['ASX111221HET'],['ASX111821HET'],['ASX111921WT'],['ASX112421WT'],...
%    ['ASX120221WT'],['ASX120321WT'],['ASX120921HET'],['ASX010622KO'],['ASX011422HET'],['ASX012122HET'],['ASX012822KO'],['ASX020322KO'],['ASX030322NA']...
%    ,['ASX030422KO'],['ASX031022KO'],['ASX031122NA'],['ASX031722WT'],['ASX031822NA'],['ASX032222WT'],['ASX032422HE'],['ASX033122HE'],['ASX040122KO']};
idstring={['ASX012323ICP']};


    disp(sprintf('start %d',i))
    disp(sprintf('start %s',datacell{1,i}.info.blockname))
    %% extract PRES data
    %% Extract EEG data
    %now that you know when (time) ventilator was stopped, find the index in
    %xRAW (EEG) in which the ventilator stopped
    FSeeg=datacell{1,i}.streams.RAWx.fs;
     %This gives you where in Raw EEG data ventilator stopped
    EEGdataClipped=datacell{1,i}.streams.RAWx.data(1:4,1:end);   %%t=-5 to t=40min
    EEGdata=(EEGdataClipped.').*1000; %transpose data so each channel is a column and convert to uV
    %save(sprintf('%s_35min',datacell{1,i}.info.blockname),'EEGdata35min')
    sdtestdetection.(idstring{i}).RawEEG=EEGdata(:,1:4);

    %% EEG data downsampled by 6 and LP filter
    EEGdata_v2=downsample(EEGdata,6);
    sdtestdetection.(idstring{i}).EEGdata=EEGdata_v2(:,1:4);
    LPeeg=zeros(length(EEGdata_v2),4);
    fs=round(1526/6);        %254hz
    %filteredEEG=zeros(length(id.EEGdata3hr),4);
     for L=1:4
         LPeeg(:,L)=filtfilt(LP0_1.Numerator,1,double(EEGdata_v2(:,L)));   %bandpass filter
     end
    sdtestdetection.(idstring{i}).LPeeg=LPeeg(:,1:4);

    %% Extract EKG data
    EKGfs=datacell{1,i}.streams.ECGx.fs;

    EKGdataClipped=datacell{1,i}.streams.ECGx.data(1,1:end);

    EKGdata=(EKGdataClipped).*1000; %convert to uV from V
%     save(sprintf('%s_35min',datacell{1,i}.info.blockname),'EKGdata35min','-append')
    sdtestdetection.(idstring{i}).EKGdata=EKGdata;

    %% Extract BPRE data (blood pressure)
    BPREfs=datacell{1,i}.streams.BPRE.fs;
    
    BPREdata=datacell{1,i}.streams.BPRE.data(1:end);
%     save(sprintf('%s_35min',datacell{1,i}.info.blockname),'BPREdata35min','-append')
    sdtestdetection.(idstring{i}).BPREdata=BPREdata;
    %% extract systolic and diastolic pressure data
    % sampling frequency for this data is just 1 sample/second
    
    SPdata=datacell{1, i}.scalars.BPHR.data(1,1:end);
    DPdata=datacell{1, i}.scalars.BPHR.data(2,1:end);
    HRdata=datacell{1, i}.scalars.BPHR.data(3,1:end);
%     save(sprintf('%s_35min',datacell{1,i}.info.blockname),'SPdata35min','-append')
%     save(sprintf('%s_35min',datacell{1,i}.info.blockname),'DPdata35min','-append')
%     save(sprintf('%s_35min',datacell{1,i}.info.blockname),'HRdata35min','-append')
    Sepehrrats.(idstring{i}).SPdata=SPdata;
    Sepehrrats.(idstring{i}).DPdata=DPdata;
    Sepehrrats.(idstring{i}).HRdata=HRdata;    
    MAPdata=(SPdata+2*DPdata)/3;
    sdtestdetection.(idstring{i}).MAPdata=MAPdata;
    %% extract DC data

    DCfs=datacell{1,i}.streams.DCPt.fs;
    
    DCdata=datacell{1,i}.streams.DCPt.data(:,1:end);
    DCdata=(DCdata').*1000;    %transpose back to columns and convert to uV from V
    %DCdata45min=downsample(DCdata45min,40);
%     addpath('V:\Signal Processing\Personnel\Sangwoo\DSP\Filters')
%     load('LP0_1v2.mat')
    sdtestdetection.(idstring{i}).DCdata=DCdata(:,1);
    DCLP=zeros(length(DCdata),2);
    %filteredEEG=zeros(length(id.EEGdata3hr),4);
     for L=1
         DCLP(:,L)=filtfilt(LP0_1.Numerator,1,double(DCdata(:,L)));   %bandpass filter from 1-50Hz. This is what Nikole did.
     end
%     save(sprintf('%s_35min',datacell{1,i}.info.blockname),'DCdata35min','-append')
    sdtestdetection.(idstring{i}).DCLP=DCLP;
%     MichaelCohort.(idstring{i}).DCLP1detrend=detrend(DCLP(:,1));
%     MichaelCohort.(idstring{i}).DCLP2detrend=detrend(DCLP(:,2));
        
    disp(sprintf('end %d',i))
    disp(sprintf('end %s',(idstring{i})))

 
end