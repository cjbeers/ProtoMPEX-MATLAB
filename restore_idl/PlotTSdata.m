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

figure;
plot(IDL.R_TAR(:),IDL.TE_TAR(:,3),'black');
hold on
title('TS Target Profiles')
ylabel('T_e [eV]')
yyaxis right
plot(IDL.R_TAR(:),IDL.DEN_TAR(:,3)*1E19,'blue');
legend('T_e', 'n_e');
ylabel('n_e [m-3]')
xlabel('TS location [mm]')
hold off;