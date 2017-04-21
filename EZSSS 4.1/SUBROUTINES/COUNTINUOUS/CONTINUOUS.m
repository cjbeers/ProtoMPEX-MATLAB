function SPECTRA=CONTINUOUS(SPECTRA,UNIV,OPT)

%************
%Assign input
%************
DISC=SPECTRA.DISC;

SPEC=OPT.SPEC;
DFSS=OPT.DFSS;

%************************************
%Assign Doppler broadening parameters
%************************************
NTG=SPEC.DOP.NTG;

%**************************
%Assign Gaussian parameters
%**************************
NFG=SPEC.GAU.NF;

%****************************
%Assign Lorentzian parameters
%****************************
NFL=SPEC.LOR.NF;

%************
%Assign logic
%************
CONT_LOG=SPEC.CONT_LOGIC;
NORM_LOG=SPEC.NORM_LOGIC;
SUM_LOG=SPEC.SUM.LOGIC;
CR_LOG=DFSS.CROSS.LOGIC;
PEAK_LOG=strcmpi(DFSS.CROSS.PEAK,'0')~=1;
DIP_LOG=strcmpi(DFSS.CROSS.DIP,'0')~=1;

%*********************
%Assign atomic spectra
%*********************
if SUM_LOG==1
    I=DISC.SUM.I;
    X=DISC.SUM.X;
    NT=DISC.SUM.NT;
else
    I=DISC.FULL.I;
    X=DISC.FULL.X;
    NT=DISC.FULL.NT;
end

ATOMIC.I=I;
ATOMIC.X=X;
ATOMIC.NX=NT;

if CR_LOG==1 && PEAK_LOG==1
    %*****************************
    %Assign crossover peak spectra
    %*****************************    
    if SPEC.SUM.LOGIC==1
        I=DISC.SUM.PEAK.I;
        X=DISC.SUM.PEAK.X;
        NT=DISC.SUM.PEAK.NT;
    else
        I=DISC.FULL.PEAK.I;
        X=DISC.FULL.PEAK.X;
        NT=DISC.FULL.PEAK.NT;
    end

    PEAK.I=I;
    PEAK.X=X;
    PEAK.NX=NT;
end
    
if CR_LOG==1 && DIP_LOG==1
    %****************************
    %Assign crossover dip spectra
    %****************************
    if SPEC.SUM.LOGIC==1
        I=DISC.SUM.DIP.I;
        X=DISC.SUM.DIP.X;
        NT=DISC.SUM.DIP.NT;
    else
        I=DISC.FULL.DIP.I;
        X=DISC.FULL.DIP.X;
        NT=DISC.FULL.DIP.NT;
    end

    DIP.I=I;
    DIP.X=X;
    DIP.NX=NT;
end
    
if CR_LOG==1 && (PEAK_LOG==1 || DIP_LOG==1)
    %*********************************
    %Assign atomic + crossover spectra
    %*********************************
    TOTAL.I=ATOMIC.I;
    TOTAL.X=ATOMIC.X;
    TOTAL.NX=ATOMIC.NX;

    if PEAK_LOG==1
        TOTAL.I=[TOTAL.I PEAK.I];
        TOTAL.X=[TOTAL.X PEAK.X];
        TOTAL.NX=TOTAL.NX+PEAK.NX;
    end

    if DIP_LOG==1
        TOTAL.I=[TOTAL.I DIP.I];
        TOTAL.X=[TOTAL.X DIP.X];
        TOTAL.NX=TOTAL.NX+DIP.NX;
    end
end

%*************************
%Calc. boundaries for grid
%*************************
AXIS=GRID_BOUNDARY(ATOMIC,UNIV,OPT);

%*******************************
%Assign grid boundary parameters
%*******************************
NG=AXIS.NG;
XL=AXIS.XL;
XU=AXIS.XU;

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||| CALC MAX DISCRETE GROUP INTENSITY |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%***************
%Allocate memory
%***************
I_D_MIN(1:NG)=0;
I_D_MAX(1:NG)=0;

for ii=1:NG
    %+++++++++++++++++++++++++++++++++
    %+++ Calc. group min intensity +++
    %+++++++++++++++++++++++++++++++++

    %***************************
    %Assign min atomic intensity
    %***************************
    MIN_AT=0;

    %***********************************
    %Assign min crossover peak intensity
    %***********************************
    if CR_LOG==1 && PEAK_LOG==1
        MIN_PK=min(PEAK.I(XL(ii)<=PEAK.X&PEAK.X<=XU(ii)));

        if isempty(MIN_PK)==1
            MIN_PK=0;
        end
    else
        MIN_PK=0;
    end

    %**********************************
    %Assign min crossover dip intensity
    %********************************** 
    if CR_LOG==1 && DIP_LOG==1
        MIN_DIP=min(DIP.I(XL(ii)<=DIP.X&DIP.X<=XU(ii)));

        if isempty(MIN_DIP)==1
            MIN_DIP=0;
        end
    else
        MIN_DIP=0;
    end

    %**********
    %Assign min
    %**********
    MIN=min([MIN_AT MIN_PK MIN_DIP]);
  
    %+++++++++++++++++++++++++++++++++
    %+++ Calc. group max intensity +++
    %+++++++++++++++++++++++++++++++++

    %***************************
    %Assign min atomic intensity
    %***************************
    MAX_AT=max(ATOMIC.I(XL(ii)<=ATOMIC.X&ATOMIC.X<=XU(ii)));

    %***********************************
    %Assign min crossover peak intensity
    %***********************************
    if CR_LOG==1 && PEAK_LOG==1
        MAX_PK=max(PEAK.I(XL(ii)<=PEAK.X&PEAK.X<=XU(ii)));

        if isempty(MAX_PK)==1
            MAX_PK=0;
        end
    else
        MAX_PK=0;
    end

    %**********************************
    %Assign min crossover dip intensity
    %********************************** 
    if CR_LOG==1 && DIP_LOG==1
        MAX_DIP=max(DIP.I(XL(ii)<=DIP.X&DIP.X<=XU(ii)));

        if isempty(MAX_DIP)==1
            MAX_DIP=0;
        end
    else
        MAX_DIP=0;
    end

    %**********
    %Assign max
    %**********
    MAX=max([MAX_AT MAX_PK MAX_DIP]);

    %******************************
    %Assign group min/max intensity
    %******************************
    I_D_MIN(ii)=MIN;
    I_D_MAX(ii)=MAX;
end

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
if CONT_LOG==1 %%%%%%%%%%%%% ASSIGN AXIS AND CONT OUTPUT IF %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||| CALC CONTINUOUS ATOMIC SPECTRA |||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

if NFG>0 || NTG>0
    %***********************************
    %Convolute with Gaussian function(s)
    %***********************************
    ATOMIC=GAUSSIAN(ATOMIC,AXIS,UNIV,OPT);
    
    if NFL>0
        %*************************************
        %Convolute with Lorentzian function(s)
        %*************************************
        ATOMIC=LORENTZIAN(ATOMIC,AXIS,OPT);   
    end
elseif NFL>0
    %*************************************
    %Convolute with Lorentzian function(s)
    %*************************************
    ATOMIC=LORENTZIAN(ATOMIC,AXIS,OPT);
end

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||| CALC CONTINUOUS CROSSOVER PEAK SPECTRA |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    if CR_LOG==1 && PEAK_LOG==1 && (NFG>0 || NTG>0)
        %***********************************
        %Convolute with Gaussian function(s)
        %***********************************
        PEAK=GAUSSIAN(PEAK,AXIS,UNIV,OPT);

        if NFL>0
            %*************************************
            %Convolute with Lorentzian function(s)
            %*************************************
            PEAK=LORENTZIAN(PEAK,AXIS,OPT); 
        end
    elseif CR_LOG==1 && PEAK_LOG==1 && NFL>0
        %*************************************
        %Convolute with Lorentzian function(s)
        %*************************************
        PEAK=LORENTZIAN(PEAK,AXIS,OPT);
    end

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||| CALC CONTINUOUS CROSSOVER DIP SPECTRA |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    if CR_LOG==1 && DIP_LOG==1 && (NFG>0 || NTG>0)
        %***********************************
        %Convolute with Gaussian function(s)
        %***********************************
        DIP=GAUSSIAN(DIP,AXIS,UNIV,OPT);

        if NFL>0
            %*************************************
            %Convolute with Lorentzian function(s)
            %*************************************
            DIP=LORENTZIAN(DIP,AXIS,OPT); 
        end
    elseif CR_LOG==1 && DIP_LOG==1 && NFL>0
        %*************************************
        %Convolute with Lorentzian function(s)
        %*************************************
        DIP=LORENTZIAN(DIP,AXIS,OPT);
    end

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%//////////////////////////////////////////////////////////////////////////
%||||||||||||| CALC CONTINUOUS ATOMIC+CROSSOVER SPECTRA |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    if CR_LOG==1 && (PEAK_LOG==1 || DIP_LOG==1) && (NFG>0 || NTG>0)
        %***********************************
        %Convolute with Gaussian function(s)
        %***********************************
        TOTAL=GAUSSIAN(TOTAL,AXIS,UNIV,OPT);

        if NFL>0
            %*************************************
            %Convolute with Lorentzian function(s)
            %*************************************
            TOTAL=LORENTZIAN(TOTAL,AXIS,OPT); 
        end
    elseif CR_LOG==1 && (PEAK_LOG==1 || DIP_LOG==1) && NFL>0
        %*************************************
        %Convolute with Lorentzian function(s)
        %*************************************
        TOTAL=LORENTZIAN(TOTAL,AXIS,OPT);
    end

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||| NORMALIZE CONTINUOUS SPECTRA |||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    if NORM_LOG==1
        %***************************
        %Assign max atomic intensity
        %***************************
        MAX_AT=max(ATOMIC.I);
        
        %***********************************
        %Assign max crossover peak intensity
        %***********************************
        if CR_LOG==1 && PEAK_LOG==1
            MAX_PK=max(abs(PEAK.I));
            
            if isempty(MAX_PK)==1
                MAX_PK=0;
            end
        else
            MAX_PK=0;
        end
        
        %**********************************
        %Assign max crossover dip intensity
        %**********************************
        if CR_LOG==1 && DIP_LOG==1
            MAX_DIP=max(abs(DIP.I));
            
            if isempty(MAX_DIP)==1
                MAX_DIP=0;
            end
        else
            MAX_DIP=0;
        end
        
        %***************************************
        %Assign max atomic + crossover intensity
        %*************************************** 
        if CR_LOG==1 && (PEAK_LOG==1 || DIP_LOG==1)
            MAX_TOT=max(abs(TOTAL.I));
            
            if isempty(MAX_TOT)==1
                MAX_TOT=0;
            end
        else
            MAX_TOT=0;
        end
        
        %***************************
        %Assign normalization factor
        %*************************** 
        NORM=max([MAX_AT MAX_PK MAX_DIP MAX_TOT]);

        %*********
        %Normalize
        %*********
        ATOMIC.I=ATOMIC.I/NORM;
        
        if CR_LOG==1 && PEAK_LOG==1
            PEAK.I=PEAK.I/NORM;
        end
        
        if CR_LOG==1 && DIP_LOG==1
            DIP.I=DIP.I/NORM;
        end
            
        if CR_LOG==1 && (PEAK_LOG==1 || DIP_LOG==1)    
            TOTAL.I=TOTAL.I/NORM;
        end
    end

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||| CALC MAX CONTINUOUS GROUP INTENSITY |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    %***************
    %Allocate memory
    %***************
    I_C_MIN(1:NG)=0;
    I_C_MAX(1:NG)=0;

    for ii=1:NG
        %+++++++++++++++++++++++++++++++++
        %+++ Calc. group min intensity +++
        %+++++++++++++++++++++++++++++++++

        %***************************
        %Assign min atomic intensity
        %***************************
        MIN_AT=0;

        %***********************************
        %Assign min crossover peak intensity
        %***********************************
        if CR_LOG==1 && PEAK_LOG==1 
            MIN_PK=min(PEAK.I(XL(ii)<=PEAK.X&PEAK.X<=XU(ii)));

            if isempty(MIN_PK)==1
                MIN_PK=0;
            end
        else
            MIN_PK=0;
        end

        %**********************************
        %Assign min crossover dip intensity
        %********************************** 
        if CR_LOG==1 && DIP_LOG==1
            MIN_DIP=min(DIP.I(XL(ii)<=DIP.X&DIP.X<=XU(ii)));

            if isempty(MIN_DIP)==1
                MIN_DIP=0;
            end
        else
            MIN_DIP=0;
        end

        %***************************************
        %Assign min atomic + crossover intensity
        %*************************************** 
        if CR_LOG==1 && (PEAK_LOG==1 || DIP_LOG==1)
            MIN_TOT=min(TOTAL.I(XL(ii)<=TOTAL.X&TOTAL.X<=XU(ii)));

            if isempty(MIN_TOT)==1
                MIN_TOT=0;
            end
        else
            MIN_TOT=0;
        end

        %**********
        %Assign min
        %**********
        MIN=min([MIN_AT MIN_PK MIN_DIP MIN_TOT]);

        %+++++++++++++++++++++++++++++++++
        %+++ Calc. group max intensity +++
        %+++++++++++++++++++++++++++++++++

        %***************************
        %Assign max atomic intensity
        %***************************
        MAX_AT=max(ATOMIC.I(XL(ii)<=ATOMIC.X&ATOMIC.X<=XU(ii)));

        %***********************************
        %Assign max crossover peak intensity
        %***********************************
        if CR_LOG==1 && PEAK_LOG==1 
            MAX_PK=max(PEAK.I(XL(ii)<=PEAK.X&PEAK.X<=XU(ii)));

            if isempty(MAX_PK)==1
                MAX_PK=0;
            end
        else
            MAX_PK=0;
        end

        %**********************************
        %Assign max crossover dip intensity
        %********************************** 
        if CR_LOG==1 && DIP_LOG==1
            MAX_DIP=max(DIP.I(XL(ii)<=DIP.X&DIP.X<=XU(ii)));

            if isempty(MAX_DIP)==1
                MAX_DIP=0;
            end
        else
            MAX_DIP=0;
        end

        %***************************************
        %Assign max atomic + crossover intensity
        %*************************************** 
        if CR_LOG==1 && (PEAK_LOG==1 || DIP_LOG==1)
            MAX_TOT=max(TOTAL.I(XL(ii)<=TOTAL.X&TOTAL.X<=XU(ii)));

            if isempty(MAX_TOT)==1
                MAX_TOT=0;
            end
        else
            MAX_TOT=0;
        end

        %**********
        %Assign max
        %**********
        MAX=max([MAX_AT MAX_PK MAX_DIP MAX_TOT]);

        %******************************
        %Assign group min/max intensity
        %******************************
        I_C_MIN(ii)=MIN;
        I_C_MAX(ii)=MAX;
    end

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||| CALC MAX CONTINUOUS GROUP INTENSITY |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    %*************
    %Assign output
    %*************
    AXIS.I_D_MIN=I_D_MIN;
    AXIS.I_D_MAX=I_D_MAX;
    
    AXIS.I_C_MIN=I_C_MIN;
    AXIS.I_C_MAX=I_C_MAX;

    CONT=ATOMIC;
    if CR_LOG==1 && PEAK_LOG==1
        CONT.PEAK=PEAK;
    end
    if CR_LOG==1 && DIP_LOG==1
        CONT.DIP=DIP;
    end
    if CR_LOG==1 && (PEAK_LOG==1 || DIP_LOG==1)
        CONT.TOTAL=TOTAL;
    end

    SPECTRA.AXIS=AXIS;
    SPECTRA.CONT=CONT;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else %%%%% ASSIGN ONLY AXIS OUTPUT IF CONTINUOUS SPECTRA CALC IS OFF %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %*************
    %Assign output
    %*************
    AXIS.I_D_MIN=I_D_MIN;
    AXIS.I_D_MAX=I_D_MAX;

    SPECTRA.AXIS=AXIS;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end