function [PARA_BACK,DATA]=MAIN_BACK(DATA,NSPF,OPT,BGN)

%**********************************************************
%Field names for the externally set fit parameters avaiable
%**********************************************************
PARA_NAME={'LINE','NU','NDT','NH_X','NH_Y','NH_Z','NTG','NFL','PSL','PSV',...
    'PSB','NDPS','PSSP'};
    
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>    SPECTRA MODEL OPTIONS     <><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%||||||DO NOT MODIFY||||||||||||DO NOT MODIFY|||||||||||DO NOT MODIFY||||||
%||||||DO NOT MODIFY||||||||||||DO NOT MODIFY|||||||||||DO NOT MODIFY||||||
%||||||DO NOT MODIFY||||||||||||DO NOT MODIFY|||||||||||DO NOT MODIFY||||||
MODEL_OPT.SOLVER.QSA=1;                     %|||||||||||DO NOT MODIFY||||||                
                                            %|||||||||||DO NOT MODIFY|||||| 
MODEL_OPT.DIAG.B=[0,0];                     %|||||||||||DO NOT MODIFY||||||   
MODEL_OPT.DIAG.EDC=[0,0];                   %|||||||||||DO NOT MODIFY||||||   
MODEL_OPT.DIAG.ERF=[0,0];                   %|||||||||||DO NOT MODIFY||||||   
MODEL_OPT.DIAG.FLOQ=[0,0];                  %|||||||||||DO NOT MODIFY||||||   
MODEL_OPT.DIAG.SOL=[0,0];                   %|||||||||||DO NOT MODIFY||||||   
                                            %|||||||||||DO NOT MODIFY|||||| 
MODEL_OPT.SPEC.REF=1.00028;                 %|||||||||||DO NOT MODIFY|||||| 
MODEL_OPT.SPEC.CONT=0;                      %|||||||||||DO NOT MODIFY||||||
MODEL_OPT.SPEC.NORM=0;                      %|||||||||||DO NOT MODIFY||||||
MODEL_OPT.PLOT.SPEC.LOGIC=0;                %|||||||||||DO NOT MODIFY||||||
MODEL_OPT.PLOT.GEO.LOGIC=0;                 %|||||||||||DO NOT MODIFY||||||
                                            %|||||||||||DO NOT MODIFY||||||  
MODEL_OPT.PRINT.TIME=0;                     %|||||||||||DO NOT MODIFY||||||                        
MODEL_OPT.PRINT.TRAN=0;                     %|||||||||||DO NOT MODIFY||||||   
MODEL_OPT.PRINT.QSA=0;                      %|||||||||||DO NOT MODIFY||||||   
%||||||DO NOT MODIFY||||||||||||DO NOT MODIFY|||||||||||DO NOT MODIFY||||||
%||||||DO NOT MODIFY||||||||||||DO NOT MODIFY|||||||||||DO NOT MODIFY||||||
%||||||DO NOT MODIFY||||||||||||DO NOT MODIFY|||||||||||DO NOT MODIFY||||||

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>    SPECTRA MODEL OPTIONS     <><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

if BGN==1
    
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><>   FIT PARAMETER SETPOINTS FOR BG 1   <><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    
    %************************
    %Spectral line parameters
    %************************
    LINE_TEMP.ATOM='ArII';
    LINE_TEMP.WAVE='4806A';
    LINE(1:NSPF)={LINE_TEMP};

    %***************
    %Frequency (GHz)
    %***************
    NU=0.01356;

    %******************************
    %Number of time discretizations
    %******************************
    NDT=20;

    %*******************
    %Number of harmonics
    %*******************
    NH_X=0;
    NH_Y=0;
    NH_Z=0;

    %****************************
    %Number of temperature groups
    %****************************
    NTG=1;

    %******************************
    %Number of Lorentzian functions
    %******************************
    NFL=0;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>   FIT PARAMETER SETPOINTS    <><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>   VARIABLE SETPOINTS   <><><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    %***********************
    %Polar observation angle
    %***********************
    THETA(1:NSPF)={35*pi/180};

    %***************************
    %Azimuthal observation angle
    %***************************
    PHI(1:NSPF)={0};

    %***************
    %Polarizer angle
    %***************
    SIGMA(1:NSPF)={0};

    %********************************
    %Parallel transmission coefficent
    %********************************
    TM1(1:NSPF)={1};

    %*************************************
    %Perpendicular transmission coefficent
    %*************************************
    TM2(1:NSPF)={0};

    %*****************************
    %Z-Component of magnetic field
    %*****************************
    B_Z(1:NSPF)={3.9};

    %*****************************
    %X-Component of electric field
    %*****************************
    EDC_X(1:NSPF)={0};
    ERF_X(1:NSPF)={[0,0,0]};
    PHA_ANG_X(1:NSPF)={[0,0,0]};

    %*****************************
    %Y-Component of electric field
    %*****************************
    EDC_Y(1:NSPF)={0};
    ERF_Y(1:NSPF)={[0,0,0]};
    PHA_ANG_Y(1:NSPF)={[0,0,0]};

    %*****************************
    %Z-Component of electric field
    %*****************************
    EDC_Z(1:NSPF)={0};
    ERF_Z(1:NSPF)={[0,0,0]};
    PHA_ANG_Z(1:NSPF)={[0,0,0]};

    %*******************************
    %Radiator distrubtion parameters
    %*******************************
    kT_DOP(1:NSPF)={[1,100,0,0]};
    X_DOP(1:NSPF)={[0,0,0,0]};
    I_DOP(1:NSPF)={[1,1,1,1]};

    %******************************
    %Lorentzian function parameters
    %******************************
    GAM_LOR(1:NSPF)={[1,.1,0,0]};
    X_LOR(1:NSPF)={[0,0,0,0]};
    I_LOR(1:NSPF)={[1,.3,1,1]};

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>   VARIABLE SETPOINTS   <><><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>   FIT VARIABLE LOGIC   <><><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    %***********************
    %Polar observation angle
    %***********************
    PSL_THETA=1;

    %***************************
    %Azimuthal observation angle
    %***************************
    PSL_PHI=1;

    %***************
    %Polarizer angle
    %***************
    PSL_SIGMA=1;

    %********************************
    %Parallel transmission coefficent
    %********************************
    PSL_TM1=1;

    %*************************************
    %Perpendicular transmission coefficent
    %*************************************
    PSL_TM2=1;

    %*****************************
    %Z-Component of magnetic field
    %*****************************
    PSL_B_Z=1;

    %*****************************
    %X-Component of electric field
    %*****************************
    PSL_EDC_X=1;
    PSL_ERF_X=[1,1,1];
    PSL_PHA_ANG_X=[1,1,1];

    %*****************************
    %Y-Component of electric field
    %*****************************
    PSL_EDC_Y=1;
    PSL_ERF_Y=[1,1,1];
    PSL_PHA_ANG_Y=[1,1,1];

    %*****************************
    %Z-Component of electric field
    %*****************************
    PSL_EDC_Z=1;
    PSL_ERF_Z=[1,1,1];
    PSL_PHA_ANG_Z=[1,1,1];

    %*******************************
    %Radiator distrubtion parameters
    %*******************************
    PSL_kT_DOP=[1,1,0,0];
    PSL_X_DOP=[1,1,0,0];
    PSL_I_DOP=[1,1,0,0];

    %******************************
    %Lorentzian function parameters
    %******************************
    PSL_GAM_LOR=[1,1,0,0];
    PSL_X_LOR=[1,1,0,0];
    PSL_I_LOR=[1,1,0,0];

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>   FIT VARIABLE LOGIC   <><><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><>  FIT VARIABLE DISCRETIZATION   <><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    %***********************
    %Polar observation angle
    %***********************
    NDPS_THETA=5;

    %***************************
    %Azimuthal observation angle
    %***************************
    NDPS_PHI=10;

    %***************
    %Polarizer angle
    %***************
    NDPS_SIGMA=10;

    %********************************
    %Parallel transmission coefficent
    %********************************
    NDPS_TM1=10;

    %*************************************
    %Perpendicular transmission coefficent
    %*************************************
    NDPS_TM2=4;

    %*****************************
    %Z-Component of magnetic field
    %*****************************
    NDPS_B_Z=8;

    %*****************************
    %X-Component of electric field
    %*****************************
    NDPS_EDC_X=8;
    NDPS_ERF_X=[8,10,10];
    NDPS_PHA_ANG_X=[15,15,15];

    %*****************************
    %Y-Component of electric field
    %*****************************
    NDPS_EDC_Y=5;
    NDPS_ERF_Y=[4,10,10];
    NDPS_PHA_ANG_Y=[15,15,15];

    %*****************************
    %Z-Component of electric field
    %*****************************
    NDPS_EDC_Z=5;
    NDPS_ERF_Z=[6,10,10];
    NDPS_PHA_ANG_Z=[15,15,15];

    %*******************************
    %Radiator distrubtion parameters
    %*******************************
    NDPS_kT_DOP=[15,8,8,8];
    NDPS_X_DOP=[15,8,8,8];
    NDPS_I_DOP=[8,15,8,8];

    %******************************
    %Lorentzian function parameters
    %******************************
    NDPS_GAM_LOR=[10,10,10,10];
    NDPS_X_LOR=[10,10,10,10];
    NDPS_I_LOR=[10,10,10,10];

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><>  FIT VARIABLE DISCRETIZATION   <><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>  FIT VARIABLE BOUNDARIES   <><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    %***********************
    %Polar observation angle
    %***********************
    PSB_THETA={[0,pi/4]};

    %***************************
    %Azimuthal observation angle
    %***************************
    PSB_PHI={[0,2*pi]};

    %***************
    %Polarizer angle
    %***************
    PSB_SIGMA={[0,pi/2]};

    %********************************
    %Parallel transmission coefficent
    %********************************
    PSB_TM1={[.15,.65]};

    %*************************************
    %Perpendicular transmission coefficent
    %*************************************
    PSB_TM2={[0,.65]};

    %*****************************
    %Z-Component of magnetic field
    %*****************************
    PSB_B_Z={[3.5,4.0]};

    %*****************************
    %X-Component of electric field
    %*****************************
    PSB_EDC_X={[-4,-6]};
    PSB_ERF_X={[2,4],[0,3],[0,3]};
    PSB_PHA_ANG_X={[0,2*pi],[0,2*pi],[0,2*pi]};

    %*****************************
    %Y-Component of electric field
    %*****************************
    PSB_EDC_Y={[-4,-6]};
    PSB_ERF_Y={[0,4],[0,3],[0,3]};
    PSB_PHA_ANG_Y={[0,2*pi],[0,2*pi],[0,2*pi]};

    %*****************************
    %Z-Component of electric field
    %*****************************
    PSB_EDC_Z={[-4,-6]};
    PSB_ERF_Z={[0,3],[0,3],[0,3]};
    PSB_PHA_ANG_Z={[0,2*pi],[0,2*pi],[0,2*pi]};

    %*******************************
    %Radiator distrubtion parameters
    %*******************************
    PSB_kT_DOP={[5,10],[100,150]};
    PSB_X_DOP={[-.1,0.1],[-1,1]};
    PSB_I_DOP={[.0,1],[1,1.5]};

    %******************************
    %Lorentzian function parameters
    %******************************
    PSB_GAM_LOR={[.01,.04],[.1,0.3]};
    PSB_X_LOR={[-1,1],[-1,1]};
    PSB_I_LOR={[.1,1],[0,0.5]};

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>  FIT VARIABLE BOUNDARIES   <><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

else
    
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><>   FIT PARAMETER SETPOINTS FOR ALL OTHER BG   <><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    
    %************************
    %Spectral line parameters
    %************************
    LINE(1:NSPF)={{2,'D',.5,[2,4]}};

    %***************
    %Frequency (GHz)
    %***************
    NU=0.01356;

    %******************************
    %Number of time discretizations
    %******************************
    NDT=20;

    %*******************
    %Number of harmonics
    %*******************
    NH_X=0;
    NH_Y=0;
    NH_Z=0;

    %****************************
    %Number of temperature groups
    %****************************
    NTG=1;

    %******************************
    %Number of Lorentzian functions
    %******************************
    NFL=0;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>   FIT PARAMETER SETPOINTS    <><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>   VARIABLE SETPOINTS   <><><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    %***********************
    %Polar observation angle
    %***********************
    THETA(1:NSPF)={35*pi/180};

    %***************************
    %Azimuthal observation angle
    %***************************
    PHI(1:NSPF)={0};

    %***************
    %Polarizer angle
    %***************
    SIGMA(1:NSPF)={0};

    %********************************
    %Parallel transmission coefficent
    %********************************
    TM1(1:NSPF)={1};

    %*************************************
    %Perpendicular transmission coefficent
    %*************************************
    TM2(1:NSPF)={0};

    %*****************************
    %Z-Component of magnetic field
    %*****************************
    B_Z(1:NSPF)={3.9};

    %*****************************
    %X-Component of electric field
    %*****************************
    EDC_X(1:NSPF)={0};
    ERF_X(1:NSPF)={[0,0,0]};
    PHA_ANG_X(1:NSPF)={[0,0,0]};

    %*****************************
    %Y-Component of electric field
    %*****************************
    EDC_Y(1:NSPF)={0};
    ERF_Y(1:NSPF)={[0,0,0]};
    PHA_ANG_Y(1:NSPF)={[0,0,0]};

    %*****************************
    %Z-Component of electric field
    %*****************************
    EDC_Z(1:NSPF)={0};
    ERF_Z(1:NSPF)={[0,0,0]};
    PHA_ANG_Z(1:NSPF)={[0,0,0]};

    %*******************************
    %Radiator distrubtion parameters
    %*******************************
    kT_DOP(1:NSPF)={[1,100,0,0]};
    X_DOP(1:NSPF)={[0,0,0,0]};
    I_DOP(1:NSPF)={[1,1,1,1]};

    %******************************
    %Lorentzian function parameters
    %******************************
    GAM_LOR(1:NSPF)={[1,.1,0,0]};
    X_LOR(1:NSPF)={[0,0,0,0]};
    I_LOR(1:NSPF)={[1,.3,1,1]};

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>   VARIABLE SETPOINTS   <><><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>   FIT VARIABLE LOGIC   <><><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    %***********************
    %Polar observation angle
    %***********************
    PSL_THETA=1;

    %***************************
    %Azimuthal observation angle
    %***************************
    PSL_PHI=1;

    %***************
    %Polarizer angle
    %***************
    PSL_SIGMA=1;

    %********************************
    %Parallel transmission coefficent
    %********************************
    PSL_TM1=1;

    %*************************************
    %Perpendicular transmission coefficent
    %*************************************
    PSL_TM2=1;

    %*****************************
    %Z-Component of magnetic field
    %*****************************
    PSL_B_Z=0;

    %*****************************
    %X-Component of electric field
    %*****************************
    PSL_EDC_X=1;
    PSL_ERF_X=[1,1,1];
    PSL_PHA_ANG_X=[1,1,1];

    %*****************************
    %Y-Component of electric field
    %*****************************
    PSL_EDC_Y=1;
    PSL_ERF_Y=[1,1,1];
    PSL_PHA_ANG_Y=[1,1,1];

    %*****************************
    %Z-Component of electric field
    %*****************************
    PSL_EDC_Z=1;
    PSL_ERF_Z=[1,1,1];
    PSL_PHA_ANG_Z=[1,1,1];

    %*******************************
    %Radiator distrubtion parameters
    %*******************************
    PSL_kT_DOP=[1,1,0,0];
    PSL_X_DOP=[0,1,0,0];
    PSL_I_DOP=[1,1,0,0];

    %******************************
    %Lorentzian function parameters
    %******************************
    PSL_GAM_LOR=[1,1,0,0];
    PSL_X_LOR=[1,1,0,0];
    PSL_I_LOR=[1,1,0,0];

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>   FIT VARIABLE LOGIC   <><><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><>  FIT VARIABLE DISCRETIZATION   <><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    %***********************
    %Polar observation angle
    %***********************
    NDPS_THETA=5;

    %***************************
    %Azimuthal observation angle
    %***************************
    NDPS_PHI=10;

    %***************
    %Polarizer angle
    %***************
    NDPS_SIGMA=10;

    %********************************
    %Parallel transmission coefficent
    %********************************
    NDPS_TM1=10;

    %*************************************
    %Perpendicular transmission coefficent
    %*************************************
    NDPS_TM2=4;

    %*****************************
    %Z-Component of magnetic field
    %*****************************
    NDPS_B_Z=8;

    %*****************************
    %X-Component of electric field
    %*****************************
    NDPS_EDC_X=8;
    NDPS_ERF_X=[8,10,10];
    NDPS_PHA_ANG_X=[15,15,15];

    %*****************************
    %Y-Component of electric field
    %*****************************
    NDPS_EDC_Y=5;
    NDPS_ERF_Y=[4,10,10];
    NDPS_PHA_ANG_Y=[15,15,15];

    %*****************************
    %Z-Component of electric field
    %*****************************
    NDPS_EDC_Z=5;
    NDPS_ERF_Z=[6,10,10];
    NDPS_PHA_ANG_Z=[15,15,15];

    %*******************************
    %Radiator distrubtion parameters
    %*******************************
    NDPS_kT_DOP=[15,8,8,8];
    NDPS_X_DOP=[15,8,8,8];
    NDPS_I_DOP=[8,15,8,8];

    %******************************
    %Lorentzian function parameters
    %******************************
    NDPS_GAM_LOR=[10,10,10,10];
    NDPS_X_LOR=[10,10,10,10];
    NDPS_I_LOR=[10,10,10,10];

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><>  FIT VARIABLE DISCRETIZATION   <><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>  FIT VARIABLE BOUNDARIES   <><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    %***********************
    %Polar observation angle
    %***********************
    PSB_THETA={[0,pi/4]};

    %***************************
    %Azimuthal observation angle
    %***************************
    PSB_PHI={[0,2*pi]};

    %***************
    %Polarizer angle
    %***************
    PSB_SIGMA={[0,pi/2]};

    %********************************
    %Parallel transmission coefficent
    %********************************
    PSB_TM1={[.15,.65]};

    %*************************************
    %Perpendicular transmission coefficent
    %*************************************
    PSB_TM2={[0,.65]};

    %*****************************
    %Z-Component of magnetic field
    %*****************************
    PSB_B_Z={[3.5,4.0]};

    %*****************************
    %X-Component of electric field
    %*****************************
    PSB_EDC_X={[-4,-6]};
    PSB_ERF_X={[2,4],[0,3],[0,3]};
    PSB_PHA_ANG_X={[0,2*pi],[0,2*pi],[0,2*pi]};

    %*****************************
    %Y-Component of electric field
    %*****************************
    PSB_EDC_Y={[-4,-6]};
    PSB_ERF_Y={[0,4],[0,3],[0,3]};
    PSB_PHA_ANG_Y={[0,2*pi],[0,2*pi],[0,2*pi]};

    %*****************************
    %Z-Component of electric field
    %*****************************
    PSB_EDC_Z={[-4,-6]};
    PSB_ERF_Z={[0,3],[0,3],[0,3]};
    PSB_PHA_ANG_Z={[0,2*pi],[0,2*pi],[0,2*pi]};

    %*******************************
    %Radiator distrubtion parameters
    %*******************************
    PSB_kT_DOP={[5,10],[100,150]};
    PSB_X_DOP={[-.1,0.1],[-1,1]};
    PSB_I_DOP={[.0,1],[1,1.5]};

    %******************************
    %Lorentzian function parameters
    %******************************
    PSB_GAM_LOR={[.01,.04],[.1,0.3]};
    PSB_X_LOR={[-1,1],[-1,1]};
    PSB_I_LOR={[.1,1],[0,0.5]};

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>  FIT VARIABLE BOUNDARIES   <><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

end

%****************************
%Assign fit parameter options
%****************************
if (isfield(OPT,'PARA_BACK')==1)
    for ii=1:length(PARA_NAME)
        if (isfield(OPT.PARA_BACK(BGN),PARA_NAME{ii})==1)
            PARA_LOGIC.(PARA_NAME{ii})=1;
            eval([PARA_NAME{ii} '=OPT.PARA_BACK(BGN).(PARA_NAME{ii});'])
        else
            PARA_LOGIC.(PARA_NAME{ii})=0;
        end
    end
else
    for ii=1:length(PARA_NAME)
        PARA_LOGIC.(PARA_NAME{ii})=0;
    end 
end

%||||||||||||||||||||||||SHOULD BE SAME AS IN MAIN.M|||||||||||||||||||||||
%||||||||||||||||||||||||SHOULD BE SAME AS IN MAIN.M|||||||||||||||||||||||
%||||||||||||||||||||||||SHOULD BE SAME AS IN MAIN.M|||||||||||||||||||||||
                                                                      %||||  
%****************                                                     %||||
%Number of groups                                                     %||||
%****************                                                     %||||
NPSG=13;                                                              %||||
                                                                      %||||
%********************************                                     %||||
%Number of groups run in parallel                                     %||||
%********************************                                     %||||
NPSGP=6;                                                              %||||
                                                                      %||||
%******************************                                       %||||
%Number of groups run in serial                                       %||||
%******************************                                       %||||
NPSGS=[4,3];                                                          %||||
                                                                      %||||
%***************************                                          %||||
%Number variables per groups                                          %||||
%***************************                                          %||||
PSNM=[2,3,1,2*NH_X+1,2*NH_Y+1,2*NH_Z+1,NTG,NTG,NTG,NFL,NFL,NFL,0];    %||||
                                                                      %||||
%*************************************                                %||||
%Group order for parallel/serial calc.                                %||||
%*************************************                                %||||
PSO=[1,2,3,4,5,6,7,8,10,11,9,12,13];                                  %||||
                                                                      %||||
%*************************                                            %||||
%Calc. number of variables                                            %||||
%*************************                                            %||||
NV=sum(PSNM);                                                         %||||
                                                                      %||||
%||||||||||||||||||||||||SHOULD BE SAME AS IN MAIN.M|||||||||||||||||||||||
%||||||||||||||||||||||||SHOULD BE SAME AS IN MAIN.M|||||||||||||||||||||||
%||||||||||||||||||||||||SHOULD BE SAME AS IN MAIN.M|||||||||||||||||||||||

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%||||||||||||||||||||    ASSIGN FIT VARIABLE LOGIC    |||||||||||||||||||||
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

if PARA_LOGIC.PSL==0
    %******************
    %Observation angles
    %******************
    PSL(1:PSNM(1))=[PSL_THETA,PSL_PHI];
    
    %************
    %Polarization
    %************
    PSL(sum(PSNM(1:1))+1:sum(PSNM(1:2)))=[PSL_SIGMA,PSL_TM1,PSL_TM2];
    
    %*****************************
    %Z-component of magnetic field
    %*****************************
    PSL(sum(PSNM(1:2))+1:sum(PSNM(1:3)))=PSL_B_Z;
    
    %*****************************
    %X-component of electric field
    %*****************************
    PSL(sum(PSNM(1:3))+1:sum(PSNM(1:4)))=[PSL_EDC_X PSL_ERF_X(1:NH_X) PSL_PHA_ANG_X(1:NH_X)];
    
    %*****************************
    %Y-component of electric field
    %*****************************
    PSL(sum(PSNM(1:4))+1:sum(PSNM(1:5)))=[PSL_EDC_Y PSL_ERF_Y(1:NH_Y) PSL_PHA_ANG_Y(1:NH_Y)];
    
    %*****************************
    %Z-component of electric field
    %*****************************
    PSL(sum(PSNM(1:5))+1:sum(PSNM(1:6)))=[PSL_EDC_Z PSL_ERF_Z(1:NH_Z) PSL_PHA_ANG_Z(1:NH_Z)];
    
    %*******************************
    %Radiator distrubtion parameters
    %*******************************
    PSL(sum(PSNM(1:6))+1:sum(PSNM(1:7)))=PSL_kT_DOP(1:NTG);
    PSL(sum(PSNM(1:7))+1:sum(PSNM(1:8)))=PSL_X_DOP(1:NTG);
    PSL(sum(PSNM(1:8))+1:sum(PSNM(1:9)))=PSL_I_DOP(1:NTG);
    
    %******************************
    %Lorentzian function parameters
    %******************************
    PSL(sum(PSNM(1:9))+1:sum(PSNM(1:10)))=PSL_GAM_LOR(1:NFL);
    PSL(sum(PSNM(1:10))+1:sum(PSNM(1:11)))=PSL_X_LOR(1:NFL);
    PSL(sum(PSNM(1:11))+1:sum(PSNM(1:12)))=PSL_I_LOR(1:NFL);
end

%********************
%Background intensity
%********************
PSL(sum(PSNM(1:12))+1:sum(PSNM(1:13)))=1;

%***************************************
%Calc. number of fit variables per group
%***************************************
PSN(1:NPSG)=0;
for ii=1:NPSG
    N1=sum(PSNM(1:ii-1))+1;
    N2=sum(PSNM(1:ii));
    PSN(ii)=PSNM(ii)-sum(PSL(N1:N2));
end

%*****************************
%Calc. number of fit variables
%*****************************
ND=sum(PSN);

%************************************************
%Calc. number of fit variables for parallel calc.
%************************************************
NDP=sum(PSN(1:NPSGP));

%**********************************************
%Calc. number of fit variables for serial calc.
%**********************************************
NDS(1:length(NPSGS))=0;
for ii=1:length(NPSGS)
    N1=NPSGP+sum(NPSGS(1:ii-1))+1;
    N2=NPSGP+sum(NPSGS(1:ii));
    NDS(ii)=sum(PSN(N1:N2));
end

%*************************
%Calc fit variable indices
%*************************
jj=0;
PSI(1:ND)=0;
for ii=1:NPSG
    if (PSN(PSO(ii))>0)
        for kk=1:PSN(PSO(ii))
            jj=jj+1;
            PSI(jj)=sum(PSN(1:PSO(ii)-1))+kk;
        end
    end
end

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%||||||||||||||||||||    ASSIGN VARIABLE SETPOINTS    |||||||||||||||||||||
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

if PARA_LOGIC.PSV==0
    %***************
    %Allocate memory
    %***************
    PSV=cell(1,NSPF);

    for ii=1:NSPF
        %******************
        %Observation angles
        %******************
        PSV{ii}(1:PSNM(1))=[THETA{ii},PHI{ii}];

        %************
        %Polarization
        %************
        PSV{ii}(sum(PSNM(1:1))+1:sum(PSNM(1:2)))=[SIGMA{ii},TM1{ii},TM2{ii}];

        %*****************************
        %Z-component of magnetic field
        %*****************************
        PSV{ii}(sum(PSNM(1:2))+1:sum(PSNM(1:3)))=B_Z{ii};

        %*****************************
        %X-component of electric field
        %*****************************
        PSV{ii}(sum(PSNM(1:3))+1:sum(PSNM(1:4)))=[EDC_X{ii} ERF_X{ii}(1:NH_X) PHA_ANG_X{ii}(1:NH_X)];

        %*****************************
        %Y-component of electric field
        %*****************************
        PSV{ii}(sum(PSNM(1:4))+1:sum(PSNM(1:5)))=[EDC_Y{ii} ERF_Y{ii}(1:NH_Y) PHA_ANG_Y{ii}(1:NH_Y)];

        %*****************************
        %Z-component of electric field
        %*****************************
        PSV{ii}(sum(PSNM(1:5))+1:sum(PSNM(1:6)))=[EDC_Z{ii} ERF_Z{ii}(1:NH_Z) PHA_ANG_Z{ii}(1:NH_Z)];

        %*******************************
        %Radiator distrubtion parameters
        %*******************************
        PSV{ii}(sum(PSNM(1:6))+1:sum(PSNM(1:7)))=kT_DOP{ii}(1:NTG);
        PSV{ii}(sum(PSNM(1:7))+1:sum(PSNM(1:8)))=X_DOP{ii}(1:NTG);
        PSV{ii}(sum(PSNM(1:8))+1:sum(PSNM(1:9)))=I_DOP{ii}(1:NTG);

        %******************************
        %Lorentzian function parameters
        %******************************
        PSV{ii}(sum(PSNM(1:9))+1:sum(PSNM(1:10)))=GAM_LOR{ii}(1:NFL);
        PSV{ii}(sum(PSNM(1:10))+1:sum(PSNM(1:11)))=X_LOR{ii}(1:NFL);
        PSV{ii}(sum(PSNM(1:11))+1:sum(PSNM(1:12)))=I_LOR{ii}(1:NFL);
    end
end

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%|||||||||||||||||    ASSIGN FIT VARIABLE BOUNDARIES    |||||||||||||||||||
%|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| 

if PARA_LOGIC.PSB==0
    %***************
    %Allocate memory
    %***************
    PSB(1:ND,1:2)=0; 
    
    %****************
    %Initialize index
    %****************
    ll=0;
    mm=1;
    
    %******************
    %Observation angles
    %******************
    if PSL(mm)==0
        ll=ll+1;
        PSB(ll,1:2)=PSB_THETA{1};
    end
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        PSB(ll,1:2)=PSB_PHI{1};
    end    
    
    %************
    %Polarization
    %************
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        PSB(ll,1:2)=PSB_SIGMA{1};
    end   
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        PSB(ll,1:2)=PSB_TM1{1};
    end   
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        PSB(ll,1:2)=PSB_TM2{1};
    end       
    
    %*****************************
    %Z-component of magnetic field
    %*****************************
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        PSB(ll,1:2)=PSB_B_Z{1};
    end
    
    %*****************************
    %X-component of electric field
    %*****************************
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        PSB(ll,1:2)=PSB_EDC_X{1};
    end
    for ii=1:NH_X
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            PSB(ll,1:2)=PSB_ERF_X{ii};
        end
    end
    for ii=1:NH_X
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            PSB(ll,1:2)=PSB_PHA_ANG_X{ii};
        end
    end
    
    %*****************************
    %Y-component of electric field
    %*****************************
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        PSB(ll,1:2)=PSB_EDC_Y{1};
    end
    for ii=1:NH_Y
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            PSB(ll,1:2)=PSB_ERF_Y{ii};
        end
    end
    for ii=1:NH_Y
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            PSB(ll,1:2)=PSB_PHA_ANG_Y{ii};
        end
    end
    
    %*****************************
    %Z-component of electric field
    %*****************************
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        PSB(ll,1:2)=PSB_EDC_Z{1};
    end
    for ii=1:NH_Z
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            PSB(ll,1:2)=PSB_ERF_Z{ii};
        end
    end
    for ii=1:NH_Z
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            PSB(ll,1:2)=PSB_PHA_ANG_Z{ii};
        end
    end    
    
    %*******************************
    %Radiator distrubtion parameters
    %*******************************
    for ii=1:NTG
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            PSB(ll,1:2)=PSB_kT_DOP{ii};
        end
    end
    for ii=1:NTG
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            PSB(ll,1:2)=PSB_X_DOP{ii};
        end
    end
    for ii=1:NTG
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            PSB(ll,1:2)=PSB_I_DOP{ii};
        end
    end
    
    %******************************
    %Lorentzian function parameters
    %******************************
    for ii=1:NFL
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            PSB(ll,1:2)=PSB_GAM_LOR{ii};
        end
    end
    for ii=1:NFL
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            PSB(ll,1:2)=PSB_X_LOR{ii};
        end
    end    
    for ii=1:NFL
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            PSB(ll,1:2)=PSB_I_LOR{ii};
        end
    end 
end

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%|||||||||||||||    ASSIGN FIT VARIABLE DISCRETIZATION    |||||||||||||||||
%|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| 

if PARA_LOGIC.NDPS==0
    %***************
    %Allocate memory
    %***************
    NDPS(1:ND)=0;
    
    %****************
    %Initialize index
    %****************
    ll=0;
    mm=1;
    
    %******************
    %Observation angles
    %******************
    if PSL(mm)==0
        ll=ll+1;
        NDPS(ll)=NDPS_THETA;
    end
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        NDPS(ll)=NDPS_PHI;
    end 
    
    %************
    %Polarization
    %************
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        NDPS(ll)=NDPS_SIGMA;
    end 
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        NDPS(ll)=NDPS_TM1;
    end 
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        NDPS(ll)=NDPS_TM2;
    end  
    
    %*****************************
    %Z-component of magnetic field
    %*****************************
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        NDPS(ll)=NDPS_B_Z;
    end  
    
    %*****************************
    %X-component of electric field
    %*****************************
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        NDPS(ll)=NDPS_EDC_X;
    end
    for ii=1:NH_X
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            NDPS(ll)=NDPS_ERF_X(ii);
        end
    end
    for ii=1:NH_X
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            NDPS(ll)=NDPS_PHA_ANG_X(ii);
        end
    end

    %*****************************
    %Y-component of electric field
    %*****************************
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        NDPS(ll)=NDPS_EDC_Y;
    end
    for ii=1:NH_Y
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            NDPS(ll)=NDPS_ERF_Y(ii);
        end
    end
    for ii=1:NH_Y
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            NDPS(ll)=NDPS_PHA_ANG_Y(ii);
        end
    end 
    
    %*****************************
    %Z-component of electric field
    %*****************************
    mm=mm+1;
    if PSL(mm)==0
        ll=ll+1;
        NDPS(ll)=NDPS_EDC_Z;
    end
    for ii=1:NH_Z
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            NDPS(ll)=NDPS_ERF_Z(ii);
        end
    end
    for ii=1:NH_Z
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            NDPS(ll)=NDPS_PHA_ANG_Z(ii);
        end
    end    

    %*******************************
    %Radiator distrubtion parameters
    %*******************************    
    for ii=1:NTG
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            NDPS(ll)=NDPS_kT_DOP(ii);
        end
    end
    for ii=1:NTG
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            NDPS(ll)=NDPS_X_DOP(ii);
        end
    end
    for ii=1:NTG
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            NDPS(ll)=NDPS_I_DOP(ii);
        end
    end
    
    %******************************
    %Lorentzian function parameters
    %******************************   
    for ii=1:NFL
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            NDPS(ll)=NDPS_GAM_LOR(ii);
        end
    end
    for ii=1:NFL
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            NDPS(ll)=NDPS_X_LOR(ii);
        end
    end
    for ii=1:NFL
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            NDPS(ll)=NDPS_I_LOR(ii);
        end
    end    
end

%****************************
%Discretize the fit variables 
%****************************
PS(1:ND,1:max(NDPS))=0;
for ii=1:ND
    PS(ii,1:NDPS(ii))=linspace(PSB(ii,1),PSB(ii,2),NDPS(ii));
end

%*******************************
%Assign PARA_BACK sub-structures
%*******************************
FP.PSI=PSI;
FP.PSNM=PSNM;
FP.PSN=PSN;
FP.PS=PS;
FP.PSB=PSB;
FP.PSL=PSL;
FP.PSV=PSV;
FP.NDPS=NDPS;
FP.ND=ND;
FP.NDP=NDP;
FP.NDS=NDS;

NP.NH_X=NH_X;
NP.NH_Y=NH_Y;
NP.NH_Z=NH_Z;
NP.NTG=NTG;
NP.NFL=NFL;
NP.NBG=0;
NP.NV=NV;
NP.NSPF=NSPF;

GP.NU=NU;

%**************************
%Assign PARA_BACK sturcture
%**************************
PARA_BACK.FP=FP;
PARA_BACK.NP=NP;
PARA_BACK.GP=GP;

%******************************
%Print fit parameters to screen
%******************************
if (OPT.PRINT.PARA_BACK==1 || OPT.PRINT.PARA_BACK==2)
    Print_Para_Back(PARA_BACK,BGN)
end

if OPT.PRINT.PARA_BACK==2
    return
end

%**************************
%Assign DATA_BACK sturcture
%**************************
DATA_BACK=DATA;

%***************
%Allocate memory
%***************
BROAD=cell(1,NSPF);
SPEC=cell(1,NSPF);

for ii=1:NSPF
    %**********************
    %Assign BROAD structure
    %**********************    
    BROAD{ii}.XC=DATA.BROAD{ii}.XC;
    BROAD{ii}.NTG=NTG;
    BROAD{ii}.NFL=NFL;
    
    %*********************
    %Assign SPEC structure
    %*********************
    MODEL_OPT.SOLVER.NDT=NDT;

    SPEC{ii}.LINE=LINE{ii};
    SPEC{ii}.MODEL_OPT=MODEL_OPT;    
end

%**************************
%Update DATA_BACK structure
%**************************
DATA_BACK.BROAD=BROAD;
DATA_BACK.SPEC=SPEC;

%*************************************
%Calc. wavelength boundaries for model
%*************************************
DATA_BACK=Mod_Bound(DATA_BACK,PARA_BACK);

%************************************
%Calc indices for parallel processing
%************************************
[JOB,NPSS,NPSP,NPSPP,NAP_BACK,~]=Parallel(PARA_BACK,OPT);

%***************
%Allocate memory
%***************
PSF_B_P=cell(1,NAP_BACK);
IGB_P=cell(1,NAP_BACK);

fprintf('\nGroup %1i Background Spectra Calculation --- %4i Spectra\n',BGN,NPSS*JOB{1}.NPSPP)

%*****************
%Calc line profile
%*****************
parfor ii=1:NAP_BACK
    [~,PSF_B_P{ii},~,IGB_P{ii}]=Fun_2(PARA_BACK,DATA_BACK,OPT,JOB{ii},NAP_BACK,ii,2); 
end

for uu=1:NSPF
    %****************************
    %Assign number of grid points
    %****************************
    NG=DATA.GRID{uu}.NG;
    
    %*********************************
    %Assign line profile and variables
    %*********************************    
    PSF_B=zeros(NPSP*NPSS,ND);
    IGB=zeros(NPSP*NPSS,NG);
    for ii=1:NAP_BACK
        N1=1+sum(NPSPP(1:ii-1))*NPSS;
        N2=sum(NPSPP(1:ii))*NPSS;

        PSF_B(N1:N2,1:ND)=PSF_B_P{ii};
        IGB(N1:N2,1:NG)=IGB_P{ii}{uu};
    end

    %*************
    %Assign output
    %*************
    if BGN==1
        DATA.BACK.IGB_CON{uu}=IGB;
    elseif BGN==2
        DATA.BACK.NB=NPSP*NPSS;
        DATA.BACK.IGB_VAR{uu}=IGB;
        DATA.BACK.PSF_B=PSF_B;
    end
end

end
