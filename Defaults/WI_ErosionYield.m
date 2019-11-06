%Coded by Josh Beers for ORNL use

%Use python 3.7/3.8 to run MPEX_W_sub_calc.py to produce WI photon flux
%output (LPN_WI_Smooth)
%Uses Abrams, 2018 paper with the two filter method to get the photon flux
%for a specific line of interest (W I 400.9 for this case)

%Use LPN_WI_Smooth times the S/XB (5 for helicon only and 15 with ECH)
%over the plasma flux to get sputtering yield

%cleanup
%Begin Code
%% Initialize variables

PLOTLPN=1;
PLOTSXB=0;
PLOTEYIELD=1;
PLOTSYIELD=1;

Shot=26300; %USER changes this to desired Shot

PATHNAME=['WI_',num2str(Shot),'.mat'];
FILENAME=['C:\Users\cxe\Documents\Proto-MPEX\Filterscopes\W I Filters\'];
FILE=[FILENAME PATHNAME];

load(FILE)
%Line_Norm_Rad in Ph/s/sr/cm2


%% Data Analysis
%Line Normalized Radiance into photon flux
PhotonFlux=Line_Norm_Rad_Smooth*4*pi*1e4; %Photons/s/m2

%S/XB values and mapped in time
SXB_Hel=5;
IonFlux_Hel=3e23; %@/m2/s
SXB_ECH=15;
IonFlux_ECH=4.3e23; %@/m2/s
ECH_start=4.68; %s
ECH_end=5.02; %s

SXB=zeros(1,62500);
IonFlux=zeros(1,62500);

SXB(Time>ECH_start & Time<ECH_end)= SXB_ECH;
IonFlux(Time>ECH_start & Time<ECH_end)= IonFlux_ECH;
SXB(Time<ECH_start | Time>ECH_end)= SXB_Hel;
IonFlux(Time<ECH_start | Time>ECH_end)= IonFlux_Hel;

%Sputtering yield
ErosionYield=PhotonFlux.*SXB;
SputterYield=ErosionYield./IonFlux; %@/ion

%% Plots

if PLOTLPN==1
    figure
    plot(Time, PhotonFlux, 'k')
    xlabel('Time [s]')
    ylabel('W I Photon Flux [Photons/s/m^{2}]')
    ylim([0 inf])
    
end

if PLOTSXB==1
    figure
    plot(Time, SXB, 'k')
    xlabel('Time [s]')
    ylabel('S/XB Value [A.U.]')
    ylim([0 inf])
end

if PLOTEYIELD==1
    figure
    plot(Time, ErosionYield, 'k')
    xlabel('Time [s]')
    ylabel('W I Photon Flux x S/XB [Ph/s/m^{2}]')
    ylim([0 inf])
end

if PLOTSYIELD==1
    figure
    plot(Time, SputterYield, 'k')
    xlabel('Time [s]')
    ylabel('W I Sputter Yield [at./ion]')
    ylim([0 inf])
end
    
