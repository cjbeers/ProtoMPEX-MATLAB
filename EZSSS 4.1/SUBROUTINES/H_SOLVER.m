function [EVec,EVal]=H_SOLVER(HAM,PARA,OPT,INDICE)

%**************************************************************************
%This function calculates the eigenvalues and eigenfunctions of the
%perturbed + unperturbed Hamiltonian
%
%                              [H+Ho]Phi=E*Phi
%
%associated with the principal quantum number n=PQN
%**************************************************************************

%************
%Assign input
%************
Ho=HAM.UNPERTURBED;
H=HAM.TOTAL;

DIAG=OPT.DIAG;

%***********************
%Assign diagnostic logic
%***********************
DIAG_LOG=DIAG.H;

%******************************
%Diagnose perturbed Hamiltonian  
%******************************
if DIAG_LOG==1
    H_DIAG(HAM,PARA,INDICE)
end

%***************
%Allocate memory
%***************
EVec=cell(2,1);
EVal=cell(2,1);

for ii=1:2
    %***************************
    %Calc. the EVec's and EVal's
    %***************************    
    [EVec{ii},EVal{ii}]=eig(H{ii,INDICE});    

    %**********************
    %Add unperturbed EVal's
    %**********************
    EVal{ii}=Ho{ii}+EVal{ii};

    %*************************
    %Rearranging in a 1D array
    %*************************
    EVal{ii}=diag(EVal{ii});
end

end