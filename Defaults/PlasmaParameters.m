
%cleanup
format shorte

Ne=4E19;  %1/m^3
Ne_std=1.39E18;

Te=5; %eV
Te_std=0.1102;

Ti=Te; %eV
%KT=10  %keV

epsilon_0org=8.854E-12;  %F/m or C^2/J or s^2*C^2/m^3*kg
confactor=1.602E-19; %J to eV
epsilon_0=epsilon_0org*confactor; %C^2/eV

e=-1.602E-19;  %C
Z=1; %Charge State
y=1; %Gamma value
B=0.75; %B field in T

%
mpkg=1.672E-27; %kg
%mp=1.007; %amu
%mp= (mpkg/1.782661E-36); %eV
%
mp=938.27e6/(3.0E8)^2; %eV %Mass of proton
%
mekg=9.109E-31; %kg
%me=5.485E-4; %amu
%me=(mekg/1.782661E-36); %eV
%
me=0.51e6/(3.0E8)^2; %eV %Mass of electron
% mi=3727e6/(3.0E8)^2; %eV %Mass of ion (He-2)
mi=mp*2; %eV %Mass of ion D
m_D=3.34E-27; %kg of D
m_He=6.64424E-27; %kg of He
mu= mi/mp;
debyel=sqrt((epsilon_0*Te)/(Ne*e^2));
PlasmaFreqe=sqrt((Ne*e^2)/(mekg*epsilon_0org));
PlasmaFreqi=sqrt((Ne*e^2)/(mpkg*epsilon_0org));
PlasmaFreqTot=sqrt((Ne*e^2)/(mekg*epsilon_0org)+(Ne*e^2)/(mpkg*epsilon_0org))

lambda=12*pi*(((epsilon_0*Te)^3)/(Ne*e^6))^(1/2);
%lambda=4*pi*n*debyel^3
lnlambda=log(lambda);

% Species interaction times
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
%collisional frequency
cf_H=(e^4*lnlambda*Ne)/(4*pi*epsilon_0^2*mp^(1/2)*Te^(3/2));
cf_He=(e^4*lnlambda*Ne)/(4*pi*epsilon_0^2*mi^(1/2)*Te^(3/2));
cf_He=(e^4*lnlambda*Ne)/(4*pi*epsilon_0^2*mi^(1/2)*Te^(3/2));

%% Larmor Radius

%another way to get sound speed
cs1=((9.79E5*(y*Z*Te/mu)^(1/2)))/100; %m/s

Gryofreq_i=Z*-e*B/(m_D*cs1); %rad/s  (omega_ci)
%rad/s -> 1/s = rad/s * 1/2pi
GyroRad_i= (m_D*(cs1))/(-e*B) %m 

%Floating potential
eV_sf=Te*0.5*log((2*pi*me/mi)*(1+Ti/Te)); %eV

%% Flux 

Te_K=Te*11604.3;  % 11604.3 K/eV
Te_K_std=Te_std*11604.3;
k_b=8.6173324E-5; %eV/K
m_i=2*((931.5E6)/(2.998E8)^2); %eV/c^2
%For now the USER inputs Ti, eventually want code to find this Std_Ti=0; 
Ti_K=Ti*11604.3; %Ion Temp. in K
Ti_K_std=Te_std;
y=3; %3 for 1D adiabatic flow, 1 for isothermal flow
ye=5.5; %sheath transmission factor for electrons
yt=1.5; %sheath transmission factor for ions
%Gamma_se = Flux to sheath entrance

cs=((((k_b)*(Te_K+y*Ti_K))/(m_i)).^0.5); %m/s

%Gamma_se=Particle flux to target=0.61*n_e*c_s
Gamma_se=0.61*Ne.*((((k_b)*(Te_K+y*Ti_K))/(m_i)).^0.5) %(1/(m^2*s^1))
Gamma_se_std=0.61*Ne.*((((k_b)*(Te_K_std+y*Ti_K_std))/(m_i)).^0.5) %(1/(m^2*s^1));
HeatFlux=Gamma_se*4*-e*Te

%% Presheath

eV_ps=-0.7*Te;

%% Magnetic presheath thickness

theta=85;
MPS_t=sqrt(6)*(cs/Gryofreq_i)*sind(theta); %(m) %From Stangeby 2.112

E_MPS=confactor*Te/(-e*MPS_t); %eV %Stangeby 2.109

%% Combined sheath and presheath

V_sf_ps=3*Te-eV_ps;


%% Equlibirum timing or relaxation time

A1=2;
A2=40;
ne=3E19*(1/100)^3; %cm-3
Z1=1;
Z2=1;
logA=12; % ln(A) from Sprizer
T1=10*11604; % K, (converted from eV)
T2=0*11604; 


t_eq=5.87*((A1*A2)/(ne*Z1^2*Z2^2*logA))*((T1/A1+T2/A2)^(3/2));

