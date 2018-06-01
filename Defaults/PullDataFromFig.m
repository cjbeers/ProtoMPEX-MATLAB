%Opens matlab .fig gets data and makes a new publication ready plot

%cleanup

open('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2018_04_30\CH Band at 100 vs room temp..fig') %open your fig file, data is the name I gave to my file
D=get(gca,'Children'); %get the handle of the line object
XData=get(D,'XData'); %get the x data
YData=get(D,'YData'); %get the y data
Data=[XData' YData']; %join the x and y data on one array nx2
Data=[XData;YData]; %join the x and y data on one array 2xn

%% Plots
figure
plot(XData2, YData2, 'k')
hold on
plot(XData, YData, 'm')
ax = gca;
ax.FontSize = 13;
%title('Time traces for Helicon', 'FontSize', 13);
xlabel('Wavelength [nm]', 'FontSize', 13);
%ylabel('Electron Density [cm^{-3}]', 'FontSize', 13);
ylabel('Intensity [Photons/m^{-2}s^{-1}]', 'FontSize', 13);
xlim([425 435.5])
ylim([-1E13 3.6E15])
legend('Room Temp.', '190 °C')
hold off

%Plot()