function SPECTRA=CROSS_INTENSITY_SIM_SER(SPECTRA,OBS,PARA,UNIV,OPT)

%************
%Assign input
%************
FULL=SPECTRA.DISC.FULL;

OBS_MODE=OBS.MODE;

c=UNIV.c;

DFSS=OPT.DFSS;
PRINT=OPT.PRINT;

%************************************************
%Assign the view integration normalization factor
%************************************************
if strcmpi(OBS_MODE,'NO_INT')==1
    INT_NORM=1;
elseif strcmpi(OBS_MODE,'1D_INT')==1
    INT_NORM=2*pi;
elseif strcmpi(OBS_MODE,'2D_INT')==1
    INT_NORM=4*pi;
end

%******************************
%Assign crossover peak/dip sign
%******************************
if strcmpi(DFSS.CROSS.PEAK,'+')==1
    MULT_PK=1;
elseif strcmpi(DFSS.CROSS.PEAK,'-')==1
    MULT_PK=-1;
elseif strcmpi(DFSS.CROSS.PEAK,'0')==1
    MULT_PK=0;
end

if strcmpi(DFSS.CROSS.DIP,'+')==1
    MULT_DIP=1;
elseif strcmpi(DFSS.CROSS.DIP,'-')==1
    MULT_DIP=-1;
elseif strcmpi(DFSS.CROSS.DIP,'0')==1
    MULT_DIP=0;
end

%********************************
%Assign min simulation absorption
%********************************
MIN_SIM=DFSS.CROSS.MIN_SIM;

%***********************************
%Assign min crossover peak/dip ratio
%***********************************
MIN_RATIO=DFSS.CROSS.MIN_RATIO;

%**********************************************
%Assign frequency window for transition spacing
%**********************************************
NU_WIN=DFSS.CROSS.NU_WIN;

%******************
%Assign print logic
%******************
PRINT_LOG=PRINT.DFSS;

%*********************
%Get DFSS base options
%*********************
DFSSS_OPT=SET_DFSSS_OPT(PARA,OPT);

%****************************
%Assign various DFSSS options
%****************************
DFSSS_OPT.ATOMIC.NT_0=2; 
DFSSS_OPT.LASER.NFP=2;  
DFSSS_OPT.LASER.NU_MODE='MANUAL';  

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||||||| CALC CROSSOVER PEAKS ||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

if MULT_PK~=0

    %********************************
    %Assign crossover peak parameters
    %********************************
    NT_PK=FULL.PEAK.NT;
    XT_PK=FULL.PEAK.XT;
    IT_PK=FULL.PEAK.IT;
    ST_PK=FULL.PEAK.ST;

    QSAN_PK=FULL.PEAK.STATE.QSAN;
    LL_PK=FULL.PEAK.STATE.LL;
    UL_PK=FULL.PEAK.STATE.UL;
    IND_PK=FULL.PEAK.STATE.IND;

    %***************
    %Allocate memory
    %***************
    X_PK(1:NT_PK)=0;
    I_PK(1:NT_PK)=0;
    S_PK(1:NT_PK)=0;

    for ii=1:NT_PK
        %**************
        %Print progress
        %**************    
        if PRINT_LOG==1
            PRINT_PROGRESS_SER(ii,NT_PK,'Crossover Peaks')
        end

        if IT_PK(ii,1)>IT_PK(ii,2)
            %******************
            %Assign wavelengths
            %******************
            X1=XT_PK(ii,1);
            X2=XT_PK(ii,2);

            %*******************************
            %Assign transition probabilities
            %******************************* 
            I1=IT_PK(ii,1);
            I2=IT_PK(ii,2);

            %******************************
            %Assign the DFSS scaling factor
            %******************************
            S1=ST_PK(ii,1);
        else
            %******************
            %Assign wavelengths
            %******************
            X1=XT_PK(ii,2);
            X2=XT_PK(ii,1);

            %*******************************
            %Assign transition probabilities
            %******************************* 
            I1=IT_PK(ii,2);
            I2=IT_PK(ii,1);

            %******************************
            %Assign the DFSS scaling factor
            %******************************
            S1=ST_PK(ii,2);
        end

        %*************************************
        %Calc. the initial crossover intensity
        %*************************************
        I_PK(ii)=I1;

        %******************************
        %Assign the DFSS scaling factor
        %******************************
        S_PK(ii)=S1;

        %******************************
        %Calc. the crossover wavelength
        %******************************
        X_PK(ii)=(X1+X2)/2; 

        %******************************
        %Calc. the transition frequency
        %******************************
        NU1=c/X1;
        NU2=c/X2;

        %***************
        %Intialize logic
        %***************
        HIT=0;

        %*********************************************
        %Assign logic for crossover peak to be ignored
        %*********************************************
        if abs(NU1-NU2)<NU_WIN(1) || abs(NU1-NU2)>NU_WIN(2)
            HIT=1;
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if HIT==0 %%% LOGIC TO IGNORE CROSSOVER PEAK %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
            %*****************************
            %Calc. the crossover frequency
            %*****************************
            NU3=(NU1+NU2)/2;

            %**********************************
            %Assign the transition probabilites
            %**********************************
            DFSSS_OPT.ATOMIC.A_0=[I1 I2]/INT_NORM;
            DFSSS_OPT.ATOMIC.NU_0=[NU1 NU2];

            %********************************
            %Assign the measurement frequency
            %********************************
            DFSSS_OPT.LASER.NU_MAN=[NU1 NU3];

            %************************
            %Run PROBE DFSSS geometry
            %************************
            DFSSS_OPT.GENERAL.MODE='PROBE'; 
            [DATA_PROBE,~,~,~]=DFSSS(DFSSS_OPT,1);    

            %*****************************
            %Run PUMP/PROBE DFSSS geometry
            %*****************************
            DFSSS_OPT.GENERAL.MODE='BOTH'; 
            [DATA_BOTH,~,~,~]=DFSSS(DFSSS_OPT,1);

            %*********************
            %Assign intensity data
            %*********************
            I_PR=DATA_PROBE.I_PR;
            I_PU_PR=DATA_BOTH.I_PR;

            %****************************************************
            %Assign the atomic and crossover absorption intensity
            %****************************************************
            I_DF=(I_PU_PR(1,2)-I_PR(1,2))/I_PR(1,1);
            I_CR=(I_PU_PR(2,2)-I_PR(2,2))/I_PR(2,1);

            %*****************
            %Calc scale factor
            %*****************
            if I_DF>MIN_SIM && I_CR>MIN_SIM
                S_PK(ii)=S_PK(ii)*I_CR/I_DF;
            else
                S_PK(ii)=0;
            end
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        else %%% LOGIC TO IGNORE CROSSOVER PEAK %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
            
            S_PK(ii)=0;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        end  %%% LOGIC TO IGNORE CROSSOVER PEAK %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
%|||||||||||||| ASSIGN SUFFICIENTLY LARGE CROSSOVER PEAKS |||||||||||||||||

    %**********************************
    %Calc. the crossover peak intensity
    %**********************************
    I_PK=S_PK.*I_PK;

    %***************
    %Allocate memory
    %***************
    XT_PK_TEMP(1:NT_PK,1:2)=0;
    IT_PK_TEMP(1:NT_PK,1:2)=0;
    ST_PK_TEMP(1:NT_PK,1:2)=0;

    X_PK_TEMP(1:NT_PK)=0;
    I_PK_TEMP(1:NT_PK)=0;
    S_PK_TEMP(1:NT_PK)=0;

    QSAN_PK_TEMP(1:NT_PK)=0;
    LL_PK_TEMP(1:NT_PK)=0;
    UL_PK_TEMP(1:NT_PK,1:2)=0;
    IND_PK_TEMP(1:NT_PK,1:2)=0;

    jj=0;
    for ii=1:NT_PK
        if I_PK(ii)>MIN_RATIO
            %***********************
            %Advance the dummy index
            %***********************
            jj=jj+1;

            %*************************************************
            %Assign crossover peaks having sufficent intensity
            %*************************************************
            XT_PK_TEMP(jj,1:2)=XT_PK(ii,1:2);
            IT_PK_TEMP(jj,1:2)=IT_PK(ii,1:2);
            ST_PK_TEMP(jj,1:2)=ST_PK(ii,1:2);

            X_PK_TEMP(jj)=X_PK(ii);
            I_PK_TEMP(jj)=I_PK(ii);
            S_PK_TEMP(jj)=S_PK(ii);

            QSAN_PK_TEMP(jj)=QSAN_PK(ii);
            LL_PK_TEMP(jj)=LL_PK(ii);
            UL_PK_TEMP(jj,1:2)=UL_PK(ii,1:2);
            IND_PK_TEMP(jj,1:2)=IND_PK(ii,1:2);
        end
    end

    %********************************
    %Update number of crossover peaks
    %********************************
    NT_PK=jj;

    %***************
    %Truncate arrays
    %***************
    XT_PK=XT_PK_TEMP(1:NT_PK,1:2);
    IT_PK=IT_PK_TEMP(1:NT_PK,1:2);
    ST_PK=ST_PK_TEMP(1:NT_PK,1:2);

    X_PK=X_PK_TEMP(1:NT_PK);
    I_PK=I_PK_TEMP(1:NT_PK);
    S_PK=S_PK_TEMP(1:NT_PK);

    QSAN_PK=QSAN_PK_TEMP(1:NT_PK);
    LL_PK=LL_PK_TEMP(1:NT_PK);
    UL_PK=UL_PK_TEMP(1:NT_PK,1:2);
    IND_PK=IND_PK_TEMP(1:NT_PK,1:2);

    %******************************************************
    %Multiple crossover peak intensity by user defined sign
    %******************************************************
    I_PK=I_PK*MULT_PK;

    %*******************************
    %Assign crossover peak structure
    %*******************************
    PEAK.XT=XT_PK;
    PEAK.IT=IT_PK;
    PEAK.ST=ST_PK;
    PEAK.NT=NT_PK;

    PEAK.X=X_PK;
    PEAK.I=I_PK;
    PEAK.S=S_PK;

    PEAK.STATE.QSAN=QSAN_PK;
    PEAK.STATE.LL=LL_PK;
    PEAK.STATE.UL=UL_PK;
    PEAK.STATE.IND=IND_PK;

    %*************
    %Assign output
    %*************
    FULL.PEAK=PEAK;

end

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||||||||| CALC CROSSOVER DIPS ||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

if MULT_DIP~=0

    %*******************************
    %Assign crossover dip parameters
    %*******************************
    NT_DIP=FULL.DIP.NT;
    XT_DIP=FULL.DIP.XT;
    IT_DIP=FULL.DIP.IT;
    ST_DIP=FULL.DIP.ST;

    QSAN_DIP=FULL.DIP.STATE.QSAN;
    LL_DIP=FULL.DIP.STATE.LL;
    UL_DIP=FULL.DIP.STATE.UL;
    IND_DIP=FULL.DIP.STATE.IND;

    %***************
    %Allocate memory
    %***************
    X_DIP(1:NT_DIP)=0;
    I_DIP(1:NT_DIP)=0;
    S_DIP(1:NT_DIP)=0;

    for ii=1:NT_DIP
        %**************
        %Print progress
        %**************    
        if PRINT_LOG==1
            PRINT_PROGRESS_SER(ii,NT_DIP,'Crossover Dips')
        end

        if IT_DIP(ii,1)>IT_DIP(ii,2)
            %******************
            %Assign wavelengths
            %******************
            X1=XT_DIP(ii,1);
            X2=XT_DIP(ii,2);

            %*******************************
            %Assign transition probabilities
            %******************************* 
            I1=IT_DIP(ii,1);
            I2=IT_DIP(ii,2);

            %******************************
            %Assign the DFSS scaling factor
            %******************************
            S1=ST_DIP(ii,1);
        else
            %******************
            %Assign wavelengths
            %******************
            X1=XT_DIP(ii,2);
            X2=XT_DIP(ii,1);

            %*******************************
            %Assign transition probabilities
            %******************************* 
            I1=IT_DIP(ii,2);
            I2=IT_DIP(ii,1);

            %******************************
            %Assign the DFSS scaling factor
            %******************************
            S1=ST_DIP(ii,2);
        end

        %*************************************
        %Calc. the initial crossover intensity
        %*************************************
        I_DIP(ii)=I1;

        %******************************
        %Assign the DFSS scaling factor
        %******************************
        S_DIP(ii)=S1;

        %******************************
        %Calc. the crossover wavelength
        %******************************
        X_DIP(ii)=(X1+X2)/2;

        %******************************
        %Calc. the transition frequency
        %******************************
        NU1=c/X1;
        NU2=c/X2;

        %***************
        %Intialize logic
        %***************
        HIT=0;

        %*********************************************
        %Assign logic for crossover peak to be ignored
        %*********************************************
        if abs(NU1-NU2)<NU_WIN(1) || abs(NU1-NU2)>NU_WIN(2)
            HIT=1;
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if HIT==0 %%% LOGIC TO IGNORE CROSSOVER DIP %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
            %*****************************
            %Calc. the crossover frequency
            %*****************************
            NU3=(NU1+NU2)/2;

            %**********************************
            %Assign the transition probabilites
            %**********************************
            DFSSS_OPT.ATOMIC.A_0=[I1 I2]/INT_NORM;
            DFSSS_OPT.ATOMIC.NU_0=[NU1 NU2];

            %********************************
            %Assign the measurement frequency
            %********************************
            DFSSS_OPT.LASER.NU_MAN=[NU1 NU3];

            %************************
            %Run PROBE DFSSS geometry
            %************************
            DFSSS_OPT.GENERAL.MODE='PROBE'; 
            [DATA_PROBE,~,~,~]=DFSSS(DFSSS_OPT,1);    

            %*****************************
            %Run PUMP/PROBE DFSSS geometry
            %*****************************
            DFSSS_OPT.GENERAL.MODE='BOTH'; 
            [DATA_BOTH,~,~,~]=DFSSS(DFSSS_OPT,1);

            %*********************
            %Assign intensity data
            %*********************
            I_PR=DATA_PROBE.I_PR;
            I_PU_PR=DATA_BOTH.I_PR;

            %****************************************************
            %Assign the atomic and crossover absorption intensity
            %****************************************************
            I_DF=(I_PU_PR(1,2)-I_PR(1,2))/I_PR(1,1);
            I_CR=(I_PU_PR(2,2)-I_PR(2,2))/I_PR(2,1);

            %*****************
            %Calc scale factor
            %*****************
            if I_DF>MIN_SIM && I_CR>MIN_SIM
                S_DIP(ii)=S_DIP(ii)*I_CR/I_DF;
            else
                S_DIP(ii)=0;
            end
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        else %%% LOGIC TO IGNORE CROSSOVER DIP %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
            
            S_DIP(ii)=0;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        end  %%% LOGIC TO IGNORE CROSSOVER DIP %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end

%||||||||||||||| ASSIGN SUFFICIENTLY LARGE CROSSOVER DIPS |||||||||||||||||

    %*********************************
    %Calc. the crossover dip intensity
    %*********************************
    I_DIP=S_DIP.*I_DIP;

    %***************
    %Allocate memory
    %***************
    XT_DIP_TEMP(1:NT_DIP,1:2)=0;
    IT_DIP_TEMP(1:NT_DIP,1:2)=0;
    ST_DIP_TEMP(1:NT_DIP,1:2)=0;

    X_DIP_TEMP(1:NT_DIP)=0;
    I_DIP_TEMP(1:NT_DIP)=0;
    S_DIP_TEMP(1:NT_DIP)=0;

    QSAN_DIP_TEMP(1:NT_DIP)=0;
    LL_DIP_TEMP(1:NT_DIP,1:2)=0;
    UL_DIP_TEMP(1:NT_DIP)=0;
    IND_DIP_TEMP(1:NT_DIP,1:2)=0;

    jj=0;
    for ii=1:NT_DIP
        if I_DIP(ii)>MIN_RATIO
            %***********************
            %Advance the dummy index
            %***********************
            jj=jj+1;

            %*************************************************
            %Assign crossover peaks having sufficent intensity
            %*************************************************
            XT_DIP_TEMP(jj,1:2)=XT_DIP(ii,1:2);
            IT_DIP_TEMP(jj,1:2)=IT_DIP(ii,1:2);
            ST_DIP_TEMP(jj,1:2)=ST_DIP(ii,1:2);

            X_DIP_TEMP(jj)=X_DIP(ii);
            I_DIP_TEMP(jj)=I_DIP(ii);
            S_DIP_TEMP(jj)=S_DIP(ii);

            QSAN_DIP_TEMP(jj)=QSAN_DIP(ii);
            LL_DIP_TEMP(jj,1:2)=LL_DIP(ii,1:2);
            UL_DIP_TEMP(jj)=UL_DIP(ii);
            IND_DIP_TEMP(jj,1:2)=IND_DIP(ii,1:2);
        end
    end

    %********************************
    %Update number of crossover peaks
    %********************************
    NT_DIP=jj;

    %***************
    %Truncate arrays
    %***************
    XT_DIP=XT_DIP_TEMP(1:NT_DIP,1:2);
    IT_DIP=IT_DIP_TEMP(1:NT_DIP,1:2);
    ST_DIP=ST_DIP_TEMP(1:NT_DIP,1:2);

    X_DIP=X_DIP_TEMP(1:NT_DIP);
    I_DIP=I_DIP_TEMP(1:NT_DIP);
    S_DIP=S_DIP_TEMP(1:NT_DIP);

    QSAN_DIP=QSAN_DIP_TEMP(1:NT_DIP);
    LL_DIP=LL_DIP_TEMP(1:NT_DIP,1:2);
    UL_DIP=UL_DIP_TEMP(1:NT_DIP);
    IND_DIP=IND_DIP_TEMP(1:NT_DIP,1:2);

    %*****************************************************
    %Multiple crossover dip intensity by user defined sign
    %*****************************************************
    I_DIP=I_DIP*MULT_DIP;

    %******************************
    %Assign crossover dip structure
    %******************************
    DIP.XT=XT_DIP;
    DIP.IT=IT_DIP;
    DIP.ST=ST_DIP;
    DIP.NT=NT_DIP;

    DIP.X=X_DIP;
    DIP.I=I_DIP;
    DIP.S=S_DIP;

    DIP.STATE.QSAN=QSAN_DIP;
    DIP.STATE.LL=LL_DIP;
    DIP.STATE.UL=UL_DIP;
    DIP.STATE.IND=IND_DIP;

    %*************
    %Assign output
    %*************
    FULL.DIP=DIP;

end

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%*************
%Assign output
%*************
SPECTRA.DISC.FULL=FULL;

end