function [HAM,PARA]=SET_H(PARA,FIELD,UNIV,OPT)

%****************
%Assign the input
%****************
EL=PARA.EL;
NS=PARA.NS;
ND=PARA.ND;

B=FIELD.B;
EDC=FIELD.EDC;
ERF=FIELD.ERF;
QSA=FIELD.QSA;

SOLVER=OPT.SOLVER;
FLOQ=OPT.FLOQ;

%*******************
%Assign solver logic
%*******************
QSA_LOG=SOLVER.QSA_LOGIC;
MAN_LOG=SOLVER.MAN_LOGIC;
FBC_LOG=FLOQ.FBC_LOGIC;

%******************************
%Assign number of ERF harmonics
%******************************
NH=ERF.NH;

%**********************
%Assign the field logic
%**********************
B_LOG=B.LOGIC;
EDC_LOG=EDC.LOGIC;
ERF_LOG=ERF.LOGIC;

%********************************
%Initialize hamiltonian variables
%********************************
HB=[];
HEDC=[];
HEQSA=[];
HF=[];

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||| Assign unperturbed Hamiltonian ||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Ho=cell(2,1);
for ii=1:2
    Ho{ii}=diag(ones(1,NS(ii))*min(EL(ii,1:NS(ii))));
end

if ERF_LOG==0 && (QSA_LOG==0 || (QSA_LOG==1 && MAN_LOG==0))
    %**********************************
    %Assign unperturbed ham. for no ERF
    %**********************************
    H=cell(2,1);
    for ii=1:2
        H(ii,1)={diag(EL(ii,1:NS(ii)))-Ho{ii}};
    end
elseif (ERF_LOG==1 || MAN_LOG==1) && QSA_LOG==1
    %*******************************************
    %Assign unperturbed ham. for quasistatic ERF
    %*******************************************
    H=cell(2,ND);
    for ii=1:2
        H(ii,1:ND)={zeros(NS(ii),NS(ii))};
        H(ii,1:ND)={diag(EL(ii,1:NS(ii)))-Ho{ii}};
    end
elseif ERF_LOG==1 && QSA_LOG==0
    %***************************************
    %Assign unperturbed ham. for floquet ERF
    %***************************************
    H=cell(2,1+2*NH);
    for ii=1:2
        H(ii,1:1+2*NH)={zeros(NS(ii),NS(ii))};
        H(ii,1)={diag(EL(ii,1:NS(ii)))-Ho{ii}};
    end    
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||| Assign B-field Hamiltonian ||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if B_LOG==1    
    %*****************************
    %Calc. B-field matrix elements
    %*****************************    
    MAT_0=B_MAT(PARA,UNIV);
    
    %**************************
    %Assign B-field hamiltonian
    %**************************
    HB=cell(1,2);
    for ii=1:2
        HB(ii)={B.MAG*MAT_0{ii}};
    end

    if (ERF_LOG==1 || MAN_LOG==1) && QSA_LOG==1
        %**************************************************
        %Assign B-field matrix elements for quasistatic ERF
        %**************************************************
        for ii=1:2
            for jj=1:ND
                H(ii,jj)={H{ii,jj}+HB{ii}};
            end
        end
    else
        %****************************************************
        %Assign B-field matrix elements for no or Floquet ERF
        %****************************************************
        for ii=1:2
            H(ii,1)={H{ii,1}+HB{ii}};
        end
    end
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||| Assign EDC-field Hamiltonian |||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if EDC_LOG==1 || ((ERF_LOG==1 || MAN_LOG==1) && QSA_LOG==1)
    %****************************
    %Calc. E-field matix elements
    %****************************
    [MAT_P,MAT_0,MAT_M]=E_MAT(PARA,UNIV);
    
    if (ERF_LOG==1 || MAN_LOG==1) && QSA_LOG==1    
        %***************
        %Allocate memory
        %***************
        HEQSA=cell(2,ND);
        
        for ii=1:ND
            %********************************************
            %Calc. spherical basis of quasistatic E-field
            %********************************************
            EQSA_SB(1)=-1/2^0.5*(QSA.E(1,ii)+1i*QSA.E(2,ii));
            EQSA_SB(2)=QSA.E(3,ii);
            EQSA_SB(3)=1/2^0.5*(QSA.E(1,ii)-1i*QSA.E(2,ii));
            
            %******************************************
            %Assign the quasistatic E-field hamiltonian
            %******************************************
            for jj=1:2
                HEQSA(jj,ii)={-EQSA_SB(1)*MAT_M{jj}+EQSA_SB(2)*MAT_0{jj}-EQSA_SB(3)*MAT_P{jj}};
            end

            %*****************************************
            %Assign quasistatic E-field matix elements
            %*****************************************
            for jj=1:2
                H(jj,ii)={H{jj,ii}+HEQSA{jj,ii}};
            end
        end
    else
        %***************************************
        %Calc. spherical basis of static E-field
        %***************************************
        EDC_SB(1)=-1/2^0.5*(EDC.MAG(1)+1i*EDC.MAG(2));
        EDC_SB(2)=EDC.MAG(3);
        EDC_SB(3)=1/2^0.5*(EDC.MAG(1)-1i*EDC.MAG(2));
        
        %*************************************
        %Assign the static E-field hamiltonian
        %*************************************
        HEDC=cell(1,2);
        for ii=1:2
            HEDC(ii)={-EDC_SB(1)*MAT_M{ii}+EDC_SB(2)*MAT_0{ii}-EDC_SB(3)*MAT_P{ii}};
        end
        
        %************************************
        %Assign static E-field matix elements
        %************************************        
        for ii=1:2
            H(ii,1)={H{ii,1}+HEDC{ii}};
        end
    end
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||| Assign ERF-field Hamiltonian |||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if ERF_LOG==1 && QSA_LOG==0    
    %*****************************************
    %Calc. the dynamic E-field matrix elements
    %*****************************************    
    [MAT_P,MAT_0,MAT_M]=E_MAT(PARA,UNIV);
    
    for ii=1:NH
        %**********************
        %Calc. RF E-field phase
        %**********************
        PHA=exp(1i*ERF.ANG(ii,1:3));
        
        %********************************************************
        %Calc. electric field for (+) harmonic of dynamic E-field
        %********************************************************         
        ERF_TEMP=ERF.MAG(ii,1:3).*PHA/2;
        
        %********************************************************
        %Calc. spherical basis of (+) harmonic of dynamic E-field
        %********************************************************
        ERF_SB(1)=-1/2^0.5*(ERF_TEMP(1)+1i*ERF_TEMP(2));
        ERF_SB(2)=ERF_TEMP(3);
        ERF_SB(3)=1/2^0.5*(ERF_TEMP(1)-1i*ERF_TEMP(2));
        
        %********************************************************
        %Assign (+) harmonic Floquet block E-field matix elements
        %********************************************************
        for jj=1:2
            H(jj,ii+1)={-ERF_SB(1)*MAT_M{jj}+ERF_SB(2)*MAT_0{jj}-ERF_SB(3)*MAT_P{jj}};
        end
        
        %********************************************************
        %Calc. electric field for (-) harmonic of dynamic E-field
        %********************************************************
        ERF_TEMP=ERF.MAG(ii,1:3).*conj(PHA)/2;
        
        %********************************************************
        %Calc. spherical basis of (-) harmonic of dynamic E-field
        %********************************************************
        ERF_SB(1)=-1/2^0.5*(ERF_TEMP(1)+1i*ERF_TEMP(2));
        ERF_SB(2)=ERF_TEMP(3);
        ERF_SB(3)=1/2^0.5*(ERF_TEMP(1)-1i*ERF_TEMP(2));
        
        %********************************************************
        %Assign (-) harmonic Floquet block E-field matix elements
        %********************************************************
        for jj=1:2
            H(jj,ii+1+NH)={-ERF_SB(1)*MAT_M{jj}+ERF_SB(2)*MAT_0{jj}-ERF_SB(3)*MAT_P{jj}};
        end
    end
    
    if FBC_LOG==1
        %*****************************************
        %Calc. number of Floquet blocks and states
        %*****************************************        
        [NB,NBS,~]=NB_SOLVER(H,PARA,FIELD,UNIV);
        
        %*******************************
        %Assign number of floquet blocks
        %*******************************
        PARA.NB=NB;
        PARA.NBS=NBS;
    end        
    
    %*********************************
    %Formulate the Floquet Hamiltonian
    %*********************************
    HF=SET_HF(H,PARA,FIELD,UNIV);
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%********************************
%Assign the hamiltonian structure
%********************************
HAM.UNPERTURBED=Ho;
HAM.TOTAL=H;
HAM.B=HB;
HAM.EDC=HEDC;
HAM.EQSA=HEQSA;
HAM.FLOQ=HF;

end