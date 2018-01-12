function [CHI,PSF,PSF_B_IND,LP]=Fun_2(PARA,DATA,OPT,JOB,NAP,PN,MODE)

NPD=80;

%***************
%Assigning input
%***************
PSI=PARA.FP.PSI;
PSN=PARA.FP.PSN;
PSNM=PARA.FP.PSNM;
PS=PARA.FP.PS;
PSL=PARA.FP.PSL;
ND=PARA.FP.ND;
NDP=PARA.FP.NDP;
NDS=PARA.FP.NDS;
NDPS=PARA.FP.NDPS;

NH_X=PARA.NP.NH_X;
NH_Y=PARA.NP.NH_Y;
NH_Z=PARA.NP.NH_Z;
NSPF=PARA.NP.NSPF;

NU=PARA.GP.NU;

if MODE==1
    NB=DATA.BACK.NB;
    
    PSB_INS=PARA.IP.PSB; 
    
    ALGO=OPT.SOLVER.ALGO(2);
    ALGO_OPT=OPT.SOLVER.ALGO_OPT{2};
end

NPSS=JOB.NPSS;
NPSSP=JOB.NPSSP;
NPSPP=JOB.NPSPP;
DIM_ST=JOB.DIM_ST;
BLOG=JOB.BLOG;

%************************************
%Limiting screen print discritization
%************************************
if NPD>NPSPP*NPSS
    NPD=NPSPP*NPSS;
end

%************************
%Max. number of harmonics
%************************
NH_MAX=max([NH_X,NH_Y,NH_Z]);

%*****************
%Allocating memory
%***************** 
VIEW(1:PSNM(1))=0;
POL(1:PSNM(2))=0;
EFP_X(1:PSNM(4))=0;
EFP_Y(1:PSNM(5))=0;
EFP_Z(1:PSNM(6))=0;
kT_DOP(1:PSNM(7))=0;
X_DOP(1:PSNM(8))=0;
I_DOP(1:PSNM(9))=0;
GAM_LOR(1:PSNM(10))=0;
X_LOR(1:PSNM(11))=0;
I_LOR(1:PSNM(12))=0; 
IB(1:PSNM(13))=0; 

if NH_MAX==0
    ERF_MAG(1,1:3)=0;
    ERF_ANG(1,1:3)=0;    
else
    ERF_MAG(1:NH_MAX,1:3)=0;
    ERF_ANG(1:NH_MAX,1:3)=0;
end

if MODE==1
    CHI_S_PAR(1:NB)=0;
    CHI_S(1:NB,1:NPSPP*NPSS,1:NSPF)=Inf; 
    CHI_T(1:NB,1:NPSPP*NPSS)=Inf; 
    LP=[]; 
elseif MODE==2
    CHI=[];
    PSF_B_IND=[]; 
    
    LP=cell(1,NSPF);
    for ii=1:NSPF
        NG=DATA.GRID{ii}.NG;
        
        LP(ii)={zeros(NPSPP*NPSS,NG)};
    end
end

for uu=1:NSPF
    %**********************************
    %Assign spectra specific parameters
    %**********************************
    PSV=PARA.FP.PSV{uu};
    
    XL=DATA.BROAD{uu}.XL;
    XU=DATA.BROAD{uu}.XU;

    NG=DATA.GRID{uu}.NG;
        
    LINE=DATA.SPEC{uu}.LINE;
    MODEL_OPT=DATA.SPEC{uu}.MODEL_OPT;
    
    if MODE==1
        IGB_CON=DATA.BACK.IGB_CON{uu};
        IGB_VAR=DATA.BACK.IGB_VAR{uu};
    end
    
    %***************
    %Allocate memory
    %***************
    DIM(1:ND)=0;
    PSF(1:NPSPP*NPSS,1:ND)=0;
    
    %*********************************
    %Initialize parallel fit variables
    %*********************************
    for ii=1:NDP
        jj=PSI(ii);
        DIM(jj)=DIM_ST(jj);
        PSF(1,jj)=PS(jj,DIM(jj));
    end

    %*******************************
    %Initialize serial fit variables
    %*******************************
    for ii=1:length(NDS)
        for jj=1:NDS(ii)
            kk=PSI(jj+sum(NDS(1:ii-1))+NDP);
            DIM(kk)=1;
            PSF(1,kk)=PS(kk,DIM(kk));
        end    
    end

    %************************
    %Initialize print indices
    %************************
    IND_P1=1;
    IND_P2=0;
    
    %*************************
    %Initialized storage index
    %*************************
    IND=1;

    %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    %||||||||||||||||||||||    LEVEL 1 PARALLEL CALC    |||||||||||||||||||||||
    %|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| 

    for ii=1:NPSPP   
        %****************************
        %Assigning observation angles
        %****************************
        if PSN(1)<PSNM(1)
            kk=0;
            for jj=1:PSNM(1)
                if PSL(jj)==0
                    kk=kk+1;
                    VIEW(jj)=PSF(IND,kk);
                else
                    VIEW(jj)=PSV(jj);
                end
            end
        else
            VIEW(1:PSNM(1))=PSF(IND,1:PSN(1));
        end

        %**********************
        %Assigning polarization
        %**********************
        if PSN(2)<PSNM(2)
            kk=0;
            for jj=1:PSNM(2)
                if PSL(PSNM(1)+jj)==0
                    kk=kk+1;
                    POL(jj)=PSF(IND,PSN(1)+kk);
                else
                    POL(jj)=PSV(PSNM(1)+jj);
                end
            end
        else
            POL(1:PSNM(1))=PSF(IND,PSN(1)+1:sum(PSN(1:2)));
        end

        %*******************************
        %Assigning z-axis magnetic field
        %*******************************
        if PSL(sum(PSNM(1:3)))==0
            B_Z=PSF(IND,sum(PSN(1:3)));
        else
            B_Z=PSV(sum(PSNM(1:3)));
        end    

        %******************************************
        %Assigning x-axis electric field parameters
        %******************************************
        if PSN(4)<PSNM(4)
            kk=0;
            for jj=1:PSNM(4)
                if PSL(sum(PSNM(1:3))+jj)==0
                    kk=kk+1;
                    EFP_X(jj)=PSF(IND,sum(PSN(1:3))+kk);
                else
                    EFP_X(jj)=PSV(sum(PSNM(1:3))+jj);
                end
            end
        else
            EFP_X(1:PSNM(4))=PSF(IND,sum(PSN(1:3))+1:sum(PSN(1:4)));
        end

        %******************************************
        %Assigning y-axis electric field parameters
        %******************************************
        if PSN(5)<PSNM(5)
            kk=0;
            for jj=1:PSNM(5)
                if PSL(sum(PSNM(1:4))+jj)==0
                    kk=kk+1;
                    EFP_Y(jj)=PSF(IND,sum(PSN(1:4))+kk);
                else
                    EFP_Y(jj)=PSV(sum(PSNM(1:4))+jj);
                end
            end
        else
            EFP_Y(1:PSNM(5))=PSF(IND,sum(PSN(1:4))+1:sum(PSN(1:5)));
        end

        %******************************************
        %Assigning z-axis electric field parameters
        %******************************************
        if PSN(6)<PSNM(6)
            kk=0;
            for jj=1:PSNM(6)
                if PSL(sum(PSNM(1:5))+jj)==0
                    kk=kk+1;
                    EFP_Z(jj)=PSF(IND,sum(PSN(1:5))+kk);
                else
                    EFP_Z(jj)=PSV(sum(PSNM(1:5))+jj);
                end
            end
        else
            EFP_Z(1:PSNM(6))=PSF(IND,sum(PSN(1:5))+1:sum(PSN(1:6)));
        end

    %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    %|||||||||||||||||    ASSIGN SPECTRAL MODEL VARIABLES    ||||||||||||||||||
    %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

        %**************
        %Magnetic field
        %**************
        B_MAG=B_Z;

        %*********************
        %Static electric field
        %*********************
        EDC_MAG=[EFP_X(1),EFP_Y(1),EFP_Z(1)];

        %*********************************
        %Dynamic electric field magnitudes
        %*********************************
        ERF_MAG(1:NH_X,1)=EFP_X(2:NH_X+1);
        ERF_MAG(1:NH_Y,2)=EFP_Y(2:NH_Y+1);
        ERF_MAG(1:NH_Z,3)=EFP_Z(2:NH_Z+1);

        %****************************
        %Dynamic electric field phase
        %****************************    
        ERF_ANG(1:NH_X,1)=EFP_X(NH_X+2:2*NH_X+1);
        ERF_ANG(1:NH_Y,2)=EFP_Y(NH_Y+2:2*NH_Y+1);
        ERF_ANG(1:NH_Z,3)=EFP_Z(NH_Z+2:2*NH_Z+1);

        %***********************
        %Assigning VAR structure
        %***********************
        MODEL_VAR.LINE=LINE;
        MODEL_VAR.VIEW=VIEW;
        MODEL_VAR.POL=[1,POL];    
        MODEL_VAR.B_MAG=B_MAG;
        MODEL_VAR.EDC_MAG=EDC_MAG*1e5;
        MODEL_VAR.ERF_MAG=ERF_MAG*1e5;
        MODEL_VAR.ERF_ANG=ERF_ANG;
        MODEL_VAR.NU=NU;    

    %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    %|||||||||||||||||||||||    CALL SPECTRAL MODEL    ||||||||||||||||||||||||
    %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||    

        %***********************
        %Calc. discrete spectrum
        %***********************
        [MODEL,~]=EZSSS(MODEL_VAR,MODEL_OPT,1);

        %******************************
        %Select transitions of interest
        %******************************
        if strcmpi(LINE.ATOM,'HeI')==1 || strcmpi(LINE.ATOM,'ArII')==1
            DATA.TRAN{uu}.IT=MODEL.DISC.I(MODEL.DISC.X*1e10>XL&MODEL.DISC.X*1e10<XU);
            DATA.TRAN{uu}.XT=MODEL.DISC.X(MODEL.DISC.X*1e10>XL&MODEL.DISC.X*1e10<XU)*1e10;
            DATA.TRAN{uu}.NT=length(MODEL.DISC.X(MODEL.DISC.X*1e10>XL&MODEL.DISC.X*1e10<XU));
        else
            DATA.TRAN{uu}.IT=MODEL.DISC.I;
            DATA.TRAN{uu}.XT=MODEL.DISC.X*1e10;
            DATA.TRAN{uu}.NT=MODEL.DISC.NT;        
        end

    %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    %|||||||||||||||||||||||    LEVEL 1 SERIAL CALC    ||||||||||||||||||||||||
    %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||     

        for jj=1:NPSSP(1)
            %**********************************************
            %Defining neutral temperature of Doppler groups
            %**********************************************
            if PSN(7)<PSNM(7)
                ll=0;
                for kk=1:PSNM(7)
                    if PSL(sum(PSNM(1:6))+kk)==0
                        ll=ll+1;
                        kT_DOP(kk)=PSF(IND,sum(PSN(1:6))+ll);
                    else
                        kT_DOP(kk)=PSV(sum(PSNM(1:6))+kk);
                    end
                end
            else
                kT_DOP(1:PSNM(7))=PSF(IND,sum(PSN(1:6))+1:sum(PSN(1:7)));
            end

            %*******************************************
            %Defining wavelength shift of Doppler groups
            %*******************************************
            if PSN(8)<PSNM(8)
                ll=0;
                for kk=1:PSNM(8)
                    if PSL(sum(PSNM(1:7))+kk)==0
                        ll=ll+1;
                        X_DOP(kk)=PSF(IND,sum(PSN(1:7))+ll);
                    else
                        X_DOP(kk)=PSV(sum(PSNM(1:7))+kk);
                    end
                end
            else
                X_DOP(1:PSNM(8))=PSF(IND,sum(PSN(1:7))+1:sum(PSN(1:8)));
            end

            %**********************************
            %Defining broadening of Lorentzians
            %**********************************
            if PSN(10)<PSNM(10)
                ll=0;
                for kk=1:PSNM(10)
                    if PSL(sum(PSNM(1:9))+kk)==0
                        ll=ll+1;
                        GAM_LOR(kk)=PSF(IND,sum(PSN(1:9))+ll);
                    else
                        GAM_LOR(kk)=PSV(sum(PSNM(1:9))+kk);
                    end
                end
            elseif (PSNM(10)>0)
                GAM_LOR(1:PSNM(10))=PSF(IND,sum(PSN(1:9))+1:sum(PSN(1:10)));
            end

            %****************************************
            %Defining wavelength shift of Lorentzians
            %****************************************
            if PSN(11)<PSNM(11)
                ll=0;
                for kk=1:PSNM(11)
                    if PSL(sum(PSNM(1:10))+kk)==0
                        ll=ll+1;
                        X_LOR(kk)=PSF(IND,sum(PSN(1:10))+ll);
                    else
                        X_LOR(kk)=PSV(sum(PSNM(1:10))+kk);
                    end
                end
            elseif (PSNM(11)>0)
                X_LOR(1:PSNM(11))=PSF(IND,sum(PSN(1:10))+1:sum(PSN(1:11)));
            end

            %*****************************
            %Calc. the Gaussian broadening
            %*****************************
            DATA=Gauss(X_DOP,kT_DOP,DATA,uu);

            %*******************************
            %Calc. the Lorentzian broadening
            %*******************************   
            if PSNM(10)>0 && PSNM(11)>0
                DATA=Lorentz(X_LOR,GAM_LOR,DATA,uu);
            end

    %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    %|||||||||||||||||||||||    LEVEL 2 SERIAL CALC    ||||||||||||||||||||||||
    %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||         

            for kk=1:NPSSP(2)
                if PN==NAP && IND==IND_P1
                    %********************
                    %Update print indices
                    %********************
                    IND_P2=IND_P2+1;
                    IND_P1=round(IND_P2*NPSPP*NPSS/NPD);
                    if (IND==IND_P1)
                        IND_P1=IND_P1+1;
                    end

                    %************************
                    %Print progress to screen
                    %************************
                    if (IND_P2<=NPD)
                       Print_Prog(IND_P2,NPD)
                    end
                end            

                %***********************************************
                %Defining relative intensities of Doppler groups
                %***********************************************
                if PSN(9)<PSNM(9)
                    mm=0;
                    for ll=1:PSNM(9)
                        if PSL(sum(PSNM(1:8))+ll)==0
                            mm=mm+1;
                            I_DOP(ll)=PSF(IND,sum(PSN(1:8))+mm);
                        else
                            I_DOP(ll)=PSV(sum(PSNM(1:8))+ll);
                        end
                    end
                else
                    I_DOP(1:PSNM(9))=PSF(IND,sum(PSN(1:8))+1:sum(PSN(1:9)));
                end 

                %*******************************************
                %Defining relative intensities of Lorentians
                %*******************************************
                if PSN(12)<PSNM(12)
                    mm=0;
                    for ll=1:PSNM(12)
                        if PSL(sum(PSNM(1:11))+ll)==0
                            mm=mm+1;
                            I_LOR(ll)=PSF(IND,sum(PSN(1:11))+mm);
                        else
                            I_LOR(ll)=PSV(sum(PSNM(1:11))+ll);
                        end
                    end
                elseif (PSNM(12)>0)
                    I_LOR(1:PSNM(12))=PSF(IND,sum(PSN(1:11))+1:sum(PSN(1:12)));
                end

                %**********************
                %Calc. the line profile
                %**********************        
                DATA=Cont_1(I_DOP,I_LOR,DATA,uu);           

                %**************************************
                %Defining background emission intensity
                %**************************************
                if PSN(13)<PSNM(13)
                    mm=0;
                    for ll=1:PSNM(13)
                        if PSL(sum(PSNM(1:12))+ll)==0
                            mm=mm+1;
                            IB(ll)=PSF(IND,sum(PSN(1:12))+mm);
                        else
                            IB(ll)=PSV(sum(PSNM(1:12))+ll);
                        end
                    end
                elseif (PSNM(13)>0)
                    IB(1:PSNM(13))=PSF(IND,sum(PSN(1:12))+1:sum(PSN(1:13)));
                end

                if MODE==1

    %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    %||||||||||||||||||||||||    FIT THE SPECTRA     ||||||||||||||||||||||||||
    %|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| 
    
                    %***************************************
                    %Add constant background to line profile
                    %***************************************
                    DATA=Cont_2(IGB_CON(1,1:NG),IB(1),DATA,uu);        
                    
                    if BLOG==0
                        for ll=1:NB
                            %******************************
                            %Add background to line profile
                            %******************************
                            DATA=Cont_2(IGB_VAR(ll,1:NG),IB(2),DATA,uu);

                            if ALGO==1
                                %************
                                %Fit the data
                                %************
                                [~,CHI_S(ll,IND,uu)]=Full_Ins(PARA,DATA,uu);
                            elseif ALGO==2
                                %*******************************************
                                %Define external parameters for fit function
                                %*******************************************
                                FH_INS=@(PFS_INS)Red_Chi(DATA,PFS_INS,uu);

                                %************
                                %Fit the data
                                %************
                                [~,CHI_S(ll,IND,uu)]=fmincon(FH_INS,[1,0],[],[],[],[],PSB_INS(1:2,1),PSB_INS(1:2,2),[],ALGO_OPT);
                            end
                        end
                    else
                        parfor ll=1:NB
                            %******************************
                            %Add background to line profile
                            %******************************
                            DATA_PAR=Cont_2(IGB_VAR(ll,1:NG),IB(2),DATA,uu);

                            if ALGO==1
                                %************
                                %Fit the data
                                %************
                                [~,CHI_S_PAR(ll)]=Full_Ins(PARA,DATA_PAR,uu);
                            elseif ALGO==2
                                %*******************************************
                                %Define external parameters for fit function
                                %*******************************************
                                FH_INS=@(PFS_INS)Red_Chi(DATA_PAR,PFS_INS,uu);

                                %************
                                %Fit the data
                                %************
                                [~,CHI_S_PAR(ll)]=fmincon(FH_INS,[1,0],[],[],[],[],PSB_INS(1:2,1),PSB_INS(1:2,2),[],ALGO_OPT);
                            end
                        end
                        
                        %*******************************
                        %Assign parallel processing data
                        %*******************************
                        CHI_S(1:NB,IND,uu)=CHI_S_PAR(1:NB);
                    end

                elseif MODE==2

    %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    %|||||||||||||||||||||||||    ASSIGN SPECTRUM    ||||||||||||||||||||||||||
    %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||                          

                    %***********************
                    %Assign the line profile
                    %***********************
                    LP{uu}(IND,1:NG)=DATA.GRID{uu}.IG(1:NG);
                    
                end

                if ii~=NPSPP || jj~=NPSSP(1) || kk~=NPSSP(2)
                    %******************
                    %Copy fit variables
                    %******************
                    PSF(IND+1,1:ND)=PSF(IND,1:ND);

                    %******************
                    %Update dummy index
                    %******************    
                    IND=IND+1;

                    %***************************
                    %Update serial fit variables
                    %***************************    
                    for ll=NDS(2):-1:1
                        mm=PSI(ll+NDS(1)+NDP);
                        if (DIM(mm)+1<=NDPS(mm))
                            DIM(mm)=DIM(mm)+1;
                            PSF(IND,mm)=PS(mm,DIM(mm));
                            break
                        else
                            DIM(mm)=1;
                            PSF(IND,mm)=PS(mm,DIM(mm));           
                        end
                    end 
                end 
            end

            if ii~=NPSPP || jj~=NPSSP(1)
                %***************************
                %Update serial fit variables
                %***************************    
                for kk=NDS(1):-1:1
                    ll=PSI(kk+NDP);
                    if (DIM(ll)+1<=NDPS(ll))
                        DIM(ll)=DIM(ll)+1;
                        PSF(IND,ll)=PS(ll,DIM(ll));
                        break
                    else
                        DIM(ll)=1;
                        PSF(IND,ll)=PS(ll,DIM(ll));           
                    end
                end 
            end
        end

        if ii~=NPSPP
            %******************************
            %Update parallel fit parameters
            %******************************    
            for jj=NDP:-1:1
                kk=PSI(jj);
                if (DIM(kk)+1<=NDPS(kk))
                    DIM(kk)=DIM(kk)+1;
                    PSF(IND,kk)=PS(kk,DIM(kk));
                    break
                else
                    DIM(kk)=1;
                    PSF(IND,kk)=PS(kk,DIM(kk));         
                end
            end  
        end
    end  
end

if MODE==1
    %************************
    %Sum chi over all spectra
    %************************
    CHI_T(1:NB,1:NPSPP*NPSS)=sum(CHI_S,3);

    %*******************************************
    %Assign the reduced chi and background index
    %*******************************************  
    if NB>1
        [CHI(1:NPSPP*NPSS),PSF_B_IND(1:NPSPP*NPSS)]=min(CHI_T(1:NB,1:NPSPP*NPSS));
    else
        CHI(1:NPSPP*NPSS)=CHI_T(1,1:NPSPP*NPSS);
        PSF_B_IND(1:NPSPP*NPSS)=1;
    end
end

end