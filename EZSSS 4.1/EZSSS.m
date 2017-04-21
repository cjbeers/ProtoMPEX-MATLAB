function [DATA,OPT]=EZSSS(VAR,OPT,MODE)
%
%                                   /++++\
%                              /++++++++++++++\
%                         /++++++++++++++++++++++++\
%                    /++++++++++++++++++++++++++++++++++\
%               /++++++++++++++++++++++++++++++++++++++++++++\
%          /++++++++++++++++++++++++++++++++++++++++++++++++++++++\
%     /++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\
%     \++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/
%          \++++++++++++++++++++++++++++++++++++++++++++++++++++++/
%               \++++++++++++++++++++++++++++++++++++++++++++/
%                    \++++++++++++++++++++++++++++++++++/
%                         \++++++++++++++++++++++++/
%                              \++++++++++++++/
%                                   \++++/
%
%               \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
%               /\/\/\   PROGRAMER:  ELIJAH MARTIN    /\/\/\
%               \/\/\/     VERSION:  4.1              \/\/\/
%               /\/\/\        DATE:  3-13-2017        /\/\/\                       
%               \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
%
%               \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
%               /\/\/\    OFFICE:  ORNL 5600 Q402     /\/\/\
%               \/\/\/     PHONE:  828-606-2961       \/\/\/
%               /\/\/\     EMAIL:  martineh@ornl.gov  /\/\/\
%               \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
%
%                                   /++++\
%                              /++++++++++++++\
%                         /++++++++++++++++++++++++\
%                    /++++++++++++++++++++++++++++++++++\
%               /++++++++++++++++++++++++++++++++++++++++++++\
%          /++++++++++++++++++++++++++++++++++++++++++++++++++++++\
%     /++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\
%     \++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/
%          \++++++++++++++++++++++++++++++++++++++++++++++++++++++/
%               \++++++++++++++++++++++++++++++++++++++++++++/
%                    \++++++++++++++++++++++++++++++++++/
%                         \++++++++++++++++++++++++/
%                              \++++++++++++++/
%                                   \++++/
%
%   <-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><->
%   <-><-><->                    DESCRIPTION                 <-><-><->
%   <-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><->
%
%This program calculates the relative intensities and associated energies
%for all ELECTRIC DIPOLE induced transitions assuming the wavefuncations 
%are hydrogenic.  
%
%The code will allow for:
%
%       Static Magnetic Field
%       Static Electric Field
%       Dynamic Electric Field with Harmonic Content
%
%By definition the magnetic field is along the z-axis, thus only has a
%z-component.  The static and dynamic electric field can have x, y, or
%z-components.  The harmonic content of the dynamic electric field can have
%a non-zero phase shift with respect to the fundamental.
%
%   <-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><->
%   <-><-><->                      UNITS                     <-><-><->
%   <-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><->
%
%All units are SI unless stated below:
%
%   MATRIX ELEMENTS = eV    
%   UNPERTURBED ENERGIES = cm-1  
%
%   <-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><->
%   <-><-><->                      INPUTS                    <-><-><->
%   <-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><->
%
%VAR - Structure - Contains the electric and magnetic field information, 
%                  the view observations angles, the polarization parmeters 
%                  and the radiator information.  All fields must be 
%                  specified, if missing the code will prompt the user for 
%                  the input.  The following are the fields:
%
%|||||||||||||||||
%   LINE      %|||            
%   VIEW      %|||
%   POL       %|||    
%   B_MAG     %|||     
%   EDC_MAG   %|||     
%   ERF_MAG   %|||             
%   ERF_ANG   %|||          
%   NU        %|||            
%|||||||||||||||||
%
%                  \/\/\/|||  {{   VAR.LINE   }}  |||\/\/\/
%
%   LINE={FS,ATOM,S,N} - cell array - This field defines what unperturbed
%                                     energy eigenvalues are used, the 
%                                     atom of interest, the total spin, and
%                                     the radial quantum numbers of the 
%                                     transition.
%                        
%
%       FS - scalar - Logic to turn on/off the fine structure.
%
%           FS=0 - states are degenerate within n                       
%           FS=1 - states are degenerate within mj                             
%
%           All eigenvalues are taken from the NIST atomic database   
%           (1-5-2011). The eigenvalues are tabulated in units of cm-1 and 
%           are converted to eV.
%
%       ATOM - string - Sets the atom and ionization stage. The possible 
%                       values are:
%
%           H
%           D
%           T
%           HeI
%           HeII
%
%       SPIN - scalar - Is the total spin assoicated with the atom of
%                       interest. The possible values are:
%
%           H    --> S=1/2
%           D    --> S=1/2
%           T    --> S=1/2
%           HeI  --> S=0
%                --> S=1
%           HeII --> S=1/2
%
%       N=[nf,ni] - array - The radial quantum numbers associated with the 
%                           transition of interest. 
%
%           nf - Is the final radial quantum number
%           ni - Is the initial radial quantum number
%
%                  /\/\/\|||  {{   VAR.LINE   }}  |||/\/\/\
%                  ||||||||||||||||||||||||||||||||||||||||
%                  \/\/\/|||  {{   VAR.VIEW   }}  |||\/\/\/
%
%   VIEW=[THETA PHI] - array - This field defines the angles associated 
%                              with the observation cord viewing the  
%                              radiator in spherical coordinates.
%
%       THETA - scalar - The angle associated with the xz plane, with
%                        respect to the z-axis - polar angle - 0 to pi 
%                        radians. UNITS=RADIANS.
%
%       PHI - scalar - The angle associated with the xy plane, with respect
%                      to the x axis - azimuthual angle - 0 to 2pi radians.
%                      UNITS=RADIANS.
%  
%                  /\/\/\|||  {{   VAR.VIEW   }}  |||/\/\/\
%                  ||||||||||||||||||||||||||||||||||||||||
%                  \/\/\/|||  {{    VAR.POL   }}  |||\/\/\/
%
%   POL=[LOGIC CHI T1 T2] - array - This field defines the polarization 
%                                   parameters: the logic, the angle, and
%                                   the transmission fractions.
%
%       LOGIC - scalar - Determines if a polarizing element is used in the
%                        observation cord.                                       
%       
%           LOGIC=0 - OFF
%           LOGIC=1 - ON
%
%           IF LOGIC=0 the remaining three parameters are not used and do
%           not need to be defined ie POL=0 is sufficient.
%
%           IF LOGIC=1 the CHI parameter must be set.  The T1 and T2
%           parameters are optional and have default values if not set. The
%           following is valid POL=[1,pi/2] or POL=[1,pi/2,1,0].
%
%       CHI - scalar - The angle associated with the polarizer. The angle
%                      is defined in the plane perpendicular to the 
%                      observation cord. Viewing along this observation 
%                      cord the angle is with respect to the vertical of 
%                      the perpendicular plane. UNITS=RADIANS.
%       
%                      IF LOGIC=1 this angle must be defined, however the 
%                      remaining two parameters have default values that 
%                      will be used if not defined. The following is valid:
%                      POL=[1,pi/2] or POL=[1,pi/2,1,0].
%                       
%       T1 - scalar - Transmission fraction of the first polarization axis.
%                     This axis is at an angle of CHI with respect to the 
%                     vertical of the plane perpendicular to the 
%                     observation cord viewed along the cord. Should have a
%                     value between 0 and 1.  The default value is 1.
%
%       T2 - scalar - Transmission fraction of the second polarization 
%                     axis. This axis is at an angle of CHI+pi/2 with  
%                     respect to the vertical of the plane perpendicular to 
%                     the observation cord viewed along the cord. Should 
%                     have a value between 0 and 1. The default value is 0.
%
%                  /\/\/\|||  {{   VAR.POL   }}  |||/\/\/\
%                  |||||||||||||||||||||||||||||||||||||||
%                  \/\/\/|||  {{  VAR.B_MAG  }}  |||\/\/\/
%
%   B_MAG - scalar - This field defines the magnitude of the magnetic 
%                    field. By defintion the magnetic field is aligned 
%                    along the z-axis.  The coordinate system must be 
%                    rotated such that this is true when defining the other 
%                    field components. UNITS=TESLA.
%                    
%                  /\/\/\|||  {{  VAR.B_MAG  }}  |||/\/\/\
%                  |||||||||||||||||||||||||||||||||||||||
%                  \/\/\/|||  {{ VAR.EDC_MAG }}  |||\/\/\/
%
%   EDC_MAG=[EDC_X,EDC_Y,EDC_Z] - array - This field defines the static
%                                         electric field vector. 
%                                         UNITS=KV/CM.                                   
%                   
%       EDC_X - scalar - The xth component
%       EDC_Y - scalar - The yth component
%       EDC_Z - scalar - The zth component
%
%                  /\/\/\|||  {{ VAR.EDC_MAG }}  |||/\/\/\
%                  |||||||||||||||||||||||||||||||||||||||
%                  \/\/\/|||  {{ VAR.ERF_MAG }}  |||\/\/\/
%
%   ERF_MAG=[ERF1_X,ERF1_Y,ERF1_Z;
%            ERF2_X,ERF2_Z,ERF2_Z;
%            ...                  
%            ERFN_X,ERFN_Y,ERFN_Z] - matrix - This field defines the RF
%                                             electric field vector. The 
%                                             rows define the vector for 
%                                             each harmonic. The first row 
%                                             is the fundamental, the second 
%                                             row is the first harmonic,  
%                                             and so on. Only the 
%                                             fundamental needs to be 
%                                             defined. There is no limit to  
%                                             the number of harmonics. The
%                                             harmonics are assumned to be
%                                             zero if not defined. 
%                                             UNITS=KV/CM.
%
%           ERF1_X - scalar - x-component of fundamental
%           ERF1_Y - scalar - y-component of fundamental
%           ERF1_Z - scalar - z-component of fundamental
%
%           ERF2_X - scalar - x-component of 1st harmonic
%           ERF2_Y - scalar - y-component of 1st harmonic
%           ERF2_Z - scalar - z-component of 1st harmonic
%
%           ERFN_X - scalar - x-component of Nth harmonic
%           ERFN_Y - scalar - y-component of Nth harmonic
%           ERFN_Z - scalar - z-component of Nth harmonic
%
%                  /\/\/\|||  {{ VAR.EDC_MAG }}  |||/\/\/\
%                  |||||||||||||||||||||||||||||||||||||||
%                  \/\/\/|||  {{ VAR.ERF_ANG }}  |||\/\/\/
%
%   ERF_ANG=[PHA1_X,PHA1_Y,PHA1_Z;
%            PHA2_X,PHA2_Z,PHA2_Z;
%            ...                  
%            PHAN_X,PHAN_Y,PHAN_Z] - matrix - This field defines the phase 
%                                             angles associated with the RF
%                                             electric field vector. The 
%                                             rows define the vector for 
%                                             each harmonic. The first row 
%                                             is the phase associated with  
%                                             the fundamental, the second  
%                                             and so on. The phase angles
%                                             row is the phase associated 
%                                             with the first harmonic, for 
%                                             each harmonic defined in
%                                             ERF_MAG must be set.
%                                             UNITS=radians.
%
%           PHA1_X - scalar - x-component of fundamental phase
%           PHA1_Y - scalar - y-component of fundamental phase
%           PHA1_Z - scalar - z-component of fundamental phase
%
%           PHA2_X - scalar - x-component of 1st harmonic phase
%           PHA2_Y - scalar - y-component of 1st harmonic phase
%           PHA2_Z - scalar - z-component of 1st harmonic phase
%
%           PHAN_X - scalar - x-component of Nth harmonic phase
%           PHAN_Y - scalar - y-component of Nth harmonic phase
%           PHAN_Z - scalar - z-component of Nth harmonic phase
%
%                  /\/\/\|||  {{ VAR.EDC_ANG }}  |||/\/\/\
%                  |||||||||||||||||||||||||||||||||||||||
%                  \/\/\/|||  {{    VAR.NU   }}  |||\/\/\/
%
%   NU - scalar - The frequency associated with the fundamental of the 
%                 RF electric field. UNITS=HERTZ.
%
%                  /\/\/\|||  {{    VAR.NU   }}  |||/\/\/\
%
%OPT - structure - Contains the options that can be set in the code.  The
%                  options are described below in the OPTIONS section. If 
%                  not set in OPT the defualt options defined below in the 
%                  DEFUALT OPTIONS section are used. OPT does not have to 
%                  be passed into EZSSS, in this case only the default 
%                  options are used.                 
%
%MODE - scalar - Is the logic that turns on/off the checking of OPT for 
%                missing options. Is used to speed up the code. MODE does 
%                not need to be passed into EZSSS, the defualt is zero.
%
%   MODE=0 - On
%   MODE=1 - Off
%
%   <-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><->
%   <-><-><->                     OUTPUTS                    <-><-><->
%   <-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><->
%
%DATA - structure - Contains the spectra data.  At a minimum the this
%                   contains the discrete spectra.  If the continuous is 
%                   calculated it contains this spectra along with the axis 
%                   information that is useful for plotting. The following
%                   are the fields of DATA:
%
%|||||||||||||||||
%   DISC      %|||            
%   CONT      %|||
%   AXIS      %|||             
%|||||||||||||||||
%
%                  \/\/\/|||  {{  DATA.DISC  }}  |||\/\/\/
%
%   DISC - structure - This field contains the discrete spectral data. The
%                      following are the fields:
%
%|||||||||||||||||||
%       NT      %|||            
%       I       %|||
%       X       %|||             
%|||||||||||||||||||
%
%       NT - scalar - Number of non-degenerate transitions
%
%       I - array - The intensites, has length of NT
%
%       X - array - The wavelengths, has length of NT
%
%                  /\/\/\|||  {{  DATA.DISC  }}  |||/\/\/\
%                  |||||||||||||||||||||||||||||||||||||||
%                  \/\/\/|||  {{  DATA.CONT  }}  |||\/\/\/
%
%   CONT - structure - This field contains the continuous spectral data. 
%                      The following are the fields:
%
%|||||||||||||||||||
%       NT      %|||            
%       I       %|||
%       X       %|||             
%|||||||||||||||||||
%
%       NT - scalar - Number of data points
%
%       I - array - The intensites, has length of NT
%
%       X - array - The wavelengths, has length of NT
%
%                  /\/\/\|||  {{  DATA.CONT  }}  |||/\/\/\
%                  |||||||||||||||||||||||||||||||||||||||
%                  \/\/\/|||  {{  DATA.AXIS  }}  |||\/\/\/
%
%   AXIS - structure - This field contains the discrete and continuous 
%                      spectral data axis info.  This field is only 
%                      assigned if the continous spectra is calculated. The 
%                      following are the fields:
%
%|||||||||||||||||||
%       NG      %|||            
%       I_D_MAX %|||
%       I_C_MAX %|||
%       XL      %|||
%       XU      %|||
%|||||||||||||||||||
%
%       NG - scalar - Number of groups
%
%       I_D_MAX - array - The max discrete spectral intensity associated 
%                         with the group, has length of NG
%
%       I_C_MAX - array - The max continuous spectral intensity associated 
%                         with the group, has length of NG
%
%       XL - array - The min continuous spectral wavelength associated with
%                    the group, has length of NG
%
%       XU - array - The max continuous spectral wavelength associated with
%                    the group, has length of NG
%
%                  /\/\/\|||  {{  DATA.AXIS  }}  |||/\/\/\
%
%TIME - scalar - The time required to complete the computation.
%
%    <-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><->
%    <-><-><->                    OPTIONS                     <-><-><->
%    <-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><-><->
%
%COMING SOON TO THE COMPUTER NEAR YOU...
%
%                                   /++++\
%                              /++++++++++++++\
%                         /++++++++++++++++++++++++\
%                    /++++++++++++++++++++++++++++++++++\
%               /++++++++++++++++++++++++++++++++++++++++++++\
%          /++++++++++++++++++++++++++++++++++++++++++++++++++++++\
%     /++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\
%     \++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/
%          \++++++++++++++++++++++++++++++++++++++++++++++++++++++/
%               \++++++++++++++++++++++++++++++++++++++++++++/
%                    \++++++++++++++++++++++++++++++++++/
%                         \++++++++++++++++++++++++/
%                              \++++++++++++++/
%                                   \++++/
%                                     
%**************************************************************************
%***************************UNIVERSAL CONSTANTS****************************
%**************************************************************************
                                               %*************************** 
    h=6.62606957e-34;                          %***************************
    hbar=1.054571628e-34;                      %***************************
    c=2.99792458e8;                            %***************************
    q=1.602176487e-19;                         %***************************
    eo=8.85418782e-12;                         %***************************
    me=9.10938215e-31;                         %***************************
    m_H=1.6737235990e-27;                      %***************************
    m_D=3.3435834772e-27;                      %***************************
    m_T=5.0082670812e-27;                      %***************************
    m_He=6.646476402e-27;                      %***************************
    m_Ar=6.6335209e-26;                        %***************************
                                               %***************************    
%**************************************************************************
%***************************UNIVERSAL CONSTANTS****************************
%**************************************************************************

%**************************************************************************
%*****************LIST OF ATOMS THAT WF CANNOT BE CALC.********************
%**************************************************************************
                                               %***************************
NO_WF_LIST={'ArII'};                           %***************************
                                               %***************************
%**************************************************************************
%*****************LIST OF ATOMS THAT WF CANNOT BE CALC.********************
%**************************************************************************

%********************************
%Assign number of input arguments
%********************************
NARGIN=nargin;

%*****************
%Assign mode logic
%*****************
MODE_LOG=NARGIN<3||(NARGIN==3&&MODE==0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if MODE_LOG==1   %%%% END FOR MODE_LOGIC %%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||||||||||||||| START CLOCK ||||||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
tic %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||||||||||||||| START CLOCK ||||||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%**************************************************************************
%***************************DEFAULT OPTIONS********************************
%**************************************************************************
                                               %***************************
    SOLVER_DEF.QSA_LOGIC=1;                    %***************************
    SOLVER_DEF.MAN_LOGIC=0;                    %***************************
    SOLVER_DEF.NDT=300;                        %***************************
                                               %***************************
    FLOQ_DEF.FBC_LOGIC=1;                      %***************************
    FLOQ_DEF.NB=[30 50];                       %***************************
                                               %*************************** 
    QUANTUM_DEF.QS_LOGIC=1;                    %***************************
    QUANTUM_DEF.EL=1;                          %***************************
    QUANTUM_DEF.WF=1;                          %***************************
                                               %***************************
    PARALLEL_DEF.PAR_LOGIC=1;                  %***************************
    PARALLEL_DEF.NAP=24;                       %***************************
                                               %***************************
    DIAG_DEF.H=0;                              %***************************
    DIAG_DEF.HF=0;                             %*************************** 
                                               %***************************
    TRAN_DEF.MIN_RATIO=1e-4;                   %***************************
    TRAN_DEF.REF=1.00028;                      %***************************
                                               %***************************
    DFSS_DEF.SCALE.LOGIC=1;                    %***************************
    DFSS_DEF.SCALE.MODE='SIM';                 %***************************
    DFSS_DEF.SCALE.DATA=[];                    %***************************    
    DFSS_DEF.SCALE.MIN_SIM=1e-12;              %***************************
    DFSS_DEF.SCALE.MIN_RATIO=1e-4;             %***************************    
                                               %***************************
    DFSS_DEF.CROSS.LOGIC=1;                    %***************************
    DFSS_DEF.CROSS.MODE='SIM';                 %***************************
    DFSS_DEF.CROSS.DATA=[];                    %***************************
    DFSS_DEF.CROSS.MIN_SIM=1e-12;              %***************************
    DFSS_DEF.CROSS.MIN_RATIO=1e-4;             %***************************
    DFSS_DEF.CROSS.NU_WIN=[1e9 20e9];          %***************************
    DFSS_DEF.CROSS.PEAK='+';                   %***************************
    DFSS_DEF.CROSS.DIP='+';                    %***************************    
                                               %***************************
    DFSS_DEF.N=1e17;                           %***************************
    DFSS_DEF.KT=0.06;                          %***************************
    DFSS_DEF.PU.AREA=pi*0.0005^2;              %***************************   
    DFSS_DEF.PR.AREA=pi*0.0005^2;              %***************************   
    DFSS_DEF.PU.P_0=0.007;                     %***************************   
    DFSS_DEF.PR.P_0=0.001;                     %***************************       
                                               %*************************** 
    SPEC_DEF.CONT_LOGIC=1;                     %***************************
    SPEC_DEF.NORM_LOGIC=1;                     %***************************
    SPEC_DEF.DX_GROUP=1e-9;                    %***************************
                                               %***************************
    SPEC_DEF.SUM.LOGIC=1;                      %***************************
    SPEC_DEF.SUM.MODE='DEGEN';                 %***************************
    SPEC_DEF.SUM.DX_RATIO=1e-8;                %***************************
    SPEC_DEF.SUM.DX_GRID=5e-14;                %***************************
                                               %*************************** 
    SPEC_DEF.DOP.NTG=1;                        %***************************
    SPEC_DEF.DOP.I=[1,.4];                     %***************************
    SPEC_DEF.DOP.X=[0,0]*1e-10;                %***************************
    SPEC_DEF.DOP.kT_LHS=[.02,200];             %***************************
    SPEC_DEF.DOP.kT_RHS=[.02,200];             %***************************    
                                               %***************************                                                 
    SPEC_DEF.GAU.NF=1;                         %***************************
    SPEC_DEF.GAU.I=[1,.3];                     %***************************
    SPEC_DEF.GAU.X=[0,.55]*1e-10;              %***************************
    SPEC_DEF.GAU.SIG=[0.01,0.03]*1e-10;        %***************************
    SPEC_DEF.GAU.NP_SIG=50;                    %***************************
    SPEC_DEF.GAU.NSIG=5;                       %***************************
                                               %***************************
    SPEC_DEF.LOR.NF=1;                         %***************************
    SPEC_DEF.LOR.I=1;                          %***************************
    SPEC_DEF.LOR.X=0;                          %***************************
    SPEC_DEF.LOR.GAM=.02e-10;                  %***************************
    SPEC_DEF.LOR.NP_GAM=50;                    %***************************
    SPEC_DEF.LOR.NGAM=15;                      %*************************** 
                                               %***************************
    PLOT_DEF.HAM.LOGIC=0;                      %***************************  
    PLOT_DEF.HAM.ADD_H0=0;                     %***************************  
    PLOT_DEF.HAM.B=1;                          %***************************  
    PLOT_DEF.HAM.EDC=1;                        %***************************  
    PLOT_DEF.HAM.EQSA=1;                       %***************************  
    PLOT_DEF.HAM.TOTAL=1;                      %***************************  
    PLOT_DEF.HAM.FLOQUET=0;                    %***************************  
                                               %***************************   
    PLOT_DEF.QS.LOGIC=0;                       %***************************  
    PLOT_DEF.QS.EL=1;                          %***************************  
    PLOT_DEF.QS.WF=1;                          %***************************  
                                               %***************************   
    PLOT_DEF.SPEC.LOGIC=1;                     %*************************** 
    PLOT_DEF.SPEC.NXTICK=5;                    %*************************** 
    PLOT_DEF.SPEC.NYTICK=5;                    %*************************** 
    PLOT_DEF.SPEC.TEXT_BOX='on';               %*************************** 
                                               %***************************
    PLOT_DEF.ATOMIC.LOGIC=0;                   %*************************** 
    PLOT_DEF.ATOMIC.INDEX=0;                   %*************************** 
    PLOT_DEF.ATOMIC.LL=1;                      %*************************** 
    PLOT_DEF.ATOMIC.UL=1;                      %*************************** 
    PLOT_DEF.ATOMIC.QSA=1;                     %*************************** 
    PLOT_DEF.ATOMIC.SUM=1;                     %*************************** 
    PLOT_DEF.ATOMIC.DISC=1;                    %*************************** 
    PLOT_DEF.ATOMIC.CONT=1;                    %***************************                                       
                                               %***************************  
    PLOT_DEF.CROSS.LOGIC=1;                    %*************************** 
    PLOT_DEF.CROSS.INDEX=1;                    %*************************** 
    PLOT_DEF.CROSS.LL=1;                       %*************************** 
    PLOT_DEF.CROSS.UL=1;                       %*************************** 
    PLOT_DEF.CROSS.QSA=1;                      %*************************** 
    PLOT_DEF.CROSS.SUM=1;                      %***************************
    PLOT_DEF.CROSS.PEAK=0;                     %*************************** 
    PLOT_DEF.CROSS.DIP=0;                      %*************************** 
    PLOT_DEF.CROSS.TOTAL=1;                    %*************************** 
    PLOT_DEF.CROSS.DISC=1;                     %*************************** 
    PLOT_DEF.CROSS.CONT=1;                     %*************************** 
                                               %*************************** 
    PLOT_DEF.GEO.LOGIC=1;                      %*************************** 
    PLOT_DEF.GEO.FIG_VIEW=[];                  %*************************** 
    PLOT_DEF.GEO.TEXT_BOX='on';                %***************************     
                                               %*************************** 
    PRINT_DEF.TIME=1;                          %***************************
    PRINT_DEF.RESULTS=1;                       %***************************
    PRINT_DEF.QSA=1;                           %***************************
    PRINT_DEF.DFSS=1;                          %***************************
                                               %***************************                                          
    OPT_DEF.SOLVER=SOLVER_DEF;                 %***************************
    OPT_DEF.FLOQ=FLOQ_DEF;                     %***************************
    OPT_DEF.QUANTUM=QUANTUM_DEF;               %*************************** 
    OPT_DEF.PARALLEL=PARALLEL_DEF;             %***************************    
    OPT_DEF.DIAG=DIAG_DEF;                     %***************************
    OPT_DEF.TRAN=TRAN_DEF;                     %***************************
    OPT_DEF.DFSS=DFSS_DEF;                     %***************************
    OPT_DEF.SPEC=SPEC_DEF;                     %***************************
    OPT_DEF.PLOT=PLOT_DEF;                     %***************************
    OPT_DEF.PRINT=PRINT_DEF;                   %***************************       
                                               %***************************
%**************************************************************************
%***************************DEFAULT OPTIONS********************************
%**************************************************************************

%**************************************************************************
%**********************OPTION FIELD NAMES/SUBNAMES*************************
%**************************************************************************  
OPT_NAME={'SOLVER',...    %%% 1  %%%
          'FLOQ',...      %%% 2  %%%
          'QUANTUM',...   %%% 3  %%%
          'PARALLEL',...  %%% 4  %%%
          'DIAG',...      %%% 5  %%%
          'TRAN',...      %%% 6  %%%
          'DFSS',...      %%% 7  %%%
          'SPEC',...      %%% 8  %%%
          'PLOT',...      %%% 9  %%%
          'PRINT'};       %%% 10 %%%

OPT_SUBNAME{1}={'QSA_LOGIC','MAN_LOGIC','NDT'};
OPT_SUBNAME{2}={'FBC_LOGIC','NB'};
OPT_SUBNAME{3}={'QS_LOGIC','EL','WF'};
OPT_SUBNAME{4}={'PAR_LOGIC','NAP'};
OPT_SUBNAME{5}={'H','HF'};
OPT_SUBNAME{6}={'MIN_RATIO','REF'};
OPT_SUBNAME{7}={'SCALE','CROSS','N','KT','PU','PR'};
OPT_SUBNAME{8}={'CONT_LOGIC','NORM_LOGIC','DX_GROUP','SUM','DOP','GAU','LOR'};
OPT_SUBNAME{9}={'HAM','QS','SPEC','ATOMIC','CROSS','GEO'};
OPT_SUBNAME{10}={'TIME','RESULTS','QSA','DFSS'};

OPT_SUBSUBNAME{1}(1:3)={{''},{''},{''}};
OPT_SUBSUBNAME{2}(1:2)={{''},{''}};
OPT_SUBSUBNAME{3}(1:3)={{''},{''},{''}};
OPT_SUBSUBNAME{4}(1:2)={{''},{''}};
OPT_SUBSUBNAME{5}(1:2)={{''},{''}};
OPT_SUBSUBNAME{6}(1:2)={{''},{''}};
OPT_SUBSUBNAME{7}{1}={'LOGIC','MODE','DATA','MIN_SIM','MIN_RATIO'};
OPT_SUBSUBNAME{7}{2}={'LOGIC','MODE','DATA','MIN_SIM','MIN_RATIO','NU_WIN','PEAK','DIP'};
OPT_SUBSUBNAME{7}(3:4)={{''},{''}};
OPT_SUBSUBNAME{7}{5}={'AREA','P_0'};
OPT_SUBSUBNAME{7}{6}={'AREA','P_0'};
OPT_SUBSUBNAME{8}(1:3)={{''},{''},{''}};
OPT_SUBSUBNAME{8}{4}={'LOGIC','MODE','DX_RATIO','DX_GRID'};
OPT_SUBSUBNAME{8}{5}={'NTG','I','X','kT_LHS','kT_RHS'};
OPT_SUBSUBNAME{8}{6}={'NF','I','X','SIG','NP_SIG','NSIG'};
OPT_SUBSUBNAME{8}{7}={'NF','I','X','GAM','NP_GAM','NGAM'};
OPT_SUBSUBNAME{9}{1}={'LOGIC','ADD_H0','B','EDC','EQSA','TOTAL','FLOQUET'};
OPT_SUBSUBNAME{9}{2}={'LOGIC','EL','WF'};
OPT_SUBSUBNAME{9}{3}={'LOGIC','NXTICK','NYTICK','TEXT_BOX'};
OPT_SUBSUBNAME{9}{4}={'LOGIC','INDEX','LL','UL','QSA','SUM','DISC','CONT'};
OPT_SUBSUBNAME{9}{5}={'LOGIC','INDEX','LL','UL','QSA','SUM','PEAK','DIP','TOTAL','DISC','CONT'};
OPT_SUBSUBNAME{9}{6}={'LOGIC','FIG_VIEW','TEXT_BOX'};
OPT_SUBSUBNAME{10}(1:4)={{''},{''},{''},{''}};

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
PATH{2}=[ROOT_PATH filesep 'SUBROUTINES' filesep 'CONTINUOUS'];
PATH{3}=[ROOT_PATH filesep 'SUBROUTINES' filesep 'DFSS'];
PATH{4}=[ROOT_PATH filesep 'SUBROUTINES' filesep 'DFSSS 4.0'];
PATH{5}=[ROOT_PATH filesep 'SUBROUTINES' filesep 'DFSSS 4.0' filesep 'SUBROUTINES'];
PATH{6}=[ROOT_PATH filesep 'SUBROUTINES' filesep 'DFSSS 4.0' filesep 'SIMULATION DATA'];
PATH{7}=[ROOT_PATH filesep 'PLOTTING ROUTINES'];

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
if NARGIN<=1
    OPT=[];
end

OPT=SET_OPT(OPT,OPT_DEF,OPT_NAMES);
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||||| Read DFSS simulation data |||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
OPT=READ_SIM_DATA(OPT);
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end              %%%% END FOR MODE_LOGIC %%%%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||||||||| Assign options ||||||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SOLVER=OPT.SOLVER; 
QUANTUM=OPT.QUANTUM; 
PARALLEL=OPT.PARALLEL; 
DFSS=OPT.DFSS; 
SPEC=OPT.SPEC;         
PLOT=OPT.PLOT;          
PRINT=OPT.PRINT;        
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%**********************
%Assign logic variables
%**********************
QSA_LOG=SOLVER.QSA_LOGIC;
MAN_LOG=SOLVER.MAN_LOGIC;
QS_LOG=QUANTUM.QS_LOGIC;
PAR_LOG=PARALLEL.PAR_LOGIC;
SC_LOG=DFSS.SCALE.LOGIC;
CR_LOG=DFSS.CROSS.LOGIC;
NORM_LOG=SPEC.NORM_LOGIC;
SUM_LOG=SPEC.SUM.LOGIC;

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||| Open parallel pool of workers |||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if MODE_LOG==1 && PAR_LOG==1
    START_PARPOOL(PARALLEL.NAP);
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||       Assign radiator parameters        |||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
RAD=VAR.RAD;
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||| Assign wave function logic ||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if any(strcmpi(RAD.ATOM,NO_WF_LIST))==1
    WF=0;
else      
    WF=1;
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||| Assign field parameters/logic ||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
[B,EDC,ERF,QSA]=SET_FIELD(VAR,WF,OPT);
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||||| Assign FIELD structure ||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
FIELD.B=B;
FIELD.EDC=EDC;
FIELD.ERF=ERF;
FIELD.QSA=QSA;
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%****************************
%Assign field logic variables
%****************************
ERF_LOG=ERF.LOGIC;

%******************
%Assign solver mode
%******************
if ERF_LOG==1 && QSA_LOG==0 
    SOLVER_MODE='FLOQUET';
elseif (ERF_LOG==1 || MAN_LOG==1) && QSA_LOG==1  
    SOLVER_MODE='QSA';
elseif ERF_LOG==0 
    SOLVER_MODE='STATIC';
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||| Assign specific observation parameters ||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
OBS=SET_OBS(VAR);
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||||| Assign univ. constants ||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
UNIV.h=h;
UNIV.hbar=hbar;
UNIV.q=q;
UNIV.c=c;
UNIV.eo=eo;
UNIV.me=me;
if strcmpi(RAD.ATOM,'H')==1
    UNIV.m=m_H;
elseif strcmpi(RAD.ATOM,'D')==1
    UNIV.m=m_D;
elseif strcmpi(RAD.ATOM,'T')==1
    UNIV.m=m_T;    
elseif strcmpi(RAD.ATOM(1:2),'He')==1
    UNIV.m=m_He;
elseif strcmpi(RAD.ATOM(1:2),'Ar')==1
    UNIV.m=m_Ar;
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%**********************************************************
%Calc. number of states, quantum numbers, and energy levels
%**********************************************************
[NS,QN,EL]=QS_DATA(RAD,UNIV);

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||| Assign RF solver parameters |||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if strcmpi(SOLVER_MODE,'STATIC')==1 || WF==0
    %***********************************
    %Assign parameters for no RF E-field
    %***********************************
    NB=[0,0];
    NBS=NS;
    ND=1;
else
    %*****************************************
    %Assign quasistatic and Floquet parameters
    %*****************************************
    [NB,NBS,ND,FIELD]=SET_RF_OPT(FIELD,NS,OPT);
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||||| Assign PARA structure |||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
PARA.RAD=RAD;
PARA.QN=QN;
PARA.EL=EL;
PARA.NS=NS;
PARA.NB=NB;
PARA.NBS=NBS;
PARA.ND=ND;
PARA.WF=WF;
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||| Calc. the Hamiltonian matrix ||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
[HAM,PARA]=SET_H(PARA,FIELD,UNIV,OPT);
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||||| FLOQUET CALCULATION |||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
if strcmpi(SOLVER_MODE,'FLOQUET')==1           %|||||||||||||||||||||||||||
%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||||| FLOQUET CALCULATION |||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    %*********************************************
    %Calc. eig. vec/val of the Floquet Hamiltonian
    %*********************************************
    [EVec,EVal]=FH_Solver(HAM,PARA,FIELD,UNIV,OPT);
    
    %*****************************************
    %Calc. electric dipole allowed transitions
    %*****************************************
    SPECTRA=TRANS_PROB_WRAPPER(EVec,EVal,OBS,PARA,FIELD,UNIV,OPT);
    
%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||  QUASISTATIC CALCULATION  ||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\    
elseif strcmpi(SOLVER_MODE,'QSA')==1           %|||||||||||||||||||||||||||
%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||  QUASISTATIC CALCULATION  ||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    if PAR_LOG==0
        %*************************************************
        %Calc. eig. vec/val of the quasistatic Hamiltonian 
        %*************************************************
        [EVec,EVal]=H_SOLVER_SER(HAM,PARA,OPT);
        
        %*****************************************
        %Calc. electric dipole allowed transitions
        %*****************************************
        SPECTRA=TRANS_PROB_WRAPPER_SER(EVec,EVal,OBS,PARA,FIELD,UNIV,OPT);
    else
        %*************************************************
        %Calc. eig. vec/val of the quasistatic Hamiltonian 
        %*************************************************
        [EVec,EVal]=H_SOLVER_PAR(HAM,PARA,OPT);
        
        %*****************************************
        %Calc. electric dipole allowed transitions
        %*****************************************
        SPECTRA=TRANS_PROB_WRAPPER_PAR(EVec,EVal,OBS,PARA,FIELD,UNIV,OPT);
    end
    
%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||     STATIC CALCULATION    ||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\    
elseif strcmpi(SOLVER_MODE,'STATIC')==1           %||||||||||||||||||||||||
%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||     STATIC CALCULATION    ||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    %********************************************
    %Calc. eig. vec/val of the static Hamiltonian
    %********************************************
    [EVec,EVal]=H_SOLVER(HAM,PARA,OPT,1);

    %*****************************************
    %Calc. electric dipole allowed transitions
    %*****************************************
    SPECTRA=TRANS_PROB_WRAPPER(EVec,EVal,OBS,PARA,FIELD,UNIV,OPT);
    
end

%*******************************************************
%Scale the intensity to account for DFSS non-linearities
%*******************************************************
if SC_LOG==1
    SPECTRA=SCALE_WRAPPER(SPECTRA,OBS,PARA,UNIV,OPT);
end

%******************************
%Calc. the DFSS crossover peaks
%******************************
if CR_LOG==1
    SPECTRA=CROSS_WRAPPER(SPECTRA,OBS,PARA,UNIV,OPT);
end

%*******************************
%Multiple spectra by QSA weights
%*******************************
if strcmpi(SOLVER_MODE,'QSA')==1
    SPECTRA=QSA_WEIGHT(SPECTRA,PARA,FIELD,OPT);
end

%********************
%Assign quantum state
%********************
if QS_LOG==1
    STATE=QS_ASSIGN(EVec,EVal,PARA,OPT);
end

if SUM_LOG==1
    if strcmpi(SPEC.SUM.MODE,'DEGEN')==1    
        %**************************
        %Sum degenerate transitions
        %**************************
        SPECTRA=SUM_DEG_WRAPPER(SPECTRA,OPT);
    elseif strcmpi(SPEC.SUM.MODE,'GRID')==1    
        %*************************
        %Sum transitions over grid
        %*************************
        SPECTRA=SUM_GRID_WRAPPER(SPECTRA,OPT);
    end
end

%**************************
%Normalize discrete spectra
%**************************
if NORM_LOG==1
    SPECTRA=NORMALIZE(SPECTRA,OPT);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if MODE_LOG==1   %%%% END FOR MODE_LOGIC %%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%*****************
%Print the results
%*****************
if PRINT.RESULTS==1
    PRINT_RESULTS(SPECTRA,FIELD,PARA,OPT)
end

%************************
%Calc. continuous spectra
%************************
if SPEC.CONT_LOGIC==1 || PLOT.SPEC.LOGIC==1
    SPECTRA=CONTINUOUS(SPECTRA,UNIV,OPT);
end

%********************
%Plot the Hamiltonian
%********************
if PLOT.HAM.LOGIC==1
    HAM_PLOT(HAM,PARA,FIELD,OPT)
end

if PLOT.QS.LOGIC==1
    %*****************************************
    %Assign quantum state if option is not set
    %*****************************************
    if QS_LOG==0
        STATE=QS_ASSIGN(EVec,EVal,PARA,OPT);
    end
    
    %**************************
    %Plot the quantum structure
    %**************************
    QS_PLOT(STATE,FIELD,OPT)
end

%****************
%Plot the spectra 
%****************
if PLOT.SPEC.LOGIC==1
    SPEC_PLOT(SPECTRA,OBS,FIELD,OPT)
end

%*****************
%Plot the geometry
%*****************
if PLOT.GEO.LOGIC==1
    GEO_PLOT(OBS,FIELD,OPT)
end

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||||||||||| STOP CLOCK ||||||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
TIME=toc; %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||||||||||| STOP CLOCK ||||||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%**************
%Print run time
%**************
if PRINT.TIME==1
    PRINT_TIME(TIME)
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||||||| Remove folder paths ||||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
for ii=1:NPATH
    rmpath(PATH{ii})
end   
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end              %%%% END FOR MODE_LOGIC %%%%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%***********************
%Assign output structure
%***********************
DATA.SPECTRA=SPECTRA;
DATA.HAM=HAM;
if QS_LOG==1; DATA.STATE=STATE; end
DATA.FIELD=FIELD;
DATA.OBS=OBS;
DATA.PARA=PARA;
DATA.UNIV=UNIV;

end