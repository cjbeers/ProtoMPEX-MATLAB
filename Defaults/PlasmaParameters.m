
cleanup


epsilon_0org=8.854E-12;  %F/m or C^2/J or s^2*C^2/m^2*kg
confactor=1.602E-19; %J to eV
epsilon_0=epsilon_0org*confactor; %C^2/eV
Ne=4E19;  %1/m^3
Te=2; %eV
Ti=Te; %eV
%KT=10  %keV
e=-1.602E-19;  %C
Z=1; %Charge State
y=1; %Gamma value
B=0.75; %B field in T

%{
mpkg=1.672E-27; %kg
%mp=1.007; %amu
mp= (mpkg/1.782661E-36); %eV
%}
mp=938.27e6/(3.0E8)^2; %eV %Mass of proton
%{
mekg=9.11E-31; %kg
%me=5.485E-4; %amu
me=(mekg/1.782661E-36); %eV
%}
me=0.51e6/(3.0E8)^2; %eV %Mass of electron
% mi=3727e6/(3.0E8)^2; %eV %Mass of ion (He-2)
mi=mp*2; %eV %Mass of ion D
m_D=3.34E-27; %kg of D
mu= mi/mp;
debyel=sqrt((epsilon_0*Te)/(Ne*e^2));

lambda=12*pi*(((epsilon_0*Te)^3)/(Ne*e^6))^(1/2);
%lambda=4*pi*n*debyel^3
lnlambda=log(lambda);

%
timepp=(6*sqrt(6)*pi*sqrt(mp)*(epsilon_0)^2*(Te)^(3/2))/(Ne*e^4*log(lambda));
timepe=(6*sqrt(3)*pi*sqrt(me)*(mp/me)*(epsilon_0)^2*(Te)^(3/2))/(Ne*e^4*log(lambda));
timeee=(6*sqrt(6)*pi*sqrt(me)*(epsilon_0)^2*(Te)^(3/2))/(Ne*e^4*log(lambda));
timeei=(6*sqrt(3)*pi*sqrt(me)*(epsilon_0)^2*(Te)^(3/2))/(Ne*e^4*log(lambda));
%

%Electron and ion collision rate in completely ionizd plasmas for Helium
ecr_He2= 2.91E-6*Ne*lnlambda*Te^(-3/2);
icr_He2= 4.8E-8*mu*Z*lnlambda*Te^(-3/2);

% Z=1; %For H
% ecr_H= 2.91E-6*Ne*lnlambda*Te^(-3/2); %1/s
% icr_H= 4.8E-8*1*Z*lnlambda*Te^(-3/2); %1/s

cf_H=(e^4*lnlambda*Ne)/(4*pi*epsilon_0^2*mp^(1/2)*Te^(3/2));
cf_He=(e^4*lnlambda*Ne)/(4*pi*epsilon_0^2*mi^(1/2)*Te^(3/2));
cf_He=(e^4*lnlambda*Ne)/(4*pi*epsilon_0^2*mi^(1/2)*Te^(3/2));

%% Larmor Radius

cs1=((9.79E5*(y*Z*Te/mu)^(1/2)))/100; %m/s

Gryofreq_i=Z*-e*B/(m_D*cs1); %1/s
GyroRad_i= (m_D*(cs1*1000))/(-e*B) %mm

%% Flux 

Te_K=Te*11604.3;  % 11604.3 K/eV
k_b=8.6173324E-5; %eV/K
m_i=2*((931.5E6)/(2.998E8)^2); %eV/c^2
%For now the USER inputs Ti, eventually want code to find thisStd_Ti=0; 
Ti_K=Ti*11604.3; %Ion Temp. in K
y=3; %3 for 1D adiabatic flow, 1 for isothermal flow
ye=5.5; %sheath transmission factor for electrons
yt=1.5; %sheath transmission factor for ions
%Gamma_se = Flux to sheath entrance

Gamma_se=0.61*Ne.*((((k_b)*(Te+y*Ti_K))/(m_i)).^0.5) %(1/(m^2*s^1))



