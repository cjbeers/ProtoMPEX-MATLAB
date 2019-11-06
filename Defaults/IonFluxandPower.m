
Ne=7E19;
ne_std=1E19;
Te=2;
Te_std=0.2;
Ti=11;

e=-1.602E-19;  %C
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

Gamma_se=0.8*Ne.*((((k_b)*(Te_K+y*Ti_K))/(m_i)).^0.5) %(1/(m^2*s^1))
Gamma_se_std=0.8*Ne.*((((k_b)*(Te_K_std+y*Ti_K_std))/(m_i)).^0.5)%(1/(m^2*s^1)) standard deviation 
HeatFlux=Gamma_se*4*-e*Te
