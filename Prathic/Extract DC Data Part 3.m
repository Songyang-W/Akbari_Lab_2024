%%
TestReneeTime = (0:length(sdtestdetection.ASX012323ICP.LPeeg)-1)/305;
TestTime = (0:length(sdtestdetection.ASX012323ICP.DCLP)-1)/305;
Time = (0:length(sdtestdetection.ASX012323ICP.RawEEG)-1)/305;
%%
ECoG_raw = sdtestdetection.ASX012323ICP.RawEEG;
ECoG_filt = sdtestdetection.ASX012323ICP.LPeeg;
%%
cd 'I:\Sangwoo\DSP\Filters' %Load the filters from Sangwoo's folder
load('LP001_01.mat') %Load the 1hz Lowpass Filter
common_mean = mean(ECoG_filt(:,1:3),2);
ECoG_filt = ECoG_filt - common_mean;

ECoG_raw = bandstop(ECoG_raw(:,1:3), [59,61], FSeeg);
ECoG_raw = filtfilt(LP001_01.Numerator,1, double(ECoG_raw));
common_mean = mean(ECoG_raw(:,1:3),2);
ECoG_raw = ECoG_raw - common_mean;

asp = 660;
ca = (14*60)+3;
rosc = (18*60)+4;
cpr = (19*60)+23;
%%
figure()
subplot(211)
plot(TestReneeTime / 60, ECoG_filt(:,1))
title("ASX012323ICP AC ECoG Channel 1")
xlabel('Time (min)')
ylabel('AC ECoG (uV)')
xline(asp/60,'-',{'Asphyxia'},'Fontsize',11)
xline(ca/60,'-',{'CA'},'Fontsize',11)
xline(cpr/60,'-',{'CPR'},'Fontsize',11)
xline(rosc/60,'-',{'ROSC'},'Fontsize',11)
ax1 = gca;

subplot(212)
plot(Time / 60, ECoG_raw(:,1))
title("ASX012323ICP AC ECoG Channel 2")
xlabel('Time (min)')
ylabel('AC ECoG (uV)')
xline(asp/60,'-',{'Asphyxia'},'Fontsize',11)
xline(ca/60,'-',{'CA'},'Fontsize',11)
xline(cpr/60,'-',{'CPR'},'Fontsize',11)
xline(rosc/60,'-',{'ROSC'},'Fontsize',11)
ax2 = gca;
%%
subplot(413)
plot(TestReneeTime / 60, sdtestdetection.ASX012323ICP.LPeeg(:,3))
title("ASX012323ICP AC ECoG Channel 3")
xlabel('Time (min)')
ylabel('AC ECoG (uV)')
xline(asp/60,'-',{'Asphyxia'},'Fontsize',11)
xline(ca/60,'-',{'CA'},'Fontsize',11)
xline(cpr/60,'-',{'CPR'},'Fontsize',11)
xline(rosc/60,'-',{'ROSC'},'Fontsize',11)
ax3 = gca;

subplot(414)
plot(TestTime / 60, sdtestdetection.ASX012323ICP.DCLP(:,1))
title("ASX012323ICP DC ECoG")
xlabel('Time (min)')
ylabel('DC ECoG ')
xline(asp/60,'-',{'Asphyxia'},'Fontsize',11)
xline(ca/60,'-',{'CA'},'Fontsize',11)
xline(cpr/60,'-',{'CPR'},'Fontsize',11)
xline(rosc/60,'-',{'ROSC'},'Fontsize',11)
ax4 = gca;

linkaxes([ax1,ax2,ax3,ax4],'x')
%% Make sure to save the struct
figure()
subplot(411)
spectrogram(sdtestdetection.ASX012323ICP.LPeeg(:,1),100,80,(0:180),FSeeg,'yaxis')
colormap('jet')
title("AC Channel 1")
ax1 = gca;
subplot(412)
spectrogram(sdtestdetection.ASX012323ICP.LPeeg(:,2),100,80,(0:180),FSeeg,'yaxis')
colormap('jet')
title("AC Channel 2")
ax2 = gca;
subplot(413)
spectrogram(sdtestdetection.ASX012323ICP.LPeeg(:,3),100,80,(0:180),FSeeg,'yaxis')
colormap('jet')
title("AC Channel 3")
ax3 = gca;
subplot(414)
spectrogram(sdtestdetection.ASX012323ICP.DCLP(:,1),100,80,(0:180),DCfs,'yaxis')
colormap('jet')
title("DC Channel")
ax4 = gca;

%%
figure()
tiledlayout(4,1)

p1 = nexttile();
window = round(2*FSeeg);
offset = 0.9; % Define offset as 90%
       colormap jet;
        spectrogram(sdtestdetection.ASX012323ICP.LPeeg(1,:),window, round(window*offset),1:200,FSeeg,'yaxis');
      %  colorbar('on');
        plot_name = 'AC Channel 1';
        title(plot_name);

p2 = nexttile();
window = round(2*FSeeg);
offset = 0.9; % Define offset as 90%
       colormap jet;
        spectrogram(sdtestdetection.ASX012323ICP.LPeeg(2,:),window, round(window*offset),1:200,FSeeg,'yaxis');
      %  colorbar('on');
        plot_name = 'AC Channel 2';
        title(plot_name);


p3 = nexttile();
window = round(2*ECoG_fs);
offset = 0.9; % Define offset as 90%
       colormap jet;
        spectrogram(sdtestdetection.ASX012323ICP.LPeeg(2,:),window, round(window*offset),1:200,FSeeg,'yaxis');
      %  colorbar('on');
        plot_name = 'AC Channel 3';
        title(plot_name);
        
p4 = nexttile();
window = round(2*ECoG_fs);
offset = 0.9; % Define offset as 90%
       colormap jet;
        spectrogram(sdtestdetection.ASX012323ICP.DCLP(:,1),window, round(window*offset),1:200,DCfs,'yaxis');
      %  colorbar('on');
        plot_name = 'DC ECoG';
        title(plot_name);

