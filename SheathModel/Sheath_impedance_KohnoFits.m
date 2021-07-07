%% Sheath Impedance Fits

%The code is based upon work described in

% H. Kohno, J.R. Myra, A finite element procedure for radio-frequency 
%sheath-plasma interactions based on a sheath impedance model, 
%Comput. Phys. Commun. 220 (2017) 129–142. 
%doi:https://doi.org/10.1016/j.cpc.2017.06.025.
% 

%% Code Start
cleanup
%Read in table

%EdgeData=xlsread('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Inputs\Beers_Inputs\HigherTe\Beers_Helicon_3D_HighDensityHighTe_SheathEdge.xlsx');
 
LayerData=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle8v33.txt');
LayerData=table2array(LayerData);

Inputs.d=0.0002; %[m]


%%

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

%% Created variables from excel table
%Inputs.Density=EdgeData(8:end,7);

Inputs.Density=1e17;

%Inputs.Vlayer=2.*abs(Inputs.VlayerInitial).*Inputs.d;
Inputs.Vlayer=2*abs(LayerData(:,3)).*Inputs.d;
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
bn=1; %1 for unmagnetized limit


Te=15; %eV
Ti=0; %eV
Z=1; %D
A=2; %D

thick_debye=sqrt((epsilon_0.*Te)./(Inputs.Density.*e.^2)); %m %Chen2015
omegapi=1.32E3.*Z.*sqrt(Inputs.Density.*1e-6./A); %eq is in cgs
xi=1*Inputs.Vlayer./Te;
omega_hat=w./omegapi;
w=omega_hat;
bx=bn;

j=0;
upar0=1.1;

%%
%-----------------------------------------------------------------------

%The functions below may only be used in the parameter range

%omega = (0,8)
%Vpp = (0,20)

%where omega_hat => omega/omega_pi is the dimensionless frequency
%and Vpp = e Vrf / Te is the dimensionless peak-to-peak voltage

% Outside of these ranges, the fits may behave wildly as they use high-order polynomials.
% Normally one should not use high-order polynomials, but in this case they are convenient because they
% provide continuously differentiable results.


%GENERAL DEFINITIONS

u0 = 1.1;
complex_xi=1i;

%Test Numbers

% omega_hat=0.2;
% omega=0;
% bx=1;
% xi=13;

%Test case
% omega_hat=1;
% omega=0;
% bx=1;
% xi=10; %ytot=0.34782583498679287-0.2209565015703985i


vpp=xi;

%%
%ION ADMITTANCE
F1_VPP=1.0042042386309231 - 0.040348243785481734.*vpp + 0.0015928747555414683.*vpp.^2 - 0.000028423592601970268.*vpp.^3 + 0.06435835731325179*tanh(0.5.*vpp);
F1_10V=1.0042042386309231 - 0.040348243785481734.*10 + 0.0015928747555414683.*10.^2 - 0.000028423592601970268.*10.^3 + 0.06435835731325179*tanh(0.5.*10);

F2_VPP=0.10853383673713796 - 0.006244170771533145.*vpp + 0.00024234826741913128.*vpp.^2 - 4.199121776132657e-6.*vpp.^3 + 0.008906384119401499*tanh(0.5.*vpp);
F2_10V=0.10853383673713796 - 0.006244170771533145.*10 + 0.00024234826741913128.*10.^2 - 4.199121776132657e-6.*10.^3 + 0.008906384119401499*tanh(0.5.*10);

New_chi=omega_hat.*F1_10V./F1_VPP;

G1 =  0.00013542350902761945 - 0.052148081768838075.*New_chi + 0.2834385542799402.*New_chi.*exp(-New_chi) + 0.03053282857790852.*New_chi.^2 - 0.006477393187352886.*New_chi.^3 + 0.0006099729221975197.*New_chi.^4 - 0.00002165822780075613.*New_chi.^5;
G2 =  -1.5282736631594822 + 0.7292398258852378.*New_chi - 0.17951815090296652.*New_chi.^2 + 0.01982701480205563.*New_chi.^3 - 0.0008171081897105175.*New_chi.^4 + 1.8339439276641656.*tanh(0.91.*New_chi);

yi_prime=G1.*exp(1i.*G2);

Yi=F2_VPP./F2_10V.*yi_prime;


%% yd

vrectfun =  3.069981715829813 + 0.06248514679413549.*vpp + 0.04681196334146159.*vpp.^2 - 0.002436325220160285.*vpp.^3 + 0.00004692674475799567.*vpp.^4;
delta = (vrectfun).^(3/4);
zinvd = -1i.*omega_hat./delta;
Yd=zinvd;

%% ye
Ye= 1.4912697017617276 - 0.39149171343072803.*exp(-vpp) - 0.35029055741496556.*vpp + 0.04370283762859965.*vpp.^2 - 0.0029806529060161235.*vpp.^3 + 0.00010448291016092317.*vpp.^4 - 1.4687221698127053e-6.*vpp.^5;

%% TOTAL ADMITTANCE

ytot = Yi + Yd + Ye;
ytot=ytot(:,1);

%% ytot and ztot

ztot=1./ytot;
Real_zsh=real(max(ztot));
Imag_zsh=imag(max(ztot));


%% Epsilon and Sigma Calculations

DataOut(:,1)=-(imag(ytot)./omega_hat).*(Inputs.d./thick_debye); %epsilon
Epsilon(:,1)=Inputs.X;
Epsilon(:,2)=Inputs.Y;
% Epsilon(:,1)=real(LayerData(:,1));
% Epsilon(:,2)=real(LayerData(:,2));
Epsilon(:,3)=DataOut(:,1);

DataOut(:,2)=epsilon_0org.*omegapi.*(Inputs.d./thick_debye).*real(ytot); %sigma
Sigma(:,1)=Inputs.X;
Sigma(:,2)=Inputs.Y;
% Sigma(:,1)=real(LayerData(:,1));
% Sigma(:,2)=real(LayerData(:,2));
Sigma(:,3)=DataOut(:,2);

%% print txt files for COMOSL

% fileID=fopen('SheathLayerEps1.txt','w');
% fprintf(fileID,'%f,%f,%f',Epsilon);
% fclose(fileID);


%%
%DISPLACEMENT ADMITTANCE

function zinvd=fdcmplxANY1(omega_hat,vpp)
delta = (vrectfun1(vpp)).^(3/4);
zinvd = -complex(0,1)*omega_hat/delta;


function vrectfun=vrectfun1(vpp)
vrectfun =  3.069981715829813 + 0.06248514679413549.*vpp + 0.04681196334146159.*vpp.^2 - 0.002436325220160285.*vpp.^3 + 0.00004692674475799567.*vpp.^4;
end

end


%ELECTRON ADMITTANCE

function fecmplxANY=fecmplxANY1(vpp)
fecmplxANY= 1.4912697017617276 - 0.39149171343072803*exp(-vpp) - 0.35029055741496556.*vpp + 0.04370283762859965.*vpp.^2 - 0.0029806529060161235.*vpp.^3 + 0.00010448291016092317.*vpp.^4 - 1.4687221698127053e-6.*vpp.^5;
end


