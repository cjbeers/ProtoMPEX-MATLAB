function SPECTRA=TRANS_PROB_WRAPPER_PAR(EVec,EVal,OBS,PARA,FIELD,UNIV,OPT)

%************
%Assign input
%************
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

%***************
%Allocate memory
%***************
NP_MAT=cell(1,ND);
LL_MAT=cell(1,ND);
UL_MAT=cell(1,ND);

I_MAT=cell(1,ND);
X_MAT=cell(1,ND);
NT_MAT(1:ND)=0;
NT_QSA_MAT=cell(1,ND);

%******************
%Assign print logic
%******************
PRINT_LOG=PRINT.QSA;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><>                Calc. transition probablities                 <><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> 

%**************
%Print progress
%**************    
if PRINT_LOG==1
    PRINT_PROGRESS_PAR('Quasistatic A_ij')
    
    PARALLEL_PROGRESS(ND);
end

parfor ii=1:ND
    %**************
    %Print progress
    %**************    
    if PRINT_LOG==1
        PARALLEL_PROGRESS;
    end

    %*****************************************
    %Calc. electric dipole allowed transitions
    %*****************************************
    SPECTRA_PAR=TRANS_PROB(EVec(1:2,ii),EVal(1:2,ii),EPS,MAT_P,MAT_0,MAT_M,OBS,PARA,FIELD,UNIV,OPT);

    %**********
    %Store data
    %**********  
    NP_MAT{ii}=SPECTRA_PAR.DISC.FULL.STATE.NP;
    LL_MAT{ii}=SPECTRA_PAR.DISC.FULL.STATE.LL;
    UL_MAT{ii}=SPECTRA_PAR.DISC.FULL.STATE.UL;

    I_MAT{ii}=SPECTRA_PAR.DISC.FULL.I;
    X_MAT{ii}=SPECTRA_PAR.DISC.FULL.X;
    NT_MAT(ii)=SPECTRA_PAR.DISC.FULL.NT;
    NT_QSA_MAT{ii}=SPECTRA_PAR.DISC.FULL.NT_QSA;
end

%**************
%Print progress
%**************    
if PRINT_LOG==1    
    PARALLEL_PROGRESS(0);
end

%*********************************
%Calc. total number of transitions
%*********************************
NT=sum(NT_MAT);

%***************
%Allocate memory
%***************
QSAN(1:NT)=0;
NP(1:NT)=0;
LL(1:NT)=0;
UL(1:NT)=0;

I(1:NT)=0;
X(1:NT)=0;
NT_QSA(1:ND,1:2)=0;

%****************************
%Reshape matrix into an array
%****************************
NT_IND3=0;
for ii=1:ND
    NT_IND1=NT_IND3;
    NT_IND2=NT_IND3+1;
    NT_IND3=NT_IND3+NT_MAT(ii);
    
    QSAN(NT_IND2:NT_IND3)=ii;
    NP(NT_IND2:NT_IND3)=NP_MAT{ii};
    LL(NT_IND2:NT_IND3)=LL_MAT{ii};
    UL(NT_IND2:NT_IND3)=UL_MAT{ii};

    I(NT_IND2:NT_IND3)=I_MAT{ii};
    X(NT_IND2:NT_IND3)=X_MAT{ii}; 
    NT_QSA(ii,1:2)=NT_QSA_MAT{ii}+NT_IND1;
end

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

