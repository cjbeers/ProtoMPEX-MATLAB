function [EVec,EVal]=H_Solver(Ho,H)

%**************************************************************************
%This function calculates the eigenvalues and eigenfunctions of the
%perturbed + unperturbed Hamiltonian
%
%                              [H+Ho]Phi=E*Phi
%
%associated with the principal quantum number n=PQN
%**************************************************************************
%                               INPUTS
%**************************************************************************
%
%Ho - Unperturbed Hamiltonian 
%
%H - Perturbed Hamiltonian 
%
%**************************************************************************
%                               OUTPUTS
%**************************************************************************
%
%EVec - Eigenvectors
%
%EVal - Eigenvalues
%
%**************************************************************************

%***************
%Allocate memory
%***************
EVec=cell(2,1);
EVal=cell(2,1);

for ii=1:2
    %***************************
    %Calc. the EVec's and EVal's
    %***************************    
    [EVec{ii},EVal{ii}]=eig(H{ii});    

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