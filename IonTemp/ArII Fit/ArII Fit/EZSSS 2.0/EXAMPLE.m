clc
close all

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~      SET THE INPUT PARAMETERS       ~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%****************
%Atom of interest
%****************
LINE.ATOM='ArII';

%*******************************************************
%**   Logic to turn on/off (1/0) the fine structure   ** 
%                                                     **
%         ~~ available for H or D atoms only ~~       **
%*******************************************************
LINE.FS=1;

%****************************************************************
%**        Principal quantum numbers of the transition         ** 
%                                                              **
%      ~~ available for  H-like and He-like atoms only ~~      **
%****************************************************************
LINE.PQN=[2,4];

%***********************************************
%**         Spin of atomic transition         ** 
%                                             **
%    ~~ available for  He-like atoms only ~~  **
%***********************************************
LINE.SPIN=1;

%*****************************************************************
%**             Wavelength of unpertrubed transition            ** 
%                                                               **
%    ~~ available for NON H-like and NON He-like atoms only ~~  **
%*****************************************************************
LINE.WAVE='4806A';

%************************************
%Define the field and view parameters
%************************************
VAR.EDC_MAG=[0 0 0]*1e5;
VAR.ERF_ANG=[0 0 0];
VAR.ERF_MAG=[0 0 0]*1e5;
VAR.NU=1;
VAR.VIEW=[pi/2 0];
VAR.POL=[0 0];
VAR.B_MAG=.75;
VAR.LINE=LINE;

%****************
%Printing options
%****************
OPT.PRINT.TIME=0;                          
OPT.PRINT.TRAN=0; 

%**********************************
%Spectral plotig logic: 0-off 1-on
%**********************************
OPT.PLOT.SPEC.LOGIC=1;

%**********************************
%Geometry ploting logic: 0-off 1-on
%**********************************
OPT.PLOT.GEO.LOGIC=0;    

%****************************
%Temperature of radiator (eV)
%****************************
OPT.SPEC.DOP.NTG=1;
OPT.SPEC.DOP.I=1;
OPT.SPEC.DOP.X=0;
OPT.SPEC.DOP.kT_LHS=3;
OPT.SPEC.DOP.kT_RHS=3;

%*********************************
%Gaussian broadening parameter (m) 
%*********************************
OPT.SPEC.GAU.NF=1; 
OPT.SPEC.GAU.I=1; 
OPT.SPEC.GAU.X=0; 
OPT.SPEC.GAU.SIG=0.25e-10;

%***********************************
%Lorentizan broadening parameter (m) 
%***********************************
OPT.SPEC.LOR.NF=0;

%--------------------------------------------------------------------------
%NOTE this parameter (SIG) is defined as f(x)=I*exp(-(x-LAM)^2/SIG^2), the
%nominal Gaussian function is f(x)=I*exp(-(x-LAM)^2/(2*SIG_NOMINAL^2))
%--------------------------------------------------------------------------

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%*****************
%Calc. the spectra
%*****************
DATA=EZSSS(VAR,OPT);
