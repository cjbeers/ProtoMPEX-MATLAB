%% Plots Ion Flux Values from 8/2/17
%Coded by Josh Beers @ ORNL

%% Load in data

HeliconPower=load('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2017_08_02\Shot15951_HeliconPower');
% Run DLP_v5 for Shot 19543


%% Plot

figure;
subplot(4,1,1); hold on
plot(HeliconPower(:,1), (HeliconPower(:,2)))
ax = gca;
ax.FontSize = 13;

%xlabel('Time [s]', 'FontSize', 13);
ylabel('Helicon Power[kW]', 'FontSize', 13);
xlim([4.2 4.3]);
ylim([90 110]);
xtic=([]);

subplot(4,1,2)
plot(time{1,1}(1,:),Ni{1,1}(1,:))
ax = gca;
ax.FontSize = 13;
ylabel('N_e [m^{-2}s^{-1} ]', 'FontSize', 13);
xlim([4.2 4.3]);
%ylim([0 inf]);
xtick=([]);













