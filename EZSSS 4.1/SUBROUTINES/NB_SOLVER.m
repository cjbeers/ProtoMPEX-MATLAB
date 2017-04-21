function [NB,NBS,dEVal]=NB_SOLVER(H,PARA,FIELD,UNIV)

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

EDC_MAG=FIELD.EDC.MAG;
ERF_MAG=FIELD.ERF.MAG;
NU=FIELD.ERF.NU;

hbar=UNIV.hbar;
q=UNIV.q;

%***************
%Allocate memory
%***************
dEVal(1:2)=0;
NB(1:2)=0;
NBS(1:2)=0;

%*******************
%Energy of RF photon
%*******************
FE=2*pi*hbar*NU/q;

%**********************************
%Summing static and dynamic E-field
%**********************************
E_MAG=(sum(abs(ERF_MAG),1))+abs(EDC_MAG);

%****************************
%Calc. E-field matix elements
%****************************
[MAT_P,MAT_0,MAT_M]=E_MAT(PARA,UNIV);

%***************************************
%Calc. spherical basis of static E-field
%***************************************
EDC_SB(1)=-1/2^0.5*(EDC_MAG(1)+1i*EDC_MAG(2));
EDC_SB(2)=EDC_MAG(3);
EDC_SB(3)=1/2^0.5*(EDC_MAG(1)-1i*EDC_MAG(2));

%******************************************
%Calc. spherical basis of estimated E-field
%******************************************
E_SB(1)=-1/2^0.5*(E_MAG(1)+1i*E_MAG(2));
E_SB(2)=E_MAG(3);
E_SB(3)=1/2^0.5*(E_MAG(1)-1i*E_MAG(2));

for ii=1:2
    %**************************************************
    %Calc. static and estimated E-field matrix elements
    %**************************************************
    H_EDC=-EDC_SB(1)*MAT_M{ii}(:,:)+EDC_SB(2)*MAT_0{ii}(:,:)-EDC_SB(3)*MAT_P{ii}(:,:);
    H_E=-E_SB(1)*MAT_M{ii}(:,:)+E_SB(2)*MAT_0{ii}(:,:)-E_SB(3)*MAT_P{ii}(:,:);
    
    %*********************************************************
    %Removing static and add estimated E-field matrix elements
    %*********************************************************
    H(ii,1)={H{ii,1}-H_EDC+H_E};

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
    [NB(ii),~,~]=NB_ROUND(MODE,NB(ii));
    
    %******************************
    %Calc. Floquet number of states
    %******************************
    NBS(ii)=NS(ii)*(2*NB(ii)+1);    
end

end