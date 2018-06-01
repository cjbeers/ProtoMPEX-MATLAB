%% Plots Beta/Alpha and Gamma/Alpha data for C, SS, and SiC targets
%Coded by Josh Beers @ ORNL

%% Load in data

%load('BalmerRatios.mat')

%% Plot Data
%C Beta
fig=figure;
scatter(Ctarget_time,Ctarget_Hba(5,:),'k')
hold on;
%semilogy(Ctarget_time,Ctarget_Hba(3,:),'c')
scatter(Ctarget_time,Ctarget_Hba(1,:),'m')
set(gca,'yscale','log')
xlim([4.2 4.5])
ylim([1E-2 1]);
ylabel('H_{beta} to H_{alpha} Ratio')
xlabel('Time [s]')
legend('30 cm from target','4 cm from target','Location','north');
hold off;

%%
%C Gamma
fig=figure;
scatter(Ctarget_time,Ctarget_Hga(5,:),'k')
hold on;
%scatter(Ctarget_time,Ctarget_Hga(3,:),'g')
scatter(Ctarget_time,Ctarget_Hga(1,:),'m')
set(gca,'yscale','log')
xlim([4.2 4.5])
ylim([1E-2 0.1]);
ylabel('H_{gamma} to H_{alpha} Ratio')
xlabel('Time [s]')
legend('30 cm from target', '4 cm from target','Location','north');
hold off;

%%
%SS Beta
fig=figure;
%scatter(SStarget_time,SStarget_Hba(1,:),'k')
hold on;
scatter(SStarget_time,SStarget_Hba(2,:),'k')
scatter(SStarget_time,SStarget_Hba(5,:),'m')
set(gca,'yscale','log')
xlim([4.2 4.5])
ylim([1E-2 1]);
ylabel('H_{beta} to H_{alpha} Ratio')
xlabel('Time [s]')
%legend('60 cm from target','30 cm from target', '4 cm from target','Location','north');
legend('30 cm from target', '4 cm from target','Location','north');
hold off;

%%
%SS Gamma
fig=figure;
%scatter(SStarget_time,SStarget_Hga(1,:),'k')
hold on;
scatter(SStarget_time,SStarget_Hga(2,:),'k')
scatter(SStarget_time,SStarget_Hga(5,:),'m')
set(gca,'yscale','log')
xlim([4.2 4.5])
ylim([1E-2 0.1]);
ylabel('H_{gamma} to H_{alpha} Ratio')
xlabel('Time [s]')
legend('30 cm from target', '4 cm from target','Location','north');
hold off;

%%
%SiC Beta
fig=figure;
%scatter(SStarget_time,SStarget_Hba(1,:),'k')
hold on;
scatter(SiCtarget_time,SiCtarget_Hba(2,:),'k')
scatter(SiCtarget_time,SiCtarget_Hba(5,:),'m')
set(gca,'yscale','log')
xlim([4.2 4.5])
ylim([1E-2 1]);
ylabel('H_{beta} to H_{alpha} Ratio')
xlabel('Time [s]')
%legend('60 cm from target','30 cm from target', '4 cm from target','Location','north');
legend('30 cm from target', '4 cm from target','Location','north');
hold off;

%%
%SiC Gamma
fig=figure;
%scatter(SStarget_time,SStarget_Hga(1,:),'k')
hold on;
scatter(SiCtarget_time,SiCtarget_Hga(2,:),'k')
scatter(SiCtarget_time,SiCtarget_Hga(5,:),'m')
set(gca,'yscale','log')
xlim([4.2 4.5])
%ylim([1E-2 0.1]);
ylabel('H_{gamma} to H_{alpha} Ratio')
xlabel('Time [s]')
legend('30 cm from target', '4 cm from target','Location','north');
hold off;