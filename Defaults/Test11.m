
Table=xlsread('C:\Users\cxe\Documents\Random\My stuff\Brianne\H and Zr values to plot');

Data.X=Table(:,1);
Data.Y1=Table(:,3);
Data.Y2=Table(:,5);
Data.Y3=Table(:,6);

%%
figure;
yyaxis left

plot(Data.X,Data.Y1,'-k')
hold on
xlabel('Wavelength [\AA]','Interpreter','latex','Fontname','TimesNewRoman')
ylabel('Flux [n/cm^2/s]')
set(gca,'ycolor','k')

yyaxis right
plot(Data.X,Data.Y2,'-r')
plot(Data.X,Data.Y3,'-b')
ylabel('Cross section [barns]')
set(gcf,'color','w')
ax = gca;
ax.FontSize = 13;
set(gca,'ycolor','k')
legend('CG1D','H','Zr')
