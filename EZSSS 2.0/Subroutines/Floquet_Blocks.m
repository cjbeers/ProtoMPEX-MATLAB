function [NB,NBS,dEVal]=Floquet_Blocks(H,PARA,FIELD,UNIV)

%**************************************************************************
%This function calculates the number of Floquet blocks required for the
%calculation by dividing the differnece of the largest and smallest energy
%eigenvalue by the energy associated with a single RF photon.
%
%The absolute value of the RF electric field magnitude is summed with the 
%absolute value of the DC electric field for the individual carteisan
%components.  The eigenvalues are then computed using the static operators.
%**************************************************************************

%**************************************************************************
%Determines how the Floquet blocks are rounded. See NB_Round.m for details.                             
%**************************************************************************
MODE=1;


%************
%Assign input
%************
NS=PARA.NS;

EDC=FIELD.EDC.MAG;
ERF=FIELD.ERF.MAG;
NU=FIELD.ERF.NU;

hbar=UNIV.hbar;
q=UNIV.q;

%***************
%Allocate memory
%***************
dEVal(1:2)=0;
NB(1:2)=0;
NBS(1:2)=0;

%****************
%Energy of photon
%****************
FE=2*pi*hbar*NU/q;

%*****************************************
%Summing static and dynamic electric field
%*****************************************
E=(sum(abs(ERF),1))+abs(EDC);

for ii=1:2
    %**********************************************
    %Removing static electric field matrix elements
    %**********************************************
    H_EDC=E_MAT(EDC,PARA,UNIV,[0 0]);
    H(ii,1)={H{ii,1}-H_EDC{ii}};

    %**********************************************
    %Adding estimate electric field matrix elements
    %**********************************************
    H_E=E_MAT(E,PARA,UNIV,[0 0]);
    H(ii,1)={H{ii,1}+H_E{ii}};

    %*****************
    %Calc. eigenvalues
    %*****************
    EVal=eig(H{ii,1});

    %*******************************
    %Calc. max eigenvalue difference
    %*******************************
    dEVal(ii)=max(EVal)-min(EVal);
    
    %******************************
    %Calc. number of Floquet blocks
    %******************************
    NB(ii)=dEVal(ii)/FE;
    
    %******************************
    %Round number of Floquet blocks
    %******************************
    [NB(ii),~,~]=NB_Round(MODE,NB(ii));
    
    %******************************
    %Calc. Floquet number of states
    %******************************
    NBS(ii)=NS(ii)*(2*NB(ii)+1);    
end

end