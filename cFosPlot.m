
load vaf_data_summary.mat


%%
scatter3(repelem([0.5,0.8,1,2,3],9),cmro2mat(:),repmat(ca1,5,1),'filled')

%% improve plot 1
figure(101);
% C = rand(9, 3);
C=[0,0,0];
color1 = [242, 75, 89] / 255; % #f24b59
color2 = [155, 177, 242] / 255; % #9bb1f2
data_input = output_vector;
for time_points = 1:5
    [R,p] = corr(data_input(:,time_points),ca1);
    ca1_r(time_points) = R;
    x_line = min(data_input(:,time_points)):0.01:max(data_input(:,time_points));
    mdl_temp = fitlm(data_input(:,time_points),ca1);
    intersection = mdl_temp.Coefficients{1,1};
    slope = mdl_temp.Coefficients{2,1};
    y_pred = x_line*slope+intersection;

    ax(time_points) = subplot(5,1,time_points);
    scatter(data_input(:,time_points),ca1,36, color1, 'filled')
    hold on
    plot(x_line,y_pred,'r')
    hold off
    legend(['R=',num2str(R), (p<0.05)*'*'])
    set(gca,'fontsize',14)
    if time_points ==3
        ylabel('Damaged Cells 2-hr postROSC(%)')
    end
end
linkaxes(ax,'x')
xlim([min(data_input(:))-0.1 max(data_input(:))])
xlabel('time post ROSC(min)')
sgtitle('CA1')
set(gcf,'color','w')

figure(102);
for time_points = 1:5
    [R,p] = corr(data_input(:,time_points),ca3);
    ca3_r(time_points) = R;
    x_line = min(data_input(:,time_points)):0.01:max(data_input(:,time_points));
    mdl_temp = fitlm(data_input(:,time_points),ca3);
    intersection = mdl_temp.Coefficients{1,1};
    slope = mdl_temp.Coefficients{2,1};
    y_pred = x_line*slope+intersection;

    ax(time_points) = subplot(5,1,time_points);
    scatter(data_input(:,time_points),ca3,36, color2, 'filled')
    hold on
    plot(x_line,y_pred,'b')
    hold off
    legend(['R=',num2str(R), (p<0.05)*'*'])
    set(gca,'fontsize',14)
    if time_points ==3
        ylabel('Damaged Cells 2-hr postROSC(%)')
    end
end
linkaxes(ax,'x')
xlim([min(data_input(:))-0.1 max(data_input(:))])
xlabel('time post ROSC(min)')
sgtitle('CA3')
set(gcf,'color','w')
%% improve plot 2
figure(103);
for time_points= 1:5
mdl_temp_ca1 = fitlm(cmro2mat(:,time_points),ca1);
intersectionca1 = mdl_temp_ca1.Coefficients{1,1};
slopeca1 = mdl_temp_ca1.Coefficients{2,1};
mdl_temp_ca3 = fitlm(cmro2mat(:,time_points),ca3);
intersectionca3 = mdl_temp_ca3.Coefficients{1,1};

ca1significant = mdl_temp_ca1.Coefficients{2,4}<0.05;
ca3significant = mdl_temp_ca3.Coefficients{2,4}<0.05;

slopeca3 = mdl_temp_ca3.Coefficients{2,1};
x_line = min(cmro2mat(:,time_points)):0.01:max(cmro2mat(:,time_points));
y_predca1 = x_line*slopeca1+intersectionca1;
y_predca3 = x_line*slopeca3+intersectionca3;
ax(time_points) = subplot(5,1,time_points);
scatter(cmro2mat(:,time_points),ca1,'r','filled','DisplayName','CA1')
hold on
scatter(cmro2mat(:,time_points),ca3,'b','filled','DisplayName','CA3')
plot(x_line,y_predca1,'r','DisplayName',['slope=',num2str(intersectionca1) ...
    , ca1significant*'*'])
plot(x_line,y_predca3,'b','DisplayName',['slope=',num2str(intersectionca3) ...
    , ca3significant*'*'])
legend
set(gca,'fontsize',14)
hold off
end
linkaxes(ax,'x')
xlabel('time post ROSC(min)')
ylabel('Damaged Cells 2-hr postROSC(%)')
set(gcf,'color','w')

%% Model set up

% Assuming you have X, Y, and Z data points for your scatter plot
T = repelem([0.5,0.8,1,2,3],9)';
Y = cmro2mat(:);
Z1 = repmat(ca1,5,1);
Z2 = repmat(ca3,5,1);
SFICMRO2_array = sficmro2mat(:);
CBFmat = sficmro2mat.*cmro2mat;
% Construct the design matrix for GLM (same as original)
%X_matrix = [ones(size(T)) T Y SFICMRO2_array];
X_matrix = [ones(size(T)) T Y T.*Y CBFmat(:) ];

%% dAIC score
distribution = 'normal'; % Options: 'normal', 'binomial', 'poisson', etc.
linkFunction = 'log'; % Options depend on the distribution
variableNames = {'intersections','Time','CMRO2','Time*CMRO2','CBF'};
Delta_AIC(X_matrix(:,2:end),Z1, distribution, linkFunction,variableNames(2:end))
Delta_AIC(X_matrix(:,2:end),Z2, distribution, linkFunction,variableNames(2:end))

%% 3D raw overlay

SFICMRO2_mat = vaf_summary_table{:,["SFICMRO205MinPostROSC",...
    "SFICMRO208MinPostROSC","SFICMRO21MinPostROSC","SFICMRO22MinPostROSC",...
    "SFICMRO23MinPostROSC"]};%adding CBF/CMRO2 in model
SFICMRO2_array = SFICMRO2_mat(:);

figure(104)
hold on
scatter3(T,Y,Z1,'blue','filled')
scatter3(T,Y,Z2,'red','filled')
hold off
grid on
legend('CA1','CA3')
xlabel('Time(min)');
ylabel('CMRO2(unit)');
zlabel('Damaged Cells 2-hr postROSC (%)');
title('Raw 3D Plot');
set(gca,'fontsize',14)
set(gcf,'color','w')


%% single model fit
% Perform GLM regression with log link function
% We use 'glmfit' function with 'link', 'log' for the log link function
[b1,dev1,stats1] = glmfit(X_matrix(:, 2:end), Z1, 'poisson', 'link', 'log');
[b2,dev2,stats2] = glmfit(X_matrix(:, 2:end), Z2, 'poisson', 'link', 'log');

% Define the fitted surface using the GLM coefficients
fitted_surface_ca1 = @(X, Y) b1(1) + b1(2)*X + b1(3)*Y + b1(4)*X.*Y;
fitted_surface_ca3 = @(X, Y) b2(1) + b2(2)*X + b2(3)*Y + b2(4)*X.*Y;

% Create formulas for the surfaces
formula_str1 = sprintf('$$z = %.3f + %.3f x + %.3f y + %.3f x*y$$', ...
                      b1(1), b1(2), b1(3), b1(4));
formula_str2 = sprintf('$$z = %.3f + %.3f x + %.3f y + %.3f x*y$$', ...
                      b2(1), b2(2), b2(3), b2(4));

% Generate meshgrid for plotting the fitted surface
[xGrid, yGrid] = meshgrid(linspace(min(T)-0.1, max(T)+0.1,1000),...
    linspace(min(Y)-0.1, max(Y)+0.1),1000);
%%
% Compute the fitted Z values on the grid (using exp because of log link)
zFitted_ca1 = exp(fitted_surface_ca1(xGrid, yGrid));
zFitted_ca3 = exp(fitted_surface_ca3(xGrid, yGrid));
% Compute the scaled Z-values for both datasets
z1 = zFitted_ca1 * 100;
z2 = zFitted_ca3 * 100;

% Determine the global minimum and maximum across both datasets
global_min = min([z1(:); z2(:)]);
%global_max = max([z1(:); z2(:)]);
global_max = max(z1(:));

% Define a function to create contour plots with consistent color scaling
function create_contour_plot(figure_number, xGrid, yGrid, zData, T, Y, ...
                             ylabel_text, plot_title, global_min, global_max)
    figure(figure_number);
    % Filled contour plot for the fitted surface
    contourf(xGrid, yGrid, zData, 50, 'LineColor', 'k'); % Black contour lines
    
    % Add colorbar to represent the Z-values
    cb = colorbar;
    ylabel(cb, ylabel_text, 'FontSize', 14); % Label for the colorbar
    
    % Set the color axis limits to the global min and max
    caxis([global_min global_max]);
    
    % Plot the original data points in 2D (scatter plot without z-axis)
    hold on;
    scatter(T, Y, 50, 'b', 'filled'); % 2D scatter plot for original data
    
    % Update the labels with better descriptions
    xlabel('Time for CMRO2 Measurement (Post-ROSC minutes)', 'FontSize', 14);
    ylabel('CMRO2 (μmol O\textsubscript{2}/100 g/min)', 'Interpreter', 'tex', 'FontSize', 14);
    title(plot_title, 'FontSize', 16);
    set(gca, 'FontSize', 14);
    set(gcf, 'Color', 'w');
    
    hold off;
    colormap(flipud(hot)); % You can adjust the colormap if needed
end

% Create the first contour plot for CA1
create_contour_plot(105, xGrid, yGrid, z1, T, Y, ...
                   'Damaged Cells 2-hr postROSC (%)', ...
                   'Fitted Polynomial Surface on CA1 (2D Contour Plot)', ...
                   global_min, global_max);

% Create the second contour plot for CA3
create_contour_plot(106, xGrid, yGrid, z2, T, Y, ...
                   'Damaged Cells 2-hr postROSC (%)', ...
                   'Fitted Polynomial Surface on CA3 (2D Contour Plot)', ...
                   global_min, global_max);
%%
% Create a 2D contour plot for CMRO2
figure(105);
% Filled contour plot for the fitted surface
contourf(xGrid, zFitted_ca1*100,yGrid,50,'LineColor', 'k'); % Black contour lines

% Add colorbar to represent the Z-values
cb = colorbar;
ylabel(cb, 'CMRO2 (μmol O2/100 g/min)', 'FontSize', 14); % Label for the colorbar


% Modify the legend to include new formula
% legend('Data', formula_str1, 'Interpreter', 'latex', ...
%     'Location', 'northoutside', 'Orientation', 'horizontal');

% Update the labels with better descriptions
xlabel('Time for CMRO2 Measurement (Post-ROSC minutes)');
ylabel('Damaged Cells 2-hr postROSC(%)');
title('Fitted Polynomial Surface on CA1 (2D Contour Plot)');
set(gca, 'fontsize', 14);
set(gcf, 'color', 'w');

% Hold off to complete the plot
hold off;
colormap(flipud(hot)); % You can adjust the colormap if needed


% Create a 2D contour plot
figure(106);
% Filled contour plot for the fitted surface
contourf(xGrid,zFitted_ca3*100,yGrid,  50,'LineColor', 'k'); % Black contour lines

% Add colorbar to represent the Z-values
cb = colorbar;
ylabel(cb, 'CMRO2 (μmol O2/100 g/min)', 'FontSize', 14); % Label for the colorbar

% Plot the original data points in 2D (scatter plot without z-axis)

% Modify the legend to include new formula
% legend('Data', formula_str2, 'Interpreter', 'latex', ...
%     'Location', 'northoutside', 'Orientation', 'horizontal');

% Update the labels with better descriptions
xlabel('Time for CMRO2 Measurement (Post-ROSC minutes)');
ylabel('Damaged Cells 2-hr postROSC(%)');
title('Fitted Polynomial Surface on CA3 (2D Contour Plot)');
set(gca, 'fontsize', 14);
set(gcf, 'color', 'w');

% Hold off to complete the plot
hold off;
colormap(flipud(hot)); % You can adjust the colormap if needed
%%
% Plot the original data points and the fitted surface
figure(105);
scatter3(T, Y, Z1*100, 'b', 'filled'); % Original scatter plot
hold on;
sc = surfc(xGrid, yGrid, zFitted_ca1*100,'EdgeColor','none');
sc(2).ZLocation = 'zmax';
sc(2).LineColor = 'k'
legend('Data', formula_str1, 'Interpreter', 'latex', ...
    'Location', 'northoutside', 'Orientation', 'horizontal');
xlabel('x = Time Collect CMRO2(min)');
ylabel('y = CMRO2(unit)');
zlabel('Damaged Cells 2-hr postROSC (%)');
title('Fitted Polynomial Surface on CA1');
set(gca, 'fontsize', 14);
set(gcf, 'color', 'w');
hold off;
colormap jet;

figure(106);
scatter3(T, Y, Z2*100, 'r', 'filled'); % Original scatter plot
hold on;
mesh(xGrid, yGrid, zFitted_ca3*100); % Fitted surface
legend('Data', formula_str2, 'Interpreter', 'latex', ...
    'Location', 'northoutside', 'Orientation', 'horizontal');
xlabel('x = Time Collect CMRO2(min)');
ylabel('y = CMRO2(unit)');
zlabel('Damaged Cells 2-hr postROSC (%)');
title('Fitted Polynomial Surface on CA3');
set(gca, 'fontsize', 14);
set(gcf, 'color', 'w');
hold off;
%% clustering
% combine CA1 and CA3 data

combined_cfos = [Z1;Z2];
combined_cmro2 = [Y;Y];
combined_time = [T;T];
combined_Mat = [combined_time,combined_cmro2,combined_cfos];

[idx_kmean_3d,C] = kmeans(combined_Mat,7);
idx_raw = [ones(45,1);ones(45,1)*2];
figure(107)
subplot(211)
gscatter(combined_cmro2,combined_cfos,idx_raw,'bgm')
legend('CA1','CA3')
subplot(212)
gscatter(combined_cmro2,combined_cfos,idx_kmean_3d)


%% GLM
% Using the Statistics and Machine Learning Toolbox
% Include an intercept in your model if necessary
mdl = fitglm(X_matrix, Z1, 'Distribution', 'gamma', 'Link', 'log');

% View model summary
disp(mdl);

[xGrid, yGrid] = meshgrid(linspace(min(T), max(T)), linspace(min(Y), max(Y)));
X_matrix = [ones(size(T)) T Y T.^2 Y.^2 T.*Y];


% Make predictions
Z1_pred = predict(mdl, expanded_X_matrix);

figure(109);
scatter3(T, Y, Z1*100, 'b','filled'); % Original scatter plot
hold on
scatter3(T, Y, Z1_pred*100, 'r','filled'); % Original scatter plot


