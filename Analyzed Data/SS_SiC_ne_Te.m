%% Plots of SS and SiC Thomson and DLP ne and Te

clear all

%% TS data from 5/1/18(SiC) and 2/14/18(SS)
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

TS_15_SS025_ne=4.90E19; %-1.5 cm for target %r=-0.25
TS_15_SS025_stdne=1.98E18;
TS_15_SS025_te=1.519;
TS_15_SS025_stdte=0.0789;
TS_15=1.5;

TS_15_SS05_ne=4.01E19;  %r=-0.5
TS_15_SS05_stdne=1.98e18;
TS_15_SS05_te=1.897;
TS_15_SS05_stdte=0.11;

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
h2=errorbar(TS_4,TS_4_SS025_te,TS_4_SS025_stdte,'x','MarkerSize',5);
h3=errorbar(TS_15,TS_15_SS025_te,TS_15_SS025_stdte,'x','MarkerSize',5);
%errorbar(DLP_4,DLP_4_SS_te,DLP_4_SS_stdte,'o','MarkerSize',5);
h4=errorbar(DLP_15,DLP_15_SS_te,DLP_15_SS_stdte,'o','MarkerSize',5);
ylim([0 5]);
xlim([-1 35]);
xlabel('Distance from Target [cm]','fontsize',15)
ylabel('T_e [eV]','fontsize',15)

yyaxis right
h5=errorbar(DLP_30,DLP_SS_ne,DLP_SS_stdne,'mo','MarkerSize',5);
h6=errorbar(TS_4,TS_4_SS025_ne,TS_4_SS025_stdne,'x','MarkerSize',5);
h7=errorbar(TS_15,TS_15_SS025_ne,TS_15_SS025_stdne,'x','MarkerSize',5);
%errorbar(DLP_4,DLP_4_SS_ne,DLP_4_SS_stdne,'o','MarkerSize',5);
h8=errorbar(DLP_15,DLP_15_SS_ne,DLP_15_SS_stdne,'o','MarkerSize',5);
legend([h1 h2 h5 h6],{'DLP T_e','Thomson T_e','DLP n_e','Thomson n_e'},'Location','north');
ylabel('n_e [m^{-3}]','fontsize',15)
ylim([0 8E19]);
%title('SS Target')

hold off;




