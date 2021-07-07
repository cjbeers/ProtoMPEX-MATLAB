%% Sheath Impedance Fits

%The code is based upon work described in

% Physics-based parametrization of the surface impedance for radio frequency sheaths
% J. R. Myra
% Physics of Plasmas 24, 072507 (2017)
% http://dx.doi.org/10.1063/1.4990373
% 
% This version (v3.2) implements an upgrate to include the JDC as described in
% 
% Effect of net direct current on the properties of radio frequency sheaths: simulation and cross-code comparison
% J. R. Myra, M.T. Elias, D. Curreli, and T. G. Jenkins
% submitted to Nucl. Fusion
% http://www.lodestar.com/LRCreports/Myra_DC_current_carrying_RF_sheaths_LRC-20-186.pdf

%% Code Start
cleanup
%Read in table

EdgeData=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Inputs\Beers_Inputs\HigherTe\Beers_Helicon_3D_HighDensityHighTe_SheathEdge.xlsx');

LayerData=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Inputs\Beers_Inputs\HigherTe\Beers_Helicon_3D_HighDensityHighTe_SheathCenter_NonMag3.xlsx');

%% Created variables from excel table
Inputs.Density=EdgeData(8:end,7);

Inputs.Vlayer=LayerData(8:end,27);
Inputs.z=LayerData(8:end,3);
Inputs.theta=LayerData(8:end,5);
%Inputs.B0=EdgeData(8:end,8);
%Inputs.Psi=EdgeData(8:end,9);

%% Variable Creation

mu = 24.17; % for Deuterium; upgrade to arbitrary single ion species is in progress
e=1.602E-19; %J to eV, also elementary charge
epsilon_0org=8.8419E-12;  %F/m or C^2/J or s^2*C^2/m^3*kg %Permittivity of free space
epsilon_0=epsilon_0org*e; %C^2/eV %Permittivity of free space

w=13.56e6*2*pi; %rad/s
omega=0; %0 omega_ci for unmagnetized case
%bx=1*sind(90);
%xi=14;
bn=1; %1 for unmagnetized limit
LayerThickness=0.005; %m

Te=8; %eV
Ti=0; %eV
Z=1; %D
A=2; %D

thick_debye=sqrt((epsilon_0.*Te)./(Inputs.Density.*e.^2)); %m %Chen2015
omegapi=1.32E3.*Z.*sqrt(Inputs.Density.*1e-6./A);
xi=1*Inputs.Vlayer./Te;
omega_hat=w./omegapi;
w=omega_hat;
bx=bn;

% w=0.2;
% omega=0.3;
% bx=0.4;
% xi=13;

j=0;
upar0=1.1;

%% phi0avg

% w=0.4;
% xi=6;

a1 = 3.70285;
a2 = 3.81991;
b1 = 1.13352;
b2 = 1.24171;
a3 = 2*b2/pi;

c0=0.966463;
c1=0.141639;

gg=c0+c1*tanh(w);
xi1=gg.*xi;
ff=((log(mu)+xi1.*a1+xi1.^2.*a2+xi1.^3.*a3)./(1+xi1.*b1+xi1.^2.*b2))-log(1-j/upar0)+log(mu./24.17);

phi0avg=ff;

%% ni1avg
% niw = ion density at the wall for a static sheath
% vv is the total dc potential drop 
%niw(omega,bx, xi)
%niww(w,omega,bx,xi)

% w=0.2;
% omega=0.3;
% bx=0.4;
% xi=13;

k0=3.7616962640756197;
k1=0.2220204461728174;

phiavg=phi0avg;
philowomega=k0+k1.*(xi-k0)-log(1-j/upar0);
phimod=philowomega+(phiavg-philowomega).*tanh(w);


d0=0.7944430930529499;
d1=0.803531266389172;
d2=0.18237897510951012;
d3=0.9957212047604492;
nu1=1.4555923231100891;

arg=sqrt((mu^2*bx.^2+1)./(mu.^2+1));

fff=-log(arg)/(1+d3*omega^2);

Thetap=phimod-fff;
Thetap1=zeros(1);

for ii=1:length(Thetap)
    Thetap1(ii,1)=Thetap(ii,1);
if Thetap(ii,1) < 0
    Thetap1(ii,1)=0;
end
end

omegaTheta=omega.*Thetap1.^(1/4);
d4=d2^2/(mu*d0^2-d2^2);

niw=((d0)./(d2+Thetap1.^(1/2))).*sqrt((bx.^2+d4+d1^2.*omegaTheta.^(2*nu1))./(1+d4+d1^2.*omegaTheta.^(2*nu1)));

% niw\[Omega] is the ion density at the wall for an rf sheath
% \[Xi] is the 0-peak rf voltage

niwomega=real(niw);

%% yd

s0=1.1241547327789232;
phi0a=phi0avg;
niwomegaa=niwomega;
Delta=sqrt(phi0a./niwomegaa);

yd=-sqrt(-1).*s0.*w./Delta;

%% ye

% bx=0.4;
% xi=3.6;

h1=0.607405123251634;
h2=0.3254965671158986;
g1=0.6243920388599393;
g2=0.5005946718280853;
g3=pi/4*h2;


he=(1+xi.*h1+xi.^2*h2)./(1+xi.*g1+xi.^2.*g2+xi.^3.*g3);

h0=1.05704235;

ye=h0.*abs(bx).*he.*(1-j/upar0);

%% yi

parp0=1.0555369617763768;
parp1=0.7976591020008023;
parp2=1.47404874815277;
parp3=0.8096145628336325;

wcup=parp3.*w./sqrt(niwomegaa);
ycup=abs(bx)./(niwomegaa.*sqrt(phi0a));
epsilon=0.0001;

gsmall=(w.^2-bx.^2*omega.^2+sqrt(-1).*epsilon)./(w.^2-omega.^2+sqrt(-1).*epsilon);
yi0=niwomegaa./sqrt(phi0a);

yi=parp0.*yi0.*(sqrt(-1).*wcup)./((wcup.^2./gsmall)-parp1+sqrt(-1).*parp2.*ycup.*wcup);

%% ytot and ztot

ytot=yi+ye+yd;

ztot=1./ytot;

%% Epsilon and Sigma Calculations

DataOut(:,1)=-(imag(ytot)./omega_hat).*(LayerThickness./thick_debye); %epsilon

DataOut(:,2)=epsilon_0org.*omegapi.*(LayerThickness./thick_debye).*real(ytot); %sigma



