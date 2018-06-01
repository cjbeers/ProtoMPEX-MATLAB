%% Plots Beta/Alpha and Gamma/Alpha data for C, SS, and SiC targets
%Coded by Josh Beers @ ORNL

%% Load in data

load('BalmerRatios.mat')

%% Plot Data

fig=figure;
semilogy(Ctarget_time,Ctarget_Hba(5,:),'k')
hold on;
semilogy(Ctarget_time,Ctarget_Hba(3,:),'g')
semilogy(Ctarget_time,Ctarget_Hba(1,:),'m')
xlim([4 4.35])
ylim([1E-2 1]);
ylabel('H_{beta} to H_{alpha} Ratio')
xlabel('Time [s]')
legend('10.5','11.5 Center', '11.75 Center','Location','north');

%%
fig=figure;
semilogy(Ctarget_time,Ctarget_Hga(5,:),'k')
hold on;
semilogy(Ctarget_time,Ctarget_Hga(3,:),'g')
semilogy(Ctarget_time,Ctarget_Hga(1,:),'m')
xlim([4 4.35])
ylim([1E-2 0.1]);
ylabel('H_{gamma} to H_{alpha} Ratio')
xlabel('Time [s]')
legend('10.5','11.5 Center', '11.75 Center','Location','north');
