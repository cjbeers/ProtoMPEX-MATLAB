clear all
close all
clc

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

Shot=[6489, 6488, 6487, 6486, 6489, 6488, 6487, 6486, 6485, 6484, 6483, 6482, 6481, 6479, 6490, 6491, 6492, 6493, 6495, 6496, 6497, 6498, 6499, 6500, 6501];
Position=[-2.5, -2.25, -2, -1.75, -1.5, -1.25, -1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5];
Ne=[6.90E+17, 1.20E+18, 6.60E+17, 1.70E+18, 4.20E+18, 5.20E+18, 5.90E+18, 5.70E+18, 7.20E+18, 4.40E+18, 4.50E+18, 4.30E+18, 3.00E+18, 3.30E+18, 5.70E+18, 6.80E+18, 6.10E+18, 4.70E+18, 1.80E+18, 6.90E+17, 6.90E+17];
Te=[8.2, 6.9, 11.8, 14.5, 16.3, 23.5, 22, 17.8, 9.2, 8.4, 7.7, 6.8, 10.9, 13.5, 18.6, 13.3, 14.1, 12.9, 10.6, 7.4, 6.8];


%excel=xlsread('Expdata_Proto-MPEX_Dec11_15');
%Get Te data from Nischal

ez=size(Ne);
z=ez(1,2);
%Table=zeros(z+1,2);


for i=1:z
Te(1,i)=Te(1,i)*11604.3; %K ,11604.3K/ev
%Te=5*11604.3;
%n_e=excel(i,4); %Bulk flux 
%n_e=1.3E19;
k_b=8.6173324E-5; %eV/K
m_i=2*((931.5E6)/(2.998E8)^2); %eV/c^2
Ti=0.5*11604.3; %K
y=3; %3 for 1D adiabatic flow, 1 for isothermal flow
corfactor=1.602E-19; %Joule/eV

Gamma_se(1,i)=0.5*Ne(1,i)*(((k_b)*(Te(1,i)+y*Ti))/(m_i))^0.5; %(1/(m^2*s^1))
HeatFlux(1,i)=((5.5*Gamma_se(1,i)*((Te(1,i))/11604.3)+1.5*Gamma_se(1,i)*(Ti/11604.3))*corfactor)/1E6; %(MW/m^2)

%{
%Table{1,1}='Position';
Table(i,1)=excel(14,2);
%Table{1,2}='Gamma_se'; 
Table(i,2)=Gamma_se; 

%Table{1,3}='HeatFlux'; 
Table(i,3)=HeatFlux;
%}
end
%
figure(1);
plot(Position, HeatFlux);
ax = gca;
ax.FontSize = 15;
title('HeatFlux vs. Position','FontSize',15);
xlabel('Position (cm)','FontSize',15);
ylabel('HeatFlux (Mw/m2)','FontSize',15);


figure(2);
plot(Position,Gamma_se);
ax = gca;
ax.FontSize = 15;
title('Flux vs. Position','FontSize',15);
xlabel('Position (cm)','FontSize',15);
ylabel('Flux (Particles/m2s)','FontSize',15);

figure(3);
plot(Position,Te);
ax = gca;
ax.FontSize = 15;
title('Te vs. Position','FontSize',15);
xlabel('Position (cm)','FontSize',15);
ylabel('Te (ev)','FontSize',15);

figure(4);
plot(Position,Ne);
ax = gca;
ax.FontSize = 15;
title('Ne vs. Position','FontSize',15);
xlabel('Position (cm)','FontSize',15);
ylabel('Ne (electrons/m3','FontSize',15);
