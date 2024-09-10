% Script to calculate average from WeissOpticalDataTransfer dataset
%% plot the overall 

figure;
hold on
Plot_range_mean(time_meta(1:3143),treatment_group(1:3143,:),'r')
Plot_range_mean(time_meta(1:3143),placebo_group(1:3143,:),'b')
hold off
title('CtHbO2')
xlabel('time(s)')
ylabel('Concentration?')
set(gca,'fontsize',15)
set(gcf,'color','white')
xlim([time_meta(1),time_meta(3143)])

%% Friedman’s test

p = friedman(treatment_group(1:3143,:),3)

%% Mann-Whitney U Test for Each Time Point
data_length = 3134;
p_vector = M_W_U_test_loop(treatment_group(1:data_length,:),placebo_group(1:data_length,:));

figure;plot(time_meta(1:data_length),p_vector,'LineWidth',1.5)
hold on
plot(time_meta(1:data_length),0.05*ones(data_length),'r--')
hold off
ylabel('p value')
xlabel('s')
title('Mann-Whitney U Test for Each Time Point')
set(gca,'fontsize',14)
set(gcf,'color','white')

%% merge plot
figure;
ax(1) = subplot(211)
hold on
Plot_range_mean(time_meta(1:3143),treatment_group(1:3143,:),'r')
Plot_range_mean(time_meta(1:3143),placebo_group(1:3143,:),'b')
hold off
title('CtHbO2')
xlabel('time(s)')
ylabel('Concentration?')
set(gca,'fontsize',15)
set(gcf,'color','white')
xlim([time_meta(1),time_meta(3143)])
ax(2) = subplot(212);
plot(time_meta(1:data_length),p_vector,'LineWidth',1.5)
hold on
plot(time_meta(1:data_length),0.05*ones(data_length),'r--')
hold off
ylabel('p value')
xlabel('s')
title('Mann-Whitney U Test for Each Time Point')
set(gca,'fontsize',14)
set(gcf,'color','white')
linkaxes(ax,'x')