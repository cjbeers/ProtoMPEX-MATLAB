clc
close all
clear all

%*******************
%Universal constants
%*******************
c=2.9979e8;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>        FIT OPTIONS     <><><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%********************
%Number of iterations
%********************
FIT_OPT.NI=3;

%********************************************************
%Number of discretizations for the SIG and GAM parameters
%********************************************************
FIT_OPT.ND_SIG=20;
FIT_OPT.ND_GAM=20;

%***********************************************************
%Scales the max boundary for the SIG and GAM parameter space
%***********************************************************
FIT_OPT.SIG_FACTOR=2.0;
FIT_OPT.GAM_FACTOR=2.0;

%***********************************************************
%Scales the max and min boundaries of the x-grid for the fit 
%***********************************************************
FIT_OPT.GRID_FACTOR=1;

%************************************************
%Number of points associated with fitted spectrum
%************************************************
FIT_OPT.NP=500;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>        FIT OPTIONS     <><><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>       SPEC SIM OPTIONS     <><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
              
OPT.PARALLEL.PAR_LOGIC=1;                                 %Number of workers
OPT.PARALLEL.NAP=24;                                      %Number of workers

OPT.GENERAL.INTER=0;                                      %Interactive mode logic
OPT.GENERAL.DIMENSION=1;                                  %Dimensionality of integration
OPT.GENERAL.MODE='BOTH';                                  %Pump/probe/both

OPT.ATOMIC.ATOM='H';                                      %Atom of interest

OPT.ATOMIC.NT_0=1;                                        %Number of transitions
OPT.ATOMIC.A_0=[3e7];                                     %Transition probabilites
OPT.ATOMIC.NU_0=c/6563.79e-10+[0]*1e9;                    %Frequency of transitions

OPT.ATOMIC.G=1;                                           %Ratio of upper to lower statistical weights

OPT.ATOMIC.N=8e15;                                        %Ground state density
OPT.ATOMIC.KT=.1;                                         %Temperature of absorbers

OPT.SIGHTLINE.NXD=1;                                      %Number of spatial discretizations
OPT.SIGHTLINE.WIDTH=0.10;                                 %Active laser path length
OPT.SIGHTLINE.WIDTH_LOGIC=0;                              %Logic for self consistent width calculation

OPT.LASER.NFP=2001;                                         %Number of frequency discretizations
OPT.LASER.NU_MODE='AUTO';                                 %Frequency discretization mode (AUTO or MANUAL)
OPT.LASER.NU_WIN=c/6563.79e-10+[-5e9,5e9];                %Frequency window - AUTO
OPT.LASER.NU_MAN=c/6563.79e-10+[-1e9 0e9 1e9];            %Manual frequency points - MANUAL

OPT.LASER.PU.P_0=0.007;                                   %Laser pump beam power
OPT.LASER.PR.P_0=0.001;                                   %Laser probe beam power

OPT.LASER.PU.AREA=pi*.0005^2;                             %Laser pump beam area
OPT.LASER.PR.AREA=pi*.0005^2;                             %Laser probe beam area

OPT.LASER.PU.DIRECTION=[1 0.04];                          %Laser pump beam direction
OPT.LASER.PR.DIRECTION=[-1 0];                            %Laser probe beam direction

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>       SPEC SIM OPTIONS     <><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%*****************************
%Define the parent folder path
%*****************************
HIT=0;
PATH=pwd;
for ii=length(PATH):-1:1
    if strcmpi(PATH(ii),filesep)==1
        HIT=HIT+1;
        
        if HIT==2
            PATH=PATH(1:ii-1);

            break
        end   
    end
end

%****************************
%Path pointing to subroutines
%****************************
PATH_LOC_SUB=[pwd filesep 'SUBROUTINES'];
PATH_MAIN_SUB=[PATH filesep 'SUBROUTINES'];
PATH_MAIN_PLOT=[PATH filesep 'PLOTTING ROUTINES'];

addpath(PATH)

%*********************************************
%Turning off the plotting (user control below)
%*********************************************
OPT.PLOT.GEO=0;                          
OPT.PLOT.INT=0;
OPT.PLOT.SAT=0;
OPT.PLOT.POP_DEN=0;                         

%**************
%Print progress
%**************
fprintf('\n***************************************\n')
fprintf('*** Calculating Probe+Pump Spectrum ***\n')
fprintf('***************************************\n\n')

%**************************
%Calc. Doppler free spectra
%**************************
OPT.GENERAL.MODE='BOTH';                            
[DATA_BOTH,SPACE,FREQ,PARA]=DFSSS(OPT);

if isempty(DATA_BOTH)==1 || isempty(SPACE)==1 || isempty(FREQ)==1 || isempty(PARA)==1 
    return
end

%**************
%Print progress
%**************
fprintf('\n***************************************\n')
fprintf('*** Calculating Probe Only Spectrum ***\n')
fprintf('***************************************\n\n')

%*******************************
%Calc. Doppler broadened spectra
%*******************************
OPT.GENERAL.MODE='PROBE';                            
[DATA_PROBE,~,~,~]=DFSSS(OPT);

if isempty(DATA_PROBE)==1
    return
end

%%

addpath(PATH_LOC_SUB);
addpath(PATH_MAIN_SUB);
addpath(PATH_MAIN_PLOT);

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %%%%%%%%%%%%  SET THE PLOTTING OPTIONS  %%%%%%%%%%%%

PLOT.GEO=0;                %Logic to control laser beam geometry plotting
PLOT.INT=0;                %Logic to control laser beam absorption plotting
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

%******************************
%Calc. the Doppler-free spectra
%******************************
SIM=GEN_DF_SPEC(DATA_BOTH,DATA_PROBE,SPACE,FREQ);

%************
%Fit the data
%************
[FIT,PARA]=FITTER(SIM,FIT_OPT);

%%

%******************************
%Plot and print the fit results
%******************************
PLOT_FIT(SIM,FIT,PARA)

%%

rmpath(PATH)
rmpath(PATH_LOC_SUB);
rmpath(PATH_MAIN_SUB);
rmpath(PATH_MAIN_PLOT);

%%


