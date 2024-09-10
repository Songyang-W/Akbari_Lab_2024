p_aCBF = ranksum(sum(aCBF_treatment),sum(aCBF_placebo));
aCBF_order = tiedrank(sum([aCBF_treatment,aCBF_placebo]));
p_order = ranksum(aCBF_order(1:10),aCBF_order(11:18));
disp(['p value from Mann-Whitney U test = ',num2str(p_aCBF)])
disp(['AUC = '])
disp(num2str(sum(aCBF_treatment)))
disp(num2str(sum(aCBF_placebo)))
disp('order = ')
disp(num2str(aCBF_order))
disp(['p value from order = ',num2str(p_aCBF)])