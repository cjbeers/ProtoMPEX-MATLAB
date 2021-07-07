%% DRGA plotting data for Proto-MPEX
%Coded by Josh Beers
%For ONRL use only

%% Initialize Code

filepath='\\mpexserver\ProtoMPEX_Data\DRGA\2021_01_20\';
filename1='RGA background-trend.csv';
filename2='Proto background-trend.csv';
filename3='Proto pressure gauge region-trend.csv';
filename4='Proto line to puffers-trend.csv';
filename5='Proto line to gas bottle-trend.csv';
filename6='Proto gas purge-trend.csv';

FileName1=[filepath filename1];
FileName2=[filepath filename2];
FileName3=[filepath filename3];
FileName4=[filepath filename4];
FileName5=[filepath filename5];
FileName6=[filepath filename6];

Colors=distinguishable_colors(6);

%% Make Data to Plot

DataTable=readtable(FileName5);

% Make data to plot
Time=datenum(DataTable{:,1}, 'dd-mmm-yyyy HH:MM');

Oxygen5=DataTable{:,20};


%% Plots

plot(1:length(Oxygen1),Oxygen1,'Color',Colors(1,:));
hold on
plot(1:length(Oxygen2),Oxygen2,'Color',Colors(2,:));
plot(1:length(Oxygen3),Oxygen3,'Color',Colors(3,:));
plot(1:length(Oxygen4),Oxygen4,'Color',Colors(4,:));
plot(1:length(Oxygen5),Oxygen5,'Color',Colors(5,:));
plot(1:length(Oxygen6),Oxygen6,'Color',Colors(6,:));
legend('DRGA background','Proto background','Proto Pressure Guage Location','Proto gauge to puffers','Proto gauge to gas line','Proto Post Gas Purge','Location','northeast')
%xlabel('Time [HH:MM]');
ylabel('Pressure [n/a]')
title('Oxygen DRGA measurements')
%ylim([0 0.5])
%datetick('x','HH:MM')   % give the a xaxis time label ticks..
set(gcf,'color','w')
set(gca,'fontsize',13)
hold off



