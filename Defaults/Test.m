
Ne=4e19;
Te1=2;
Te=Te1;

Te_K=Te1*11604.3;  % 11604.3 K/eV
k_b=8.6173324E-5; %eV/K
m_i=2*((931.5E6)/(2.998E8)^2); %eV/c^2
%For now the USER inputs Ti, eventually want code to find this
Ti=Te; %eV
Std_Ti=0; 
Ti_K=Ti*11604.3; %Ion Temp. in K
y=3; %3 for 1D adiabatic flow, 1 for isothermal flow
ye=5.5; %sheath transmission factor for electrons
yt=1.5; %sheath transmission factor for ions
corfactor=1.602E-19; %Joules to eV
%Gamma_se = Flux to sheath entrance

Gamma_se=0.61*Ne.*((((k_b)*(Te+y*Ti_K))/(m_i)).^0.5) %(1/(m^2*s^1))
