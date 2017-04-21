function SPECTRA=SCALE_INTENSITY_EQN(SPECTRA,OBS,PARA,OPT)

%************
%Assign input
%************
DISC=SPECTRA.DISC;

OBS_MODE=OBS.MODE;

ND=PARA.ND;

DFSS=OPT.DFSS;

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

%**************************
%Assign min intensity ratio
%**************************
MIN_RATIO=DFSS.SCALE.MIN_RATIO;

%***********************
%Assign discrete spectra 
%***********************
X=DISC.FULL.X;
I=DISC.FULL.I;
NT_QSA=DISC.FULL.NT_QSA;

QSAN=DISC.FULL.STATE.QSAN;
NP=DISC.FULL.STATE.NP;
LL=DISC.FULL.STATE.LL;
UL=DISC.FULL.STATE.UL;

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||||| CALCULATE DFSS SCALE FACTOR ||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%*********************************************************
%Normalize intensity by the geometrical integration factor
%*********************************************************
I_NORM=I/INT_NORM;

%************************
%Interpolate scale factor
%************************
S=0.44877*(I_NORM/1e6).^0.49864-0.00010515;

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

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