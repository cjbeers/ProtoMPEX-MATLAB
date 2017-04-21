clc
close all
clear all

%*******************
%Universal constants
%*******************
c=2.9979e8;

%*****************************
%Define the parent folder path
%*****************************
PATH=pwd;
for ii=length(PATH):-1:1
    if strcmpi(PATH(ii),filesep)==1
        PATH=PATH(1:ii-1);
        
        break
    end
end

%****************************
%Path pointing to subroutines
%****************************
PATH_SUB=[PATH filesep 'SUBROUTINES'];
PATH_PLOT=[PATH filesep 'PLOTTING ROUTINES'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%  SET THE DFSS OPTIONS  %%%%%%%%%%%%%%%%%%%%%%%%%

OPT.PARALLEL.PAR_LOGIC=1;                                 %Number of workers
OPT.PARALLEL.NAP=24;                                      %Number of workers

OPT.GENERAL.INTER=0;                                      %Interactive mode logic
OPT.GENERAL.DIMENSION=1;                                  %Dimensionality of integration

OPT.ATOMIC.ATOM='H';                                      %Atom of interest

OPT.ATOMIC.NT_0=2;                                        %Number of transitions
OPT.ATOMIC.A_0=[5e5 1e4];                                 %Transition probabilites
OPT.ATOMIC.NU_0=c/6563.79e-10+[-0.8 0.8]*1e9;             %Frequency of transitions

OPT.ATOMIC.G=1;                                           %Ratio of upper to lower statistical weights

OPT.ATOMIC.N=1e17;                                        %Ground state density
OPT.ATOMIC.KT=.06;                                         %Temperature of absorbers

OPT.SIGHTLINE.NXD=1;                                      %Number of spatial discretizations
OPT.SIGHTLINE.WIDTH=0.10;                                 %Active laser path length
OPT.SIGHTLINE.WIDTH_LOGIC=0;                              %Logic for self consistent width calculation

OPT.LASER.NFP=2001;                                       %Number of frequency discretizations
OPT.LASER.NU_MODE='AUTO';                                 %Frequency discretization mode (AUTO or MANUAL)
OPT.LASER.NU_WIN=c/6563.79e-10+[-5e9,5e9];                %Frequency window - AUTO
OPT.LASER.NU_MAN=c/6563.79e-10+[-0.8e9 0e9 0.8e9];        %Manual frequency points - MANUAL

OPT.LASER.PU.P_0=0.007;                                   %Laser pump beam power
OPT.LASER.PR.P_0=0.001;                                   %Laser probe beam power

OPT.LASER.PU.AREA=pi*.0005^2;                             %Laser pump beam area
OPT.LASER.PR.AREA=pi*.0005^2;                             %Laser probe beam area

OPT.LASER.PU.DIRECTION=[1 0.04];                          %Laser pump beam direction
OPT.LASER.PR.DIRECTION=[-1 0];                            %Laser probe beam direction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%*************
%Add main path
%*************
addpath(PATH)

%*********************************************
%Turning off the plotting (user control below)
%*********************************************
OPTIONS.PLOT.GEO=0;                          
OPTIONS.PLOT.INT=0;
OPTIONS.PLOT.SAT=0;
OPTIONS.PLOT.POP_DEN=0;                        

%**************************
%Calc. Doppler free spectra
%**************************
OPT.GENERAL.MODE='BOTH';                            
[DATA_BOTH,SPACE,FREQ,PARA]=DFSSS(OPT);

if isempty(DATA_BOTH)==1 || isempty(SPACE)==1 || isempty(FREQ)==1 || isempty(PARA)==1 
    return
end

%*******************************
%Calc. Doppler broadened spectra
%*******************************
OPT.GENERAL.MODE='PROBE';                            
[DATA_PROBE,~,~,~]=DFSSS(OPT);

if isempty(DATA_PROBE)==1
    return
end

%****************
%Remove main path
%****************
rmpath(PATH)

%%

%*****************
%Add plotting path
%*****************
addpath(PATH_SUB);
addpath(PATH_PLOT);

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %%%%%%%%%%%%  SET THE PLOTTING OPTIONS  %%%%%%%%%%%%

PLOT.GEO=0;                %Logic to control laser beam geometry plotting
PLOT.INT=1;                %Logic to control laser beam absorption plotting
PLOT.SAT=0;                %Logic to control laser beam saturation plotting
PLOT.POP_DEN=0;            %Logic to control population density plotting

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%**********************
%PLot the beam geometry
%**********************
if PLOT.GEO==1
    PLOT_GEO(PARA);
end

%***********************
%Plot the beam intensity
%***********************
if PLOT.INT==1
    PLOT_INT(DATA_BOTH,SPACE,FREQ,PARA)
end

%*******************
%Plot the saturation 
%*******************
if PLOT.SAT==1
    PLOT_SAT(DATA_BOTH,SPACE,FREQ,PARA)
end

%***************************
%Plot the population density
%***************************
if PLOT.POP_DEN==1
    PLOT_POP_DEN(DATA_BOTH,SPACE,FREQ,PARA)
end

%%

%********************
%Remove plotting path
%********************
rmpath(PATH_SUB);
rmpath(PATH_PLOT)

%%

%*************************************************************
%Normalization logic ~ 0 -> photons/s                       **
%                      1 -> percent absorption              **
%*************************************************************
NORM_LOG=1;

%*************************************************************
%X-axis units ~ frequency  -> resonant deturning frequency  **
%               wavelength -> transition wavelength         **
%************************************************************* 
UNITS_LOG='frequency';

%*********************
%Assign intensity data
%*********************
I_PU_PR=DATA_BOTH.I_PR;
I_PR=DATA_PROBE.I_PR;

NXP=SPACE.NXP;
X=SPACE.X;

NFP=FREQ.NFP;
NU=FREQ.NU;

%**********************************************************
%Calc. the resonant detuning frequncy (centered about zero)
%**********************************************************
NU_RDT=NU-(NU(1)+NU(NFP))/2;

%******************** 
%Calc. the wavelength
%********************
WAVE=c./NU;

%********************
%Normalization factor
%********************
if NORM_LOG==0
    NORM=1;
    UNITS='\gamma/s';
elseif NORM_LOG==1
    NORM=max(max(DATA_BOTH.I_PR))/100;
    UNITS='%';
end

%**************************
%Calc. Doppler-free profile
%**************************
I_DFSS(1:NFP)=(I_PU_PR(1:NFP,NXP)-I_PR(1:NFP,NXP))/NORM;

figure 
if strcmpi(UNITS_LOG,'frequency')==1
    plot(NU_RDT/1e9,I_DFSS,'-b','LineWidth',5)
    xlabel('Resonant Detuning Frequency (GHz)','FontSize',38)
elseif strcmpi(UNITS_LOG,'wavelength')==1
    plot(WAVE*1e10,I_DFSS,'-b','LineWidth',5)
    xlabel(['Wavelength (' char(197) ')'],'FontSize',38)
end
grid on
ylabel(['Absorption Signal (' UNITS ')'],'FontSize',38)
title(['Absorption Length ' num2str(X(NXP)*1000) ' (mm)'],'FontSize',38,'FontWeight','Normal')
set(gca,'FontSize',38)
