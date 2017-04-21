function [NB,NBS,ND,FIELD]=SET_RF_OPT(FIELD,NS,OPT)

%****************
%Assign the input
%****************
QSA=FIELD.QSA;

SOLVER=OPT.SOLVER;
FLOQ=OPT.FLOQ;

%*******************
%Assign solver logic
%*******************
QSA_LOG=SOLVER.QSA_LOGIC;
MAN_LOG=SOLVER.MAN_LOGIC;
FBC_LOG=FLOQ.FBC_LOGIC;

if QSA_LOG==1
    %*******************************
    %Assign number of Floquet blocks
    %*******************************
    NB=[0,0];

    %******************************
    %Calc. Floquet number of states
    %******************************
    NBS=NS;   
    
    if MAN_LOG==0
        %******************************************
        %Assign temporal quasistatic discretization
        %******************************************
        NDT=SOLVER.NDT;
        
        %************************
        %Calc. QSA E-field values
        %************************
        FIELD=QSA_DISCRETIZE(FIELD,NDT);
        
        %****************************************
        %Assign global quasistatic discretization
        %****************************************
        ND=NDT;
    else
        %****************************************
        %Assign global quasistatic discretization
        %****************************************
        ND=QSA.NP;
    end
elseif QSA_LOG==0 && FBC_LOG==0
    %*******************************
    %Assign number of Floquet blocks
    %*******************************
    NB=FLOQ.NB;

    %******************************
    %Calc. Floquet number of states
    %******************************
    NBS=(2*NB+1).*NS;   
    
    %***************************************************
    %Assign quasistatic discretization for Floquet calc.
    %***************************************************
    ND=1;
elseif QSA_LOG==0 && FBC_LOG==1
    %***************************************
    %Allocate memory for Floquet block calc.
    %***************************************
    NB=[0,0];
    NBS=[0,0];
    
    %***************************************************
    %Assign quasistatic discretization for Floquet calc.
    %***************************************************
    ND=1;
end

end
    
    