%Uses restore_idl to read in a .sav file from IDL and analyzes the TS data
%Written by Josh Beers @ ONRL

cleanup

%% Select file when prompted to input .sav file
%Creates IDL file to manipulate data
restore_idl;
IDL=ans.OUT;

%% Plotting

figure;
plot(IDL.R_TAR(:),IDL.TE_TAR(:,1),'red');
hold on;
plot(IDL.R_TAR(:),IDL.TE_TAR(:,2),'blue');
hold on;
plot(IDL.R_TAR(:),IDL.TE_TAR(:,3),'black');
legend('Second Time Trace', 'Third Time Trace');
title(['TS Target Profile'])
ylabel('Te [eV]')
xlabel('TS location [mm]')
hold off;

figure
plot(IDL.R_TAR(:),IDL.DEN_TAR(:,1),'red');
hold on;
plot(IDL.R_TAR(:),IDL.DEN_TAR(:,2),'blue');
hold on;
plot(IDL.R_TAR(:),IDL.DEN_TAR(:,3),'black');
legend('Second Time Trace', 'Third Time Trace');
title(['TS Target Profile'])
ylabel('ne [m-3]')
xlabel('TS location [mm]')
hold off;


%% Plots single ne and Te

fig=figure;
left_color = [0 0 0];
right_color = [1 0 1];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);
yyaxis left
scatter(4,IDL.TE_TAR(3,3),'ko','LineWidth',3);
hold on
errorbar(30,2.012,0.1107,'d','MarkerSize',5)
errorbar(0,1.497,0.06233,'x','MarkerSize',7)
ylim([0 5]);
xlim([-1 35]);
xlabel('Distance from Target [cm]','fontsize',15)
ylabel('T_e [eV]','fontsize',15)

yyaxis right
scatter(4,(IDL.DEN_TAR(3,3)*1E19),'mo','LineWidth',3);
errorbar(30,4.27E19,7.51E17,'d','MarkerSize',4)
errorbar(0,3.23E19,8.72E17,'x','MarkerSize',4)
legend('Thomson T_e','DLP T_e','Target T_e','Thomson n_e','DLP n_e','Target n_e','Location','north');
ylabel('n_e [m^{-3}]','fontsize',15)

ylim([0 8E19]);

hold off;

Plot()