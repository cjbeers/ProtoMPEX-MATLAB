%Code by Josh Beers, Calculates debye length and Saturation current for
%DLP based on radius of probe in mm

cleanup

ne=5E19; %1/m3
KT=2; %eV
epsilon_0org=8.854E-12;  %F/m or C^2/J or s^2*C^2/m^2*kg
confactor=1.602E-19; %J to eV
epsilon_0=epsilon_0org*confactor; %C^2/eV
e=-1.602E-19; %C
k=0.6; %For spherical presheath
r=25; %mm %USER adjusts this
As=pi*(r/1000)^2; %m2
V=60; %V on probe
u=4; %Reduced mass of plasma 1 for H, 40 for Ar, 4 or He,
mi_eV=2*(938.27e6); %eV
me_eV=0.511E6; %eV
cs=sqrt(KT/mi_eV)*(1/100); %cm/s to m/s
%% Debye length
debye=7430*sqrt(KT/ne); %m
debye1=sqrt((epsilon_0*KT)/(ne*e^2)); % m

%% Potentials
Vplasma=KT*(3.34+0.5*log(u));
vplasma= (1/4)*-e*As*ne*sqrt((8*KT)/(pi*mi_eV));

%% Currents
Ie=-e*ne*k*As*cs; %C/s = Amps
Iis=0.6*e*ne*As*sqrt(KT/mi_eV) %Amps
Ies=(1/4)*e*ne*As*sqrt(8*KT/(pi*me_eV)) %Amps

Iratio=Ies/Iis
%% Sheath Thickness

deltaxs=((2/3)*(2/exp(-1))^(1/4)*((Vplasma/(KT))^(1/2)-(1/sqrt(2)))^(1/2)*((Vplasma/(KT))^(1/2)+sqrt(2)));  % m
x=(sqrt(2))/3*(2*Vplasma/KT)^(3/4) % debye lengths, m
deltaxsfloating=1.02*(sqrt(3.34+0.5+log(u))-(1/sqrt(2)))^(1/2)*(sqrt(3.34+0.5*log(u))+sqrt(2));






