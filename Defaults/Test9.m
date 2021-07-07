
%data comes from first 5 columns from the analyzed layer data
%data column 6 is the IMABS or Layer Voltage 
%data column 7 is the density at the layer edge

pointsize=10;

figure;
scatter(data(:,3),data(:,5),pointsize,data(:,6));
cmap=colorbar;
ylabel(cmap,'Voltage across sheath layer [V]')
title('Low Density Case 7-Magnetized');
xlabel('Window Z [m]');
ylabel('Angle along window (deg.)');
ylim([0 360]);
set(gcf,'color','w')
ax = gca;
ax.FontSize = 13;

%% 
T_e_eV=4;
T_i_eV=0.5;
e=1.602E-19; %J to eV, also elementary charge


y_e=1; %3 for 1D adiabatic flow, 1 for isothermal flow %Adiabatic index (1+2n) where n is the degree of freedom
y_i=3; %ions adiabatic and electrons isothermal
m_p=938.27e6/(3.0E8)^2; %eV %Mass of proton
m_D=2*m_p; %eV %Mass of D ion

c_s= sqrt(((y_e*T_e_eV)+(y_i*T_i_eV))/m_D); %m/s %Sound speed from Chen2015 4.41


Gamma_se=0.61*data(:,7).*c_s;

q=((2*T_e_eV+data(:,6)).*e).*Gamma_se; %W/m2?

%%
figure;
scatter(data(:,3),data(:,5),pointsize,q);
cmap=colorbar;
ylabel(cmap,'Heat flux [W/m^2]')
title('Low Density Case 7-Magnetized');
xlabel('Window Z [m]');
ylabel('Angle along window (deg.)');
ylim([0 360]);
set(gcf,'color','w')
ax = gca;
ax.FontSize = 13;


figure;
scatter(data(:,3),data(:,5),pointsize,data(:,7));
cmap=colorbar;
ylabel(cmap,'Electron Density on Sheath Boundary [Particles/m^2/s]')
title('Low Density Case 7-Magnetized');
xlabel('Window Z [m]');
ylabel('Angle along window (deg.)');
ylim([0 360]);
set(gcf,'color','w')
ax = gca;
ax.FontSize = 13;