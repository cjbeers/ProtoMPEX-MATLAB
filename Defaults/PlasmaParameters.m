clear all
close all
clc

epsilon_0org=8.854E-12;  %F/m or C^2/J or s^2*C^2/m^2*kg
confactor=1.602E-19; %J to eV
epsilon_0=epsilon_0org*confactor; %C^2/eV
Te=1; %eV
%KT=10  %keV
Ne=3E19;  %1/m^3
e=-1.602E-19;  %C
Z=2; %Charge State
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
mi=3727e6/(3.0E8)^2; %eV %Mass of ion (He-2)
mu= mi/mp;
debyel=sqrt((epsilon_0*Te)/(Ne*e^2));

lambda=12*pi*(((epsilon_0*Te)^3)/(Ne*e^6))^(1/2);
%lambda=4*pi*n*debyel^3
lnlambda=log(lambda)

%
timepp=(6*sqrt(6)*pi*sqrt(mp)*(epsilon_0)^2*(Te)^(3/2))/(Ne*e^4*log(lambda))
timepe=(6*sqrt(3)*pi*sqrt(me)*(mp/me)*(epsilon_0)^2*(Te)^(3/2))/(Ne*e^4*log(lambda))
timeee=(6*sqrt(6)*pi*sqrt(me)*(epsilon_0)^2*(Te)^(3/2))/(Ne*e^4*log(lambda))
timeei=(6*sqrt(3)*pi*sqrt(me)*(epsilon_0)^2*(Te)^(3/2))/(Ne*e^4*log(lambda))
%

%Electron and ion collision rate in completely ionizd plasmas for Helium
ecr_He2= 2.91E-6*Ne*lnlambda*Te^(-3/2)
icr_He2= 4.8E-8*mu*Z*lnlambda*Te^(-3/2)

Z=1; %For H
ecr_H= 2.91E-6*Ne*lnlambda*Te^(-3/2) %1/s
icr_H= 4.8E-8*1*Z*lnlambda*Te^(-3/2) %1/s

cf_H=(e^4*lnlambda*Ne)/(4*pi*epsilon_0^2*mp^(1/2)*Te^(3/2))
cf_He=(e^4*lnlambda*Ne)/(4*pi*epsilon_0^2*mi^(1/2)*Te^(3/2))
cf_He=(e^4*lnlambda*Ne)/(4*pi*epsilon_0^2*mi^(1/2)*Te^(3/2))

