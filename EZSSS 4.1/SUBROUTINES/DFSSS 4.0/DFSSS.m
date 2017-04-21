function [DATA,SPACE,FREQ,PARA]=DFSSS(OPT,MODE)

%********************************
%Assign number of input arguments
%********************************
NARGIN=nargin;

%*****************
%Assign mode logic
%*****************
MODE_LOG=NARGIN<2||(NARGIN==3&&MODE==0);

%**************************************************************************
%***************************UNIVERSAL CONSTANTS****************************
%**************************************************************************
                                               %***************************
    h=6.62606957e-34;                          %***************************
    c=2.99792458e8;                            %***************************
    q=1.602176487e-19;                         %***************************
    eo=8.85418782e-12;                         %***************************
    m_H=1.6737235990e-27;                      %***************************
    m_D=3.3435834772e-27;                      %***************************
    m_T=5.0082670812e-27;                      %***************************
    m_He=6.646476402e-27;                      %***************************
    m_Ar=6.6335209e-26;                        %***************************
                                               %***************************    
%**************************************************************************
%***************************UNIVERSAL CONSTANTS****************************
%**************************************************************************

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if MODE_LOG==1   %%%% END FOR MODE_LOGIC %%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%**************************************************************************
%***************************DEFAULT OPTIONS********************************
%**************************************************************************
    GENERAL_DEF.INTER=0;                       %***************************         
    GENERAL_DEF.DIMENSION=1;                   %***************************
    GENERAL_DEF.MODE='PROBE';                  %***************************
                                               %***************************
    PARALLEL_DEF.PAR_LOGIC=1;                  %***************************
    PARALLEL_DEF.NAP=24;                       %***************************
                                               %***************************                                           %***************************
    SIGHTLINE_DEF.NXD=1;                       %***************************
    SIGHTLINE_DEF.WIDTH=0.10;                  %***************************
    SIGHTLINE_DEF.WIDTH_LOGIC=0;               %***************************
                                               %***************************
    ATOMIC_DEF.ATOM='HeI';                     %***************************
    ATOMIC_DEF.N=5e15;                         %***************************
                                               %***************************
    ATOMIC_DEF.NT_0=1;                         %***************************
    ATOMIC_DEF.A_0=3e7;                        %***************************
    ATOMIC_DEF.NU_0=7.239e14;                  %***************************
                                               %***************************
    ATOMIC_DEF.G=1;                            %***************************
    ATOMIC_DEF.GAMMA=0;                        %***************************
                                               %***************************
    ATOMIC_DEF.V_BULK=[0e4 0e4];               %***************************
    ATOMIC_DEF.KT=.05;                         %***************************
                                               %***************************
    LASER_DEF.NFP=31;                          %***************************
    LASER_DEF.NU_MODE='AUTO';                  %***************************
    LASER_DEF.NU_WIN=7.239e14+[-1e9,1e9];      %***************************
    LASER_DEF.NU_MAN=[];                       %***************************
                                               %***************************
    LASER_DEF.PU.P_0=0.001;                    %***************************
    LASER_DEF.PR.P_0=0.00015;                  %***************************
                                               %***************************
    LASER_DEF.PU.AREA=pi*.0005^2;              %***************************
    LASER_DEF.PR.AREA=pi*.0005^2;              %***************************
                                               %***************************
    LASER_DEF.PU.DIRECTION=[1 0.01];           %***************************
    LASER_DEF.PR.DIRECTION=[-1 0];             %***************************
                                               %***************************
    VELOCITY_DEF.RANGE_SIG=200;                %***************************
    VELOCITY_DEF.RANGE_N=200;                  %***************************
                                               %***************************
    VELOCITY_DEF.POP_DEN_LOGIC=0;              %***************************
    VELOCITY_DEF.NVXD=2001;                    %***************************
    VELOCITY_DEF.NVYD=101;                     %***************************
                                               %***************************
    ERROR_DEF.EVAL=100000;                     %***************************
    ERROR_DEF.ABS=1e-17;                       %***************************
    ERROR_DEF.REL=1e-16;                       %***************************
                                               %***************************
    PLOT_DEF.GEO=0;                            %***************************
    PLOT_DEF.INT=0;                            %***************************
    PLOT_DEF.SAT=0;                            %***************************
    PLOT_DEF.POP_DEN=0;                        %***************************
                                               %***************************
    OPT_DEF.GENERAL=GENERAL_DEF;               %***************************
    OPT_DEF.PARALLEL=PARALLEL_DEF;             %***************************
    OPT_DEF.SIGHTLINE=SIGHTLINE_DEF;           %*************************** 
    OPT_DEF.ATOMIC=ATOMIC_DEF;                 %***************************    
    OPT_DEF.LASER=LASER_DEF;                   %***************************
    OPT_DEF.VELOCITY=VELOCITY_DEF;             %***************************
    OPT_DEF.ERROR=ERROR_DEF;                   %***************************
    OPT_DEF.PLOT=PLOT_DEF;                     %***************************     
                                               %***************************
%**************************************************************************
%***************************DEFAULT OPTIONS********************************
%**************************************************************************

%**************************************************************************
%**********************OPTION FIELD NAMES/SUBNAMES*************************
%**************************************************************************  
OPT_NAME={'GENERAL','PARALLEL','SIGHTLINE','ATOMIC','LASER','VELOCITY','ERROR','PLOT'};

OPT_SUBNAME{1}={'INTER','DIMENSION','MODE'};
OPT_SUBNAME{2}={'PAR_LOGIC','NAP'};
OPT_SUBNAME{3}={'NXD','WIDTH','WIDTH_LOGIC'};
OPT_SUBNAME{4}={'ATOM','N','NT_0','A_0','NU_0','G','GAMMA','V_BULK','KT'};
OPT_SUBNAME{5}={'NFP','NU_MODE','NU_WIN','NU_MAN','PU','PR'};
OPT_SUBNAME{6}={'RANGE_SIG','RANGE_N','POP_DEN_LOGIC','NVXD','NVYD'};
OPT_SUBNAME{7}={'EVAL','ABS','REL'};
OPT_SUBNAME{8}={'GEO','INT','SAT','POP_DEN'};

OPT_SUBSUBNAME{1}(1:3)={{''},{''},{''}};
OPT_SUBSUBNAME{2}(1:2)={{''},{''}};
OPT_SUBSUBNAME{3}(1:3)={{''},{''},{''}};
OPT_SUBSUBNAME{4}(1:9)={{''},{''},{''},{''},{''},{''},{''},{''},{''}};
OPT_SUBSUBNAME{5}(1:4)={{''},{''},{''},{''}};
OPT_SUBSUBNAME{5}{5}={'P_0','AREA','DIRECTION'};
OPT_SUBSUBNAME{5}{6}={'P_0','AREA','DIRECTION'};
OPT_SUBSUBNAME{6}(1:5)={{''},{''},{''},{''},{''}};
OPT_SUBSUBNAME{7}(1:3)={{''},{''},{''}};
OPT_SUBSUBNAME{8}(1:4)={{''},{''},{''},{''}};

OPT_NAMES.OPT_NAME=OPT_NAME;
OPT_NAMES.OPT_SUBNAME=OPT_SUBNAME;
OPT_NAMES.OPT_SUBSUBNAME=OPT_SUBSUBNAME;
%**************************************************************************
%**********************OPTION FIELD NAMES/SUBNAMES*************************
%************************************************************************** 

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||||||||| Add folder paths |||||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ROOT_PATH=which(mfilename);
for ii=length(ROOT_PATH):-1:1
    if strcmpi(ROOT_PATH(ii),filesep)==1
        %******************
        %Generate root path
        %******************
        ROOT_PATH=ROOT_PATH(1:ii-1);
        
        break
    end
end

%***************************************
%List of folders to add in the root path
%***************************************
PATH{1}=[ROOT_PATH filesep 'SUBROUTINES'];
PATH{2}=[ROOT_PATH filesep 'PLOTTING ROUTINES'];

%*****************************
%Assign number of paths to add
%*****************************
NPATH=length(PATH);

%*********
%Add paths
%*********
for ii=1:NPATH
    addpath(PATH{ii})
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||||||||| Set default options ||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if NARGIN==0
    OPT=[];
end

OPT=SET_OPT(OPT,OPT_DEF,OPT_NAMES);
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end              %%%% END FOR MODE_LOGIC %%%%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||||||||| Assign options ||||||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GENERAL=OPT.GENERAL;
PARALLEL=OPT.PARALLEL;
SIGHTLINE=OPT.SIGHTLINE; 
ATOMIC=OPT.ATOMIC; 
LASER=OPT.LASER;         
VELOCITY=OPT.VELOCITY;          
ERROR=OPT.ERROR;    
PLOT=OPT.PLOT;    
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||||| Assign univ. constants ||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
UNIV.h=h;
UNIV.q=q;
UNIV.c=c;
UNIV.eo=eo;
if strcmpi(ATOMIC.ATOM,'H')==1
    UNIV.m=m_H;
elseif strcmpi(ATOMIC.ATOM,'D')==1
    UNIV.m=m_D;
elseif strcmpi(ATOMIC.ATOM,'T')==1
    UNIV.m=m_T;    
elseif strcmpi(ATOMIC.ATOM(1:2),'He')==1
    UNIV.m=m_He;
elseif strcmpi(ATOMIC.ATOM(1:2),'Ar')==1
    UNIV.m=m_Ar;
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||| Preform presimulation checks ||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%*********************************
%Normalize laser direction vectors
%*********************************
LASER.PU.DIRECTION=LASER.PU.DIRECTION/sum(LASER.PU.DIRECTION.^2)^.5;
LASER.PR.DIRECTION=LASER.PR.DIRECTION/sum(LASER.PR.DIRECTION.^2)^.5; 

%********************************
%Set parameters for 1D calcuation
%********************************
if GENERAL.DIMENSION==1
    VELOCITY.NVYD=1;
    
    ATOMIC.V_BULK=[ATOMIC.V_BULK(1) 0];
    
    LASER.PU.DIRECTION=[1 0];
    LASER.PR.DIRECTION=[-1 0];
end

%**********************************
%Assign total transtion probability
%**********************************
ATOMIC.A_0_TOT=sum(ATOMIC.A_0(1:ATOMIC.NT_0));
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%***************************
%Assign sightline parameters
%***************************
NXD=SIGHTLINE.NXD;
WIDTH=SIGHTLINE.WIDTH;
WIDTH_LOGIC=SIGHTLINE.WIDTH_LOGIC;

%*********************************
%Assign laser frequency parameters
%*********************************
NFP=LASER.NFP;
NU_MODE=LASER.NU_MODE;
NU_WIN=LASER.NU_WIN;
NU_MAN=LASER.NU_MAN;

if strcmpi(GENERAL.MODE,'BOTH')==1 && WIDTH_LOGIC==1
    %*********************************
    %Calc. width of overlapping region
    %*********************************
    WIDTH=BEAM_GEOMETRY(LASER); 
    
    %**************************
    %Update SIGHTLINE structure
    %**************************
    SIGHTLINE.WIDTH=WIDTH;
end

%*********************
%Assign PARA structure
%*********************
PARA.ATOMIC=ATOMIC;
PARA.LASER=LASER;
PARA.SIGHTLINE=SIGHTLINE;
PARA.VELOCITY=VELOCITY;
PARA.ERROR=ERROR;
PARA.MODE=GENERAL.MODE;
PARA.DIMENSION=GENERAL.DIMENSION;

if GENERAL.INTER==1
    %**********************************
    %Plot geometry and print parameters
    %**********************************
    EXIT=INTERACTIVE(PARA,UNIV);
    
    %****
    %Exit 
    %****
    if strcmpi(EXIT,'n')==1
        DATA=[];
        SPACE=[];
        FREQ=[];
        PARA=[];

        return
    end
end

%**********************************
%Assign parallel processing options
%**********************************
PAR_LOG=PARALLEL.PAR_LOGIC==1&&NFP>1;

%****************
%Open NAP workers
%****************
if PAR_LOG==1
    START_PARPOOL(PARALLEL.NAP)
end

%*************************
%Assign number of x points
%*************************
NXP=NXD+1;

%************************
%Discretize the sightline
%************************
X=linspace(0,WIDTH,NXP);

%*****************************
%Discretize the laser freqency
%*****************************
if strcmpi(NU_MODE,'AUTO')==1
    NU=linspace(NU_WIN(1),NU_WIN(2),NFP);
elseif strcmpi(NU_MODE,'MANUAL')==1
    NU=NU_MAN(1:NFP);
end

%********************************
%Assign SPACE and FREQ structures
%********************************
SPACE.X=X;
SPACE.NXP=NXP;

FREQ.NFP=NFP;
FREQ.NU=NU;

%***************
%Allocate memory
%***************
DATA_PAR=cell(1,NFP);

if PAR_LOG==1
    %*********************
    %Initalize progess bar
    %*********************
    PARALLEL_PROGRESS(NFP);

    parfor ii=1:NFP
        %*************************
        %Calc. the laser intensity
        %*************************
        DATA_PAR{ii}=INTENSITY(NU(ii),SPACE,PARA,UNIV);

        %******************
        %Update progess bar
        %******************
        PARALLEL_PROGRESS;
    end

    %**********************
    %Finialize progress bar
    %**********************
    PARALLEL_PROGRESS(0);
else
    for ii=1:NFP
        %*************************
        %Calc. the laser intensity
        %*************************
        DATA_PAR{ii}=INTENSITY(NU(ii),SPACE,PARA,UNIV);
    end
end

%*********************
%Assign intensity data
%*********************
I_PU(1:NFP,1:NXP)=0;
I_PR(1:NFP,1:NXP)=0;
ALPHA(1:NFP,1:NXP)=0;

for ii=1:NFP
    I_PU(ii,1:NXP)=DATA_PAR{ii}.I.PU;
    I_PR(ii,1:NXP)=DATA_PAR{ii}.I.PR;
    ALPHA(ii,1:NXP)=DATA_PAR{ii}.ALPHA;
end

%**********************
%Assign population data
%**********************
if VELOCITY.POP_DEN_LOGIC==1
    POP_DEN=cell(NFP,NXD+1);
    SAT(1:NFP,1:NXP)=0;

    for ii=1:NFP
        POP_DEN(ii,1:NXP)=DATA_PAR{ii}.POP_DEN(1:NXP);
        SAT(ii,1:NXP)=DATA_PAR{ii}.SAT;
    end
else
    POP_DEN=[];
    SAT=[];
end

%*****************
%Assign the output 
%*****************
DATA.I_PU=I_PU;
DATA.I_PR=I_PR;
DATA.ALPHA=ALPHA;
DATA.POP_DEN=POP_DEN;
DATA.SAT=SAT;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if MODE_LOG==1   %%%% END FOR MODE_LOGIC %%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%*********************************
%Plot the pump/probe beam geometry
%*********************************
if PLOT.GEO==1
    [~,~]=BEAM_GEOMETRY(PARA,1);
end

if PLOT.INT==1
    PLOT_INT(DATA,SPACE,FREQ,PARA);
end

if PLOT.SAT==1
    PLOT_SAT(DATA,SPACE,FREQ,PARA);
end

if PLOT.POP_DEN==1
    PLOT_POP_DEN(DATA,SPACE,FREQ,PARA);
end

%************
%Remove paths
%************
for ii=1:NPATH
    rmpath(PATH{ii})
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end              %%%% END FOR MODE_LOGIC %%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

