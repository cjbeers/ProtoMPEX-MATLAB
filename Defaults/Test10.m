%% Code for plotting convergence of COMSOL simulation data
%Read in data
cleanup

CaseL2=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle2.xlsx');
CaseL3=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle3.xlsx');
CaseL4=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle4.xlsx');
CaseL5=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle5.xlsx');
CaseL6=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle6.xlsx');
CaseL7=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle7.xlsx');

CaseLv2=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle2.xlsx');
CaseLv3=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle3_v2.xlsx');
CaseLv4=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle4_v2.xlsx');
CaseLv5=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle5_v2.xlsx');
CaseLv6=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle6_v2.xlsx');
CaseLv7=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_HeliconData_LayerMiddle7_v2.xlsx');

CaseH2=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle2.xlsx');
CaseH3=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle3.xlsx');
CaseH4=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle4.xlsx');
CaseH5=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle5.xlsx');
CaseH6=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle6.xlsx');
CaseH7=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle7.xlsx');

CaseHv2=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle2.xlsx');
CaseHv3=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle3_v2.xlsx');
CaseHv4=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle4_v2.xlsx');
CaseHv5=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle5_v2.xlsx');
CaseHv6=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle6_v2.xlsx');
CaseHv7=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle7_v2.xlsx');
CaseHv8=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle8_v2.xlsx');
CaseHv9=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle9_v2.xlsx');
CaseHv10=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle10_v2.xlsx');
CaseHv11=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_HeliconData_LayerMiddle11_v2.xlsx');
%% Get data

%low-density nonmag Case
DataLX(:,1)=CaseL2(33:100:end,3);
DataLY(:,1)=CaseL2(33:100:end,27);

DataLX(:,2)=CaseL3(33:100:end,3);
DataLY(:,2)=CaseL3(33:100:end,27);

DataLX(:,3)=CaseL4(33:100:end,3);
DataLY(:,3)=CaseL4(33:100:end,27);

DataLX(:,4)=CaseL5(33:100:end,3);
DataLY(:,4)=CaseL5(33:100:end,27);

DataLX(:,5)=CaseL6(33:100:end,3);
DataLY(:,5)=CaseL6(33:100:end,27);

DataLX(:,6)=CaseL7(33:100:end,3);
DataLY(:,6)=CaseL7(33:100:end,27);

%Low density mag

DataL2X(:,1)=CaseLv2(33:100:end,3);
DataL2Y(:,1)=CaseLv2(33:100:end,27);

DataL2X(:,2)=CaseLv3(33:100:end,3);
DataL2Y(:,2)=CaseLv3(33:100:end,27);

DataL2X(:,3)=CaseLv4(33:100:end,3);
DataL2Y(:,3)=CaseLv4(33:100:end,27);

DataL2X(:,4)=CaseLv5(33:100:end,3);
DataL2Y(:,4)=CaseLv5(33:100:end,27);

DataL2X(:,5)=CaseLv6(33:100:end,3);
DataL2Y(:,5)=CaseLv6(33:100:end,27);

DataL2X(:,6)=CaseLv7(33:100:end,3);
DataL2Y(:,6)=CaseLv7(33:100:end,27);

%High density nonmag
DataHX(:,1)=CaseH2(33:100:end,3);
DataHY(:,1)=CaseH2(33:100:end,27);

DataHX(:,2)=CaseH3(33:100:end,3);
DataHY(:,2)=CaseH3(33:100:end,27);

DataHX(:,3)=CaseH4(33:100:end,3);
DataHY(:,3)=CaseH4(33:100:end,27);

DataHX(:,4)=CaseH5(33:100:end,3);
DataHY(:,4)=CaseH5(33:100:end,27);

DataHX(:,5)=CaseH6(33:100:end,3);
DataHY(:,5)=CaseH6(33:100:end,27);

DataHX(:,6)=CaseH7(33:100:end,3);
DataHY(:,6)=CaseH7(33:100:end,27);

DataHX(:,1)=CaseH2(33:100:end,3);
DataHY(:,1)=CaseH2(33:100:end,27);

DataHX(:,2)=CaseH3(33:100:end,3);
DataHY(:,2)=CaseH3(33:100:end,27);

DataHX(:,3)=CaseH4(33:100:end,3);
DataHY(:,3)=CaseH4(33:100:end,27);

DataHX(:,4)=CaseH5(33:100:end,3);
DataHY(:,4)=CaseH5(33:100:end,27);

DataHX(:,5)=CaseH6(33:100:end,3);
DataHY(:,5)=CaseH6(33:100:end,27);

DataHX(:,6)=CaseH7(33:100:end,3);
DataHY(:,6)=CaseH7(33:100:end,27);

%high-density case magnetized
DataH2X(:,1)=CaseHv2(33:100:end,3);
DataH2Y(:,1)=CaseHv2(33:100:end,27);

DataH2X(:,2)=CaseHv3(33:100:end,3);
DataH2Y(:,2)=CaseHv3(33:100:end,27);

DataH2X(:,3)=CaseHv4(33:100:end,3);
DataH2Y(:,3)=CaseHv4(33:100:end,27);

DataH2X(:,4)=CaseHv5(33:100:end,3);
DataH2Y(:,4)=CaseHv5(33:100:end,27);

DataH2X(:,5)=CaseHv6(33:100:end,3);
DataH2Y(:,5)=CaseHv6(33:100:end,27);

DataH2X(:,6)=CaseHv7(33:100:end,3);
DataH2Y(:,6)=CaseHv7(33:100:end,27);

DataH2X(:,7)=CaseHv8(33:100:end,3);
DataH2Y(:,7)=CaseHv8(33:100:end,27);

DataH2X(:,8)=CaseHv9(33:100:end,3);
DataH2Y(:,8)=CaseHv9(33:100:end,27);

DataH2X(:,9)=CaseHv10(33:100:end,3);
DataH2Y(:,9)=CaseHv10(33:100:end,27);

DataH2X(:,10)=CaseHv11(33:100:end,3);
DataH2Y(:,10)=CaseHv11(33:100:end,27);

%% Get convergence data points
%1633 is under the antenna ring on the negative side(z=-.1015) at 90deg 
%(top of the antenna)

%Low density non Mag
DataCX=1:1:6;
DataCX=rot90(DataCX,3);
DataCY(1,:)=CaseL2(1633,27);
DataCY(2,:)=CaseL3(1633,27);
DataCY(3,:)=CaseL4(1633,27);
DataCY(4,:)=CaseL5(1633,27);
DataCY(5,:)=CaseL6(1633,27);
DataCY(6,:)=CaseL7(1633,27);

%Low density Mag
DataCX2=1:1:6;
DataCX2=rot90(DataCX2,3);
DataCY2(1,:)=CaseLv2(1633,27);
DataCY2(2,:)=CaseLv3(1633,27);
DataCY2(3,:)=CaseLv4(1633,27);
DataCY2(4,:)=CaseLv5(1633,27);
DataCY2(5,:)=CaseLv6(1633,27);
DataCY2(6,:)=CaseLv7(1633,27);

%High density non mag
DataCHX=1:1:6;
DataCHX=rot90(DataCHX,3);
DataCHY(1,:)=CaseH2(1633,27);
DataCHY(2,:)=CaseH3(1633,27);
DataCHY(3,:)=CaseH4(1633,27);
DataCHY(4,:)=CaseH5(1633,27);
DataCHY(5,:)=CaseH6(1633,27);
DataCHY(6,:)=CaseH7(1633,27);

%High density mag
DataCHX2=1:1:10;
DataCHX2=rot90(DataCHX2,3);
DataCHY2(1,:)=CaseHv2(1633,27);
DataCHY2(2,:)=CaseHv3(1633,27);
DataCHY2(3,:)=CaseHv4(1633,27);
DataCHY2(4,:)=CaseHv5(1633,27);
DataCHY2(5,:)=CaseHv6(1633,27);
DataCHY2(6,:)=CaseHv7(1633,27);
DataCHY2(7,:)=CaseHv8(1633,27);
DataCHY2(8,:)=CaseHv9(1633,27);
DataCHY2(9,:)=CaseHv10(1633,27);
DataCHY2(10,:)=CaseHv11(1633,27);


%---------------
%high density nonmag %maximum voltage on the whole window
DataCHX3=1:1:6;
DataCHX3=rot90(DataCHX3,3);
DataCHY3(1,:)=max(CaseH2(:,27));
DataCHY3(2,:)=max(CaseH3(:,27));
DataCHY3(3,:)=max(CaseH4(:,27));
DataCHY3(4,:)=max(CaseH5(:,27));
DataCHY3(5,:)=max(CaseH6(:,27));
DataCHY3(6,:)=max(CaseH7(:,27));


%High density mag %maximum voltage on the whole window
DataCHX4=1:1:10;
DataCHX4=rot90(DataCHX4,3);
DataCHY4(1,:)=max(CaseHv2(:,27));
DataCHY4(2,:)=max(CaseHv3(:,27));
DataCHY4(3,:)=max(CaseHv4(:,27));
DataCHY4(4,:)=max(CaseHv5(:,27));
DataCHY4(5,:)=max(CaseHv6(:,27));
DataCHY4(6,:)=max(CaseHv7(:,27));
DataCHY4(7,:)=max(CaseHv8(:,27));
DataCHY4(8,:)=max(CaseHv9(:,27));
DataCHY4(9,:)=max(CaseHv10(:,27));
DataCHY4(10,:)=max(CaseHv11(:,27));


%% Plot data

Colors=distinguishable_colors(size(DataH2X,2));

%Low density mag

figure
subplot(2,1,1);
plot(DataLX(:,1),DataLY(:,1),'Color',[Colors(1,1) Colors(1,2) Colors(1,3)])
hold on
plot(DataLX(:,2),DataLY(:,2),'Color',[Colors(2,1) Colors(2,2) Colors(2,3)])
plot(DataLX(:,3),DataLY(:,3),'Color',[Colors(3,1) Colors(3,2) Colors(3,3)])
plot(DataLX(:,4),DataLY(:,4),'Color',[Colors(4,1) Colors(4,2) Colors(4,3)])
plot(DataLX(:,5),DataLY(:,5),'Color',[Colors(5,1) Colors(5,2) Colors(5,3)])
plot(DataLX(:,6),DataLY(:,6),'Color',[Colors(6,1) Colors(6,2) Colors(6,3)])
title('Unmagnetized case, theta=90deg')
xlabel('Z [m]')
ylabel('Sheath potential [V]')
set(gcf,'color','w')
legend('Run1','Run2','Run3','Run4','Run5','Run6')
ax = gca;
ax.FontSize = 13;
set(gcf,'color','w')
hold off

subplot(2,1,2);
plot(DataL2X(:,1),DataL2Y(:,1),'Color',[Colors(1,1) Colors(1,2) Colors(1,3)])
hold on
plot(DataL2X(:,2),DataL2Y(:,2),'Color',[Colors(2,1) Colors(2,2) Colors(2,3)])
plot(DataL2X(:,3),DataL2Y(:,3),'Color',[Colors(3,1) Colors(3,2) Colors(3,3)])
plot(DataL2X(:,4),DataL2Y(:,4),'Color',[Colors(4,1) Colors(4,2) Colors(4,3)])
plot(DataL2X(:,5),DataL2Y(:,5),'Color',[Colors(5,1) Colors(5,2) Colors(5,3)])
plot(DataL2X(:,6),DataL2Y(:,6),'Color',[Colors(6,1) Colors(6,2) Colors(6,3)])
title('Magnetized case, theta=90deg')
xlabel('Z [m]')
ylabel('Sheath potential [V]')
set(gcf,'color','w')
legend('Run1','Run2','Run3','Run4','Run5','Run6')
ax = gca;
ax.FontSize = 13;
set(gcf,'color','w')
hold off
%--------------------------

%high density non mag
figure
subplot(2,1,1);
plot(DataLX(:,1),DataHY(:,1),'Color',[Colors(1,1) Colors(1,2) Colors(1,3)])
hold on
plot(DataLX(:,2),DataHY(:,2),'Color',[Colors(2,1) Colors(2,2) Colors(2,3)])
plot(DataLX(:,3),DataHY(:,3),'Color',[Colors(3,1) Colors(3,2) Colors(3,3)])
plot(DataLX(:,4),DataHY(:,4),'Color',[Colors(4,1) Colors(4,2) Colors(4,3)])
plot(DataLX(:,5),DataHY(:,5),'Color',[Colors(5,1) Colors(5,2) Colors(5,3)])
plot(DataLX(:,6),DataHY(:,6),'Color',[Colors(6,1) Colors(6,2) Colors(6,3)])
title('Unmagnetized case, theta=90deg')
xlabel('Z [m]')
ylabel('Sheath Potential [V]')
set(gcf,'color','w')
legend('Run1','Run2','Run3','Run4','Run5','Run6')
ax = gca;
ax.FontSize = 13;
set(gcf,'color','w')
hold off

%High density mag
subplot(2,1,2);
plot(DataH2X(:,1),DataH2Y(:,1),'Color',[Colors(1,1) Colors(1,2) Colors(1,3)])
hold on
plot(DataH2X(:,2),DataH2Y(:,2),'Color',[Colors(2,1) Colors(2,2) Colors(2,3)])
plot(DataH2X(:,3),DataH2Y(:,3),'Color',[Colors(3,1) Colors(3,2) Colors(3,3)])
plot(DataH2X(:,4),DataH2Y(:,4),'Color',[Colors(4,1) Colors(4,2) Colors(4,3)])
plot(DataH2X(:,5),DataH2Y(:,5),'Color',[Colors(5,1) Colors(5,2) Colors(5,3)])
plot(DataH2X(:,6),DataH2Y(:,6),'Color',[Colors(6,1) Colors(6,2) Colors(6,3)])
plot(DataH2X(:,7),DataH2Y(:,7),'Color',[Colors(7,1) Colors(7,2) Colors(7,3)])
plot(DataH2X(:,8),DataH2Y(:,8),'Color',[Colors(8,1) Colors(8,2) Colors(8,3)])
plot(DataH2X(:,9),DataH2Y(:,9),'Color',[Colors(9,1) Colors(9,2) Colors(9,3)])
plot(DataH2X(:,10),DataH2Y(:,10),'Color',[Colors(10,1) Colors(10,2) Colors(10,3)])
title('Magnetized Case, theta=90deg')
xlabel('Z [m]')
ylabel('Sheath Potential [V]')
set(gcf,'color','w')
legend('Run1','Run2','Run3','Run4','Run5','Run6','Run7','Run8','Run9','Run10')
ax = gca;
ax.FontSize = 13;
set(gcf,'color','w')
hold off

%% Convergence plots

%low density nonmag plot
figure
plot(DataCX,log(DataCY),'--ok')
title('Low-density convergence for theta=90deg');
xlabel('Iteration #')
ylabel('Log(Vlayer) [V]')
ax = gca;
ax.FontSize = 13;
set(gcf,'color','w')

%high density nonmag plot
figure
plot(DataCHX,log(DataCHY),'--ok')
title('High-density convergence for theta=90deg');
xlabel('Iteration #')
ylabel('Log(Vlayer) [V]')
ax = gca;
ax.FontSize = 13;
set(gcf,'color','w')

%--------------

%low density mag plot
figure
plot(DataCX2,log(DataCY2),'--ok')
title('Low-density convergence for theta=90deg');
xlabel('Iteration #')
ylabel('Log(Vlayer) [V]')
ax = gca;
ax.FontSize = 13;
set(gcf,'color','w')

%high density mag plot
figure
plot(DataCHX2,log(DataCHY2),'--ok')
%title('High-density convergence for theta=90deg');
xlabel('Iteration #')
ylabel('Log(V_{layer}) [V]')
ax = gca;
ax.FontSize = 13;
set(gcf,'color','w')

%high density nonmag plot
figure
plot(DataCHX3,DataCHY3,'--ok')
%title('Sheath Maximum Voltage');
xlabel('Iteration #')
ylabel('V_{layer} [V]')
ax = gca;
ax.FontSize = 13;
set(gcf,'color','w')

%high density mag plot
figure
plot(DataCHX4,DataCHY4,'--ok')
title('Sheath Maximum Voltage');
xlabel('Iteration #')
ylabel('Vlayer [V]')
ax = gca;
ax.FontSize = 13;
set(gcf,'color','w')
