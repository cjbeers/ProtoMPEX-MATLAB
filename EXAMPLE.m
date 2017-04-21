clc
clear all
%close all

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
%**             Wavelength of unpertrubed transition            ** 
%                                                               **
%    ~~ available for NON H-like and NON He-like atoms only ~~  **
%*****************************************************************
RAD.WAVE='4806A';

%*****************************************************************
%**                Magnetic and Electric Fields                 ** 
%                                                               **
%                   ~~ B   -> UNITS=Tesla    ~~                 **
%                   ~~ E   -> UNITS=V/m      ~~                 **
%                   ~~ ANG -> UNITS=radians  ~~                 **
%                   ~~ NU  -> UNITS=Hz       ~~                 **
%*****************************************************************
B.MAG=0.08;

EDC.MAG=[0 0 0]*1e5;

ERF.MAG=[0 0 0]*1e5;
ERF.ANG=[0 0 0];
ERF.NU=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Quasistatic solver options                  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                             %%%%%
OPT.SOLVER.NDT=10;                           %%%%%
OPT.SOLVER.QSA_LOGIC=1;  % 0/1 -> off/on %   %%%%%
OPT.SOLVER.MAN_LOGIC=0;  % 0/1 -> off/on %   %%%%%
                                             %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Example for manual quasistatic calculation  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                             %%%%%
QSA.WT=[.1 .3 1 .6 .1];                      %%%%%
QSA.E(1,1:5)=[0 1 2 3 4]*1e5;                %%%%%
QSA.E(2,1:5)=[0 0 0 0 0]*1e5;                %%%%%
QSA.E(3,1:5)=[0 1 2 3 4]*1e5;                %%%%%
QSA.NP=5;                                    %%%%%
                                             %%%%%
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
OBS.MODE='NO_INT';

OBS.VIEW.POLAR=pi/2;
OBS.VIEW.AZIM=0;

OBS.POL.LOGIC=1;
OBS.POL.ANG=pi/2;
OBS.POL.T=[1,0];

%********************
%Assign VAR structure
%********************
VAR.B=B;
if OPT.SOLVER.MAN_LOGIC==1 && OPT.SOLVER.QSA_LOGIC==1
    VAR.QSA=QSA;
else
    VAR.EDC=EDC;
    VAR.ERF=ERF;
end
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
OPT.SPEC.NORM_LOGIC=1;         

OPT.SPEC.SUM.LOGIC=0;                     
OPT.SPEC.SUM.MODE='DEGEN';                

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
OPT.SPEC.LOR.NF=2;
OPT.SPEC.LOR.GAM=[0.01 0.002]*1e-10;
OPT.SPEC.LOR.I=[1 4];
OPT.SPEC.LOR.X=[0 0];

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

OPT.PLOT.CROSS.LOGIC=1;
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