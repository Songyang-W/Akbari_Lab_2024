
load("cFos_data.mat")
addpath("DrosteEffect-BrewerMap-3.2.5.0/")
cFos_data_mat_knn_imputed = knnimpute([cFos_data_mat';ones(1,46)],2)';

%% Fig 3A
% assume rats performed same
%cFos_data_mat_knn_imputed = knnimpute(cFos_data_mat,3);

mean_matrix = [mean(cFos_data_mat_knn_imputed(control_ind,:));...
    mean(cFos_data_mat_knn_imputed(twohr_ind,:));...
    mean(cFos_data_mat_knn_imputed(fourhr_ind,:));...
    mean(cFos_data_mat_knn_imputed(twofour_ind,:));...
    mean(cFos_data_mat_knn_imputed(seventwo_ind,:))];

figure(111)
imagesc(mean_matrix)
colormap(brewermap([],'RdBu')) %colormap(jet) works fine too
c = colorbar;
ylabel(c, 'c-Fos %');  % Add your desired label here

xticks(1:12);  % Assuming 10 labels on the x-axis, adjust accordingly
xticklabels({'VMH', 'SC', 'PAG', 'PBN', 'mRt', 'IC', 'LC', 'DG', 'CPu', 'CA1', 'CA3', 'CeA'});
yticks(1:5);  % Assuming 5 time points, adjust accordingly
yticklabels({'0', '2', '4', '24', '72'}); % Time points in hours

xlabel('Brain Regions');
ylabel('Post-CA Time (hours)');
set(gca, 'TickLength', [0 0]); % Remove tick marks for clean formatting
set(gca, 'LineWidth', 1.5);    % Thicker axis lines
set(gca, 'FontSize', 14);      % Set font size
set(gca, 'FontWeight', 'bold'); % Make axis labels bold
set(gca,'fontsize',15,'Box','off')
set(gcf,'color','w')
%% Fig 3B -- question: why flip scatter axis
[nmfFeature_0hr,H] = nnmf(cFos_data_mat_knn_imputed(control_ind,:),2);
[nmfFeature_2hr,H] = nnmf(cFos_data_mat_knn_imputed(twohr_ind,:),2);
[nmfFeature_4hr,H] = nnmf(cFos_data_mat_knn_imputed(fourhr_ind,:),2);
[nmfFeature_24hr,H] = nnmf(cFos_data_mat_knn_imputed(twofour_ind,:),2);
[nmfFeature_72hr,H] = nnmf(cFos_data_mat_knn_imputed(seventwo_ind,:),2);
figure(112)
hold on
scatter(nmfFeature_0hr(:,1),nmfFeature_0hr(:,2),'filled')
scatter(nmfFeature_2hr(:,1),nmfFeature_2hr(:,2),'filled')
scatter(nmfFeature_4hr(:,1),nmfFeature_4hr(:,2),'filled')
scatter(nmfFeature_24hr(:,1),nmfFeature_24hr(:,2),'filled')
scatter(nmfFeature_72hr(:,1),nmfFeature_72hr(:,2),'filled')
legend('0 hr','2','4','24','72')
xlabel('nmfFeature 1')
ylabel('nmfFeature 2')

hold off
set(gca,'fontsize',15,'Box','off')
set(gcf,'color','w')

%% Fig 3c
figure(113)
[nmfFeature_all,H] = nnmf(cFos_data_mat_knn_imputed,2);
imagesc(H)
colormap(brewermap([],'RdBu')) %colormap(jet) works fine too
c = colorbar;
xticks(1:12);  % Assuming 10 labels on the x-axis, adjust accordingly
xticklabels({'VMH', 'SC', 'PAG', 'PBN', 'mRt', 'IC', 'LC', 'DG', 'CPu', 'CA1', 'CA3', 'CeA'});
yticks(1:2);  % Assuming 5 time points, adjust accordingly
yticklabels({'1','2'}); % Time points in hours

%% Fig 4 

% chatgpt version:

% Define parameters
alpha = 1.0;
sigma = 0.1;
tspan = [0, 1];
dt = 0.01;
n = round((tspan(2) - tspan(1)) / dt);
W = cumsum(sqrt(dt) * randn(1, n)); % Wiener process

% Initial condition
w0 = 0;
w = zeros(1, n);
w(1) = w0;

% Euler-Maruyama method
for i = 2:n
    drift = -alpha * w(i-1);
    diffusion = sigma;
    w(i) = w(i-1) + drift * dt + diffusion * (W(i) - W(i-1));
end

% Plot the solution
plot(linspace(tspan(1), tspan(2), n), w);
title('Solution to the SDE in MATLAB');
xlabel('Time');
ylabel('w(t)');