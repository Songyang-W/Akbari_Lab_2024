function Weiss_Optical_Stats_V2(time,treatment,placebo,group_name)
% This code will 1.smooth the raw data by using sgolayfilt; 2.
%% variable settings TODO
window_size = 2;%min
overlap = 1;%min

%% calculate the slope change
%TODO, sgolayfilt(treatment, 1, 101) can change 1 and 101
treatment_sgolay = sgolayfilt(treatment, 1, 101);
placebo_sgolay = sgolayfilt(placebo, 1, 101);
[placebo_slope,placebo_intersect,new_time]=Slope_trend(time,placebo_sgolay,window_size,overlap);
[treatment_slope,treatment_intersect]=Slope_trend(time,treatment_sgolay,window_size,overlap);
% stats of the slope
p_vector_MW = M_W_U_test_loop(treatment_slope,placebo_slope);

%% reform data into table format
%TODO change the number to not hard coded
mouse_number = size(treatment_slope,2)+size(placebo_slope,2);
timepoint_number = size(treatment_slope,1);
mouse_number_placebo = size(placebo_slope,2);
mouse_number_treatment = size(treatment_slope,2)

types = [repmat("treatment", mouse_number_treatment*timepoint_number, 1);...
    repmat("placebo", mouse_number_placebo*timepoint_number, 1)];
timepoints = [repmat(new_time', mouse_number_treatment, 1);...
    repmat(new_time', mouse_number_placebo, 1)];
mice = repmat((1:mouse_number)', timepoint_number, 1);  % Mouse ID from 1 to 30, repeated for 10 timepoints

data_combined = [treatment_slope(:); placebo_slope(:)];

combined_Table = table(types, timepoints, mice, data_combined, ...
    'VariableNames', {'type', 'timepoint', 'mouse', 'data'});

%% plot figure
data_length = length(treatment);

figure;
ax(1) = subplot(311)
hold on
Plot_range_mean(time(1:data_length),treatment,'r', ...
    'treatment group')
Plot_range_mean(time(1:data_length),placebo,'b', ...
    'placebo group')
legend
hold off
title(group_name)
%xlabel('time(min)')
ylabel(group_name)
set(gca,'fontsize',15)
set(gcf,'color','white')

ax(2) = subplot(312);
%subplot(312)
hold on
boxchart(combined_Table.timepoint,combined_Table.data,'GroupByColor',combined_Table.type)
legend
%{
Plot_range_mean(new_time',treatment_slope,'ro', ...
    'treatment group')
Plot_range_mean(new_time',placebo_slope,'bo', ...
    'placebo group')
legend
%}
hold off
title('Slope changes over time')
ylabel('slope')
set(gca,'fontsize',15)
set(gcf,'color','white')

ax(3) = subplot(313);
plot(new_time,p_vector_MW,'LineWidth',1.5)
hold on
plot(new_time,0.05*ones(length(new_time)),'r--')
hold off
text(1, 0.05, 'p = 0.05', 'VerticalAlignment', 'bottom',...
    'HorizontalAlignment', 'right', 'FontSize', 10, 'Color', 'red');
ylabel('p value')
xlabel('time (min)')
title('Mann-Whitney U Test for Slope')
set(gca,'fontsize',14)
set(gcf,'color','white')
linkaxes(ax,'x')

linkaxes(ax,'x')
xlim([new_time(1),new_time(end)])

end