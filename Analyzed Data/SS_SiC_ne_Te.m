%% Plots of SS and SiC Thomson and DLP ne and Te

clear all

%% TS data from 5/1/18(SiC) and 2/14/18(SS) and 08/02/17 (C)
TS_275_SiC075_ne=1.04E19; %-2.75 cm for target %r=-0.75
TS_275_SiC075_stdne=8.93E17;
TS_275_SiC075_te=1.96;
TS_275_SiC075_stdte=0.311;
TS_275=2.75;

TS_275_SiC0_ne=2.21E19; %r=0
TS_275_SiC0_stdne=7.53E17;
TS_275_SiC0_te=2.057;
TS_275_SiC0_stdte=0.1305;

TS_4_SS025_ne=3.13E19; %-4 cm for target %r=-0.25
TS_4_SS025_stdne=1.26E18;
TS_4_SS025_te=1.716;
TS_4_SS025_stdte=0.103;
TS_4=4;

TS_4_SS05_ne=4.3719;  %r=-0.5
TS_4_SS05_stdne=9.87E17;
TS_4_SS05_te=1.94;
TS_4_SS05_stdte=0.06;

TS_15_SS025_ne=4.90E19; %-1.5 cm for target %r=+0.25
TS_15_SS025_stdne=1.98E18;
TS_15_SS025_te=1.519;
TS_15_SS025_stdte=0.0789;
TS_15=1.5;

TS_15_SS05_ne=4.01E19;  %r=-0.5
TS_15_SS05_stdne=1.98e18;
TS_15_SS05_te=1.897;
TS_15_SS05_stdte=0.11;

TS_4_C0_ne=4.109E19;
TS_4_C0_stdne=1.98e18;
TS_4_C0_te=1.8821;
TS_4_C0_stdte=0.11;

% C embedded flux probes 08/02/17

CFP_0_C0_ne=3.23E19;
CFP_0_C0_stdne=8.72E17;
CFP_0_C0_te=1.497;
CFP_0_C0_stdte=0.06233;

%% DLP data same XP as TS

DLP_SS_ne=6.90E19;
DLP_SS_stdne=2.83E18;
DLP_SS_te=2.726;
DLP_SS_stdte=0.4636;
DLP_30=30;

DLP_SiC_ne=2.90E19;
DLP_SiC_stdne=1.92E18;
DLP_SiC_te=4.396;
DLP_SiC_stdte=1.29;

%DLP Target Scan

DLP_4_SS_ne=7.21E19; %DLP at 11.5 with target -4 cm
DLP_4_SS_stdne=2.58E18;
DLP_4_SS_te=1.95;
DLP_4_SS_stdte=0.233;
DLP_4=4;


DLP_15_SS_ne=6.97E19; %DLP at 11.5 with target -1.5 cm
DLP_15_SS_stdne=2.61E18;
DLP_15_SS_te=1.87;
DLP_15_SS_stdte=0.3277;
DLP_15=1.5;

DLP_30_C_ne=4.27E19;
DLP_30_C_stdne=7.51E17;
DLP_30_C_te=2.012;
DLP_30_C_stdte=0.1107;

%% Flux data 

DLP_30_C_flux=5.1324E23;
DLP_30_C_flux_std=6.0202E22;
TS_4_C_flux=4.7720E23;
TS_4_C_flux_std=5.769E22;
FP_0_C_flux=3.3488E23;
FP_0_C_flux_std=3.3526E22;

Flux_C_x(1,1)=0;
Flux_C_x(1,2)=4;
Flux_C_x(1,3)=30;
Flux_C_y(1,1)=FP_0_C_flux;
Flux_C_y(1,2)=TS_4_C_flux;
Flux_C_y(1,3)=DLP_30_C_flux;
Flux_C_err(1,1)=FP_0_C_flux_std;
Flux_C_err(1,2)=TS_4_C_flux_std;
Flux_C_err(1,3)=DLP_30_C_flux_std;

DLP_30_SS_flux=9.657E23;
DLP_30_SS_flux_std=1.9908E23;
TS_15_SS_flux=5.1175E23;
TS_15_SS_flux_std=5.4935E22;

Flux_SS_x(1,1)=1.5;
Flux_SS_x(1,2)=30;
Flux_SS_y(1,1)=TS_15_SS_flux;
Flux_SS_y(1,2)=DLP_30_SS_flux;
Flux_SS_err(1,1)=TS_15_SS_flux_std;
Flux_SS_err(1,2)=DLP_30_SS_flux_std;

DLP_30_SiC_flux=5.1524E23;
DLP_30_SiC_flux_std=1.3957E23;
TS_15_SiC_flux=2.6859E23;
TS_15_SiC_flux_std=3.830E22;

Flux_SiC_x(1,1)=1.5;
Flux_SiC_x(1,2)=30;
Flux_SiC_y(1,1)=TS_15_SiC_flux;
Flux_SiC_y(1,2)=DLP_30_SiC_flux;
Flux_SiC_err(1,1)=TS_15_SiC_flux_std;
Flux_SiC_err(1,2)=DLP_30_SiC_flux_std;

%% Plots

%SiC

fig=figure;
left_color = [0 0 0];
right_color = [1 0 1];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);
yyaxis left
errorbar(DLP_30,DLP_SiC_te,DLP_SiC_stdte,'ko','MarkerSize',5);
hold on
errorbar(TS_275,TS_275_SiC0_te,TS_275_SiC0_stdte,'x','MarkerSize',5)
ylim([0 5]);
xlim([-1 35]);
xlabel('Distance from Target [cm]','fontsize',15)
ylabel('T_e [eV]','fontsize',15)

yyaxis right
errorbar(DLP_30,DLP_SiC_ne,DLP_SiC_stdne,'mo','MarkerSize',5);
errorbar(TS_275,TS_275_SiC0_ne,TS_275_SiC0_stdne,'x','MarkerSize',5)
legend('DLP T_e','Thomson T_e','DLP n_e','Thomson n_e','Location','north');
ylabel('n_e [m^{-3}]','fontsize',15)
%title('SiC Target')

ylim([0 8E19]);

hold off;

%% SS plots

fig=figure;
left_color = [0 0 0];
right_color = [1 0 1];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);
yyaxis left
h1=errorbar(DLP_30,DLP_SS_te,DLP_SS_stdte,'ko','MarkerSize',5);
hold on
%h2=errorbar(TS_4,TS_4_SS025_te,TS_4_SS025_stdte,'x','MarkerSize',5);
h3=errorbar(TS_15,TS_15_SS025_te,TS_15_SS025_stdte,'x','MarkerSize',5);
%errorbar(DLP_4,DLP_4_SS_te,DLP_4_SS_stdte,'o','MarkerSize',5);
%h4=errorbar(DLP_15,DLP_15_SS_te,DLP_15_SS_stdte,'o','MarkerSize',5);
ylim([0 5]);
xlim([-1 35]);
xlabel('Distance from Target [cm]','fontsize',15)
ylabel('T_e [eV]','fontsize',15)

yyaxis right
h5=errorbar(DLP_30,DLP_SS_ne,DLP_SS_stdne,'mo','MarkerSize',5);
%h6=errorbar(TS_4,TS_4_SS025_ne,TS_4_SS025_stdne,'x','MarkerSize',5);
h7=errorbar(TS_15,TS_15_SS025_ne,TS_15_SS025_stdne,'x','MarkerSize',5);
%errorbar(DLP_4,DLP_4_SS_ne,DLP_4_SS_stdne,'o','MarkerSize',5);
%h8=errorbar(DLP_15,DLP_15_SS_ne,DLP_15_SS_stdne,'o','MarkerSize',5);
legend([h1 h3 h5 h7],{'DLP T_e','Thomson T_e','DLP n_e','Thomson n_e'},'Location','north');
ylabel('n_e [m^{-3}]','fontsize',15)
ylim([0 8E19]);
%title('SS Target')

hold off;

%% Flux Plots 
% all data as points 
figure;
h1=errorbar(30,DLP_30_C_flux,DLP_30_C_flux_std,'ok');
hold on
h2=errorbar(4,TS_4_C_flux,TS_4_C_flux_std,'ok');
h3=errorbar(0,FP_0_C_flux,FP_0_C_flux_std,'ok');

h4=errorbar(30,DLP_30_SS_flux,DLP_30_SS_flux_std,'xm');
h5=errorbar(1.5,TS_15_SS_flux,TS_15_SS_flux_std,'xm');

h6=errorbar(30,DLP_30_SiC_flux,DLP_30_SiC_flux_std,'^c');
h7=errorbar(1.5,TS_15_SiC_flux,TS_15_SiC_flux_std,'^c');

ylim([1E23 10E23]);
xlim([-1 35]);
ylabel('Ion Flux [m^{-2}s^{-1}]','fontsize',15)
ylabel('Distance from target [cm]','fontsize',15)
legend([h1 h4 h6],'Graphite Target','SS Target','SiC Target')
hold off;

%%
%all data as lines
figure;
h1=errorbar(-Flux_C_x,Flux_C_y,Flux_C_err,'-ok');
hold on
h2=errorbar(-Flux_SS_x,Flux_SS_y,Flux_SS_err,'-xm');
h3=errorbar(-Flux_SiC_x,Flux_SiC_y,Flux_SiC_err,'-^c');
h4=errorbar(0,5E23,2.5E23,'-sr');
xlim([-35 1]);
ylim([1E23 10E23]);
ylabel('Ion Flux [m^{-2}s^{-1}]','fontsize',15)
xlabel('Distance from target [cm]','fontsize',15)
legend([h1 h2 h3 h4],'Graphite Target','SS Target','SiC Target','Graphite Flux Probe')
hold off;

%% Plots ne only

figure;
h1=errorbar([-DLP_30 -4 0],[DLP_30_C_ne TS_4_C0_ne CFP_0_C0_ne],[DLP_30_C_stdne TS_4_C0_stdne CFP_0_C0_stdne], '-ko');
hold on
h2=errorbar([-DLP_30 -1.5],[DLP_SS_ne TS_15_SS025_ne],[DLP_SS_stdne TS_15_SS025_stdne],'-mx');
h3=errorbar([-DLP_30 -2.75],[DLP_SiC_ne TS_275_SiC0_ne],[DLP_SiC_stdne TS_275_SiC0_stdne],'-c^');
ylim([1E19 10E19]);
xlim([-31 1]);
xlabel('Distance from Target [cm]','fontsize',15)
ylabel('n_e [m^{-3}]','fontsize',15)
legend([h1 h2 h3],'Graphite Target','SS Target','SiC Target')
hold off

%% Plots Te only

figure;
h1=errorbar([-DLP_30 -4 0],[DLP_30_C_te TS_4_C0_te CFP_0_C0_te],[DLP_30_C_stdte TS_4_C0_stdte CFP_0_C0_stdte], '-ko');
hold on
h2=errorbar([-DLP_30 -1.5],[DLP_SS_te TS_15_SS025_te],[DLP_SS_stdte TS_15_SS025_stdte],'-mx');
h3=errorbar([-DLP_30 -2.75],[DLP_SiC_te TS_275_SiC0_te],[DLP_SiC_stdte TS_275_SiC0_stdte],'-c^');
ylim([0 5]);
xlim([-31 1]);
xlabel('Distance from Target [cm]','fontsize',15)
ylabel('T_e [eV]','fontsize',15)
legend([h1 h2 h3],'Graphite Target','SS Target','SiC Target')
hold off

