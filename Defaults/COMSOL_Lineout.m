%% Code for plotting line out of a given z location on the COMSOL sheath voltage
%Coded by Josh Beers for ORNL use only

% Code start
%Read in the data
cleanup

LD_Data{1,1}=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle1.xlsx');
LD_Data{1,2}=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle7.xlsx');
LD_Data{1,3}=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle7_v2.xlsx');

HD_Data{1,1}=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle0.xlsx');
HD_Data{1,2}=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle7.xlsx');
HD_Data{1,3}=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle11_v2.xlsx');

%% Set desired values

z=0.095;
ColumnOfInterest=27; % 22 is the normE, 27 is the Sheath Voltage

%% Setup data of interest

[D, IX]=min(abs(z-LD_Data{1,1}(8:end,3)));
znew=z+D;
zLoc=find(LD_Data{1,1}(:,3)==znew);


%% plot data

Colors=distinguishable_colors(size(LD_Data,2));

%Low density
figure
plot(LD_Data{1,1}(zLoc(1):zLoc(end),5),LD_Data{1,1}(zLoc(1):zLoc(end),ColumnOfInterest),'Color',[Colors(1,1) Colors(1,2) Colors(1,3)])
hold on
plot(LD_Data{1,2}(zLoc(1):zLoc(end),5),LD_Data{1,2}(zLoc(1):zLoc(end),ColumnOfInterest)*5,'Color',[Colors(2,1) Colors(2,2) Colors(2,3)])
plot(LD_Data{1,3}(zLoc(1):zLoc(end),5),LD_Data{1,3}(zLoc(1):zLoc(end),ColumnOfInterest),'Color',[Colors(3,1) Colors(3,2) Colors(3,3)])
title('Low Density Cases for z=0.0955');
xlabel('Angle [deg]');
ylabel('Sheath Voltage [V]');
xlim([0 360])
legend('Starting case','Unmangetized case final x5','Magnetized case final')
set(gcf,'color','w')
ax = gca;
ax.FontSize = 13;

%High density
figure
plot(HD_Data{1,1}(zLoc(1):zLoc(end),5),HD_Data{1,1}(zLoc(1):zLoc(end),ColumnOfInterest),'Color',[Colors(1,1) Colors(1,2) Colors(1,3)])
hold on
plot(HD_Data{1,2}(zLoc(1):zLoc(end),5),HD_Data{1,2}(zLoc(1):zLoc(end),ColumnOfInterest)*5,'Color',[Colors(2,1) Colors(2,2) Colors(2,3)])
plot(HD_Data{1,3}(zLoc(1):zLoc(end),5),HD_Data{1,3}(zLoc(1):zLoc(end),ColumnOfInterest),'Color',[Colors(3,1) Colors(3,2) Colors(3,3)])
title('High Density Cases for z=0.0955');
xlabel('Angle [deg]');
ylabel('Sheath Voltage [V]');
xlim([0 360])
legend('Starting case','Unmangetized case final x5','Magnetized case final')
set(gcf,'color','w')
ax = gca;
ax.FontSize = 13;
