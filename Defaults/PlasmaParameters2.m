
%% Plasma Parameters, conditions, and theory of plasma behaviors
%Coded by Josh Beers for UTK Fusion classes and use at ORNL
%Info comes from NRL plasma formulary unless otherwise stated 

%cleanup;
format shorte;

%% Initialize input variables

N_e=2.5E19; %1/m^3 %Plasma density
%N_e=Ni{1,1};
N_e_std=1.39E18; %1/m^3 %Standard deviation of plasma density

T_e_eV=5; %eV %Plasma electron temperature
%T_e_eV=Te{1,1};
T_e_eV_std=0.1; %Plasma electron temperature standard deviation

T_i_eV=5; %eV %Plasma ion temperature
T_i_eV_std=0.1; %eV %Plasma ion temperature standard deviation

theta=89; %deg % Incoming angle from target normal to mangetic field direction from Stangeby
B=0.75; %T %Magnetic field in Tesla
Z=1; %Charge state of ion
y=1; %Gamma value %Ratio of Masses
y_e=1; %3 for 1D adiabatic flow, 1 for isothermal flow %Adiabatic index (1+2n) where n is the degree of freedom
y_i=3; %ions adiabatic and electrons isothermal
SHTF_e=5.5; %sheath transmission factor for electrons
SHTF_t=1.5; %sheath transmission factor for ions
As=0.00026; %m^-2 surface area of collecting probe

A1=183; %Ion 1
A2=4; %Ion 2
n_e=N_e*(1/100)^3; %cm-3
Z1=1;
Z2=2;
logA=12; % ln(A) from Sprizer
T1=10*11604; % K, (converted from eV)
T2=2*11604; 

%% Constants
e=1.602E-19; %J to eV, also elementary charge
k_b=1.3807E-23; %J/K %Boltzman Constant
m_e=0.51e6/(3.0E8)^2; %eV %Mass of electron
m_e_kg=9.1094E-31; %kg %Mass of electron
m_p=938.27e6/(3.0E8)^2; %eV %Mass of proton
m_p_kg=1.6726E-27; %kg %Mass of proton
m_D=2*m_p; %eV %Mass of D ion
m_D_kg=3.34E-27; %kg %mass of D ion
m_He_kg=6.64424E-27; %kg %mass of alpha particle
m_W_kg=3.0527348E-25; %kg %mass of W atom
h=6.6261E-34; %J/s %Planck constant
c=2.9979E8; %m/s %Speed of sound in a vacuum
epsilon_0org=8.854E-12;  %F/m or C^2/J or s^2*C^2/m^3*kg %Permittivity of free space
epsilon_0=epsilon_0org*e; %C^2/eV %Permittivity of free space
eV_2_K=e/k_b; %K %Conversion from eV to Kelvin
K_2_eV=k_b/e; %eV %Conversion from Kelvin to eV

%Basic Quantities

lambda_1eV=h*c/e; %m %Wavelength associated with 1 eV
omega_1eV=e/h; %1/s = Hz % 
unitmass=m_D_kg/m_p_kg; %Dimensionless %Unit Mass

T_e_K=T_e_eV*eV_2_K; %K %electron temp. in Kelvin
T_e_K_std=T_e_eV_std*eV_2_K; %K %electron temp. standard deviation in Kelvin
T_i_K=T_i_eV*eV_2_K; %K %electron temp. in Kelvin
T_i_K_std=T_i_eV_std*eV_2_K; %K %electron temp. standard deviation in Kelvin

c_s= sqrt(((y_e*T_e_eV)+(y_i*T_i_eV))/m_D); %m/s %Sound speed from Chen2015 4.41

lambda=12*pi*(((epsilon_0*T_e_eV)^3)/(N_e*e^6))^(1/2);
lnlambda=log(lambda);

%% Frequencies

omega_ce=sqrt((N_e*e^2)/(m_e_kg*epsilon_0org)); %rad/s %Plasma electron gyro frequency Chen2015 3.2
% omega_ce=-1.76E11*0.75; %rad/s %from Stacey2010
freq_ce=omega_ce/(2*pi); %Hz %Electron gyrofrequency

omega_ci=sqrt((N_e*e^2)/(m_W_kg*epsilon_0org)); %rad/s %Plasma ion gyro frequency Chen2015 3.2
%omega_ci=0.96E8*0.75; %rad/s %from Stacey2010
freq_ci=omega_ci/(2*pi); %Hz %Ion gyrofrequency

omega_tot=sqrt((N_e*e^2)/(m_e_kg*epsilon_0org)+(N_e*e^2)/(m_p_kg*epsilon_0org)); %rad/s %Chen2015 4.25
freq_tot=omega_ci/(2*pi); %Hz %Total Plasma gyrofrequency

%% Lengths

%Electron Lamar radius
Gyro_e=1.066E-4*sqrt((T_e_eV/1000)/B); %m %Stacey2010

%Ion Lamar radius
Gyro_i= 4.57E-3*sqrt((A1*T_e_eV/1000)/(Z*B)); %m %Stacey2010

%Debye sheath thickness
thick_debye=sqrt((epsilon_0*T_e_eV)/(N_e*e^2)); %m %Chen2015

%Magnetic presheath thickness
thick_mps=sqrt(6)*(c_s/omega_ci)*sind(theta); %m %From Stangeby 2.112
% x=[0:0.1:90];
% thick_mps=sqrt(6)*(c_s/omega_ci)*sind(x);
% plot(x,thick_mps)

TimeInSheath=1/(c_s/(thick_debye+thick_mps)); %s
FracGyroInSheath=TimeInSheath*freq_ci; %assumes sound speed for ions even in sheath
GyroLengthInSheath=FracGyroInSheath*Gyro_i; %m %a radius value

%% Interaction times

%Capital Lambda used in equations
lambda=12*pi*(((epsilon_0*T_e_eV)^3)/(N_e*e^6))^(1/2);
lnlambda=log(lambda);

% Species interaction times
time_pp=(6*sqrt(6)*pi*sqrt(m_p)*(epsilon_0)^2*(T_e_eV)^(3/2))/(N_e*e^4*log(lambda));
time_pe=(6*sqrt(3)*pi*sqrt(m_e)*(m_p/m_e)*(epsilon_0)^2*(T_e_eV)^(3/2))/(N_e*e^4*log(lambda));
time_ee=(6*sqrt(6)*pi*sqrt(m_e)*(epsilon_0)^2*(T_e_eV)^(3/2))/(N_e*e^4*log(lambda));
time_ei=(6*sqrt(3)*pi*sqrt(m_e)*(epsilon_0)^2*(T_e_eV)^(3/2))/(N_e*e^4*log(lambda));

%Equilibrium timing or relaxation timings
time_eq=5.87*((A1*A2)/(n_e*Z1^2*Z2^2*logA))*((T1/A1+T2/A2)^(3/2));

%collisional frequency
cf_H=(e^4*lnlambda*N_e)/(4*pi*epsilon_0^2*m_p^(1/2)*T_e_eV^(3/2));
cf_He=(e^4*lnlambda*N_e)/(4*pi*epsilon_0^2*m_D^(1/2)*T_e_eV^(3/2));
cf_He=(e^4*lnlambda*N_e)/(4*pi*epsilon_0^2*m_D^(1/2)*T_e_eV^(3/2));

%Electron and ion collision rate in completely ionizd plasmas for Helium
ecr_He2= 2.91E-6*N_e*lnlambda*T_e_eV^(-3/2);
icr_He2= 4.8E-8*unitmass*Z*lnlambda*T_e_eV^(-3/2);

%% Potentials

%Floating potential
eV_sf=T_e_eV*0.5*log((2*pi*m_e/m_D)*(1+T_i_eV/T_e_eV)); %eV

eV_mps=-T_e_eV*log(cosd(theta)); %eV %Energy from the magnetic presheath from stangeby 2.109

eV_ps=-0.7*T_e_eV; %eV %Presheath energy from Chen2015

eV_sf_ps=3*T_e_eV-eV_ps; %eV %Combined sheath and presheath voltage from unknown, also plasma potential

Ef_mps=eV_mps/thick_mps; %electric field E_mps from potential drop and the length of the MPS. from Schmid 2010

MachNum=(2*pi*(m_e/m_D)*(1+(T_i_eV/T_e_eV)))^(-1/2)*sind(theta); %Ding 2016

% I_es=93; % electron saturation current
% I_is=88; % ion saturation current
% eV_pp=eV_sf_ps+T_e_eV*log(I_es/I_is); %plasma potential

%% Fluxes

%Gamma_se=Particle flux to target=0.61*n_e*c_s from Chen
Gamma_se=0.61*N_e.*c_s; %(1/(m^2*s^1))
Gamma_se_std=0.61*N_e.*((((T_e_eV_std+y*T_i_eV_std))/(m_D)).^0.5); %(1/(m^2*s^1))
HeatFlux=Gamma_se*4*e*T_e_eV; %W/m^2

%Currents
Ie=e*N_e*0.6*As*c_s; %C/s = Amps

eV_impact=2*T_i_eV+3*Z*T_e_eV; %Ion impact energy [eV]

%% Sputtering

%Borodkina 2015, data done via SPICE2 simulation in paper
alpha=45; %0=normal to wall surface
m_i_kg=3.0527348e-25 ;
lambda_mps=log(cosd(alpha));
lambda_w=(1/2)*log(2*pi*(m_e_kg/m_i_kg)*((T_e_eV+T_i_eV)/T_e_eV)); %floating potential at the wall
rho=Gyro_i/thick_debye;
delta_n=lambda/(rho*sind(alpha))^2;
epsilon=0.01/thick_debye;

%a and Q are parameters for the boundary condition, C1 is a constant, 
C1=-delta_n*lambda_mps-6*cosd(alpha);
a=(sqrt(-delta_n*lambda_mps)-sqrt(2*exp(lambda_w)+4*cosd(alpha)*sqrt(1-(lambda_w-lambda_mps))+C1))/(lambda_w-lambda_mps);
Q=(1/a)*sqrt(2*exp(lambda_w)+4*cosd(alpha)*sqrt(1-(lambda_w-lambda_mps))+C1);
lambda_epsilon=lambda_w+Q-Q*exp(-a*epsilon); %electric field potential in the magnetic pre-layer

%% 

