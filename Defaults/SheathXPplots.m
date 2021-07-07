%% read in data from 2/5/20 for the sheath XP plots

HelPower=load('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2020_02_05\HeliconPower.txt');
HelPressure=load('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2020_02_05\HeliconPressure.txt');
TargetPressure=load('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2020_02_05\TargetPressure.txt');
TargetDensity=load('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2020_02_05\TargetDensity.txt');
TargetTemperature=load('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2020_02_05\TargetTemperature.txt');


HelPressure(:,2)=HelPressure(:,2)*133;
TargetPressure(:,2)=TargetPressure(:,2)*133;

%% plots

figure
subplot(5,1,1)
plot(HelPower(:,1),HelPower(:,2),'k')
xlim([4.1 4.7])
set(gca,'xticklabel',[])
ylim([-inf 150])
legend('Power [kW]')
set(gcf,'color','w')
set(gca,'fontsize',15)

subplot(5,1,2)
plot(HelPressure(:,1),HelPressure(:,2),'k')
xlim([4.1 4.7])
set(gca,'xticklabel',[])
legend('Helicon Pressure [Pa]')
set(gcf,'color','w')
set(gca,'fontsize',15)

subplot(5,1,3)
plot(TargetPressure(:,1),TargetPressure(:,2),'k')
xlim([4.1 4.7])
set(gca,'xticklabel',[])
legend('Target Pressure [Pa]')
set(gcf,'color','w')
set(gca,'fontsize',15)

subplot(5,1,4)
plot(TargetDensity(:,1),TargetDensity(:,2),'k')
xlim([4.1 4.7])
set(gca,'xticklabel',[])
legend('n_e [m^{-3}]')
set(gcf,'color','w')
set(gca,'fontsize',15)

subplot(5,1,5)
plot(TargetTemperature(:,1),TargetTemperature(:,2),'k')
xlim([4.1 4.7])
ylim([0 5])
legend('T_e [eV]')
xlabel('Time [s]')
set(gcf,'color','w')
set(gca,'fontsize',15)



