
ccc

%% Measured Ion Temperature Plot
%With ICH

X=[0 0.80198 1.392657 1.91323 2.400575 2.717701 3.035021];
Y= [0.253652087  1.084530055 4.221198023 2.137862368 3.479385078 2.69254539 3.03885015];
err=[0.090091424  0.091156012 0.095853567 0.09125755 0.089138853	0.085565778	0.088420274];

figure;
hold on
errorbar(X,Y,err, 'bs', 'MarkerSize', 3)

ax = gca;
title('Proto-MPEX Measured T_i','FontSize',13);
xlabel('Distance from Dump Plate [m]','FontSize',13);
ylabel('T_i [eV]','FontSize',13);
xlim([0 3.5]);
ylim([0,10]);
hold off;    
Plot()   
%% Measured Ion Temperature Plot
%Data from Ralph, without ICH

X=[0 0.80198 1.392657 1.91323 2.400575 2.717701 3.035021];
Y= [2.5 7.5 5.5 9.5 9 2.0 3.0];

figure;
hold on
plot(X,Y, 'bs', 'MarkerSize', 3)

ax = gca;
title('Proto-MPEX Measured T_i','FontSize',13);
xlabel('Distance from Dump Plate [m]','FontSize',13);
ylabel('T_i [eV]','FontSize',13);
xlim([0 3.5]);
ylim([0,10]);
hold off;    
Plot()
%% Measured Ion Temperature Plot
%Data from Ralph, with ICH

X=[0.339979 0.80198 1.392657 2.400575 2.717701];
Y= [ 29.12 8.84 19.7 7.35 16];

X1=[0 0.80198 1.392657 2.400575 2.717701 3.035021];
Y1= [3.01 7.6 5.5 9.2 2.24 3.12];

X2=[1.39267];
Y2=[23.5];

figure;
hold on
plot(X,Y, 'bs', 'MarkerSize', 3)
plot(X1,Y1, 'ks', 'MarkerSize', 3)
plot(X2,Y2, 'ks', 'MarkerSize', 3)

ax = gca;
title('Proto-MPEX Measured T_i','FontSize',13);
xlabel('Distance from Dump Plate [m]','FontSize',13);
ylabel('T_i [eV]','FontSize',13);
legend('With ICH', 'Without ICH')
xlim([0 3.5]);
%ylim([0,10]);
hold off;    
Plot()     
%% 8/19 Te Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_08_19\2016_08_19_Te&Ne','Sheet1');

X=excel(3:16,2);
Y=excel(3:16,3);
err=excel(3:16,4);

figure;
hold on
errorbar(X,Y,err, 'bs', 'MarkerSize', 3)

ax = gca;
title('T_e','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('T_e [eV]','FontSize',13);
xlim([-2 2]);
ylim([0,10]);
hold off;    
Plot()    

%% 8/19 Ne Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_08_19\2016_08_19_Te&Ne','Sheet1');

X=excel(3:16,2);
Y=excel(3:16,5);
err=excel(3:16,6);

figure;
hold on
errorbar(X,Y,err, 'bs', 'MarkerSize', 3)

ax = gca;
title('n_e','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('n_e [1/m^{3}]','FontSize',13);
xlim([-2 2]);
ylim([0,5E19]);
hold off;    
Plot()    
%% 8/19 Flux Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_08_19\2016_08_19_Te&Ne','Sheet1');

X=excel(3:16,2);
Y=excel(3:16,7);
err=excel(3:16,8);

figure;
hold on
errorbar(X,Y,err, 'bs', 'MarkerSize', 3)

ax = gca;
title('Ion Flux','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('Flux [1/m^{2}s]','FontSize',13);
xlim([-2 2]);
ylim([0,3E23]);
hold off;    
Plot()    
%% 8/19 Q Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_08_19\2016_08_19_Te&Ne','Sheet1');
excel1=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_08_19\2016_08_19_Te&Ne','Sheet3');

X=excel(3:16,2);
Y=excel(3:16,9);

X1=excel1(1,:);
Y1=excel1(45,:);

figure;
hold on
plot(X, Y, '-s', 'MarkerSize', 3)
plot (X1, Y1, '-o', 'MarkerSize', 3)
ax = gca;
title('Power Flux','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel(' Power Flux [MW/m^{2}]','FontSize',13);
legend('Probe C DLP q', 'IR q');
xlim([-3 3]);
ylim([0,1]);
hold off;    
Plot()
%% 8/19 STC Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_08_19\2016_08_19_Te&Ne','Sheet1');

X=excel(3:16,2);
Y=excel(3:16,11);
err=excel(3:16,12);

Y1=excel(3:16,15);
err1=excel(3:16,16);

figure;
hold on
errorbar(X, Y,err, '-s', 'MarkerSize', 3)
errorbar(X, Y1,err1, '-o', 'MarkerSize', 3)
ax = gca;
title('Sheath Transmission Coefficient','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('Electron STC','FontSize',9);
legend('T_i=0', 'T_i=T_e');
xlim([-2 2]);
ylim([0,20]);
hold off;    
Plot()
%% 8/19 Ion Temp

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_08_19\2016_08_19_Te&Ne','Sheet1');

X=excel(3:11,2);
Y=excel(3:11,17);
err=excel(3:11,18);

figure;
hold on
errorbar(X,Y,err, 'bs', 'MarkerSize', 3)

ax = gca;
title('Calculated Ti','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('T_i [eV]','FontSize',13);
xlim([-2 2]);
ylim([0,40]);
hold off;    
Plot()
%% ========================================================================



%=========================================================================
%% 9/22-Horizontal Te Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','9.5');

X=excel(2:10,2);
Y=excel(2:10,3);
err=excel(2:10,4);

figure;
hold on
errorbar(X,Y,err, 'bs', 'MarkerSize', 3)

ax = gca;
title('T_e','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('T_e [eV]','FontSize',13);
xlim([-2 2]);
ylim([0,10]);
hold off;    
Plot()    
%% 9/22 Ne Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','9.5');

X=excel(2:10,2);
Y=excel(2:10,5);
err=excel(2:10,6);

figure;
hold on
errorbar(X,Y,err, 'bs', 'MarkerSize', 3)

ax = gca;
title('n_e','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('n_e [1/m^{3}]','FontSize',13);
xlim([-2 2]);
ylim([0,5E19]);
hold off;    
Plot()    
%% 9/22 Flux Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','9.5');

X=excel(2:10,2);
Y=excel(2:10,7);
err=excel(2:10,8);

figure;
hold on
errorbar(X,Y,err, 'bs', 'MarkerSize', 3)

ax = gca;
title('Ion Flux','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('Flux [1/m^{2}s]','FontSize',13);
xlim([-2 2]);
ylim([0,3E23]);
hold off;    
Plot()    
%% 9/22 Q Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','9.5');
excel1=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','Q');

X=excel(2:9,2);
Y=excel(2:9,18);

X1=excel1(1,:);
Y1=excel1(46,:);

figure;
hold on
plot(X, Y, '-s', 'MarkerSize', 3)
plot (X1, Y1, '-o', 'MarkerSize', 3)
ax = gca;
title('Power Flux','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel(' Power Flux [MW/m^{2}]','FontSize',13);
legend('Probe C DLP q', 'IR q');
xlim([-3 3]);
ylim([0,1]);
hold off;    
Plot()
%% 9/22 STC Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','9.5');

X=excel(2:10,2);
Y=excel(2:10,9);
err=excel(2:10,10);

Y1=excel(2:10,13);
err1=excel(2:10,14);

figure;
hold on
errorbar(X, Y,err, '-s', 'MarkerSize', 3)
errorbar(X, Y1,err1, '-o', 'MarkerSize', 3)
ax = gca;
title('Sheath Transmission Coefficient','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('Electron STC','FontSize',9);
legend('T_i=0', 'T_i=T_e');
xlim([-2 2]);
ylim([0,20]);
hold off;    
Plot()
%% 9/22 Ion Temp

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','9.5');

X=excel(2:10,2);
Y=excel(2:10,15);
err=excel(2:10,16);


figure;
hold on
errorbar(X,Y,err, 'bs', 'MarkerSize', 3)

ax = gca;
title('Calculated Ti','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('T_i [eV]','FontSize',13);
xlim([-2 2]);
ylim([0,40]);
hold off;    
Plot()
%% ========================================================================



%=========================================================================
%% 9/22-Vertical Te Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','10.5');

X=excel(1:14,2);
Y=excel(1:14,3);
err=excel(1:14,4);

figure;
hold on
errorbar(X,Y,err, 'bs', 'MarkerSize', 3)

ax = gca;
title('T_e','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('T_e [eV]','FontSize',13);
xlim([-2 2]);
ylim([0,10]);
hold off;    
Plot()    
%% 9/22 Ne Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','10.5');

X=excel(1:14,2);
Y=excel(1:14,5);
err=excel(1:14,6);

figure;
hold on
errorbar(X,Y,err, 'bs', 'MarkerSize', 3)

ax = gca;
title('n_e','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('n_e [1/m^{3}]','FontSize',13);
xlim([-2 2]);
ylim([0,5E19]);
hold off;    
Plot()    
%% 9/22 Flux Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','10.5');

X=excel(1:14,2);
Y=excel(1:14,7);
err=excel(1:14,8);

figure;
hold on
errorbar(X,Y,err, 'bs', 'MarkerSize', 3)

ax = gca;
title('Ion Flux','FontSize',13);
xlabel('Distance from  Center [cm]','FontSize',13);
ylabel('Flux [1/m^{2}s]','FontSize',13);
xlim([-2 2]);
ylim([0,3E23]);
hold off;    
Plot()    
%% 9/22 Q Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','10.5');
excel1=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','Q');

X=excel(2:14,2);
Y=excel(2:14,18);

X1=excel1(1,:);
Y1=excel1(46,:);

figure;
hold on
plot(X, Y, '-s', 'MarkerSize', 3)
plot (X1, Y1, '-o', 'MarkerSize', 3)
ax = gca;
title('Power Flux','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel(' Power Flux [MW/m^{2}]','FontSize',13);
legend('Probe B DLP q', 'IR q');
xlim([-3 3]);
ylim([0,1]);
hold off;    
Plot()
%% 9/22 STC Plot

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','10.5');

X=excel(1:14,2);
Y=excel(1:14,9);
err=excel(1:14,10);

Y1=excel(1:14,13);
err1=excel(1:14,14);

figure;
hold on
errorbar(X, Y,err, '-s', 'MarkerSize', 3)
errorbar(X, Y1,err1, '-o', 'MarkerSize', 3)
ax = gca;
title('Sheath Transmission Coefficient','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('Electron STC','FontSize',9);
legend('T_i=0', 'T_i=T_e');
xlim([-2 2]);
ylim([0,20]);
hold off;    
Plot()
%% 9/22 Ion Temp

excel=xlsread('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2016_09_22\2016_09_22_DLP_Sheath_IonFlux','10.5');

X=excel(2:14,2);
Y=excel(2:14,15);
err=excel(2:14,16);


figure;
hold on
errorbar(X,Y,err, 'bs', 'MarkerSize', 3)

ax = gca;
title('Calculated Ti','FontSize',13);
xlabel('Distance from Center [cm]','FontSize',13);
ylabel('T_i [eV]','FontSize',13);
xlim([-2 2]);
ylim([0,40]);
hold off;    
Plot()
%%
X=[170:10:320];
Y= [0.00829112
0.00792626
0.00808969
0.00937548
0.00948999
0.01056768
0.01184398
0.01239569
0.01270188
0.01279859
0.01281044
0.01282146
0.01277745
0.01275454
0.01275771
0.0125139
];

figure;
hold on
plot(X,Y, 'bs', 'MarkerSize', 3)

ax = gca;
title('FWHM During Shot','FontSize',13);
xlabel('Time During Shot [ms]','FontSize',13);
ylabel('FWHM ','FontSize',13);
xlim([170 320]);
ylim([0,0.015]);
hold off;    
Plot()