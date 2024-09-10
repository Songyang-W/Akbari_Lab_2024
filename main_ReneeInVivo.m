% Script to calculate average from WeissOpticalDataTransfer dataset

load_updated_weiss
%% plot the overall 

% aCBF
Weiss_Optical_Stats_V1(time_norm,aCBF_treatment,aCBF_placebo,'aCBF')
%aCMRO2
Weiss_Optical_Stats_V1(time_norm,aCMRO2_treatment,aCMRO2_placebo,'aCMRO2')
%CtHb
Weiss_Optical_Stats_V1(time_norm,CtHb_treatment,CtHb_placebo,'CtHb')
%CtHbO2
Weiss_Optical_Stats_V1(time_norm,CtHbO2_treatment,CtHbO2_placebo,'CtHbO2')
%CtHbTot
Weiss_Optical_Stats_V1(time_norm,CtHbTot_treatment,CtHbTot_placebo,'CtHbTot')
%rCtHb
Weiss_Optical_Stats_V1(time_norm,rCtHb_treatment,rCtHb_placebo,'relative CtHb')
%rCtHbO2
Weiss_Optical_Stats_V1(time_norm,rCtHbO2_treatment,rCtHbO2_placebo,'relative CtHbO2')
%rCtHbTot
Weiss_Optical_Stats_V1(time_norm,rCtHbTot_treatment,rCtHbTot_placebo,'relative CtHbTot')
%rRatio
Weiss_Optical_Stats_V1(time_norm,rRatio_treatment,rRatio_placebo,'rRatio')

%rCBF
Weiss_Optical_Stats_V1(time_norm,renee_rCBF_treatment,renee_rCBF_placebo,'relative CBF')
%rCMRO2
Weiss_Optical_Stats_V1(time_norm,renee_rCMRO2_treatment,renee_rCMRO2_placebo,'relative CMRO2')

%% Friedman’s test

p_friedman = friedman(treatment_group(1:3143,:),3)

