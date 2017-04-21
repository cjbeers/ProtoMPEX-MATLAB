function SPECTRA=QSA_WEIGHT(SPECTRA,PARA,FIELD,OPT)

%************
%Assign input
%************
FULL=SPECTRA.DISC.FULL;

QSA=FIELD.QSA;

DFSS=OPT.DFSS;

%************************************
%Assign number of QSA discretizations
%************************************
ND=PARA.ND;

%*********************
%Assign QSA parameters
%*********************
WT=QSA.WT;

%************
%Assign logic
%************
CR_LOG=DFSS.CROSS.LOGIC;
PEAK_LOG=strcmpi(DFSS.CROSS.PEAK,'0')~=1;
DIP_LOG=strcmpi(DFSS.CROSS.DIP,'0')~=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%|||||||||||||||||||||| WEIGHT ATOMIC TRANSITIONS |||||||||||||||||||||||||
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%***********************
%Assign discrete spectra
%***********************
I=FULL.I;
NT_QSA=FULL.NT_QSA;

for ii=1:ND
    %*********************************************
    %Assign transition indices for the current QSA
    %*********************************************
    IND1=NT_QSA(ii,1);
    IND2=NT_QSA(ii,2);
    
    %***************************************
    %Multiple intensity by the weight factor
    %***************************************
    I(IND1:IND2)=WT(ii)*I(IND1:IND2);
end

%************************************************
%Normalize intensity by QSA discretization number
%************************************************
I=I/ND;

%************************************
%Update intensity of discrete spectra 
%************************************
FULL.I=I;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%||||||||||||||||||||||| WEIGHT CROSSOVER PEAKS |||||||||||||||||||||||||||
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if CR_LOG==1 && PEAK_LOG==1
    %**********************
    %Assign crossover peaks
    %**********************    
    PEAK=FULL.PEAK;
    
    %*************************
    %Assign crossover spectrum
    %*************************
    I_PK=PEAK.I;
    N_PK=PEAK.NT;
    QSAN_PK=PEAK.STATE.QSAN;
    
    for ii=1:N_PK
        %********************************************
        %Assign QSA indice for the current transition
        %********************************************
        IND=QSAN_PK(ii);

        %***************************************
        %Multiple intensity by the weight factor
        %***************************************
        I_PK(ii)=WT(IND)*I_PK(ii);
    end

    %************************************************
    %Normalize intensity by QSA discretization number
    %************************************************
    I_PK=I_PK/ND;
    
    %**************************************
    %Update intensity of crossover spectrum 
    %**************************************
    PEAK.I=I_PK;
    
    %*********************
    %Update FULL structure
    %*********************
    FULL.PEAK=PEAK;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%|||||||||||||||||||||||| WEIGHT CROSSOVER DIPS |||||||||||||||||||||||||||
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if CR_LOG==1 && DIP_LOG==1
    %*********************
    %Assign crossover dips
    %*********************    
    DIP=FULL.DIP;
    
    %*************************
    %Assign crossover spectrum
    %*************************
    I_DIP=DIP.I;
    N_DIP=DIP.NT;
    QSAN_DIP=DIP.STATE.QSAN;
    
    for ii=1:N_DIP
        %********************************************
        %Assign QSA indice for the current transition
        %********************************************
        IND=QSAN_DIP(ii);

        %***************************************
        %Multiple intensity by the weight factor
        %***************************************
        I_DIP(ii)=WT(IND)*I_DIP(ii);
    end

    %************************************************
    %Normalize intensity by QSA discretization number
    %************************************************
    I_DIP=I_DIP/ND;
    
    %**************************************
    %Update intensity of crossover spectrum 
    %**************************************
    DIP.I=I_DIP;
    
    %*********************
    %Update FULL structure
    %*********************
    FULL.DIP=DIP;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%*************
%Assign output
%*************
SPECTRA.DISC.FULL=FULL;

end