%% Flux paper helicon, pressure plot
%load in the data

%cleanup

C_HP=load('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Shot Info\Shot18455_HeliconPower');
SS_HP=load('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Shot Info\Shot19787_HeliconPower');
SiC_HP=load('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Shot Info\Shot21450_HeliconPower');

C_Pressure=load('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Shot Info\Shot18455_Pressure');
SS_Pressure=load('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Shot Info\Shot19787_Pressure');
SiC_Pressure=load('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Shot Info\Shot21450_Pressure');

C_Alpha=load('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Shot Info\Shot18455_AlphaTrace');
SS_Alpha=load('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Shot Info\Shot19787_AlphaTrace');
SiC_Alpha=load('C:\Users\cxe\Documents\Papers\PSI 18 Paper\Shot Info\Shot21450_AlphaTrace');


%% Plots

figure;
%subplot(3,1,1) %helicon power
plot(C_HP(:,1),C_HP(:,2),'-k')
hold on
plot(SS_HP(:,1),SS_HP(:,2),'-m')
plot(SiC_HP(:,1),SiC_HP(:,2),'-c')
ylabel('Helicon Power [kW]','FontSize',15)
xlabel('Time [s]', 'FontSize', 15)
ylim([0 120])
xlim([4.0 4.7])
vline(4.25,'--k','Spectroscopy Frame')
legend('Graphite','SS','SiC')
hold off

%%
figure;
%subplot(3,1,2)
plot(C_Pressure(:,1),C_Pressure(:,2),'-k')
hold on
plot(SS_Pressure(:,1),SS_Pressure(:,2),'-m')
plot(SiC_Pressure(:,1),SiC_Pressure(:,2),'-c')
ylabel('Pressure at DLP [mTorr]','FontSize',15)
ylim([0 1.5])
xlim([4.0 4.7])
xticks([])
vline(4.25,'--k')
hold off

%%
figure
%subplot(3,1,3)
plot(C_Alpha(:,1),C_Alpha(:,2)/max(max(C_Alpha(:,2))),'-k')

% C_AlphaFit=smooth(C_Alpha(:,2),100,'sgolay');
% plot(C_Alpha(:,1),C_AlphaFit(:)/max(max(C_AlphaFit(:))),'-k')

hold on
plot(SS_Alpha(:,1),SS_Alpha(:,2)/max(max(SS_Alpha(:,2))),'-m')
plot(SiC_Alpha(:,1),SiC_Alpha(:,2)/max(max(SiC_Alpha(:,2))),'-c')

% SS_AlphaFit=smooth(SS_Alpha(:,2),100,'sgolay');
% plot(SS_Alpha(:,1),SS_AlphaFit(:)/max(max(SS_AlphaFit(:))),'-k')
% 
% SiC_AlphaFit=smooth(SiC_Alpha(:,2),100,'sgolay');
% plot(SiC_Alpha(:,1),SiC_AlphaFit(:)/max(max(SiC_AlphaFit(:))),'-k')

ylabel('Dalpha @ target [Ab. Units]','FontSize',15)
xlabel('Time [s]','FontSize',15)
ylim([0 1])
xlim([4.0 4.7])
vline(4.25,'--k')
hold off



