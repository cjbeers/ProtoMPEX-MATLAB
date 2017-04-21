function [EVec,EVal]=H_SOLVER_PAR(HAM,PARA,OPT)

%************
%Assign input
%************
ND=PARA.ND;

PRINT=OPT.PRINT;

%***************
%Allocate memory
%***************
EVec_PAR=cell(1,ND);
EVal_PAR=cell(1,ND);

%******************
%Assign print logic
%******************
PRINT_LOG=PRINT.QSA;

%**************
%Print progress
%**************    
if PRINT_LOG==1
    PRINT_PROGRESS_PAR('Quasistatic EV/EV')
    
    PARALLEL_PROGRESS(ND);
end

parfor ii=1:ND
    %**************
    %Print progress
    %**************    
    if PRINT_LOG==1
        PARALLEL_PROGRESS;
    end

    %***********************************************************
    %Calc. eigenvalues/eigenvectors of the perturbed Hamiltonian
    %***********************************************************
    [EVec_PAR{ii},EVal_PAR{ii}]=H_SOLVER(HAM,PARA,OPT,ii);
end

%**************
%Print progress
%**************    
if PRINT_LOG==1    
    PARALLEL_PROGRESS(0);
end

%**********************************************
%Reshape eigenvalue and eigenvector cell matrix
%**********************************************
EVec=cell(2,ND);
EVal=cell(2,ND);
for ii=1:ND
    EVec(1:2,ii)=EVec_PAR{ii}(1:2);
    EVal(1:2,ii)=EVal_PAR{ii}(1:2);
end  

end