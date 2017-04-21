function SPECTRA=CROSS_INTENSITY_EQN(SPECTRA,OBS,UNIV,OPT)

%************
%Assign input
%************
FULL=SPECTRA.DISC.FULL;

OBS_MODE=OBS.MODE;

c=UNIV.c;

DFSS=OPT.DFSS;

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

%***********************************
%Assign min crossover peak/dip ratio
%***********************************
MIN_RATIO=DFSS.CROSS.MIN_RATIO;

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
    I_PK(1:NT_PK,1)=0;
    S_PK(1:NT_PK,1)=0;

    %**********************************
    %Calc. wavelength of crossover peak
    %**********************************
    X_PK=(XT_PK(1:NT_PK,1)+XT_PK(1:NT_PK,2))/2;
    
    %***************************************
    %Calc. differential crossover peak freq.
    %***************************************
    dNU=abs(c./XT_PK(1:NT_PK,1)-c./XT_PK(1:NT_PK,2))/1e9;

    %***************************
    %Assign min. intensity logic
    %***************************
    LOG1=IT_PK(1:NT_PK,1)>=IT_PK(1:NT_PK,2);
    LOG2=IT_PK(1:NT_PK,1)<IT_PK(1:NT_PK,2);

    %*********************
    %Assign min. intensity
    %*********************
    I_PK(LOG1)=IT_PK(LOG1,2);
    I_PK(LOG2)=IT_PK(LOG2,1);
    
    %********************************
    %Assign scaling of min. intensity
    %********************************
    S_PK(LOG1)=ST_PK(LOG1,2);
    S_PK(LOG2)=ST_PK(LOG2,1);

    %*********************************************
    %Assign logic for piecewise crossover equation
    %*********************************************
    LOG1=dNU<=1;
    LOG2=dNU>1&dNU<=14;
    LOG3=dNU>14&dNU<=23;
    LOG4=dNU>23;
    
    %****************************
    %Calc. crossover peak scaling
    %****************************
    S_PK(LOG1)=S_PK(LOG1).*(2*dNU(LOG1));
    S_PK(LOG2)=S_PK(LOG2).*(-0.13076*dNU(LOG2)+2.13076);
    S_PK(LOG3)=S_PK(LOG3).*(-0.03333*dNU(LOG3)+0.76662);
    S_PK(LOG4)=0;

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
    I_DIP(1:NT_DIP,1)=0;
    S_DIP(1:NT_DIP,1)=0;

    %**********************************
    %Calc. wavelength of crossover peak
    %**********************************
    X_DIP=(XT_DIP(1:NT_DIP,1)+XT_DIP(1:NT_DIP,2))/2;
    
    %***************************************
    %Calc. differential crossover peak freq.
    %***************************************
    dNU=abs(c./XT_DIP(1:NT_DIP,1)-c./XT_DIP(1:NT_DIP,2))/1e9;
   
    %***************************
    %Assign min. intensity logic
    %***************************
    LOG1=IT_DIP(1:NT_DIP,1)>=IT_DIP(1:NT_DIP,2);
    LOG2=IT_DIP(1:NT_DIP,1)<IT_DIP(1:NT_DIP,2);
    
    %*********************
    %Assign min. intensity
    %*********************
    I_DIP(LOG1)=IT_DIP(LOG1,2);
    I_DIP(LOG2)=IT_DIP(LOG2,1);
    
    %********************************
    %Assign scaling of min. intensity
    %********************************
    S_DIP(LOG1)=ST_DIP(LOG1,2);
    S_DIP(LOG2)=ST_DIP(LOG2,1);
    
    %*********************************************
    %Assign logic for piecewise crossover equation
    %*********************************************
    LOG1=dNU<=1;
    LOG2=dNU>1&dNU<=14;
    LOG3=dNU>14&dNU<=23;
    LOG4=dNU>23;
    
    %****************************
    %Calc. crossover peak scaling
    %****************************
    S_DIP(LOG1)=S_DIP(LOG1).*(2*dNU(LOG1));
    S_DIP(LOG2)=S_DIP(LOG2).*(-0.13076*dNU(LOG2)+2.13076);
    S_DIP(LOG3)=S_DIP(LOG3).*(-0.03333*dNU(LOG3)+0.76662);
    S_DIP(LOG4)=0;
    
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