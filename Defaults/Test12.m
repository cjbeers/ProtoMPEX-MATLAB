%% Helicon Antenna Overlay
cleanup

datahelicon=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HeliconAntenna.xlsx');

%dataplot=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle9.xlsx');  
%dataplot=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Inputs\Beers_Inputs\ModelPaperDensity\Beers_Helicon_3D_ModelPaperDensity_SheathCenter_NonMag10.xlsx');
%dataplot=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Inputs\Beers_Inputs\LowerPowerCase\Beers_Helicon_3D_LowerPower_SheathCenter_Mag8.xlsx');
dataplot=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Inputs\Beers_Inputs\HigherDensity\Beers_Helicon_3D_HigherDensity_SheathCenter_NonMag5.xlsx');
%dataplot=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Inputs\Beers_Inputs\HigherTe\Beers_Helicon_3D_HighDensityHighTe_SheathCenter_Mag2.xlsx');


%% Plot of antenna 

pointsize=10;
ColumnOfInterests=22; % 22 is the normE, 27 is the Sheath Voltage

figure;
scatter(datahelicon(8:end,3),datahelicon(8:end,5),pointsize,datahelicon(8:end,ColumnOfInterests),'filled');
cmap=colorbar;
ylabel(cmap,'Voltage across sheath layer [V]')
title('Helicon Antenna Geometry');
xlabel('Window Z [m]');
ylabel('Angle along window [deg.]');
ylim([0 360]);
set(gcf,'color','w')
ax = gca;
ax.FontSize = 13;

%% Make mask for data

mask=datahelicon(8:end,ColumnOfInterests)>0;
mask=double(mask);
Setvoltage=250;

for ii=1:length(mask)
    
    if mask(ii)==0
        voltage(ii,1)=Setvoltage;
    elseif mask(ii)==1
        voltage(ii,1)=0;
    else
        disp('errror')
    end    
    
end


%% Plot with mask

figure;

scatter(datahelicon(8:end,3),datahelicon(8:end,5),pointsize,dataplot(8:end,ColumnOfInterests),'filled');
hold on
scatter(datahelicon(8:end,3),datahelicon(8:end,5),pointsize,(max(dataplot(8:end,ColumnOfInterests))*mask),'MarkerFaceAlpha',0.1,'MarkerEdgeAlpha',0.1);
cmap=colorbar;
ylabel(cmap,'Electric field [V/m]')
%title('High Density Higher Te Unmagnetized Case');
title('High Density Higher Te Magnetized Case');
%title('High Density Higher Te Initial Case');
xlabel('Window Z [m]');
ylabel('Angle along window [deg.]');
ylim([0 360]);
set(gcf,'color','w')
ax = gca;
ax.FontSize = 13;
hold off    

%% 

efieldx=dataplot(8:end,10)+sqrt(-1).*dataplot(8:end,11);
efieldy=dataplot(8:end,12)+sqrt(-1).*dataplot(8:end,13);

efield=abs(real(sqrt(efieldx.^2+efieldy.^2)));
efield=dataplot(8:end,22);

%%

SheathVoltage=efield*0.005;
figure;
scatter(datahelicon(8:end,3),datahelicon(8:end,5),pointsize,dataplot(8:end,27),'filled');
hold on
scatter(datahelicon(8:end,3),datahelicon(8:end,5),pointsize,(max(dataplot(8:end,27))*mask),'MarkerFaceAlpha',0.1,'MarkerEdgeAlpha',0.1);
%scatter(datahelicon(8:end,3),datahelicon(8:end,5),pointsize,dataplot(8:end,27));
%hold on
%scatter(datahelicon(8:end,3),datahelicon(8:end,5),pointsize,(max(dataplot(8:end,27))*mask),'MarkerFaceAlpha',0.1,'MarkerEdgeAlpha',0.1);
cmap=colorbar;
ylabel(cmap,'Sheath Potential [V]')
%title('High Density Higher Te Unmagnetized Case');
%title('High Density Higher Te Magnetized Case');
%title('High Density Higher Te Initial Case');
title('Unmagnetized Case');
%xlabel('Window Z [m]');
xlabel('Window Z [m]');
ylabel('Angle along window [deg.]');
ylim([0 360]);
set(gcf,'color','w')
ax = gca;
ax.FontSize = 13;

%% Line out




