function SPECTRA=SCALE_INTENSITY_TAB(SPECTRA,OBS,PARA,OPT)

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

%*************************
%Assign interpolation data
%*************************
A_INT=DFSS.SCALE.DATA.A;
S_INT=DFSS.SCALE.DATA.S;
NP_INT=DFSS.SCALE.DATA.NP;

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
%||||||||||||||||||||| INTERPOLATE DFSS SCALE FACTOR ||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%*********************************************************
%Normalize intensity by the geometrical integration factor
%*********************************************************
I_NORM=I/INT_NORM;

%*********************************
%Assign indice equation parameters
%*********************************
a=(NP_INT-1)/(log10(A_INT(NP_INT))-log10(A_INT(1)));
b=1-a*log10(A_INT(1));

%********************
%Calc. extact indices
%********************
IND=a*log10(I_NORM)+b;

%**************************
%Calc. lower interp. indice
%**************************
IND1=floor(IND);

%*************************************************
%Limit lower indice to within interpolation bounds
%*************************************************
IND1(IND1<1)=1;
IND1(IND1>=NP_INT)=NP_INT-1;

%**************************
%Calc. upper interp. indice
%**************************
IND2=IND1+1;

%************************
%Interpolate scale factor
%************************
S=S_INT(IND1)+(S_INT(IND2)-S_INT(IND1))./(A_INT(IND2)-A_INT(IND1)).*(I_NORM-A_INT(IND1));

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