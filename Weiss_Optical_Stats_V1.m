function Weiss_Optical_Stats_V1(time_norm,treatment,placebo,group_name,folder_name,save_fig)
% this function is just a copy of the previous code, plot the normal
% comparasion between treatment group and placebo group, and calculate p
% values of Mann-Whitney U test for both AUC and all time points

% Sep 15 add permutation test same way as Mann-Whitney U test

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
ylabel(group_name
set(gca,'fontsize',15)
set(gcf,'color','white')
xlim([time_norm(1),time_norm(end)])
%}
%% Mann-Whitney U Test for Each Time Point
data_length = length(treatment);
p_vector_MW = M_W_U_test_loop(treatment,placebo);
p_vector_permuation = Permutation_test_loop(treatment,placebo,100);
%% Mann-Whitney U Test for AUC
p_auc_MW = ranksum(sum(treatment),sum(placebo));
p_auc_permutation = permutationTest(sum(treatment),sum(placebo),100);
%% merge plot
figure;
ax(1) = subplot(311)
hold on
Plot_range_mean(time_norm(1:data_length),treatment,'r', ...
    'treatment group')
Plot_range_mean(time_norm(1:data_length),placebo,'b', ...
    'placebo group')
legend
hold off
title(group_name)
%xlabel('time(min)')
ylabel(group_name)
set(gca,'fontsize',15)
set(gcf,'color','white')
ax(2) = subplot(312);
plot(time_norm(1:data_length),p_vector_MW,'LineWidth',1.5)
hold on
plot(time_norm(1:data_length),0.05*ones(data_length),'r--')
hold off
text(1, 0.05, 'p = 0.05', 'VerticalAlignment', 'bottom',...
    'HorizontalAlignment', 'right', 'FontSize', 10, 'Color', 'red');
ylabel('p value')
%xlabel('time (min)')
title('Mann-Whitney U Test for Each Time Point')
legend(['p value for AUC =',num2str(p_auc_MW)])
set(gca,'fontsize',14)

ax(3) = subplot(313);
plot(time_norm(1:data_length),p_vector_permuation,'LineWidth',1.5)
hold on
plot(time_norm(1:data_length),0.05*ones(data_length),'r--')
hold off
text(1, 0.05, 'p = 0.05', 'VerticalAlignment', 'bottom',...
    'HorizontalAlignment', 'right', 'FontSize', 10, 'Color', 'red');
ylabel('p value')
xlabel('time (min)')
title('Permutation Test for Each Time Point')
legend(['p value for AUC =',num2str(p_auc_permutation)])
set(gca,'fontsize',14)
set(gcf,'color','white')
linkaxes(ax,'x')
xlim([time_norm(1),time_norm(end)])

%set(gcf, 'Position', get(0, 'Screensize'));
% Save the figure with the group name in the created folder
if save_fig ~= 1
    savefig(gcf, fullfile(folder_name, [group_name '_plot.fig']));
end
% Save data
%save(fullfile(folder_name, [group_name '_data.mat']), 'time_norm', 'treatment', 'placebo', 'p_vector_MW', 'p_vector_permuation', 'p_auc_MW', 'p_auc_permutation');
close
end