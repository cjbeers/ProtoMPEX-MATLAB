%Coded by: Josh Beers
%ORNL

%Code uses Nishal's excel file to calculate heat flux and particle flux as
%a function of DLP location

%% Start Code
ccc

%{
%plasma pressure = ne*Te/k*R *7.5 mTorr/Pa (mTorr for Te in eV, ne in m-3
lp_pe1=lp_ne1*lp_Te1/8.617e-5*8.31/6.02e23*7.5  )
mi= 2.*931.5e6/2.998e8^2 %  ion mass for deuterium = 2.*931.5 MeV/c2 (eV)
cs1=sqrt(lp_te1/mi)  %sound speed for Ti=0 (m/s)
gamma1=lp_ne1*cs1  %particle flux (m-2 s-1)
q1=5.*gamma1*lp_te1*1.602e-19  %heat flux  (W/m2)
B1=1.5  %full field
pb1=B1^2/(2.*4.*3.14159e-7)*7.5  %magnetic pressure 
%(mTorr for B in T) normal to B axis
beta1=lp_pe1/pb1
%}

i=1;
%excel=xlsread('Expdata_Proto-MPEX_Dec11_15');
excel=xlsread('Proto_MPEX_RadialProfile_07_01_16');
%Get Te data from Nischal
ez=size(excel);
z=ez(1,1);
Table=zeros(z,2);

for i=1:z
Te(i,1)=excel(i,3)*11604.3; %K ,11604.3K/ev
%Te=5*11604.3;
n_e(i,1)=excel(i,4); %Bulk flux 
%n_e=1.3E19;
k_b=8.6173324E-5; %eV/K
m_i=2*((931.5E6)/(2.998E8)^2); %eV/c^2
Ti=0*11604.3; %K
y=3; %3 for 1D adiabatic flow, 1 for isothermal flow
corfactor=1.602E-19; %Joule/eV

Gamma_se=0.5*n_e(i,1)*(((k_b)*(Te(i,1)+y*Ti))/(m_i))^0.5; %(1/(m^2*s^1))

%Table='Te;
Table(i,2)=excel(i,3);
%n_e
Table(i,3)=excel(i,4);
%Table{1,1}='Position';
Table(i,1)=excel(i,2);
%Table{1,4}='Gamma_se'; 
Table(i,4)=Gamma_se; 
HeatFlux=((5.5*Gamma_se*(Te(i,1)/11604.3)+1.5*Gamma_se*(Ti/11604.3))*corfactor)/1E6; %(MW/m^2)
%Table{1,5}='HeatFlux'; 
Table(i,5)=HeatFlux;
end

figure(); hold on
subplot(2,1,1);
plot(Table(:,1),Table(:,3));
ax=gca;
ax.FontSize = 15;
title('Ni','FontSize',15);

subplot(2,1,2); hold on
plot(Table(:,1),Table(:,2));
ax=gca;
ax.FontSize = 15;
title('Te','FontSize',15);
hold off

%
figure(); hold on
subplot(2,1,1);
plot(Table(:,1),Table(:,4));
ax = gca;
ax.FontSize = 15;
title('HeatFlux vs. Position','FontSize',15);
xlabel('Position (cm)','FontSize',15);
ylabel('HeatFlux (MW/m2)','FontSize',15);


subplot(2,1,2); hold on
plot(Table(:,1),Table(:,5));
ax = gca;
ax.FontSize = 15;
title('Flux vs. Position','FontSize',15);
xlabel('Position (cm)','FontSize',15);
ylabel('Flux (Particles/m2*s)','FontSize',15);
hold off
%

