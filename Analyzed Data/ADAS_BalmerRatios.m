%Plots for Balmer series ratios
%Coded by Josh Beers @ ORNL
%Data in Janev

%% Load Data

cleanup

%Te1=open('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Hydrogen1.00.mat');
Te2=open('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Hydrogen2.00.mat');
Te3=open('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Hydrogen3.00.mat');
Te5=open('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Hydrogen5.00.mat');
Te7=open('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Hydrogen6.94.mat');
Te8=open('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Hydrogen8.00.mat');
%% Convert data into num

Te2.ne=str2num(Te2.ne);
Te2.Da=str2num(Te2.Da);
Te2.Db=str2num(Te2.Db);
Te2.Dg=str2num(Te2.Dg);
Te2.Dd=str2num(Te2.Dd);

Te2.Dba=Te2.Db/Te2.Da;
Te2.Dga=Te2.Dg/Te2.Da;
Te2.Dda=Te2.Dd/Te2.Da;

Te3.ne=str2num(Te3.ne);
Te3.Da=str2num(Te3.Da);
Te3.Db=str2num(Te3.Db);
Te3.Dg=str2num(Te3.Dg);
Te3.Dd=str2num(Te3.Dd);

Te3.Dba=Te3.Db/Te3.Da;
Te3.Dga=Te3.Dg/Te3.Da;
Te3.Dda=Te3.Dd/Te3.Da;

Te5.ne=str2num(Te5.ne);
Te5.Da=str2num(Te5.Da);
Te5.Db=str2num(Te5.Db);
Te5.Dg=str2num(Te5.Dg);
Te5.Dd=str2num(Te5.Dd);

Te5.Dba=Te5.Db/Te5.Da;
Te5.Dga=Te5.Dg/Te5.Da;
Te5.Dda=Te5.Dd/Te5.Da;

Te7.ne=str2num(Te7.ne);
Te7.Da=str2num(Te7.Da);
Te7.Db=str2num(Te7.Db);
Te7.Dg=str2num(Te7.Dg);
Te7.Dd=str2num(Te7.Dd);

Te7.Dba=Te7.Db/Te7.Da;
Te7.Dga=Te7.Dg/Te7.Da;
Te7.Dda=Te7.Dd/Te7.Da;

Te8.ne=str2num(Te8.ne);
Te8.Da=str2num(Te8.Da);
Te8.Db=str2num(Te8.Db);
Te8.Dg=str2num(Te8.Dg);
Te8.Dd=str2num(Te8.Dd);

Te8.Dba=Te8.Db/Te8.Da;
Te8.Dga=Te8.Dg/Te8.Da;
Te8.Dda=Te8.Dd/Te8.Da;

%% Plots

Te2plot=figure;
hold on;
h1=plot(Te3.ne,(Te3.Dba),'k');
h2=plot(Te5.ne,(Te5.Dga),'k--');
h3=plot(Te8.ne,(Te8.Dda),'k:');
ylim([10^-3 10^0])
xlim([1E18 1E20])
ylabel('Balmer Series Raio [Db/Da]')
xlabel('Electron density [m^{-2}]')
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
legend([h1(1) h2(1) h3(1)], 'Te= 3 eV', 'Te= 5 eV', 'Te= 8 eV')

hold off











