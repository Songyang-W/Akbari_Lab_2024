% Script to calculate average from WeissOpticalDataTransfer dataset
addpath("permutation_Matlab/")
load_updated_weiss
timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
folder_name = ['Results_' timestamp];
mkdir(folder_name);
%% plot the overall 

% aCBF
Weiss_Optical_Stats_V1(time_norm,aCBF_treatment,aCBF_placebo,'aCBF',folder_name)
%aCMRO2
Weiss_Optical_Stats_V1(time_norm,aCMRO2_treatment,aCMRO2_placebo,'aCMRO2',folder_name)
%CtHb
Weiss_Optical_Stats_V1(time_norm,CtHb_treatment,CtHb_placebo,'CtHb',folder_name)
%CtHbO2
Weiss_Optical_Stats_V1(time_norm,CtHbO2_treatment,CtHbO2_placebo,'CtHbO2',folder_name)
%CtHbTot
Weiss_Optical_Stats_V1(time_norm,CtHbTot_treatment,CtHbTot_placebo,'CtHbTot',folder_name)
%rCtHb
Weiss_Optical_Stats_V1(time_norm,rCtHb_treatment,rCtHb_placebo,'relative CtHb',folder_name)
%rCtHbO2
Weiss_Optical_Stats_V1(time_norm,rCtHbO2_treatment,rCtHbO2_placebo,'relative CtHbO2',folder_name)
%rCtHbTot
Weiss_Optical_Stats_V1(time_norm,rCtHbTot_treatment,rCtHbTot_placebo,'relative CtHbTot',folder_name)
%rRatio
Weiss_Optical_Stats_V1(time_norm,rRatio_treatment,rRatio_placebo,'rRatio',folder_name)

%rCBF
Weiss_Optical_Stats_V1(time_norm,renee_rCBF_treatment,renee_rCBF_placebo,'relative CBF',folder_name)
%rCMRO2
Weiss_Optical_Stats_V1(time_norm,renee_rCMRO2_treatment,renee_rCMRO2_placebo,'relative CMRO2',folder_name)

%% calculate slope
% using model to denoise
aCBF_t_sgolay = sgolayfilt(aCBF_treatment, 1, 101);
aCBF_p_sgolay = sgolayfilt(aCBF_placebo, 1, 101);
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
%% TODO permutation test

%% Friedman’s test

p_friedman = friedman(treatment_group(1:3143,:),3)

