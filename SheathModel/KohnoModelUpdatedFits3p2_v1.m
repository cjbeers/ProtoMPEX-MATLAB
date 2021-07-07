%% Code Start
cleanup
%Read in table

%EdgeData=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Inputs\Beers_Inputs\HigherTe\Beers_Helicon_3D_HighDensityHighTe_SheathEdge.xlsx');

LayerData=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle8v34.txt');
Inputs.d=0.0002;
LayerData=table2array(LayerData);

%% Created variables from excel table
%Inputs.Density=EdgeData(8:end,7);

% ii=1;
% for jj=1:100
%     
%     Inputs.Y(jj,1)=LayerData(ii,2);
%     Inputs.VlayerInitial(jj,1)=trapz(LayerData(ii:ii+49,3),LayerData(ii:ii+49,1));
%     ii=ii+50;
%     
% end
Inputs.Y=LayerData(:,2);
Inputs.X=1.2-Inputs.d/2*ones(100,1);


Inputs.Density=1e17;


%Inputs.Vlayer=abs(Inputs.VlayerInitial).*Inputs.d;
Inputs.Vlayer=abs(((LayerData(:,3))).*Inputs.d);
%Inputs.Vlayer=10;

%Inputs.z=LayerData(8:end,3);
%Inputs.theta=LayerData(8:end,5);
%Inputs.B0=EdgeData(8:end,8);
%Inputs.Psi=EdgeData(8:end,9);

%% Variable Creation

mu = 24.17; % for Deuterium; upgrade to arbitrary single ion species is in progress
e=1.602E-19; %J to eV, also elementary charge
epsilon_0org=8.8419E-12;  %F/m or C^2/J or s^2*C^2/m^3*kg %Permittivity of free space
epsilon_0=epsilon_0org*e; %C^2/eV %Permittivity of free space

w=80e6*2*pi; %rad/s
omega=0; %0 omega_ci for unmagnetized case
%bx=1*sind(90);
%xi=14;
bn=1; %1 for unmagnetized limit


Te=15; %eV
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
% omega=0;
% bx=1;
% xi=13/2;

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
Real_zsh=real(max(ztot));
Imag_zsh=imag(max(ztot));

%% Epsilon and Sigma Calculations

DataOut(:,1)=-(imag(ytot)./omega_hat).*(Inputs.d./thick_debye); %epsilon
Sigma(:,1)=Inputs.X;
Sigma(:,2)=Inputs.Y;
% Sigma(:,1)=real(LayerData(:,1));
% Sigma(:,2)=real(LayerData(:,2));
Epsilon(:,3)=DataOut(:,1);

DataOut(:,2)=epsilon_0org.*omegapi.*(Inputs.d./thick_debye).*real(ytot); %sigma
Epsilon(:,1)=Inputs.X;
Epsilon(:,2)=Inputs.Y;
% Sigma(:,1)=real(LayerData(:,1));
% Sigma(:,2)=real(LayerData(:,2));
Sigma(:,3)=DataOut(:,2);

