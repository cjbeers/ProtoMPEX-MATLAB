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
OPT.GENERAL.MODE='BOTH';                                 %Pump/probe/both

OPT.ATOMIC.ATOM='H';                                      %Atom of interest

OPT.ATOMIC.NT_0=1;                                        %Number of transitions
OPT.ATOMIC.A_0=[3e7 3e7];                                 %Transition probabilites
OPT.ATOMIC.NU_0=c/6563.79e-10+[-0. 0.8]*1e9;             %Frequency of transitions

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%*************
%Add main path
%*************
addpath(PATH)

%*********************************************
%Turning off the plotting (user control below)
%*********************************************
OPT.PLOT.GEO=0;                          
OPT.PLOT.INT=0;
OPT.PLOT.SAT=0;
OPT.PLOT.POP_DEN=0;                        

%******************
%Call the main code
%******************
[DATA,SPACE,FREQ,PARA]=DFSSS(OPT);

if isempty(DATA)==1 || isempty(SPACE)==1 || isempty(FREQ)==1 || isempty(PARA)==1 
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
    PLOT_INT(DATA,SPACE,FREQ,PARA)
end

%*******************
%Plot the saturation 
%*******************
if PLOT.SAT==1
    PLOT_SAT(DATA,SPACE,FREQ,PARA)
end

%***************************
%Plot the population density
%***************************
if PLOT.POP_DEN==1
    PLOT_POP_DEN(DATA,SPACE,FREQ,PARA)
end

%%

%********************
%Remove plotting path
%********************
rmpath(PATH_SUB);
rmpath(PATH_PLOT)