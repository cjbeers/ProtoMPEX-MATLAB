clc
clear all
close all

NI=5e17;
NANG=50;
NHM=100;
MAX_HM=15;

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||  SET THE INPUT PARAMETERS  |||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%****************
%Atom of interest
%****************
RAD.ATOM='H';

%*******************************************************
%**   Logic to turn on/off (1/0) the fine structure   ** 
%                                                     **
%         ~~ available for H or D atoms only ~~       **
%*******************************************************
RAD.FS=1;

%****************************************************************
%**        Principal quantum numbers of the transition         ** 
%                                                              **
%      ~~ available for  H-like and He-like atoms only ~~      **
%****************************************************************
RAD.PQN=[2,3];

%***********************************************
%**         Spin of atomic transition         ** 
%***********************************************
RAD.SPIN=.5;

%*****************************************************************
%**                      Magnetic Field                         ** 
%                                                               **
%                   ~~ B   -> UNITS=Tesla    ~~                 **
%*****************************************************************
B.MAG=0.08;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Quasistatic solver options                  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                             %%%%%
OPT.SOLVER.QSA_LOGIC=1;  % 0/1 -> off/on %   %%%%%
OPT.SOLVER.MAN_LOGIC=1;  % 0/1 -> off/on %   %%%%%
                                             %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calc. the quasistatic mirco E-Field         %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%***************************
%Calc. electric field angles
%***************************
if B.MAG==0
    NANG=1;
    ANG=0;
else
    ANG=linspace(0,pi,NANG);
end

%**************************************
%Calc. nominal Holtsmark electric field
%**************************************
EN=linspace(0,MAX_HM,NHM);

%***********************
%Calc. Holtsmark weights
%***********************
addpath([pwd filesep 'SUBROUTINES' filesep 'STARK BROADENING'])
[WN,E0]=HOLTSMARK(NI,EN,NHM);
rmpath([pwd filesep 'SUBROUTINES' filesep 'STARK BROADENING'])

%******************************
%Calc. Holtsmark electric field
%******************************
E=EN*E0;

%**************************************
%Assign number of discretization points
%**************************************
NP=NHM*NANG;

EX(1:NP)=0;
EZ(1:NP)=0;
WT(1:NP)=0;
for ii=1:NANG
    %************************
    %Assign the angle indices
    %************************
    IND1=(ii-1)*NHM+1;
    IND2=ii*NHM;
    
    %*****************************************************
    %Assign the Holtsmark electric field vector components
    %*****************************************************
    EX(IND1:IND2)=E*sin(ANG(ii));
    EZ(IND1:IND2)=E*cos(ANG(ii));
    
    %***************************
    %Assign the Holtsmark weight
    %***************************
    WT(IND1:IND2)=WN;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                          %%%%%%%%
%****************************             %%%%%%%%
%Assign quasistatic structure             %%%%%%%%
%****************************             %%%%%%%%
QSA.NP=NP;                                %%%%%%%%
QSA.WT=WT;                                %%%%%%%%
QSA.E(1,1:NP)=EX;                         %%%%%%%%
QSA.E(2,1:NP)=0;                          %%%%%%%%
QSA.E(3,1:NP)=EZ;                         %%%%%%%%                         
                                          %%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%*****************************************************************
%**                       Observation View                      ** 
%                                                               **
%              ~~ MODE -> can be the following string:          **
%                                                               **
%                             'NO_INT'                          **
%                             '1D_INT'                          **
%                             '2D_INT'                          **
%                                                               **
%              ~~ Angular parameters -> UNITS=radians  ~~       **
%*****************************************************************
OBS.MODE='1D_INT';

OBS.VIEW.POLAR=pi/2;
OBS.VIEW.AZIM=0;

OBS.POL.LOGIC=1;
OBS.POL.ANG=pi/2;
OBS.POL.T=[1,0];

%********************
%Assign VAR structure
%********************
VAR.B=B;
VAR.QSA=QSA;
VAR.OBS=OBS;
VAR.RAD=RAD;

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||     PARALLEL PROCESSING LOGIC      |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

OPT.PARALLEL.PAR_LOGIC=1;                     
OPT.PARALLEL.NAP=24;                 

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||          DFSS OPTIONS              |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

OPT.DFSS.SCALE.LOGIC=0;                    
OPT.DFSS.SCALE.MODE='TAB';
OPT.DFSS.SCALE.MIN_RATIO=5e-4; 

OPT.DFSS.CROSS.LOGIC=0;                    
OPT.DFSS.CROSS.MODE='SIM';   
OPT.DFSS.CROSS.MIN_RATIO=5e-4;             
OPT.DFSS.CROSS.NU_WIN=[1e9 20e9];
OPT.DFSS.CROSS.PEAK='+';   
OPT.DFSS.CROSS.DIP='+';  

OPT.DFSS.N=1e17;                        
OPT.DFSS.KT=0.06;                        
OPT.DFSS.PU.AREA=pi*0.0005^2;               
OPT.DFSS.PR.AREA=pi*0.0005^2;               
OPT.DFSS.PU.P_0=0.007;                    
OPT.DFSS.PR.P_0=0.001;                    

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||    TRANSITION OPTIONS        |||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                
OPT.TRAN.MIN_RATIO=1e-4;    %%%% A/A_MAX < MIN_RATIO are DISCARDED  %%%%     
OPT.TRAN.REF=1.00028;    

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||       SPECTRA OPTIONS        |||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

OPT.SPEC.CONT_LOGIC=1;                     
OPT.SPEC.NORM_LOGIC=0;         

OPT.SPEC.SUM.LOGIC=1;                     
OPT.SPEC.SUM.MODE='GRID';  
OPT.SPEC.SUM.DX_GRID=2e-14;  

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++      CONTINUOUS SPECTRAL PARAMETERS        ++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
%%%%%%%%%%%%
%%% NOTE %%%          The SIG parameter is defined as:
%%%%%%%%%%%%
%                        f(x)=I*exp(-(x-LAM)^2/SIG^2)
%
%                     The nominal Gaussian function is:
%
%                  f(x)=I*exp(-(x-LAM)^2/(2*SIG_NOMINAL^2))
%
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%****************************
%Temperature of radiator (eV)
%****************************
OPT.SPEC.DOP.NTG=1;
OPT.SPEC.DOP.kT_LHS=1/11604.5;
OPT.SPEC.DOP.kT_RHS=1/11604.5;
OPT.SPEC.DOP.I=1;
OPT.SPEC.DOP.X=0;

%*********************************
%Gaussian broadening parameter (m) 
%*********************************
OPT.SPEC.GAU.NF=0; 
OPT.SPEC.GAU.SIG=0.01e-10;
OPT.SPEC.GAU.I=1;
OPT.SPEC.GAU.X=0;

%***********************************
%Lorentizan broadening parameter (m) 
%***********************************
OPT.SPEC.LOR.NF=1;
OPT.SPEC.LOR.GAM=0.002e-10;
OPT.SPEC.LOR.I=1;
OPT.SPEC.LOR.X=0;

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||      QUANTUM STRUCTURE LOGIC       |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

OPT.QUANTUM.QS_LOGIC=0;                     
OPT.QUANTUM.EL=1;
OPT.QUANTUM.WF=1;

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||      PLOTTING LOGIC        |||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%**************************************
%Hamiltonian plotting logic: 0-off 1-on
%**************************************
OPT.PLOT.HAM.LOGIC=0;  

OPT.PLOT.HAM.ADD_H0=0;                    
OPT.PLOT.HAM.B=1;                            
OPT.PLOT.HAM.EDC=1;                          
OPT.PLOT.HAM.EQSA=0;                         
OPT.PLOT.HAM.TOTAL=0;                      
OPT.PLOT.HAM.FLOQUET=0;                     

%****************************************
%Quantum state plotting logic: 0-off 1-on
%****************************************
OPT.PLOT.QS.LOGIC=0;  

OPT.PLOT.QS.EL=1;                        
OPT.PLOT.QS.WF=1;                       
    
%***********************************
%Spectral plotting logic: 0-off 1-on
%***********************************
OPT.PLOT.SPEC.LOGIC=1;

OPT.PLOT.ATOMIC.LOGIC=1;
OPT.PLOT.ATOMIC.INDEX=0;
OPT.PLOT.ATOMIC.LL=0;
OPT.PLOT.ATOMIC.UL=0;
OPT.PLOT.ATOMIC.QSA=0;
OPT.PLOT.ATOMIC.SUM=0;
OPT.PLOT.ATOMIC.DISC=0;
OPT.PLOT.ATOMIC.CONT=1;

OPT.PLOT.CROSS.LOGIC=0;
OPT.PLOT.CROSS.INDEX=0;
OPT.PLOT.CROSS.LL=0;
OPT.PLOT.CROSS.UL=0;
OPT.PLOT.CROSS.QSA=0;
OPT.PLOT.CROSS.SUM=0;
OPT.PLOT.CROSS.DISC=0;
OPT.PLOT.CROSS.CONT=1;
OPT.PLOT.CROSS.PEAK=0;
OPT.PLOT.CROSS.DIP=0;
OPT.PLOT.CROSS.TOTAL=1;

%***********************************
%Geometry plotting logic: 0-off 1-on
%***********************************
OPT.PLOT.GEO.LOGIC=0;    

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||      PRINTING LOGIC        |||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

OPT.PRINT.TIME=1;                          
OPT.PRINT.RESULTS=1; 
OPT.PRINT.QSA=1; 
OPT.PRINT.DFSS=1; 

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%*****************
%Calc. the spectra
%*****************
[DATA,OPT]=EZSSS(VAR,OPT);