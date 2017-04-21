function [EVec,EVal]=H_SOLVER_SER(HAM,PARA,OPT)

%************
%Assign input
%************
ND=PARA.ND;

PRINT=OPT.PRINT;

%***************
%Allocate memory
%***************
EVec=cell(2,ND);
EVal=cell(2,ND);

%******************
%Assign print logic
%******************
PRINT_LOG=PRINT.QSA;

for ii=1:ND
    %**************
    %Print progress
    %**************    
    if PRINT_LOG==1
        PRINT_PROGRESS_SER(ii,ND,'Quasistatic EV/EV')
    end

    %***********************************************************
    %Calc. eigenvalues/eigenvectors of the perturbed Hamiltonian
    %***********************************************************
    [EVec(1:2,ii),EVal(1:2,ii)]=H_SOLVER(HAM,PARA,OPT,ii);
end   

end