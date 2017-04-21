function SPECTRA=SCALE_INTENSITY_SIM_PAR(SPECTRA,OBS,PARA,UNIV,OPT)

%************
%Assign input
%************
DISC=SPECTRA.DISC;

OBS_MODE=OBS.MODE;

ND=PARA.ND;

c=UNIV.c;

DFSS=OPT.DFSS;
PRINT=OPT.PRINT;

%************************************************
%Assign the view integration normalization factor
%************************************************
if strcmpi(OBS_MODE,'NO_INT')==1
    INT_NORM=1;
elseif strcmpi(OBS_MODE,'1D_INT')==1
    INT_NORM=2*pi;
elseif strcmpi(OBS_MODE,'2D_INT')==1
    INT_NORM=4*pi;
end

%********************************
%Assign min simulation absorption
%********************************
MIN_SIM=DFSS.SCALE.MIN_SIM;

%**************************
%Assign min intensity ratio
%**************************
MIN_RATIO=DFSS.SCALE.MIN_RATIO;

%******************
%Assign print logic
%******************
PRINT_LOG=PRINT.DFSS;

%***********************
%Assign discrete spectra 
%***********************
X=DISC.FULL.X;
I=DISC.FULL.I;
NT=DISC.FULL.NT;
NT_QSA=DISC.FULL.NT_QSA;

QSAN=DISC.FULL.STATE.QSAN;
NP=DISC.FULL.STATE.NP;
LL=DISC.FULL.STATE.LL;
UL=DISC.FULL.STATE.UL;

%*********************
%Get DFSS base options
%*********************
DFSSS_OPT=SET_DFSSS_OPT(PARA,OPT);

%****************************
%Assign various DFSSS options
%****************************
DFSSS_OPT.ATOMIC.NT_0=1; 
DFSSS_OPT.LASER.NFP=1;  
DFSSS_OPT.LASER.NU_MODE='MANUAL';  

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||| CALC DOPPLER-FREE ABSORPTION ||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%***************
%Allocate memory
%***************
I_DF(1:NT)=0;

DFSSS_OPT_PROBE=cell(1,NT);
DFSSS_OPT_BOTH=cell(1,NT);

for ii=1:NT    
    %******************************
    %Calc. the transition frequency
    %******************************
    NU=c/X(ii);
    
    %**********************************
    %Assign the transition probabilites
    %**********************************
    DFSSS_OPT.ATOMIC.A_0=I(ii)/INT_NORM;
    DFSSS_OPT.ATOMIC.NU_0=NU;
    
    %********************************
    %Assign the measurement frequency
    %********************************
    DFSSS_OPT.LASER.NU_MAN=NU;
    
    %********************
    %Assing DFSSS options
    %********************
    DFSSS_OPT.GENERAL.MODE='PROBE'; 
    DFSSS_OPT_PROBE{ii}=DFSSS_OPT; 

    %********************
    %Assing DFSSS options
    %********************
    DFSSS_OPT.GENERAL.MODE='BOTH'; 
    DFSSS_OPT_BOTH{ii}=DFSSS_OPT; 
end

%**************
%Print progress
%**************    
if PRINT_LOG==1
    PRINT_PROGRESS_PAR('DFSS Intensity Correction')
    
    PARALLEL_PROGRESS(NT);
end

parfor ii=1:NT
    %**************
    %Print progress
    %**************    
    if PRINT_LOG==1
        PARALLEL_PROGRESS;
    end
    
    %************************
    %Run PROBE DFSSS geometry
    %************************
    [DATA_PROBE,~,~,~]=DFSSS(DFSSS_OPT_PROBE{ii},1);    

    %*****************************
    %Run PUMP/PROBE DFSSS geometry
    %*****************************
    [DATA_BOTH,~,~,~]=DFSSS(DFSSS_OPT_BOTH{ii},1);

    %*********************
    %Assign intensity data
    %*********************
    I_PR=DATA_PROBE.I_PR;
    I_PU_PR=DATA_BOTH.I_PR;

    %*******************************************
    %Calc. the Doppler-free absorption intensity
    %*******************************************
    I_DF(ii)=(I_PU_PR(1,2)-I_PR(1,2))/I_PR(1,1);

    %********************************************
    %Assign the Doppler-free absorption intensity
    %********************************************
    if I_DF(ii)<MIN_SIM || isnan(I_DF(ii))==1
        I_DF(ii)=0;
    end
end

%**************
%Print progress
%**************    
if PRINT_LOG==1
    PARALLEL_PROGRESS(0);
end

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%******************
%Calc. scale factor
%******************
S=I_DF./I*max(I)/max(I_DF);

%*******************************************
%Correct the intensity for DFSS nonlinearity
%*******************************************
I=I.*S;

%**********************************************
%Assign logic for sufficently large intensities
%**********************************************
LOG=I>max(I)*MIN_RATIO;

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||||    DROP SMALL INTENSITIES    ||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%*************************************
%Drop transitions with small intensity
%*************************************
I=I(LOG);
X=X(LOG);
S=S(LOG);
NT=sum(LOG);

NT_IND2=0;
for ii=1:ND
    %****************************************
    %Assign transition indice for current QSA
    %****************************************
    IND1=NT_QSA(ii,1);
    IND2=NT_QSA(ii,2);
    
    %***************************************
    %Calc. transition indice for current QSA
    %***************************************
    NT_IND1=NT_IND2+1;
    NT_IND2=NT_IND2+sum(LOG(IND1:IND2));
    
    NT_QSA(ii,1:2)=[NT_IND1 NT_IND2];
end

QSAN=QSAN(LOG);
NP=NP(LOG);
LL=LL(LOG);
UL=UL(LOG);

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%***********************
%Update discrete spectra 
%***********************
FULL.X=X;
FULL.I=I;
FULL.S=S;
FULL.NT=NT;
FULL.NT_QSA=NT_QSA;

STATE.QSAN=QSAN;
STATE.NP=NP;
STATE.LL=LL;
STATE.UL=UL;

FULL.STATE=STATE;

%*************
%Assign output
%*************
SPECTRA.DISC.FULL=FULL;

end