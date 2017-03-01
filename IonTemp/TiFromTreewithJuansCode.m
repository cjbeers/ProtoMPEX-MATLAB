clear all
clc

%{
SHOT = 9001;
[~,~]=mdsopen('MPEX',SHOT)
[Snote, ~] = mdsvalue('\MPEX::TOP.SHOT_NOTE')
[KTE,~]=mdsvalue('\MPEX::TOP.ANALYZED.DLP:KTE');
[NE,~]=mdsvalue('\MPEX::TOP.ANALYZED.DLP:NE');
[Time,~]=mdsvalue('DIM_OF(\MPEX::TOP.ANALYZED.DLP:KTE)');
%}

%{
prompt = 'Starting Shot Number? ';
j = input(prompt);
%USER innputs Shot number
%}
Shots=9330;

%Calls Nishals's DLP fitting routine that creates the Te and Ne profiles
DLP_fitting
NOTE{1,1,1};

Te=cell2mat(Te);  %Array for Te (eV)
Ne=cell2mat(Ni);  %Array for Ni (Bulk Density) (1/m3)
Time=cell2mat(time);
ez=size(Te);
z=ez(1,2);

Te=Te*11604.3;  % 11604.3 K/eV
k_b=8.6173324E-5; %eV/K
m_i=2*((931.5E6)/(2.998E8)^2); %eV/c^2
%For now the USER inputs, eventually want code to find this
Ti=2.5*11604.3; %K
y=3; %3 for 1D adiabatic flow, 1 for isothermal flow
corfactor=1.602E-19; %Joule/eV

for i=1:z

Gamma_se(1,i)=0.5*Ne(1,i)*((((k_b)*(Te(1,i)+y*Ti))/(m_i)).^0.5); %(1/(m^2*s^1))
HeatFlux(1,i)=((5.5*Gamma_se(1,i)*(Te(1,i)/11604.3)+1.5*Gamma_se(1,i)*(Ti/11604.3))*corfactor)/1E6; %(MW/m^2)

%Table{1,1}='Position';
Table(i,1)=Time(1,i);
%Table{1,2}='Gamma_se'; 
Table(i,2)=Ne(1,i); 
%Table{1,3}='HeatFlux'; 
Table(i,3)=HeatFlux(1,i);
end

%
figure;
plot(Table(:,1),Table(:,3));
ax = gca;
ax.FontSize = 15;
title('HeatFlux vs. Time)','FontSize',15);
xlabel('Time (s)','FontSize',15);
ylabel('HeatFlux (Mw/m2)','FontSize',15);
%}

%
figure;
plot(Table(:,1),Gamma_se);
ax = gca;
ax.FontSize = 15;
title('Flux vs. Time)','FontSize',15);
xlabel('Time (s)','FontSize',15);
ylabel('IonFlux (Ions/m2s)','FontSize',15);
%}