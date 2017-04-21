%% Code README
%Coded by: Josh Beers
%ORNL

%This code finds the target flux, heat flux, and fluence using an assumed 
%sheath power transmission coefficient and ion temperature for a single 
% USER input shot.

%If using MaxQValues will need the correct shot number to the corresponding
%no DLP IR image for calculating SHTC and IR camera Q values. The IR
%camera's focus can change shot to shot and may need to be fine tuned. The
%MaxDeltaT_Pic can be used to quickly see the IR image for a given shot
%number. 
%-------------------------------------------------------------------------%
%% Start code

cleanup

shotlist = [12451]; %USER defines the shot number
DLPType='9'; %USER needs to review shot notes to figure out which probe...
%was used or find out from Nishal for accuracy
%}
PlotFlux=0;
FINDMAXQ=0;
FINDSTC=0;

%Calls Juan and Nishal's DLP fitting routine that creates the Te and Ne profiles
DLP_v5

%% Heat and Particle Flux
Te=cell2mat(Te);  %Array for Te (eV)
Ne=cell2mat(Ni);  %Array for Ni (Bulk Density) (1/m3)
Time=cell2mat(time);
ez=size(Te);
z=ez(1,2);

Te_K=Te1*11604.3;  % 11604.3 K/eV
k_b=8.6173324E-5; %eV/K
m_i=2*((931.5E6)/(2.998E8)^2); %eV/c^2
%For now the USER inputs Ti, eventually want code to find this
Ti=5; %eV
Std_Ti=0; 
Ti_K=Ti*11604.3; %Ion Temp. in K
y=3; %3 for 1D adiabatic flow, 1 for isothermal flow
ye=5.5; %sheath transmission factor for electrons
yt=1.5; %sheath transmission factor for ions
corfactor=1.602E-19; %Joules to eV
%Gamma_se = Flux to sheath entrance
%Heat Flux from Ne and Ni

for i=1:z

Gamma_se(1,i)=0.5*Ne(1,i)*((((k_b)*(Te(1,i)+y*Ti_K))/(m_i)).^0.5); %(1/(m^2*s^1))
Std_Gamm_se(1,i)=((k_b*Ne(1,i)^2*Std_Te^2)/(16*m_i*(Te(1,i) + Ti_K*y)) + (k_b*(Te(1,i) + Ti_K*y)*Std_Ne^2)/(4*m_i))^(1/2);
HeatFlux(1,i)=((ye*Gamma_se(1,i)*(Te(1,i)/11604.3)+yt*Gamma_se(1,i)*(Ti_K/11604.3))*corfactor)/1E6; %(MW/m^2)

%Table{1,1}='Position';
Table(i,1)=Time(1,i);
%Table{1,2}='Gamma_se'; 
Table(i,2)=Gamma_se(1,i); 
%Table{1,3}='HeatFlux'; 
Table(i,3)=HeatFlux(1,i);
end


formatPrint='Ti = %1.4g\n';
fprintf(formatPrint, Ti)

%Gamma_seAVG=Flux (1/m2s)
Gamma_seAVG=0.5*Ne1*((((k_b)*(Te_K+y*Ti_K))/(m_i)).^0.5); %(1/(m^2*s^1))
Gamma_seAVGTiTe=0.5*Ne1*((((k_b)*(Te_K+y*Te_K))/(m_i)).^0.5); %(1/(m^2*s^1))
Std_Gamma_seAVG=((k_b*Ne1^2*Std_Te^2)/(16*m_i*(Te_K + Ti_K*y)) + (k_b*(Te_K + Ti_K*y)*Std_Ne^2)/(4*m_i))^(1/2);

%Gamma_seAVG_std=Gamma_seAVG*sqrt((Ne_

HeatFluxAVG=((ye*Gamma_seAVG*(Te_K/11604.3)+yt*Gamma_seAVG*(Ti_K/11604.3))*corfactor)/1E6; %(MW/m^2)
Std_HeatFluxAVG=((Std_Gamma_seAVG^2*corfactor^2*((274877906944*Te_K*ye)/3189765695550259 + (274877906944*Ti_K*yt)/3189765695550259)^2)/1000000000000 + (18446744073709551616*Gamma_seAVG^2*Std_Te^2*corfactor^2*ye^2)/2484034470827448141707225333760009765625)^(1/2);
HeatFluxTiTe=((ye*Gamma_seAVG*(Te_K/11604.3)+yt*Gamma_seAVG*(Te_K/11604.3))*corfactor)/1E6; %(MW/m^2)
Std_HeatFluxTiTe=((Std_Te^2*corfactor^2*((274877906944*Gamma_seAVG*ye)/3189765695550259 + (274877906944*Gamma_seAVG*yt)/3189765695550259)^2)/1000000000000 + (Std_Gamma_seAVG^2*corfactor^2*((274877906944*Te_K*ye)/3189765695550259 + (274877906944*Te_K*yt)/3189765695550259)^2)/1000000000000)^(1/2);

formatPrint='Flux = %1.4g\n';
fprintf(formatPrint, Gamma_seAVG)
formatPrint='Flux Std = %1.4g\n';
fprintf(formatPrint, Std_Gamma_seAVG)
formatPrint='HeatFluxAVG = %1.4g\n';
fprintf(formatPrint, HeatFluxAVG)
formatPrint='HeatFluxAVG Std = %1.4g\n';
fprintf(formatPrint, Std_HeatFluxAVG)
formatPrint='HeatFluxTiTe = %1.4g\n';
fprintf(formatPrint, HeatFluxTiTe)
formatPrint='Std of HeatFlux when Ti=Te = %1.4g\n';
fprintf(formatPrint, Std_HeatFluxTiTe)
%% Plotting

if PlotFlux==1

figure()
subplot(2,1,1); hold on
plot(Table(:,1),Table(:,3));
ax = gca;
ax.FontSize = 13;
title('Heat Flux vs. Time','FontSize',12);
xlabel('Time [s]','FontSize',13);
ylabel('Heat Flux [MW/m^{2}]','FontSize',13);
ylim([0,inf]);

subplot(2,1,2);
plot(Table(:,1),Gamma_se);
ax = gca;
ax.FontSize = 13;
title('Particle Flux vs. Time','FontSize',12);
xlabel('Time [s]','FontSize',13);
ylabel('Particle Flux [1/m^{2}s]','FontSize',13);
ylim([0,inf]);
hold off
%
end

%% Fluence Calc.
Fluence = trapz(Table(:,1), Gamma_se); % (Total Particles/m^{2})
formatFluence='Fluence = %1.4e\n';
fprintf(formatFluence, Fluence)
if Fluence <0
    disp('Error with Fluence')
end

%% Average Heat Flux
%Calls MaxQValues script to run IR camera information and use ROIs to get Q
%value
if FINDMAXQ==1
MaxQValues

close all
end
%% Total Sheath Transmision Coefficient
if FINDSTC==1
format short

syms vv
Ti_K=0;
eqnv = QROI==((vv*Gamma_seAVG*(Te_K/11604.3)+yt*Gamma_seAVG*(Ti_K/11604.3))*corfactor)/1E6;

solv=solve(eqnv,vv);
SHTC_Ti0=vpa(solv,5); %Displays total sheath transmission coefficient, Ti=0
Std_SHTC_Ti0=(Std_Gamma_seAVG^2*((49840088992972796875*(QROI - (4294967296*Gamma_seAVG*Ti_K*corfactor*yt)/49840088992972796875))/(4294967296*Gamma_seAVG^2*Te_K*corfactor) + (Ti_K*yt)/(Gamma_seAVG*Te_K))^2 + (Std_Ti^2*yt^2)/Te_K^2 + (2484034470827448141707225333760009765625*Std_Te^2*(QROI - (4294967296*Gamma_seAVG*Ti_K*corfactor*yt)/49840088992972796875)^2)/(18446744073709551616*Gamma_seAVG^2*Te_K^4*corfactor^2))^(1/2);
formatPrint='SHTC_Ti0 = %1.4g\n';
fprintf(formatPrint, SHTC_Ti0)
formatPrint='Std of SHTC for Ti=0 = %1.4g\n';
fprintf(formatPrint, Std_SHTC_Ti0)

syms ww
Ti_K=(1/40);
eqnw = QROI==((ww*Gamma_seAVG*(Te_K/11604.3)+yt*Gamma_seAVG*(Ti_K/11604.3))*corfactor)/1E6;

solw=solve(eqnw,ww);
SHTC_TiRT=vpa(solw,5); %Displays electron sheath transmission coefficient 
Std_SHTC_TiRT=(Std_Gamma_seAVG^2*((49840088992972796875*(QROI - (4294967296*Gamma_seAVG*Ti_K*corfactor*yt)/49840088992972796875))/(4294967296*Gamma_seAVG^2*Te_K*corfactor) + (Ti_K*yt)/(Gamma_seAVG*Te_K))^2 + (Std_Ti^2*yt^2)/Te_K^2 + (2484034470827448141707225333760009765625*Std_Te^2*(QROI - (4294967296*Gamma_seAVG*Ti_K*corfactor*yt)/49840088992972796875)^2)/(18446744073709551616*Gamma_seAVG^2*Te_K^4*corfactor^2))^(1/2);
formatPrint='SHTC_TiRT = %1.4g\n';
fprintf(formatPrint, SHTC_TiRT)
formatPrint='Std of SHTC for Ti=Room Temp. = %1.4g\n';
fprintf(formatPrint, Std_SHTC_TiRT)

syms xx
Ti_K=Te_K;
eqnx = QROI==((xx*Gamma_seAVG*(Te_K/11604.3)+yt*Gamma_seAVG*(Ti_K/11604.3))*corfactor)/1E6;

solx=solve(eqnx,xx);
SHTC_TiTe=vpa(solx,5); %Displays electron sheath transmission coefficient
Std_SHTC_TiTe=(Std_Gamma_seAVG^2*((49840088992972796875*(QROI - (4294967296*Gamma_seAVG*Ti_K*corfactor*yt)/49840088992972796875))/(4294967296*Gamma_seAVG^2*Te_K*corfactor) + (Ti_K*yt)/(Gamma_seAVG*Te_K))^2 + (Std_Ti^2*yt^2)/Te_K^2 + (2484034470827448141707225333760009765625*Std_Te^2*(QROI - (4294967296*Gamma_seAVG*Ti_K*corfactor*yt)/49840088992972796875)^2)/(18446744073709551616*Gamma_seAVG^2*Te_K^4*corfactor^2))^(1/2);
formatPrint='SHTC_TiTe = %1.4g\n';
fprintf(formatPrint, SHTC_TiTe)
formatPrint='Std of SHTC for Ti=Te = %1.4g\n';
fprintf(formatPrint, Std_SHTC_TiTe)

% Ion Temperature Calculations

syms zz
eqnz = QROI==((ye*Gamma_seAVG*(Te_K/11604.3)+yt*Gamma_seAVG*(zz/11604.3))*corfactor)/1E6;

solz=(solve(eqnz,zz))/11604.3;
Ti_calc=vpa(solz,5);
Std_Ti=(Std_Gamma_seAVG^2*((1000000*(QROI - (4294967296*Gamma_seAVG*Te_K*corfactor*ye)/49840088992972796875))/(Gamma_seAVG^2*corfactor*yt) + (274877906944*Te_K*ye)/(3189765695550259*Gamma_seAVG*yt))^2 + (75557863725914323419136*Std_Te^2*ye^2)/(10174605192509227588432794967081*yt^2))^(1/2);
formatPrint='Ti = %1.4g\n';
fprintf(formatPrint, Ti_calc)
formatPrint='Std of Ti = %1.4g\n';
fprintf(formatPrint, Std_Ti)
end