% Script to calculate average,range,slope from WeissOpticalDataTransfer dataset
% this step is adding data and function, maybe has several bugs, with
% loading, be careful for the path

addpath("permutation_Matlab/") %feel free to copy paste the folder to your directory
addpath("functions/")
load_updated_weiss %run a separate code, hard coded the loading process

% comment this if you don't want to save (taking a long time)
timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
folder_name = ['Results_' timestamp]; % save data to the folder that contains
mkdir(folder_name);
%% plot the overall 
% Weiss Optical Stats V1 is the basic code only run MW test and Permutation
% Test

% aCBF
Weiss_Optical_Stats_V1(time_norm,aCBF_treatment,aCBF_placebo,'aCBF',folder_name,0)
%aCMRO2
Weiss_Optical_Stats_V1(time_norm,aCMRO2_treatment,aCMRO2_placebo,'aCMRO2',folder_name,0)
%CtHb
Weiss_Optical_Stats_V1(time_norm,CtHb_treatment,CtHb_placebo,'CtHb',folder_name,0)
%CtHbO2
Weiss_Optical_Stats_V1(time_norm,CtHbO2_treatment,CtHbO2_placebo,'CtHbO2',folder_name,0)
%CtHbTot
Weiss_Optical_Stats_V1(time_norm,CtHbTot_treatment,CtHbTot_placebo,'CtHbTot',folder_name,0)
%rCtHb
Weiss_Optical_Stats_V1(time_norm,rCtHb_treatment,rCtHb_placebo,'relative CtHb',folder_name,0)
%rCtHbO2
Weiss_Optical_Stats_V1(time_norm,rCtHbO2_treatment,rCtHbO2_placebo,'relative CtHbO2',folder_name,0)
%rCtHbTot
Weiss_Optical_Stats_V1(time_norm,rCtHbTot_treatment,rCtHbTot_placebo,'relative CtHbTot',folder_name,0)
%rRatio
Weiss_Optical_Stats_V1(time_norm,rRatio_treatment,rRatio_placebo,'rRatio',folder_name,0)

%rCBF
Weiss_Optical_Stats_V1(time_norm,renee_rCBF_treatment,renee_rCBF_placebo,'relative CBF',folder_name,0)
%rCMRO2
Weiss_Optical_Stats_V1(time_norm,renee_rCMRO2_treatment,renee_rCMRO2_placebo,'relative CMRO2',folder_name,0)

%% calculate slope
% testing the method, Weiss_Optical_Stats_V2 included everything
% using model to denoise
aCBF_t_sgolay = sgolayfilt(aCBF_treatment, 1, 101);
aCBF_p_sgolay = sgolayfilt(aCBF_placebo, 1, 101);
%plot the result out
figure;
ax(1) = subplot(211);
plot(time_norm(1:length(aCBF_t_sgolay)),mean(aCBF_treatment'))
hold on;plot(time_norm(1:length(aCBF_p_sgolay)),mean(aCBF_placebo'))
title('pre filtering')
set(gca,'fontsize',14)
ax(2) = subplot(212);
plot(time_norm(1:length(aCBF_t_sgolay)),mean(aCBF_t_sgolay'))
hold on;plot(time_norm(1:length(aCBF_p_sgolay)),mean(aCBF_p_sgolay'))
legend('treatment','placebo')
title('post filtering')
linkaxes(ax,'x')
xlim([0 30])
xlabel('time(min)')
set(gca,'fontsize',14)
set(gcf,'color','white')

%% Study the change of the slope


Weiss_Optical_Stats_V2(time_norm,aCBF_treatment,aCBF_placebo,'aCBF')
Weiss_Optical_Stats_V2(time_norm,CtHbTot_treatment,CtHbTot_placebo,'CtHbTot')

Weiss_Optical_Stats_V2(time_norm,rRatio_treatment,rRatio_placebo,'rRatio')
Weiss_Optical_Stats_V2(time_norm,CtHbO2_treatment,CtHbO2_placebo,'CtHbO2')
Weiss_Optical_Stats_V2(time_norm,rCtHbO2_treatment,rCtHbO2_placebo,'relative CtHbO2')


%% Friedman’s test
% I tried this, but doesn't feel very helpful, can be deleted
p_friedman = friedman(treatment_group(1:3143,:),3)

