function SPECTRA=NORMALIZE(SPECTRA,OPT)

%*****************
%Assign input data
%*****************
DISC=SPECTRA.DISC;

SPEC=OPT.SPEC;
DFSS=OPT.DFSS;

%************
%Assign logic
%************
SUM_LOG=SPEC.SUM.LOGIC;
CR_LOG=DFSS.CROSS.LOGIC;
PEAK_LOG=strcmpi(DFSS.CROSS.PEAK,'0')~=1;
DIP_LOG=strcmpi(DFSS.CROSS.DIP,'0')~=1;

if SUM_LOG==0
    %********************
    %Atomic normalization
    %********************
    NORM_AT=max(DISC.FULL.I);
    
    %****************************
    %Crossover peak normalization
    %****************************
    if CR_LOG==1 && PEAK_LOG==1
        NORM_PK=max(abs(DISC.FULL.PEAK.I));
        
        if isempty(NORM_PK)==1
            NORM_PK=0;
        end
    else
        NORM_PK=0;
    end
    
    %***************************
    %Crossover dip normalization
    %***************************
    if CR_LOG==1 && DIP_LOG==1
        NORM_DIP=max(abs(DISC.FULL.DIP.I));
        
        if isempty(NORM_DIP)==1
            NORM_DIP=0;
        end
    else
        NORM_DIP=0;
    end
    
    %*******************
    %Calc. normalization
    %*******************
    NORM=max([NORM_AT NORM_PK NORM_DIP]);
        
    %*********
    %Normalize
    %*********
    DISC.FULL.I=DISC.FULL.I/NORM;

    if CR_LOG==1 && PEAK_LOG==1
        DISC.FULL.PEAK.I=DISC.FULL.PEAK.I/NORM;
    end
    
    if CR_LOG==1 && DIP_LOG==1
        DISC.FULL.DIP.I=DISC.FULL.DIP.I/NORM;
    end
else
    %********************
    %Atomic normalization
    %********************
    NORM_AT=max(DISC.SUM.I);
    
    %****************************
    %Crossover peak normalization
    %****************************
    if CR_LOG==1 && PEAK_LOG==1
        NORM_PK=max(abs(DISC.SUM.PEAK.I));
        
        if isempty(NORM_PK)==1
            NORM_PK=0;
        end
    else
        NORM_PK=0;
    end
    
    %***************************
    %Crossover dip normalization
    %***************************
    if CR_LOG==1 && DIP_LOG==1
        NORM_DIP=max(abs(DISC.SUM.DIP.I));
        
        if isempty(NORM_DIP)==1
            NORM_DIP=0;
        end
    else
        NORM_DIP=0;
    end

    %*******************
    %Calc. normalization
    %*******************     
    NORM=max([NORM_AT NORM_PK NORM_DIP]);
        
    %*********
    %Normalize
    %*********
    DISC.FULL.I=DISC.FULL.I/NORM;
    DISC.SUM.I=DISC.SUM.I/NORM;

    if CR_LOG==1 && PEAK_LOG==1
        DISC.FULL.PEAK.I=DISC.FULL.PEAK.I/NORM;
        DISC.SUM.PEAK.I=DISC.SUM.PEAK.I/NORM;
    end
    
    if CR_LOG==1 && DIP_LOG==1
        DISC.FULL.DIP.I=DISC.FULL.DIP.I/NORM;
        DISC.SUM.DIP.I=DISC.SUM.DIP.I/NORM;
    end  
end

%*************
%Assign output
%*************
SPECTRA.DISC=DISC;

end