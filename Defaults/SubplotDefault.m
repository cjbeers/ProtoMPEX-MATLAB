%%
cleanup

Maincoil=load('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2017_01_09\Shot12619_MainCoilAmps');
Heliconpower=load('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2017_01_09\Shot12619_HeliconPower');
Heliconcoil=load('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2017_01_09\Shot12619_HeliconCoilAmps');

%%
figure;
subplot(2,2,2); hold on
plot(Maincoil(:,1), (Maincoil(:,2)))
ax = gca;
ax.FontSize = 13;
title('Machine Conditions', 'FontSize', 13);
%xlabel('Time [s]', 'FontSize', 13);
ylabel('Main Coil Current [kA]', 'FontSize', 13);
xlim([4.1 4.4]);
%ylim([0 inf]);


subplot(2,2,3); hold on
plot(Heliconcoil(:,1), Heliconcoil(:,2))
ax = gca;
ax.FontSize = 13;
%title('Machine Conditions', 'FontSize', 13);
xlabel('Time [s]', 'FontSize', 13);
ylabel('Helicon Current [A]', 'FontSize', 13);
xlim([4.1 4.4]);
ylim([0 300]);

subplot(2,2,4); hold on
plot(Heliconpower(:,1), Heliconpower(:,2))
ax = gca;
ax.FontSize = 13;
%('Machine Conditions', 'FontSize', 13);
xlabel('Time [s]', 'FontSize', 13);
ylabel('Helicon Power [kW]', 'FontSize', 13);
xlim([4.1 4.4]);
ylim([0 150]);
hold off;

