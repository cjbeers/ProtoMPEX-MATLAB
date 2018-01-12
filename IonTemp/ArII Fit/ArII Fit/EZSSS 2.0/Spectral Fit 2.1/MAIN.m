function [FIT,PARA,PARA_BACK_CON,PARA_BACK_VAR]=MAIN(NSPF,EXP,INS,LINE,OPT)

%*********************************
%Folder path containing EZSSS code
%*********************************
PATH=[pwd filesep 'IonTemp\ArII Fit\ArII Fit\EZSSS 2.0\Spectral Fit 2.1'];

%***************
%Add folder PATH
%***************
addpath(PATH);

%**********************************************************
%Field names for the externally set fit parameters avaiable
%**********************************************************
PARA_NAME={'NU','NDT','NH_X','NH_Y','NH_Z','NTG','NFL','NBG','M','NS','NI','NI_INS',...
    'PSL','PSV','PSB','PSB_INS','NDPS','NDPS_INS','PSSP'};

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>      SOLVER OPTIONS      <><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%**************************
%Number of parallel workers
%**************************
NAP=4;

%***************
%Algorithm logic
%***************
ALGO=[1,1];

%**************
%Solver options
%**************
ALGO_OPT{1}={'Algorithm','interior-point',...
             'UseParallel','always',...
             'DiffMaxChange',0.5,...
             'DiffMinChange',0.001,...
             'TolX',1e-3,...
             'TolFun',1e-5,...
             'MaxIter',5000,...
             'FinDiffType','forward',...
             'Display','off'};

ALGO_OPT{2}={'Algorithm','interior-point',...
             'UseParallel','always',...
             'DiffMaxChange',0.05,...
             'DiffMinChange',0.001,...
             'TolX',1e-4,'TolFun',1e-5,...
             'MaxIter',1000,...
             'FinDiffType','forward',...
             'Display','off'};

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>      SOLVER OPTIONS      <><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>      PLOT/PRINT OPTIONS      <><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%***********
%Print logic
%***********
PRINT.PARA=1;
PRINT.PARA_BACK=1;
PRINT.FIT=1;

%**********
%Plot logic
%**********
PLOT.LOGIC.FIT=1;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>      PLOT/PRINT OPTIONS      <><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

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

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>   FIT PARAMETER SETPOINTS    <><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

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

%***************************
%Number of background groups
%***************************
NBG=2;

%*******************************************
%Number of fit points per experimental point
%*******************************************
M=5;

%*************************
%Number of tracking points
%*************************
NS=1;

%************************
%Number of fit iterations
%************************
NI=1;

%***********************************
%Number of instrument fit iterations 
%***********************************
NI_INS=3;

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
kT_DOP(1:NSPF)={[8,0,0,0]};
X_DOP(1:NSPF)={[0,0,0,0]};
I_DOP(1:NSPF)={[1,1,1,1]};

%******************************
%Lorentzian function parameters
%******************************
GAM_LOR(1:NSPF)={[1,.1,0,0]};
X_LOR(1:NSPF)={[0,0,0,0]};
I_LOR(1:NSPF)={[1,.3,1,1]};

%*****************************
%Background emission intensity
%*****************************
IB(1:NSPF)={[1 0]};

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
PSL_ERF_X=[1,0,0];
PSL_PHA_ANG_X=[1,0,0];

%*****************************
%Y-Component of electric field
%*****************************
PSL_EDC_Y=1;
PSL_ERF_Y=[1,0,0];
PSL_PHA_ANG_Y=[1,0,0];

%*****************************
%Z-Component of electric field
%*****************************
PSL_EDC_Z=1;
PSL_ERF_Z=[1,0,0];
PSL_PHA_ANG_Z=[1,0,0];

%*******************************
%Radiator distrubtion parameters
%*******************************
PSL_kT_DOP=[1,1,0,0];
PSL_X_DOP=[1,1,0,0];
PSL_I_DOP=[1,0,0,0];

%******************************
%Lorentzian function parameters
%******************************
PSL_GAM_LOR=[0,0,0,0];
PSL_X_LOR=[1,0,0,0];
PSL_I_LOR=[1,0,0,0];

%*****************************
%Background emission intensity
%*****************************
PSL_IB=[1 0];

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>   FIT VARIABLE LOGIC   <><><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><>  FIT VARIABLE DISCRETIZATION   <><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%***********************
%Polar observation angle
%***********************
NDPS_THETA=20;

%***************************
%Azimuthal observation angle
%***************************
NDPS_PHI=20;

%***************
%Polarizer angle
%***************
NDPS_SIGMA=10;

%********************************
%Parallel transmission coefficent
%********************************
NDPS_TM1=15;

%*************************************
%Perpendicular transmission coefficent
%*************************************
NDPS_TM2=4;

%*****************************
%Z-Component of magnetic field
%*****************************
NDPS_B_Z=10;

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
NDPS_kT_DOP=[10,8,8,8];
NDPS_X_DOP=[10,8,8,8];
NDPS_I_DOP=[8,15,8,8];

%******************************
%Lorentzian function parameters
%******************************
NDPS_GAM_LOR=[10,10,10,10];
NDPS_X_LOR=[10,10,10,10];
NDPS_I_LOR=[10,10,10,10];

%*****************************
%Background emission intensity
%*****************************
NDPS_IB=[20 20];

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><>  FIT VARIABLE DISCRETIZATION   <><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>  FIT VARIABLE BOUNDARIES   <><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%***********************
%Polar observation angle
%***********************
PSB_THETA={[pi/8,pi/4]};

%***************************
%Azimuthal observation angle
%***************************
PSB_PHI={[0,pi/8]};

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
PSB_B_Z={[3.6,4.2]};

%*****************************
%X-Component of electric field
%*****************************
PSB_EDC_X={[-4,-6]};
PSB_ERF_X={[1.8,2.8],[0,3],[0,3]};
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
PSB_kT_DOP={[6,9],[100,150]};
PSB_X_DOP={[-.05,-0.02],[-1,1]};
PSB_I_DOP={[.0,1],[1,1.5]};

%******************************
%Lorentzian function parameters
%******************************
PSB_GAM_LOR={[.01,.04],[.1,0.3]};
PSB_X_LOR={[-1,1],[-1,1]};
PSB_I_LOR={[.1,1],[0,0.5]};

%*****************************
%Background emission intensity
%*****************************
PSB_IB={[.2,.6],[.2,.6]};

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><>  FIT VARIABLE BOUNDARIES   <><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><>   INSTRUMENT VARIABLE DISCRETIZATION   <><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%**************
%Vertical scale
%**************
NDPS_VS=8;

%*****************
%Horizaontal shift
%*****************
NDPS_HS=8;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><>   INSTRUMENT VARIABLE DISCRETIZATION   <><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><>   INSTRUMENT VARIABLE BOUNDARIES   <><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%**************
%Vertical scale
%**************
PSB_VS=[0.92,1.08];

%*****************
%Horizaontal shift
%*****************
PSB_HS=[-0.1,0.1];

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><>   INSTRUMENT VARIABLE BOUNDARIES   <><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%|||||||||||||||||||||||||||UNIVERSAL CONSTANTS||||||||||||||||||||||||||||
%//////////////////////////////////////////////////////////////////////////
                                               %\\\\\\\\\\\\\\\\\\\\\\\\\\\
    hbar=1.054571628e-34;                      %///////////////////////////
    c=2.99792458e8;                            %\\\\\\\\\\\\\\\\\\\\\\\\\\\
    q=1.602176487e-19;                         %///////////////////////////
    eo=8.85418782e-12;                         %\\\\\\\\\\\\\\\\\\\\\\\\\\\
    me=9.10938215e-31;                         %///////////////////////////
    m_H=1.67221e-27;                           %\\\\\\\\\\\\\\\\\\\\\\\\\\\
    m_D=3.34449e-27;                           %\\\\\\\\\\\\\\\\\\\\\\\\\\\
    m_T=5.00736e-27;                           %\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
    m_He=6.64465e-27;                          %///////////////////////////
    m_Ar=6.6335209e-26;                        %\\\\\\\\\\\\\\\\\\\\\\\\\\\    
                                               %///////////////////////////    
%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||||||UNIVERSAL CONSTANTS||||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%||||||||||||||||||||||||| Assign UNIV structure ||||||||||||||||||||||||||
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

UNIV.hbar=hbar;
UNIV.q=q;
UNIV.c=c;
UNIV.eo=eo;
UNIV.me=me;
for ii=1:NSPF
    if strcmpi(LINE{ii}.ATOM,'H')==1
        UNIV.m(ii)=m_H;
    elseif strcmpi(LINE{ii}.ATOM,'D')==1
        UNIV.m(ii)=m_D;
    elseif strcmpi(LINE{ii}.ATOM,'T')==1
        UNIV.m(ii)=m_T;
    elseif strcmpi(LINE{ii}.ATOM(1:2),'He')==1
        UNIV.m(ii)=m_He;
    elseif strcmpi(LINE{ii}.ATOM(1:2),'Ar')==1
        UNIV.m(ii)=m_Ar;
    end
end

%********************
%Assign print options
%********************
if isfield(OPT,'PRINT')==0
    OPT.PRINT=PRINT;
end

%*******************
%Assign plot options
%*******************
if isfield(OPT,'PLOT')==0
    OPT.PLOT=PLOT;
end

%***************************
%Assign number of processors
%*******************%*******
if isfield(OPT,'NAP')==0
    OPT.NAP=NAP;
end

%****************************
%Assign fit parameter options
%****************************
if isfield(OPT,'PARA')==1
    for ii=1:length(PARA_NAME)
        if isfield(OPT.PARA,PARA_NAME{ii})==1
            PARA_LOGIC.(PARA_NAME{ii})=1;
            eval([PARA_NAME{ii} '=OPT.PARA.(PARA_NAME{ii});'])
        else
            PARA_LOGIC.(PARA_NAME{ii})=0;
        end
    end
else
    for ii=1:length(PARA_NAME)
        PARA_LOGIC.(PARA_NAME{ii})=0;
    end 
end

if (isfield(OPT,'SOLVER')==0) || isfield(OPT.SOLVER,'ALGO')
    %*************************
    %Assign algorithum options
    %*************************
    SOLVER.ALGO=ALGO;
    SOLVER.ALGO_OPT=cell(1,2);
    for ii=1:2
        if SOLVER.ALGO(ii)~=1
            SOLVER.ALGO_OPT{ii}=optimset(ALGO_OPT{ii}{1:length(ALGO_OPT{ii})});
        else 
            SOLVER.ALGO_OPT{ii}=0;
        end
    end
    
    %********************
    %Update OPT structure
    %********************
    OPT.SOLVER=SOLVER;
end

%****************
%Number of groups
%****************
NPSG=13;

%********************************
%Number of groups run in parallel
%********************************
NPSGP=6;

%******************************
%Number of groups run in serial
%******************************
NPSGS=[4,3];

%***************************
%Number variables per groups
%***************************
PSNM=[2,3,1,2*NH_X+1,2*NH_Y+1,2*NH_Z+1,NTG,NTG,NTG,NFL,NFL,NFL,NBG];

%*************************************
%Group order for parallel/serial calc.
%*************************************
PSO=[1,2,3,4,5,6,7,8,10,11,9,12,13];

%*************************
%Calc. number of variables
%*************************
NV=sum(PSNM);

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%||||||||||||||||||||    OPEN PARALLEL WORKER POOL    |||||||||||||||||||||
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%****************
%Open NAP workers
%****************
Start_Parpool(OPT.NAP);

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

    %********************
    %Background intensity
    %********************
    PSL(sum(PSNM(1:12))+1:sum(PSNM(1:13)))=PSL_IB(1:NBG);
end

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
    if PSN(PSO(ii))>0
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

        %********************
        %Background intensity
        %********************
        PSV{ii}(sum(PSNM(1:12))+1:sum(PSNM(1:13)))=IB{ii}(1:NBG);
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
    if (PSL(mm)==0)
        ll=ll+1;
        PSB(ll,1:2)=PSB_THETA{1};
    end
    mm=mm+1;
    if (PSL(mm)==0)
        ll=ll+1;
        PSB(ll,1:2)=PSB_PHI{1};
    end    
    
    %************
    %Polarization
    %************
    mm=mm+1;
    if (PSL(mm)==0)
        ll=ll+1;
        PSB(ll,1:2)=PSB_SIGMA{1};
    end   
    mm=mm+1;
    if (PSL(mm)==0)
        ll=ll+1;
        PSB(ll,1:2)=PSB_TM1{1};
    end   
    mm=mm+1;
    if (PSL(mm)==0)
        ll=ll+1;
        PSB(ll,1:2)=PSB_TM2{1};
    end       
    
    %*****************************
    %Z-component of magnetic field
    %*****************************
    mm=mm+1;
    if (PSL(mm)==0)
        ll=ll+1;
        PSB(ll,1:2)=PSB_B_Z{1};
    end
    
    %*****************************
    %X-component of electric field
    %*****************************
    mm=mm+1;
    if (PSL(mm)==0)
        ll=ll+1;
        PSB(ll,1:2)=PSB_EDC_X{1};
    end
    for ii=1:NH_X
        mm=mm+1;
        if (PSL(mm)==0)
            ll=ll+1;
            PSB(ll,1:2)=PSB_ERF_X{ii};
        end
    end
    for ii=1:NH_X
        mm=mm+1;
        if (PSL(mm)==0)
            ll=ll+1;
            PSB(ll,1:2)=PSB_PHA_ANG_X{ii};
        end
    end
    
    %*****************************
    %Y-component of electric field
    %*****************************
    mm=mm+1;
    if (PSL(mm)==0)
        ll=ll+1;
        PSB(ll,1:2)=PSB_EDC_Y{1};
    end
    for ii=1:NH_Y
        mm=mm+1;
        if (PSL(mm)==0)
            ll=ll+1;
            PSB(ll,1:2)=PSB_ERF_Y{ii};
        end
    end
    for ii=1:NH_Y
        mm=mm+1;
        if (PSL(mm)==0)
            ll=ll+1;
            PSB(ll,1:2)=PSB_PHA_ANG_Y{ii};
        end
    end
    
    %*****************************
    %Z-component of electric field
    %*****************************
    mm=mm+1;
    if (PSL(mm)==0)
        ll=ll+1;
        PSB(ll,1:2)=PSB_EDC_Z{1};
    end
    for ii=1:NH_Z
        mm=mm+1;
        if (PSL(mm)==0)
            ll=ll+1;
            PSB(ll,1:2)=PSB_ERF_Z{ii};
        end
    end
    for ii=1:NH_Z
        mm=mm+1;
        if (PSL(mm)==0)
            ll=ll+1;
            PSB(ll,1:2)=PSB_PHA_ANG_Z{ii};
        end
    end    
    
    %*******************************
    %Radiator distrubtion parameters
    %*******************************
    for ii=1:NTG
        mm=mm+1;
        if (PSL(mm)==0)
            ll=ll+1;
            PSB(ll,1:2)=PSB_kT_DOP{ii};
        end
    end
    for ii=1:NTG
        mm=mm+1;
        if (PSL(mm)==0)
            ll=ll+1;
            PSB(ll,1:2)=PSB_X_DOP{ii};
        end
    end
    for ii=1:NTG
        mm=mm+1;
        if (PSL(mm)==0)
            ll=ll+1;
            PSB(ll,1:2)=PSB_I_DOP{ii};
        end
    end
    
    %******************************
    %Lorentzian function parameters
    %******************************
    for ii=1:NFL
        mm=mm+1;
        if (PSL(mm)==0)
            ll=ll+1;
            PSB(ll,1:2)=PSB_GAM_LOR{ii};
        end
    end
    for ii=1:NFL
        mm=mm+1;
        if (PSL(mm)==0)
            ll=ll+1;
            PSB(ll,1:2)=PSB_X_LOR{ii};
        end
    end    
    for ii=1:NFL
        mm=mm+1;
        if (PSL(mm)==0)
            ll=ll+1;
            PSB(ll,1:2)=PSB_I_LOR{ii};
        end
    end
    
    %********************
    %Background intensity
    %********************
    for ii=1:NBG
        mm=mm+1;
        if (PSL(mm)==0)
            ll=ll+1;
            PSB(ll,1:2)=PSB_IB{ii};
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
    
    %********************
    %Background intensity
    %********************
    for ii=1:NBG
        mm=mm+1;
        if PSL(mm)==0
            ll=ll+1;
            NDPS(ll)=NDPS_IB(ii);
        end    
    end
end

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%||||||||||||    ASSIGN INSTRUMENT FIT VARIABLE BOUNDARIES    |||||||||||||
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

if PARA_LOGIC.PSB_INS==0
    PSB_INS=[PSB_VS;PSB_HS];
end

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%||||||||||    ASSIGN INSTRUMENT FIT VARIABLE DISCRETIZATION    |||||||||||
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

if PARA_LOGIC.NDPS_INS==0
    NDPS_INS(1:2)=[NDPS_VS,NDPS_HS];
end

%****************************
%Discretize the fit variables 
%****************************
PS(1:ND,1:max(NDPS))=0;
for ii=1:ND
    PS(ii,1:NDPS(ii))=linspace(PSB(ii,1),PSB(ii,2),NDPS(ii));
end

%***************************************
%Discretize the instrument fit variables 
%***************************************
PS_INS(1:2,1:max(NDPS_INS))=0;
for ii=1:2
    PS_INS(ii,1:NDPS_INS(ii))=linspace(PSB_INS(ii,1),PSB_INS(ii,2),NDPS_INS(ii));
end

%**************************
%Assign PARA sub-structures
%**************************

%**************
%Fit parameters
%**************
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
FP.NS=NS;
FP.NI=NI;

%*********************
%Instrument parameters
%*********************
IP.PS=PS_INS;
IP.PSB=PSB_INS;
IP.NDPS=NDPS_INS;
IP.NI=NI_INS;

%*****************
%Number parameters
%*****************
NP.NH_X=NH_X;
NP.NH_Y=NH_Y;
NP.NH_Z=NH_Z;
NP.NTG=NTG;
NP.NFL=NFL;
NP.NBG=NBG;
NP.NV=NV;
NP.NSPF=NSPF;

%******************
%General parameters
%******************
GP.NU=NU;
GP.M=M;

%*********************
%Assign PARA sturcture
%*********************
PARA.FP=FP;
PARA.IP=IP;
PARA.NP=NP;
PARA.GP=GP;

%******************************
%Print fit parameters to screen
%******************************
if (OPT.PRINT.PARA==1 || OPT.PRINT.PARA==2)
    Print_Para(PARA,OPT)
end

if OPT.PRINT.PARA==2
    return
end

%************************
%Format experimental data
%************************
EXP=Exp_Data(EXP,NSPF);

%***************
%Allocate memory
%***************
GRID=cell(1,NSPF);
CONT=cell(1,NSPF);
BROAD=cell(1,NSPF);
SPEC=cell(1,NSPF);

for ii=1:NSPF
    %*********************
    %Number of grid points
    %*********************
    NG=EXP{ii}.NE*M;
    
    %***************
    %Allocate memory
    %***************
    IG=zeros(1,NG);
    IGT=zeros(1,NG);
    XG=zeros(1,NG);

    IMAT_GAU=zeros(NG,NTG);
    IMAT_LOR=zeros(NG,NTG,NFL);

    %*********************
    %Assign GRID sturcture
    %*********************
    GRID{ii}.IG=IG;
    GRID{ii}.IGT=IGT;
    GRID{ii}.XG=XG;
    GRID{ii}.NG=NG;
    
    %*********************
    %Assign CONT sturcture
    %*********************
    CONT{ii}.IMAT_GAU=IMAT_GAU;
    CONT{ii}.IMAT_LOR=IMAT_LOR;
    
    %*********************
    %Assign BACK sturcture
    %*********************
    BACK.NB=1;
    BACK.IGB_CON{ii}(1,1:NG)=0;
    BACK.IGB_VAR{ii}(1,1:NG)=0;
    BACK.PSF_B(1:1,1:0)=0;

    %**********************
    %Assign BROAD structure
    %**********************   
    BROAD{ii}.XC=EXP{ii}.XC;
    BROAD{ii}.NTG=NTG;
    BROAD{ii}.NFL=NFL; 
    
    %*********************
    %Assign SPEC structure
    %*********************
    MODEL_OPT.SOLVER.NDT=NDT;  

    SPEC{ii}.LINE=LINE{ii};
    SPEC{ii}.MODEL_OPT=MODEL_OPT;    
end

%*********************
%Assign DATA sturcture 
%*********************
DATA.UNIV=UNIV;
DATA.EXP=EXP;
DATA.GRID=GRID;
DATA.CONT=CONT;
DATA.BROAD=BROAD;
DATA.BACK=BACK;
DATA.SPEC=SPEC;
DATA.INS=INS;

%**********
%Calc. grid
%**********
DATA=Grid(PARA,DATA);

%*************************************
%Calc. wavelength boundaries for model 
%*************************************
DATA=Mod_Bound(DATA,PARA);

%****************
%Calc. background
%****************
LOG=0;
for ii=1:NSPF
    LOG=LOG+PSV{ii}(sum(PSNM(1:12))+1);
end

if PSL(sum(PSNM(1:12))+1)==0  || (PSL(sum(PSNM(1:12))+1)==1 && LOG~=0)
    [PARA_BACK_CON,DATA]=MAIN_BACK(DATA,NSPF,OPT,1);
else
    PARA_BACK_CON=[];
end

LOG=0;
for ii=1:NSPF
    LOG=LOG+PSV{ii}(sum(PSNM(1:13)));
end

if PSL(sum(PSNM(1:13)))==0  || (PSL(sum(PSNM(1:13)))==1 && LOG~=0)
    [PARA_BACK_VAR,DATA]=MAIN_BACK(DATA,NSPF,OPT,2);
else
    PARA_BACK_VAR=[];
end

if OPT.SOLVER.ALGO(1)==1
    %*************************
    %Fit the experimental data
    %*************************
    FIT=Full(PARA,PARA_BACK_VAR,DATA,OPT);
else
    %*******************************************
    %Define external parameters for fit function
    %*******************************************
    FH=@(PSF)Fun_1a(PARA,DATA,OPT,PSF);

    %******************
    %Calc. start points
    %******************   
    if PARA_LOGIC.PSSP==0
        PSSP(1:NS,1:ND)=0;
        for ii=1:NS
            PSSP(ii,1:ND)=(PSB(1:ND,1)+PSB(1:ND,2))/2;
        end
    end

    %*********************************
    %Assign upper and lower boundaries
    %*********************************    
    PSLB(1:ND)=0;
    PSUB(1:ND)=0;
    for ii=1:ND
        if PSB(ii,1)<PSB(ii,2)
            PSLB(ii)=PSB(ii,1);
            PSUB(ii)=PSB(ii,2);
        else
            PSLB(ii)=PSB(ii,2);
            PSUB(ii)=PSB(ii,1);
        end
    end

    %***************
    %Allocate memory
    %***************
    PSF(1:NS,1:ND)=0;
    CHI(1:NS)=0;
    FLAG(1:NS)=0;

    %**********************
    %Assign routine options
    %**********************
    OPTIONS=OPT.SOLVER.ALGO_OPT{1};

    for ii=1:NI
        parfor jj=1:NS 
            %************
            %Fit the data
            %************            
            [PSF(jj,:),CHI(jj),FLAG(jj)]=fmincon(FH,PSSP(jj,1:ND),[],[],[],[],PSLB,PSUB,[],OPTIONS);      
        end
        
        %******************************
        %Calc. background fit variables
        %******************************
        PSF_B=Fun_1b(PARA,DATA,PSF,OPT);
        
        %****************************
        %Calc. number of track points
        %****************************   
        NS=sum(FLAG>=0);

        %*********************
        %Remove empty elements
        %********************* 
        CHI=CHI(FLAG>=0);
        PSF=PSF(FLAG>=0,1:ND);

        %********************
        %Assign FIT structure
        %********************
        FIT.MIN.CHI{ii}=CHI;
        FIT.MIN.PSF{ii}=PSF;
        FIT.MIN.PSF_B{ii}=PSF_B;

        %*******************
        %Update start points
        %*******************
        if NI>1
            PSSP=PSF;
        end
    end
    
    %*********************
    %Update PARA sturcture
    %*********************
    PARA.FP.NS=NS;        
end

%***************************************
%Assign variables and calc. line profile
%***************************************
FIT=Var_Fit(PARA,DATA,FIT,OPT);

%***************************
%Assign background variables
%***************************
if isempty(PARA_BACK_CON)==0 
    FIT=Var_Back_Fit(PARA,PARA_BACK_CON,PARA_BACK_VAR,FIT,1); 
end

if isempty(PARA_BACK_CON)==0 
    FIT=Var_Back_Fit(PARA,PARA_BACK_CON,PARA_BACK_VAR,FIT,2); 
end

%**************************************
%Print the fit parameters to the screen
%**************************************
if OPT.PRINT.FIT==1
    Print_Var(PARA,PARA_BACK_CON,PARA_BACK_VAR,FIT)
end

%************
%Plot the fit
%************
if OPT.PLOT.LOGIC.FIT==1
    OPT=Plot_Fit(PARA,DATA,FIT,OPT);
end

%***************
%Add folder PATH
%***************
rmpath(PATH);

end