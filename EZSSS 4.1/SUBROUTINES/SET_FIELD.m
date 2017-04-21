function [B,EDC,ERF,QSA]=SET_FIELD(VAR,WF,OPT)

%************
%Assign input
%************
SOLVER=OPT.SOLVER;

%*******************
%Assign solver logic
%*******************
QSA_LOG=SOLVER.QSA_LOGIC;
MAN_LOG=SOLVER.MAN_LOGIC;

%****************
%Assign QSA logic
%****************
LOG=QSA_LOG==0||(QSA_LOG==1&&MAN_LOG==0); 

if abs(VAR.B.MAG)==0
    %*********************
    %Assign magnetic field
    %*********************
    B.MAG=0;

    %******************
    %Define field logic
    %******************
    B.LOGIC=0;
else
    %*********************
    %Assign magnetic field
    %*********************
    B=VAR.B;

    %******************
    %Define field logic
    %******************
    B.LOGIC=1;
end

if LOG==0 || sum(abs(VAR.EDC.MAG))==0 
    %*******************
    %Null EDC parameters
    %*******************
    EDC.MAG=[0 0 0];

    %******************
    %Define field logic
    %******************
    EDC.LOGIC=0;
else
    %****************************
    %Assign static electric field
    %****************************
    EDC=VAR.EDC;

    %******************
    %Define field logic
    %******************
    EDC.LOGIC=1;
end

if LOG==0 || sum(abs(VAR.ERF.MAG(1,:)))==0  
    %*******************
    %Null ERF parameters
    %*******************
    ERF.NH=0;
    ERF.NU=0;
    ERF.MAG=[0 0 0];
    ERF.ANG=[0 0 0];

    %******************
    %Define field logic
    %******************
    ERF.LOGIC=0;
else
    %************************
    %Assign RF electric field
    %************************
    ERF=VAR.ERF;

    %*********************************
    %Set arbitary RF frequency for QSA
    %*********************************
    if QSA_LOG==1
        ERF.NU=1;
    end

    %******************************
    %Assign the number of harmonics
    %******************************
    ERF.NH=length(ERF.MAG(:,1));

    %******************
    %Define field logic
    %******************
    ERF.LOGIC=1;
end

%*****************************
%Assign quasistatic parameters
%*****************************
if LOG==0
    QSA=VAR.QSA;
else
    QSA=[];
end

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><>  E-field calc. is only applicable to hydrogen/helium-like atoms  <><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
if WF==0
    %************************************************************
    %Null DC electric field if atom is not listed in EF_ATOM_LIST
    %************************************************************
    if EDC.LOGIC==1
        EDC.LOGIC=0;
        
        EDC.MAG=[0 0 0];
    end
    
    %************************************************************
    %Null RF electric field if atom is not listed in EF_ATOM_LIST
    %************************************************************
    if ERF.LOGIC==1
        ERF.LOGIC=0;
        
        ERF.NH=0;
        ERF.MAG=[0 0 0];
        ERF.ANG=[0 0 0];
    end
    
    %*****************************************************************
    %Null quasistatic parameters if atom is not listed in EF_ATOM_LIST
    %*****************************************************************
    if LOG==0
        QSA.NP=1;
        QSA.E=[0 0 0];
        QSA.WT=1;
    end
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

end