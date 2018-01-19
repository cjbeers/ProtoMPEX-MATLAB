
ne=4E19; %m^-3
Te=2.5; % eV
time=0.5; %s
e=1.602E-19; %C/electron
r=1.2; %mm
y=1; %Gamma value
Z=1; %Charge on ions
mu=2; %average mass of particles
M=3.34E-27; %kg of D
rprobe=r/1000; %m
Aprobe=pi*rprobe^2; %m^2

cs1=((9.79E5*(y*Z*Te/mu)^(1/2)))/100; %m/s
lsat=0.61*ne*e*Aprobe*cs1*1000; %mA


cs2=((1.602E-19*Te)/M)^(1/2); %m/s
I_B=0.61*ne*e*Aprobe*cs2*1000; %mA 
Flux=(((I_B/1000)/(e*Aprobe))/time) %Particles/m-2s-1
