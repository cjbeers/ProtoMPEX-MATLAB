%Opens matlab .fig gets data and makes a new publication ready plot

%cleanup

open('C:\Users\cxe\Documents\Proto-MPEX\McPherson\Analyzed Data\ICHFit.fig') %open your fig file, data is the name I gave to my file
D=get(gca,'Children'); %get the handle of the line object
XData=get(D,'XData'); %get the x data
YData=get(D,'YData'); %get the y data
Data=[XData' YData']; %join the x and y data on one array nx2
Data=[XData;YData]; %join the x and y data on one array 2xn

%% Plots
figure
plot(XData{1,1}(:), YData{3,1}(:), 'k')
hold on
plot(XData{1,1}(:), YData{1,1}(:), 'm')
ax = gca;
ax.FontSize = 13;
%title('Time traces for Helicon', 'FontSize', 13);
xlabel('Vertical Position [cm]', 'FontSize', 13);
%ylabel('Electron Density [cm^{-3}]', 'FontSize', 13);
ylabel('Electron Temperature [eV]', 'FontSize', 13);
%xlim([4.15 4.7])
ylim([0 5])
legend('No ICH', 'With ICH')
hold off

Plot()