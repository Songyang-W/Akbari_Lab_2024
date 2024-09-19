function Plot_range_mean(time_vector,input_matrix,color,legend_txt)
%{
this function plot the mean of input_matrix, and calculate and overlay the
range of the input_matrix. The range can be either determined by 
%}
mean_data = mean(input_matrix');
std_data = std(input_matrix');
max_data = max(input_matrix');
min_data = min(input_matrix');

plot(time_vector,mean_data,color,'LineWidth',1.5,'DisplayName',legend_txt)
%{
patch([time_vector;flipud(time_vector)],...
    [mean_data + std_data,fliplr(mean_data - std_data)],...
    color,'EdgeColor', 'none', 'FaceAlpha', 0.2);
%}
patch([time_vector;flipud(time_vector)],...
    [max_data,fliplr(min_data)],...
    color,'EdgeColor', 'none', 'FaceAlpha', 0.15,'DisplayName',legend_txt);
end

