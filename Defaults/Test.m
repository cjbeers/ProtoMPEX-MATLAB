

yy=smooth(x(2,:),'sgolay');
%yy1=smooth(x(10,:),'sgolay');

%% plots
figure
%plot(Spectra.LambdaPlot,Spectra.Intensity4(8,:))
hold on
plot(x(1,:),yy,'k')
%plot(printthis(1,:),printthis(5,:),'m')
%plot(x(1,:),yy1,'r')
hold off
ax = gca;
ax.FontSize = 13;
title('CH Band', 'FontSize', 13);
xlabel('Wavelength [nm]', 'FontSize', 13);
ylabel('Intensity [Photons/s/m^{-2}]', 'FontSize', 13);
legend('Smoothed Data')
%xlim([421.5 435]);
%ylim([0 inf]);
