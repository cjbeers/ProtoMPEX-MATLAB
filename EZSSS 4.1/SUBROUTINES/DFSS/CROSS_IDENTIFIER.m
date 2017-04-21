function SPECTRA=CROSS_IDENTIFIER(SPECTRA,PARA,OPT)

%************
%Assign input
%************
DISC=SPECTRA.DISC;

DFSS=OPT.DFSS;

%******************************
%Assign crossover peak/dip sign
%******************************
if strcmpi(DFSS.CROSS.PEAK,'0')==1
    LOG_PK=0;
else
    LOG_PK=1;
end

if strcmpi(DFSS.CROSS.DIP,'0')==1
    LOG_DIP=0;
else
    LOG_DIP=1;
end

%*********************************************
%Assign discrete spectra and state information
%*********************************************
X=DISC.FULL.X;
I=DISC.FULL.I;
NT=DISC.FULL.NT;
NT_QSA=DISC.FULL.NT_QSA;

if DFSS.SCALE.LOGIC==1
    S=DISC.FULL.S;
else
    S(1:NT)=1;
end

LL=DISC.FULL.STATE.LL;
UL=DISC.FULL.STATE.UL;

%*****************************************
%Assign number quasistatic discretizations
%*****************************************
ND=PARA.ND;

%************************
%Assign transition indice
%************************
NT_QSA_MAX=max(NT_QSA(1:ND,2)-NT_QSA(1:ND,1))+1;
INDICE=1:1:NT_QSA_MAX;

%***********************************
%Assign number of magnetic substates
%***********************************
NS_LL=PARA.NS(1);
NS_UL=PARA.NS(2);

%*****************************************
%Assign max number of crossover peaks/dips
%*****************************************
NT_LL_MAX=NS_LL*NT*ND;
NT_UL_MAX=NS_UL*NT*ND;

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||||||||| CALC CROSSOVER PEAKS |||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

if LOG_PK==1

    %***************
    %Allocate memory
    %***************
    XT_PK(1:NT_LL_MAX,1:2)=0;
    IT_PK(1:NT_LL_MAX,1:2)=0;
    ST_PK(1:NT_LL_MAX,1:2)=0;

    QSAN_PK(1:NT_LL_MAX)=0;
    LL_PK(1:NT_LL_MAX)=0;
    UL_PK(1:NT_LL_MAX,1:2)=0;
    IND_PK(1:NT_LL_MAX,1:2)=0;

    kk=0;
    for ii=1:NS_LL
        for jj=1:ND
            %*********************************************
            %Assign transition indices for the current QSA
            %*********************************************
            IND1=NT_QSA(jj,1);
            IND2=NT_QSA(jj,2);

            %********************************************
            %Assign number of transitions for current QSA
            %********************************************
            IND3=IND2-IND1+1;

            %************
            %Assign logic
            %************
            LOG=LL(IND1:IND2)==ii;

            %*****************************************************
            %Calc. number of transitions with the same LL and QSAN
            %*****************************************************
            N1=sum(LOG);

            %*********************************************************
            %Initiate indice number of crossover peaks per LL and QSAN
            %*********************************************************
            nn=0;

            if N1>0
                %***********************
                %Assign current QSA data
                %***********************
                T1=X(IND1:IND2);
                T2=I(IND1:IND2);
                T3=S(IND1:IND2);
                T4=UL(IND1:IND2);
                T5=INDICE(1:IND3);

                %***********
                %Assign data
                %***********
                T1=T1(LOG);
                T2=T2(LOG);
                T3=T3(LOG);
                T4=T4(LOG);
                T5=T5(LOG);

                for ll=1:N1
                    for mm=ll+1:N1
                        %*********************************
                        %Advance indice for crossover peak
                        %*********************************
                        kk=kk+1;

                        %********************************************************
                        %Advance indice number of crossover peaks per LL and QSAN
                        %********************************************************
                        nn=nn+1;

                        %********************************
                        %Assign crossover peak parameters
                        %********************************
                        XT_PK(kk,1:2)=[T1(ll) T1(mm)];
                        IT_PK(kk,1:2)=[T2(ll)/T3(ll) T2(mm)/T3(mm)];
                        ST_PK(kk,1:2)=[T3(ll) T3(mm)];

                        %**************************************
                        %Assign crossover peak state parameters
                        %**************************************
                        QSAN_PK(kk)=jj;
                        LL_PK(kk)=ii;
                        UL_PK(kk,1:2)=[T4(ll),T4(mm)];
                        IND_PK(kk,1:2)=[T5(ll),T5(mm)];
                    end
                end
            end
        end
    end
    NT_PK=kk;      

    %***************
    %Truncate arrays
    %***************
    XT_PK=XT_PK(1:NT_PK,1:2);
    IT_PK=IT_PK(1:NT_PK,1:2);
    ST_PK=ST_PK(1:NT_PK,1:2);

    QSAN_PK=QSAN_PK(1:NT_PK);
    LL_PK=LL_PK(1:NT_PK);
    UL_PK=UL_PK(1:NT_PK,1:2);
    IND_PK=IND_PK(1:NT_PK,1:2);

    %*******************************
    %Assign crossover peak structure
    %*******************************
    PEAK.XT=XT_PK;
    PEAK.IT=IT_PK;
    PEAK.ST=ST_PK;
    PEAK.NT=NT_PK;

    PEAK.STATE.QSAN=QSAN_PK;
    PEAK.STATE.LL=LL_PK;
    PEAK.STATE.UL=UL_PK;
    PEAK.STATE.IND=IND_PK;
    
    %*************
    %Assign output
    %*************
    DISC.FULL.PEAK=PEAK;

end

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||||  CALC CROSSOVER DIPS |||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

if LOG_DIP==1

    %***************
    %Allocate memory
    %***************
    XT_DIP(1:NT_UL_MAX,1:2)=0;
    IT_DIP(1:NT_UL_MAX,1:2)=0;
    ST_DIP(1:NT_UL_MAX,1:2)=0;

    QSAN_DIP(1:NT_UL_MAX)=0;
    LL_DIP(1:NT_UL_MAX,1:2)=0;
    UL_DIP(1:NT_UL_MAX)=0;
    IND_DIP(1:NT_UL_MAX,1:2)=0;

    kk=0;
    for ii=1:NS_UL
        for jj=1:ND
            %*********************************************
            %Assign transition indices for the current QSA
            %*********************************************
            IND1=NT_QSA(jj,1);
            IND2=NT_QSA(jj,2);

            %********************************************
            %Assign number of transitions for current QSA
            %********************************************
            IND3=IND2-IND1+1;

            %************
            %Assign logic
            %************
            LOG=UL(IND1:IND2)==ii;

            %*****************************************************
            %Calc. number of transitions with the same UL and QSAN
            %*****************************************************
            N1=sum(LOG);

            %*********************************************************
            %Initiate indice number of crossover peaks per UL and QSAN
            %*********************************************************
            nn=0;

            if N1>0
                %***********************
                %Assign current QSA data
                %***********************
                T1=X(IND1:IND2);
                T2=I(IND1:IND2);
                T3=S(IND1:IND2);
                T4=LL(IND1:IND2);
                T5=INDICE(1:IND3);

                %***********
                %Assign data
                %***********
                T1=T1(LOG);
                T2=T2(LOG);
                T3=T3(LOG);
                T4=T4(LOG);
                T5=T5(LOG);

                for ll=1:N1
                    for mm=ll+1:N1
                        %********************************
                        %Advance indice for crossover dip
                        %********************************
                        kk=kk+1;

                        %*******************************************************
                        %Advance indice number of crossover dips per LL and QSAN
                        %*******************************************************
                        nn=nn+1;

                        %*******************************
                        %Assign crossover dip parameters
                        %*******************************
                        XT_DIP(kk,1:2)=[T1(ll) T1(mm)];
                        IT_DIP(kk,1:2)=[T2(ll)/T3(ll) T2(mm)/T3(mm)];
                        ST_DIP(kk,1:2)=[T3(ll) T3(mm)];

                        %*************************************
                        %Assign crossover dip state parameters
                        %*************************************
                        QSAN_DIP(kk)=jj;
                        LL_DIP(kk,1:2)=[T4(ll),T4(mm)];
                        UL_DIP(kk)=ii;
                        IND_DIP(kk,1:2)=[T5(ll),T5(mm)];
                    end
                end
            end
        end
    end
    NT_DIP=kk;      

    %***************
    %Truncate arrays
    %***************
    XT_DIP=XT_DIP(1:NT_DIP,1:2);
    IT_DIP=IT_DIP(1:NT_DIP,1:2);
    ST_DIP=ST_DIP(1:NT_DIP,1:2);

    QSAN_DIP=QSAN_DIP(1:NT_DIP);
    LL_DIP=LL_DIP(1:NT_DIP,1:2);
    UL_DIP=UL_DIP(1:NT_DIP);
    IND_DIP=IND_DIP(1:NT_DIP,1:2);

    %******************************
    %Assign crossover dip structure
    %******************************
    DIP.XT=XT_DIP;
    DIP.IT=IT_DIP;
    DIP.ST=ST_DIP;
    DIP.NT=NT_DIP;

    DIP.STATE.QSAN=QSAN_DIP;
    DIP.STATE.LL=LL_DIP;
    DIP.STATE.UL=UL_DIP;
    DIP.STATE.IND=IND_DIP;
    
    %*************
    %Assign output
    %*************
    DISC.FULL.DIP=DIP;
    
end

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%*************
%Assign output
%*************
SPECTRA.DISC=DISC;

end