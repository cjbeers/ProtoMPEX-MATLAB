clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%
%%% TRANSITION PROB %%%
%%%%%%%%%%%%%%%%%%%%%%%

%H n=3->2 - A=4.4e7 - LAM=6562.8e-10
%H n=4->2 - A=8.4e6 - LAM=4861.4e-10
%H n=5->2 - A=2.5e6 - LAM=4340.5e-10
%H n=6->2 - A=9.7e5 - LAM=4101.7e-10
%H n=7->2 - A=4.3e5 - LAM=3970.1e-10
%H n=8->2 - A=2.2e5 - LAM=3889.1e-10

%HeI n=5^3D->2^3P - A=11.7e7 - LAM=4026.2e-10

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TOTAL TRANSITION PROB %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%H n=2 - A=4.7e8 - g=8
%H n=3 - A=1.0e8 - g=18 
%H n=4 - A=3.0e7 - g=32 
%H n=5 - A=1.1e7 - g=50 
%H n=6 - A=5.2e6 - g=72 
%H n=7 - A=2.6e6 - g=98
%H n=8 - A=X.XeX - g=128
%HeI n=5^3D - A=16.4e7 

%*********
%File name
%*********
FILE_NAME='HD';

%**************************
%Temperature discretization
%**************************
NKT=2;
KT=[1 2];

%**********************
%Density discretization
%**********************
NN=1;
N=1e19;

%********************
%Power discretization
%********************
NP_0=2;
P_0_PU=[5 20]*1e-3;
P_0_PR=P_0_PU/10;

%************************
%Direction discretization
%************************
NDIR=1;
DIR_PU{1}=[1 0.05];
DIR_PR{1}=[-1 0];

%********************************
%Assign the discretized variables
%********************************
VARIABLES.KT=KT(1:NKT);
VARIABLES.N=N(1:NN);
VARIABLES.P_0_PU=P_0_PU(1:NP_0);
VARIABLES.P_0_PR=P_0_PR(1:NP_0);
VARIABLES.DIR_PU=DIR_PU(1:NDIR);
VARIABLES.DIR_PR=DIR_PR(1:NDIR);

%***************
%Set the options
%***************
OPT.GENERAL.INTER=0;
OPT.GENERAL.DIMENSION=1;

OPT.PLOT.GEO=0;                          
OPT.PLOT.INT=0;
OPT.PLOT.SAT=0;
OPT.PLOT.POP_DEN=0; 

%****************************
%Set the sightline parameters
%****************************
OPT.SIGHTLINE.NXD=1;
OPT.SIGHTLINE.WIDTH_LOGIC=1;

%*************************
%Set the atomic parameters
%*************************
ATOMIC.ATOM='H';

ATOMIC.NT_0=1;
ATOMIC.NU_0=2.99792458e8/4101.7e-10;
ATOMIC.A_0=9.7e5;

ATOMIC.G=1;
ATOMIC.GAMMA=0;
ATOMIC.V_BULK=[0 0];

%************************
%Set the laser parameters
%************************
LASER.NFP=480;
LASER.NU_MODE='AUTO';
LASER.NU_WIN=[0,4e9];

LASER.PU.AREA=pi*.0002^2;
LASER.PR.AREA=pi*.0002^2;

%********************
%Calc. number of runs
%********************
NR=NKT*NN*NP_0*NDIR;

%***************
%Allcoate memory
%***************
DATA_BOTH=cell(1,NR);
DATA_PROBE=cell(1,NR);
SPACE=cell(1,NR);
FREQ=cell(1,NR);
PARA=cell(1,NR);

mm=0;
for ii=1:NKT
    for jj=1:NN
        for kk=1:NP_0
            for ll=1:NDIR
                %******************
                %Advance run indice
                %******************
                mm=mm+1;
                
                tic
                fprintf('\n*********************************\n')
                fprintf('Running case %4i of %4i \n',mm,NR)
                
                %************************************************
                %Set the run specific atmoic and laser parameters
                %************************************************
                ATOMIC.KT=KT(ii); 
                ATOMIC.N=N(jj);

                LASER.PU.P_0=P_0_PU(kk);
                LASER.PR.P_0=P_0_PR(kk);

                LASER.PU.DIRECTION=DIR_PU{ll};
                LASER.PR.DIRECTION=DIR_PR{ll};

                OPT.ATOMIC=ATOMIC;
                OPT.LASER=LASER;
                    
                %******************************
                %Calc. the Doppler free spectra
                %******************************
                OPT.GENERAL.MODE='BOTH';
                [DATA_BOTH{mm},SPACE{mm},FREQ{mm},PARA{mm}]=DFSSS(OPT);
                
                %***********************************
                %Calc. the Doppler broadened spectra
                %***********************************
                OPT.GENERAL.MODE='PROBE';
                [DATA_PROBE{mm},~,~,~]=DFSSS(OPT);
                
                TIME=toc;
                fprintf('RUN TIME: %6.1f\n',TIME)
                fprintf('*********************************\n')
            end
        end
    end
end

%*****************
%Save the run data
%*****************
save(['RUN_DATA_' FILE_NAME '.mat'],'DATA_BOTH','DATA_PROBE','SPACE','FREQ','PARA','VARIABLES')




