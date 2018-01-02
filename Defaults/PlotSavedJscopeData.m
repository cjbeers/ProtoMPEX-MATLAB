%%
cleanup

ICHPower=load('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2017_11_01\Shot17279_ICHPower');
HeliconPower=load('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2017_11_01\Shot17279_HeliconPower');


%%
figure;

plot(HeliconPower(:,1), HeliconPower(:,2), 'black')
ax = gca;
ax.FontSize = 13;
%title('Time traces for Helicon', 'FontSize', 13);
xlabel('Time [s]', 'FontSize', 13);
ylabel('Input Power [kW]', 'FontSize', 13);
hold on
plot(ICHPower(:,1), ICHPower(:,2)*100,'m')
xlim([4.15 4.7])
ylim([0 100])
line([4.35 4.35],get(gca, 'ylim'));
line([4.40 4.40],get(gca, 'ylim'));
line([4.50 4.50],get(gca, 'ylim'));
line([4.55 4.55],get(gca, 'ylim'));
legend('Helicon', 'ICH', 'Integration Time')
Plot()

%%
