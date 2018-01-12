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
%               \/\/\/     VERSION:  2.0              \/\/\/
%               /\/\/\        DATE:  12-2-2016        /\/\/\                       
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

%**************************************************************************
%*********************LIST OF ATOMS THAT ARE H-LIKE************************
%**************************************************************************
                                               %***************************
HLIKE_ATOM_LIST={'H',...                       %***************************
                 'D',...                       %***************************
                 'T',...                       %***************************
                 'HeII'};                      %***************************
                                               %***************************
%**************************************************************************
%*********************LIST OF ATOMS THAT ARE H-LIKE************************
%**************************************************************************

%**************************************************************************
%********************LIST OF ATOMS THAT ARE HE-LIKE************************
%**************************************************************************
                                               %***************************
HELIKE_ATOM_LIST={'HeI'};                      %***************************
                                               %***************************
%**************************************************************************
%********************LIST OF ATOMS THAT ARE HE-LIKE************************
%**************************************************************************

%**************************************************************************
%***************************DEFAULT OPTIONS********************************
%**************************************************************************
                                               %***************************
    SOLVER_DEF.QSA=1;                          %***************************
    SOLVER_DEF.NDT=150;                        %***************************
                                               %***************************    
    FLOQ_DEF.NB_CALC=1;                        %***************************
    FLOQ_DEF.NB_SET=[30 50];                   %***************************
                                               %***************************    
    DIAG_DEF.B=[0,0];                          %***************************
    DIAG_DEF.EDC=[0,0];                        %***************************
    DIAG_DEF.ERF=[0,0];                        %***************************   
    DIAG_DEF.FLOQ=[0,0];                       %***************************       
    DIAG_DEF.SOL=[0,0];                        %***************************
                                               %*************************** 
    SPEC_DEF.CONT=1;                           %***************************
    SPEC_DEF.NORM=1;                           %***************************
    SPEC_DEF.REF=1.00028;                      %***************************
    SPEC_DEF.XLIM=1e-9;                        %***************************
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
    SPEC_DEF.GAU.NX_SIG=30;                    %***************************
    SPEC_DEF.GAU.NSIG=5;                       %***************************
                                               %***************************
    SPEC_DEF.LOR.NF=0;                         %***************************
    SPEC_DEF.LOR.I=1;                          %***************************
    SPEC_DEF.LOR.X=0;                          %***************************
    SPEC_DEF.LOR.GAM=.02e-10;                  %***************************
    SPEC_DEF.LOR.NX_GAM=30;                    %***************************
    SPEC_DEF.LOR.NGAM=15;                      %*************************** 
                                               %***************************
    PLOT_DEF.SPEC.LOGIC=1;                     %*************************** 
    PLOT_DEF.SPEC.NXTICK=5;                    %*************************** 
    PLOT_DEF.SPEC.NYTICK=5;                    %*************************** 
    PLOT_DEF.SPEC.TEXT_BOX='on';               %*************************** 
                                               %*************************** 
    PLOT_DEF.GEO.LOGIC=1;                      %*************************** 
    PLOT_DEF.GEO.FIG_VIEW=[];                  %*************************** 
    PLOT_DEF.GEO.TEXT_BOX='on';                %***************************     
                                               %*************************** 
    PRINT_DEF.TIME=1;                          %***************************
    PRINT_DEF.TRAN=1;                          %***************************
    PRINT_DEF.QSA=1;                           %***************************
                                               %***************************                                          
    OPT_DEF.SOLVER=SOLVER_DEF;                 %***************************
    OPT_DEF.FLOQ=FLOQ_DEF;                     %***************************
    OPT_DEF.DIAG=DIAG_DEF;                     %***************************
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
OPT_NAME={'SOLVER','FLOQ','DIAG','SPEC','PLOT','PRINT'};

OPT_SUBNAME{1}={'QSA','NDT'};
OPT_SUBNAME{2}={'NB_CALC','NB_SET'};
OPT_SUBNAME{3}={'B','EDC','ERF','FLOQ','SOL'};
OPT_SUBNAME{4}={'CONT','NORM','REF','XLIM','DOP','GAU','LOR'};
OPT_SUBNAME{5}={'SPEC','GEO'};
OPT_SUBNAME{6}={'TIME','TRAN','QSA'};

OPT_SUBSUBNAME{1}(1:2)={{''},{''}};
OPT_SUBSUBNAME{2}(1:2)={{''},{''}};
OPT_SUBSUBNAME{3}(1:5)={{''},{''},{''},{''},{''}};
OPT_SUBSUBNAME{4}(1:4)={{''},{''},{''},{''}};
OPT_SUBSUBNAME{4}{5}={'NTG','I','X','kT_LHS','kT_RHS'};
OPT_SUBSUBNAME{4}{6}={'NF','I','X','SIG','NX_SIG','NSIG'};
OPT_SUBSUBNAME{4}{7}={'NF','I','X','GAM','NX_GAM','NGAM'};
OPT_SUBSUBNAME{5}{1}={'LOGIC','NXTICK','NYTICK','TEXT_BOX'};
OPT_SUBSUBNAME{5}{2}={'LOGIC','FIG_VIEW','TEXT_BOX'};
OPT_SUBSUBNAME{6}(1:3)={{''},{''},{''}};
%**************************************************************************
%**********************OPTION FIELD NAMES/SUBNAMES*************************
%************************************************************************** 

%**************************************************************************
%*************************VARIABLE FIELD NAMES*****************************
%**************************************************************************   
VAR_NAME={'LINE','B_MAG','EDC_MAG','ERF_MAG','ERF_ANG','NU','VIEW','POL'};

VAR_SUBNAME{1}={'ATOM','FS','PQN','SPIN','WAVE'};
VAR_SUBNAME{2}={''};
VAR_SUBNAME{3}={''};
VAR_SUBNAME{4}={''};
VAR_SUBNAME{5}={''};
VAR_SUBNAME{6}={''};
VAR_SUBNAME{7}={''};
VAR_SUBNAME{8}={''};
%**************************************************************************
%*************************VARIABLE FIELD NAMES*****************************
%**************************************************************************  

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||||||||||||||| START CLOCK ||||||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
tic %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||||||||||||||| START CLOCK ||||||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||||| Assign default options ||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if nargin<3 || (nargin==3 && MODE==0)
    for ii=1:length(OPT_NAME)
        if nargin==1 || (nargin==2 && isfield(OPT,OPT_NAME{ii})==0)
            for jj=1:length(OPT_SUBNAME{ii})
                OPT.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj})=OPT_DEF.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj});
            end
        elseif (nargin==2 && isfield(OPT,OPT_NAME{ii})==1)
            for jj=1:length(OPT_SUBNAME{ii})
                if isfield(OPT.(OPT_NAME{ii}),OPT_SUBNAME{ii}{jj})==0
                    OPT.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj})=OPT_DEF.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj});
                else
                    for kk=1:length(OPT_SUBSUBNAME{ii}{jj})
                        if isempty(OPT_SUBSUBNAME{ii}{jj}{kk})==0
                            if isfield(OPT.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj}),OPT_SUBSUBNAME{ii}{jj}{kk})==0
                                OPT.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj}).(OPT_SUBSUBNAME{ii}{jj}{kk})=OPT_DEF.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj}).(OPT_SUBSUBNAME{ii}{jj}{kk});
                            end
                        end
                    end
                end
            end        
        end
    end
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||||||||| Assign options ||||||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SOLVER=OPT.SOLVER;     
DIAG=OPT.DIAG;          
SPEC=OPT.SPEC;         
PLOT=OPT.PLOT;          
PRINT=OPT.PRINT;        
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%********************************
%Assign RF E-field solver options
%********************************
QSA=SOLVER.QSA;

if QSA==1
    %**************************
    %Assign Quasistatic options
    %**************************
    NDT=SOLVER.NDT;
elseif QSA==0
    %**********************
    %Assign Floquet options
    %**********************
    FLOQ=OPT.FLOQ;

    NB_CALC=FLOQ.NB_CALC;
    NB_SET=FLOQ.NB_SET;
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||| Read Field and Atom Parameters if Missing ||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
EXIT=0;
for ii=1:length(VAR_NAME)
    if (nargin>=1 && isfield(VAR,VAR_NAME{ii})==1)
        %**************************
        %Assign the input variables
        %**************************        
        eval([VAR_NAME{ii} '=VAR.(VAR_NAME{ii});'])
    else
        if EXIT==0
            EXIT=1;
            fprintf('\n<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>\n')
            fprintf('<><><><><><><><><><><><><><><>  INPUT REQUIRED  <><><><><><><><><><><><><><><><>\n')
            fprintf('<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>\n')
        end   

        %*************************
        %Assign the read variables
        %*************************        
        if isempty(VAR_SUBNAME{ii})==1
            STR=['Must define ' VAR_NAME{ii} ' variable= '];
            eval([VAR_NAME{ii} '=input(STR);'])
        else
            for jj=1:length(VAR_SUBNAME{ii})
                STR=['Must define ' VAR_NAME{ii} '.' VAR_SUBNAME{ii}{jj} ' variable= '];
                eval([VAR_NAME{ii} '.' VAR_SUBNAME{ii}{jj} '=input(STR);'])
            end
        end
    end   

    if (ii==length(VAR_NAME) && EXIT==1)
        fprintf('<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>\n')
        fprintf('<><><><><><><><><><><><><><><>  INPUT REQUIRED  <><><><><><><><><><><><><><><><>\n')
        fprintf('<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>\n')
    end
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||||||| Assign RAD structure |||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
RAD.ATOM=LINE.ATOM;      %Assign the atom

if any(strcmpi(RAD.ATOM,NO_WF_LIST))==1
    %********************************
    %Assign the transition parameters
    %********************************
    RAD.WAVE=LINE.WAVE;  %Assign the tranistion wavelength
    
    %**********************************
    %Wavefunctions have no significance
    %**********************************
    WF=0;
    
    %*********************
    %Turn on normalization
    %*********************
    SPEC.NORM=1;
elseif any(strcmpi(RAD.ATOM,HLIKE_ATOM_LIST))==1
    %********************************
    %Assign the transition parameters
    %********************************
    RAD.FS=LINE.FS;      %Assign the fine structure logic
    RAD.PQN=LINE.PQN;    %Assign the principal quantum numbers
    RAD.SPIN=0.5;        %Assign the spin
    
    %*************************************
    %Hydrogenic wavefunctions are utilized
    %*************************************
    WF=1;
elseif any(strcmpi(RAD.ATOM,HELIKE_ATOM_LIST))==1
    %********************************
    %Assign the transition parameters
    %********************************
    RAD.PQN=LINE.PQN;    %Assign the principal quantum numbers
    RAD.SPIN=LINE.SPIN;  %Assign the spin
    
    %*************************************
    %Hydrogenic wavefunctions are utilized
    %*************************************
    WF=1;
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||||||| Assign UNIV structure ||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||||||| Assign OBS structure |||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
OBS.VIEW.POLAR=VIEW(1);
OBS.VIEW.AZIM=VIEW(2);

OBS.POL.LOGIC=POL(1);
if (POL(1)==0)
    %**********************
    %Assign polarizer angle
    %**********************
    OBS.POL.ANG=0;    
    
    %**********************************
    %Define default transmission coeff.
    %**********************************
    OBS.POL.T(1)=1;
    OBS.POL.T(2)=1; 
elseif (POL(1)==1 && length(POL)<4)
    %**********************
    %Assign polarizer angle
    %**********************
    OBS.POL.ANG=POL(2);
    
    %**************************
    %Assign transmission coeff.
    %**************************        
    OBS.POL.T(1)=1;
    OBS.POL.T(2)=0;        
elseif (POL(1)==1 && length(POL)==4)  
    %**********************
    %Assign polarizer angle
    %**********************
    OBS.POL.ANG=POL(2);    
    
    %**********************************
    %Define default transmission coeff.
    %**********************************
    OBS.POL.T(1)=POL(3)/(POL(3)+POL(4));
    OBS.POL.T(2)=POL(4)/(POL(3)+POL(4));
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||||||||| Add folder paths |||||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%******************
%Generate root path
%******************
ROOT_PATH=which(mfilename);
for ii=length(ROOT_PATH):-1:1
    if strcmpi(ROOT_PATH(ii),filesep)==1
        ROOT_PATH=ROOT_PATH(1:ii-1);
        break
    end
end

%***************************************
%List of folders to add in the root path
%***************************************
PATH{1}=[ROOT_PATH filesep 'Plotting Routines'];
PATH{2}=[ROOT_PATH filesep 'Subroutines'];

NPATH=length(PATH);

%*********
%Add paths
%*********
for ii=1:NPATH
    addpath(PATH{ii})
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%**********************************************************
%Calc. number of states, quantum numbers, and energy levels
%**********************************************************
[NS,QN,EL]=QS_Data(RAD,UNIV);

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||| Assign field parameters/logic ||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if (QSA==0 && NB_CALC==0)
    %*******************************
    %Assign number of Floquet blocks
    %*******************************    
    NB=NB_SET;
    
    %******************************
    %Calc. Floquet number of states
    %******************************
    NBS=(2*NB+1).*NS;    
else
    NB=[0,0];
    NBS=[0,0];
end

%*******************
%Number of harmonics
%*******************
NH=length(ERF_MAG(:,1));

%******************
%Define field logic
%******************
if B_MAG>0
    B_ON=1;
else
    B_ON=0;
end

if sum(abs(EDC_MAG))>0
    EDC_ON=1;
else
    EDC_ON=0;
end

if sum(ERF_MAG(1,:))>0
    ERF_ON=1;
else
    ERF_ON=0;
end

%*********************************************************************
%Electric field calc. is only applicable to hydrogen/helium-like atoms
%*********************************************************************
if WF==0
    %************************************************************
    %Null DC electric field if atom is not listed in EF_ATOM_LIST
    %************************************************************
    if EDC_ON==1
        EDC_ON=0;
        
        EDC_MAG=[0 0 0];
    end
    
    %************************************************************
    %Null RF electric field if atom is not listed in EF_ATOM_LIST
    %************************************************************
    if ERF_ON==1
        ERF_ON=0;
        
        NH=1;
        ERF_MAG=[0 0 0];
        ERF_ANG=[0 0 0];
        
        NB=[0,0];
        NBS=[0,0];
    end
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||||| Assign FIELD structure ||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
FIELD.B.MAG=B_MAG;
FIELD.B.LOGIC=B_ON;

FIELD.EDC.MAG=EDC_MAG;
FIELD.EDC.LOGIC=EDC_ON;

FIELD.ERF.MAG=ERF_MAG;
FIELD.ERF.ANG=ERF_ANG;
FIELD.ERF.NU=NU;
FIELD.ERF.NH=NH;
FIELD.ERF.LOGIC=ERF_ON;
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||||| Assign PARA structure |||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
PARA.RAD=RAD;
PARA.NS=NS;
PARA.QN=QN;
PARA.NB=NB;
PARA.NBS=NBS;
PARA.WF=WF;
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%**********************************
%Assign unperturbed matrix elements
%**********************************
Ho=cell(2,1);
for ii=1:2
    Ho{ii}=diag(ones(1,NS(ii))*min(EL(ii,1:NS(ii))));
end

%**********************************
%Assign unperturbed matrix elements
%**********************************
if (ERF_ON==1 && QSA==1)
    H=cell(2,NDT);
    for ii=1:2
        H(ii,1:NDT)={zeros(NS(ii),NS(ii))};
        H(ii,1:NDT)={diag(EL(ii,1:NS(ii)))-Ho{ii}};
    end
elseif (ERF_ON==1 && QSA==0)
    H=cell(2,1:2*NH);
    for ii=1:2
        H(ii,1:2*NH)={zeros(NS(ii),NS(ii))};
        H(ii,1)={diag(EL(ii,1:NS(ii)))-Ho{ii}};
    end    
else
    H=cell(2,1);
    for ii=1:2
        H(ii,1)={diag(EL(ii,1:NS(ii)))-Ho{ii}};
    end
end

%**************************************
%Discretize the electric field waveform
%**************************************
if (ERF_ON==1 && QSA==1)
    EQS=QSA_Weight(FIELD,OPT);
end

if B_ON==1
    %************************************
    %Calc. magnetic field matrix elements
    %************************************    
    H_B=B_MAT(B_MAG,PARA,UNIV,DIAG.B,Ho);

    %*************************************
    %Assign magnetic field matrix elements
    %*************************************
    if (ERF_ON==1 && QSA==1) 
        for ii=1:2
            for jj=1:NDT
                H(ii,jj)={H{ii,jj}+H_B{ii}};
            end
        end
    else
        for ii=1:2
            H(ii,1)={H{ii,1}+H_B{ii}};
        end
    end
end

if EDC_ON==1 || (ERF_ON==1 && QSA==1)
    %*************************************************
    %Calc. (quasi)static electric field matix elements
    %*************************************************
    [H_EDC,MAT]=E_MAT(EDC_MAG,PARA,UNIV,DIAG.EDC,Ho);
    

    if (ERF_ON==1 && QSA==1)  
        for ii=1:NDT
            %***************************************************
            %Calc. spherical basis of quasistatic electric field
            %***************************************************
            EQS_SB(1)=-1/2^0.5*(EQS(1,ii)+1i*EQS(2,ii));
            EQS_SB(2)=EQS(3,ii);
            EQS_SB(3)=1/2^0.5*(EQS(1,ii)-1i*EQS(2,ii));

            %************************************************
            %Assign quasistatic electric field matix elements
            %************************************************
            for jj=1:2
                for kk=1:3
                    H(jj,ii)={H{jj,ii}+EQS_SB(kk)*MAT{jj}(:,:,kk)};
                end
            end
        end
    else
        %*******************************************
        %Assign static electric field matix elements
        %*******************************************        
        for ii=1:2
            H(ii,1)={H{ii,1}+H_EDC{ii}};
        end
    end
end

if (ERF_ON==1 && QSA==0)
    %**************************************************
    %Calc. electric field for fundamental Floquet block
    %**************************************************      
    ERF_TEMP=ERF_MAG(1,1:3)/2;
    
    %************************************************
    %Calc. the dynamic electric field matrix elements
    %************************************************    
    [H_ERF,MAT]=E_MAT(ERF_TEMP,PARA,UNIV,DIAG.ERF,Ho);
    
    %************************************************************
    %Assign fundament Floquet block electric field matix elements
    %************************************************************
    for ii=1:2
        H(ii,2)=H_ERF(ii);
    end
    
    %**********************************
    %Calc. dynamic electric field phase
    %**********************************
    if NH>1
        PHA=exp(1i*ERF_ANG);
    end

    for ii=2:NH
        %***************************************************************
        %Calc. electric field for (+) harmonic of dynamic electric field
        %***************************************************************         
        ERF_TEMP=ERF_MAG(ii,1:3).*PHA(ii,1:3)/2;
        
        %***************************************************************
        %Calc. spherical basis of (+) harmonic of dynamic electric field
        %***************************************************************
        ERF_SB(1)=-1/2^0.5*(ERF_TEMP(1)+1i*ERF_TEMP(2));
        ERF_SB(2)=ERF_TEMP(3);
        ERF_SB(3)=1/2^0.5*(ERF_TEMP(1)-1i*ERF_TEMP(2));
        
        %***************************************************************
        %Assign (+) harmonic Floquet block electric field matix elements
        %***************************************************************
        for jj=1:2
            for kk=1:3
                H(jj,ii+1)={H{jj,ii+1}+ERF_SB(kk)*MAT{jj}(:,:,kk)};
            end
        end
        
        %***************************************************************
        %Calc. electric field for (-) harmonic of dynamic electric field
        %***************************************************************
        ERF_TEMP=ERF_MAG(ii,1:3).*conj(PHA(ii,1:3))/2;
        
        %***************************************************************
        %Calc. spherical basis of (-) harmonic of dynamic electric field
        %***************************************************************
        ERF_SB(1)=-1/2^0.5*(ERF_TEMP(1)+1i*ERF_TEMP(2));
        ERF_SB(2)=ERF_TEMP(3);
        ERF_SB(3)=1/2^0.5*(ERF_TEMP(1)-1i*ERF_TEMP(2));
        
        %***************************************************************
        %Assign (-) harmonic Floquet block electric field matix elements
        %***************************************************************
        for jj=1:2
            for kk=1:3
                H(jj,ii+NH)={H{jj,ii+1}+ERF_SB(kk)*MAT{jj}(:,:,kk)};
            end
        end
    end
end

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||||| FLOQUET CALCULATION |||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
if (ERF_ON==1 && QSA==0) %|||||||||||||||||||||||||||||||||||||||||||||||||
%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||||| FLOQUET CALCULATION |||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    if NB_CALC==1
        %*****************************************
        %Calc. number of Floquet blocks and states
        %*****************************************        
        [NB,NBS,~]=Floquet_Blocks(H,PARA,FIELD,UNIV);
        
        %*********************
        %Assign PARA structure
        %*********************
        PARA.NB=NB;
        PARA.NBS=NBS;
    end        
    
    %***********************************
    %Formulating the Floquet Hamiltonian
    %***********************************
    FH=Floquet_Ham(H,PARA,FIELD,UNIV,DIAG.FLOQ);

    %********************************************
    %Calc. EVec/Eval of the perturbed Hamiltonian
    %********************************************
    [EVec,EVal]=FH_Solver(Ho,H,FH,PARA,FIELD,UNIV);

    %********************
    %Check orthonormality
    %********************
    if DIAG.SOL(1)==1
        Orthonormal(EVec,PARA,DIAG.SOL)
    end
    
    %*****************************************
    %Calc. electric dipole allowed transitions
    %*****************************************
    DATA=Dipole_Trans(EVec,EVal,OBS,PARA,FIELD,UNIV,OPT);
    
%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||||||| (QUASI)STATIC CALCULATION ||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\    
elseif ERF_ON==0 || (ERF_ON==1 && QSA==1) %||||||||||||||||||||||||||||||||
%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||||||| (QUASI)STATIC CALCULATION ||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    %***************
    %Allocate memory
    %***************
    if ERF_ON==1
        I(1:10000*NDT)=0;
        X(1:10000*NDT)=0;
    end
    
    for ii=1:NDT
        %***********************************************************
        %Calc. eigenvalues/eigenvectors of the perturbed Hamiltonian
        %***********************************************************
        [EVec,EVal]=H_Solver(Ho,H(:,ii));

        %********************
        %Check orthonormality
        %********************
        if DIAG.SOL(1)==1
            Orthonormal(EVec,PARA,DIAG.SOL)
        end
        
        %*****************************************
        %Calc. electric dipole allowed transitions
        %*****************************************
        DATA=Dipole_Trans(EVec,EVal,OBS,PARA,FIELD,UNIV,OPT);
        
        %*********************
        %Assign DISC structure
        %*********************
        DISC=DATA.DISC;
        
        %************
        %Conc. arrays
        %************
        if ii==1
            I(1:DISC.NT)=DISC.I;
            X(1:DISC.NT)=DISC.X;
            NT=DISC.NT;
        else
            I(NT+1:NT+DISC.NT)=DISC.I;
            X(NT+1:NT+DISC.NT)=DISC.X;
            NT=NT+DISC.NT;
        end

        if ERF_ON==0
            %****
            %Exit
            %****            
            break
        elseif PRINT.QSA==1
            %***********************************
            %Normalize the quasistatic summation
            %***********************************
            if ii==NDT
                I=I/NDT;
            end
            
            %**************
            %Print progress
            %**************
            QSA_Print(ii,NDT)
        end
    end
    
    %*********************
    %Assign SPEC structure
    %*********************
    DATA.DISC.I=I(1:NT);
    DATA.DISC.X=X(1:NT);
    DATA.DISC.NT=NT;
end

%********************************
%Assign quantum state information
%********************************
if ERF_ON==0 || (ERF_ON==1 && QSA==0)
    DATA=QS_Assign(EVec,EVal,DATA,PARA);
end

%**************************
%Sum degenerate transitions
%**************************
DATA=Deg_Trans(DATA,OPT);

%*****************************
%Calc. continuous line profile
%*****************************
if SPEC.CONT==1
    DATA=Continuous(DATA,UNIV,OPT);
end

%*****************
%Plot line profile
%*****************
if PLOT.SPEC.LOGIC==1
    Spec_Plot(DATA,OBS,FIELD,OPT)
end

%*****************
%Plot the geometry
%*****************
if PLOT.GEO.LOGIC==1
    Geo_Plot(OBS,FIELD,OPT)
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
    Time_Print(TIME)
end

%*******************
%Remove folder paths
%*******************
for ii=1:NPATH
    rmpath(PATH{ii})
end

end