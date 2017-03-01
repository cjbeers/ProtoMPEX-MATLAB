function DATA=Mod_Bound(DATA,PARA)

NSIG=4;
NGAM=8;

%************
%Assign input
%************
UNIV=DATA.UNIV;

FP=PARA.FP;
NP=PARA.NP;

PSNM=FP.PSNM;
PSN=FP.PSN;
PSL=FP.PSL;
PSB=FP.PSB;
    
NFL=NP.NFL;
NSPF=NP.NSPF;

for uu=1:NSPF
    %**********************************
    %Assign spectra specific parameters
    %**********************************   
    EXP=DATA.EXP{uu};
    BROAD=DATA.BROAD{uu};
    INS=DATA.INS{uu};

    PSV=FP.PSV{uu};
    
    %************************
    %Assign the radiator mass
    %************************
    M=UNIV.m(uu);
    
    %************************
    %Assign experimental data
    %************************
    NE=EXP.NE;
    XE=EXP.XE;
    XC=EXP.XC;
    
    %****************************************
    %Select max instrument dopppler parameter
    %****************************************
    SIG_INS_MAX=max(INS{4}(1:INS{1}));

    %***************************
    %Select max main temperature
    %***************************
    jj=0;
    KT_MAX(1:PSNM(7))=0;
    for ii=1:PSNM(7)
        if (PSL(sum(PSNM(1:6))+ii)==0)
            jj=jj+1;
            KT_MAX(ii)=max(PSB(sum(PSN(1:6))+jj,1:2));
        else
            KT_MAX(ii)=PSV(sum(PSNM(1:6))+ii);
        end
    end
    KT_MAX=min(KT_MAX);

    %*************************************
    %Select min and max main Doppler shift
    %*************************************
    jj=0;
    X_MIN(1:PSNM(8))=0;
    X_MAX(1:PSNM(8))=0;
    for ii=1:PSNM(8)
        if (PSL(sum(PSNM(1:7))+ii)==0)
            jj=jj+1;
            X_MIN(ii)=min(PSB(sum(PSN(1:7))+jj,1:2));
            X_MAX(ii)=max(PSB(sum(PSN(1:7))+jj,1:2));
        else
            X_MIN(ii)=PSV(sum(PSNM(1:7))+ii);
            X_MAX(ii)=PSV(sum(PSNM(1:7))+ii);
        end
    end
    X_MIN=min(X_MIN);
    X_MAX=min(X_MAX);

    %***********************************************
    %Select max main Lorentizan boardening parameter
    %***********************************************
    if (NFL>0)
        jj=0;
        GAM_MAX(1:PSNM(10))=0;
        for ii=1:PSNM(10)
            if (PSL(sum(PSNM(1:9))+ii)==0)
                jj=jj+1;
                GAM_MAX(ii)=max(PSB(sum(PSN(1:9))+jj,1:2));
            else
                GAM_MAX(ii)=PSV(sum(PSNM(1:9))+ii);
            end
        end
        GAM_MAX=min(GAM_MAX);
    else
        GAM_MAX=0;
    end

    %**********************************
    %Calc. doppler broadening parameter
    %**********************************
    SIG_DOP_MAX=Doppler(KT_MAX,XC,M,UNIV);

    %***************************************
    %Calc. max Gaussian broadening parameter
    %***************************************
    SIG_MAX=(SIG_INS_MAX^2+SIG_DOP_MAX^2)^.5;

    %**********************************
    %Assign lower and uppper boundaries
    %**********************************
    XL=min(XE(1:NE))+X_MIN-NSIG*SIG_MAX-NGAM*GAM_MAX;
    XU=max(XE(1:NE))+X_MAX+NSIG*SIG_MAX+NGAM*GAM_MAX;

    %**********************
    %Update BROAD structure
    %**********************
    BROAD.XL=XL;
    BROAD.XU=XU;

    %*********************
    %Update DATA sturcture
    %*********************
    DATA.BROAD{uu}=BROAD;
end

end