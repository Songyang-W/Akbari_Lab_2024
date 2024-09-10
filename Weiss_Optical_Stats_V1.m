function Weiss_Optical_Stats_V1(time_norm,treatment,placebo,group_name)
% this function is just a copy of the previous code, plot the normal
% comparasion between treatment group and placebo group, and calculate p
% values of Mann-Whitney U test for both AUC and all time points
%% plot the raw 
%{
figure;
hold on
Plot_range_mean(time_norm(1:3121),treatment,'r', ...
    'treatment group')
Plot_range_mean(time_norm(1:3121),placebo,'b', ...
    'placebo group')
legend
hold off
xlabel('time(min)')
ylabel(group_name)
set(gca,'fontsize',15)
set(gcf,'color','white')
xlim([time_norm(1),time_norm(end)])
%}
%% Mann-Whitney U Test for Each Time Point
data_length = length(treatment);
p_vector = M_W_U_test_loop(treatment,placebo);
%% Mann-Whitney U Test for AUC
p_auc = ranksum(sum(treatment),sum(placebo))
%% merge plot
figure;
ax(1) = subplot(211)
hold on
Plot_range_mean(time_norm(1:data_length),treatment,'r', ...
    'treatment group')
Plot_range_mean(time_norm(1:data_length),placebo,'b', ...
    'placebo group')
legend
hold off
title(group_name)
xlabel('time(min)')
ylabel(group_name)
set(gca,'fontsize',15)
set(gcf,'color','white')
ax(2) = subplot(212);
plot(time_norm(1:data_length),p_vector,'LineWidth',1.5)
hold on
plot(time_norm(1:data_length),0.05*ones(data_length),'r--')
hold off
text(1, 0.05, 'p = 0.05', 'VerticalAlignment', 'bottom',...
    'HorizontalAlignment', 'right', 'FontSize', 10, 'Color', 'red');
ylabel('p value')
xlabel('time (min)')
title('Mann-Whitney U Test for Each Time Point')
legend(['p value for AUC =',num2str(p_auc)])
set(gca,'fontsize',14)
set(gcf,'color','white')
linkaxes(ax,'x')
xlim([time_norm(1),time_norm(end)])

end