function SPECTRA=TRANS_PROB_WRAPPER_SER(EVec,EVal,OBS,PARA,FIELD,UNIV,OPT)

%************
%Assign input
%************
NS=PARA.NS;
NB=PARA.NB;
ND=PARA.ND;

PRINT=OPT.PRINT;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><>        Calc. observeration cord vector components            <><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> 

EPS=SET_EPS(OBS);

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><>           Calc. electric dipole matrix elements              <><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> 

[MAT_P,MAT_0,MAT_M]=E_DIPOLE_MAT(PARA,UNIV);

%*****************************
%Max. number of Floquet blocks
%*****************************
NB_MAX=max(NB);

%*******************************
%Calc. max number of transitions
%*******************************
NT_MAX=NS(1)*NS(2)*(4*NB_MAX+1)*ND;

%***************
%Allocate memory
%***************
QSAN(1:NT_MAX)=0;
NP(1:NT_MAX)=0;
LL(1:NT_MAX)=0;
UL(1:NT_MAX)=0;

I(1:NT_MAX)=0;
X(1:NT_MAX)=0;

%******************
%Assign print logic
%******************
PRINT_LOG=PRINT.QSA;

%************************************
%Initialize the number of transitions
%************************************
NT_IND3=0;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><>                Calc. transition probablities                 <><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> 

%***************
%Allocate memory
%***************
NT_QSA(1:ND,1:2)=0;

for ii=1:ND
    %**************
    %Print progress
    %**************    
    if PRINT_LOG==1
        PRINT_PROGRESS_SER(ii,ND,'Quasistatic A_ij')
    end

    %*****************************************
    %Calc. electric dipole allowed transitions
    %*****************************************
    SPECTRA=TRANS_PROB(EVec(1:2,ii),EVal(1:2,ii),EPS,MAT_P,MAT_0,MAT_M,OBS,PARA,FIELD,UNIV,OPT);

    %**********************
    %Assign data structures
    %**********************
    STATE=SPECTRA.DISC.FULL.STATE;
    FULL=SPECTRA.DISC.FULL;
    
    %***********
    %Calc indice
    %***********
    NT_IND1=NT_IND3;
    NT_IND2=NT_IND3+1;
    NT_IND3=NT_IND3+FULL.NT;
    
    %************
    %Conc. arrays
    %************
    QSAN(NT_IND2:NT_IND3)=ii;
    NP(NT_IND2:NT_IND3)=STATE.NP;
    LL(NT_IND2:NT_IND3)=STATE.LL;
    UL(NT_IND2:NT_IND3)=STATE.UL;
     
    I(NT_IND2:NT_IND3)=FULL.I;
    X(NT_IND2:NT_IND3)=FULL.X;
    NT_QSA(ii,1:2)=FULL.NT_QSA+NT_IND1;
end

%**********************************
%Assign total number of transitions
%**********************************
NT=NT_IND3;

%*******************
%Truncate the arrays
%*******************
QSAN=QSAN(1:NT);
NP=NP(1:NT);
LL=LL(1:NT);
UL=UL(1:NT);

I=I(1:NT);
X=X(1:NT);

%**********************
%Update data structures
%**********************
FULL.X=X;
FULL.I=I;
FULL.NT=NT;
FULL.NT_QSA=NT_QSA;

STATE.QSAN=QSAN;
STATE.NP=NP;
STATE.LL=LL;
STATE.UL=UL;

FULL.STATE=STATE;

%*****************************
%Assign discrete spectral data
%*****************************
SPECTRA.DISC.FULL=FULL; 

end

