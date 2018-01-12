function PSF_B=Fun_1b(PARA,DATA,PSF,OPT) 

%*******************
%Assigning the input
%*******************
PSN=PARA.FP.PSN;
PSNM=PARA.FP.PSNM;
PSL=PARA.FP.PSL;
NS=PARA.FP.NS;

PSB_INS=PARA.IP.PSB;

NSPF=PARA.NP.NSPF;

NH_X=PARA.NP.NH_X;
NH_Y=PARA.NP.NH_Y;
NH_Z=PARA.NP.NH_Z;

NU=PARA.GP.NU;

NB=DATA.BACK.NB;

ALGO=OPT.SOLVER.ALGO;
ALGO_OPT=OPT.SOLVER.ALGO_OPT;

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

if NH_MAX==0
    ERF_MAG(1,1:3)=0;
    ERF_ANG(1,1:3)=0;    
else
    ERF_MAG(1:NH_MAX,1:3)=0;
    ERF_ANG(1:NH_MAX,1:3)=0;
end

CHI_T(1:NB,1:NSPF)=Inf;
PSF_B(1:NS)=0;

for ii=1:NS
    for uu=1:NSPF
        %**********************************
        %Assign spectra specific parameters
        %**********************************
        PSV=PARA.FP.PSV{uu};

        NG=DATA.GRID{uu}.NG;

        XL=DATA.BROAD{uu}.XL;
        XU=DATA.BROAD{uu}.XU;

        IGB=DATA.BACK.IGB{uu};

        LINE=DATA.SPEC{uu}.LINE;
        MODEL_OPT=DATA.SPEC{uu}.MODEL_OPT;
   
        %****************************
        %Assigning observation angles
        %****************************
        if (PSN(1)<PSNM(1))
            kk=0;
            for jj=1:PSNM(1)
                if (PSL(jj)==0)
                    kk=kk+1;
                    VIEW(jj)=PSF(ii,kk);
                else
                    VIEW(jj)=PSV(jj);
                end
            end
        else
            VIEW(1:PSNM(1))=PSF(ii,1:PSN(1));
        end    

        %**********************
        %Assigning polarization
        %**********************
        if (PSN(2)<PSNM(2))
            kk=0;
            for jj=1:PSNM(2)
                if (PSL(PSNM(1)+jj)==0)
                    kk=kk+1;
                    POL(jj)=PSF(ii,PSN(1)+kk);
                else
                    POL(jj)=PSV(PSNM(1)+jj);
                end
            end
        else
            POL(1:PSNM(1))=PSF(ii,PSN(1)+1:sum(PSN(1:2)));
        end

        %*******************************
        %Assigning z-axis magnetic field
        %*******************************
        if (PSL(sum(PSNM(1:3)))==0)
            B_Z=PSF(ii,sum(PSN(1:3)));
        else
            B_Z=PSV(sum(PSNM(1:3)));
        end    

        %******************************************
        %Assigning x-axis electric field parameters
        %******************************************
        if (PSN(4)<PSNM(4))
            kk=0;
            for jj=1:PSNM(4)
                if (PSL(sum(PSNM(1:3))+jj)==0)
                    kk=kk+1;
                    EFP_X(jj)=PSF(ii,sum(PSN(1:3))+kk);
                else
                    EFP_X(jj)=PSV(sum(PSNM(1:3))+jj);
                end
            end
        else
            EFP_X(1:PSNM(4))=PSF(ii,sum(PSN(1:3))+1:sum(PSN(1:4)));
        end

        %******************************************
        %Assigning y-axis electric field parameters
        %******************************************
        if (PSN(5)<PSNM(5))
            kk=0;
            for jj=1:PSNM(5)
                if (PSL(sum(PSNM(1:4))+jj)==0)
                    kk=kk+1;
                    EFP_Y(jj)=PSF(ii,sum(PSN(1:4))+kk);
                else
                    EFP_Y(jj)=PSV(sum(PSNM(1:4))+jj);
                end
            end
        else
            EFP_Y(1:PSNM(5))=PSF(ii,sum(PSN(1:4))+1:sum(PSN(1:5)));
        end

        %******************************************
        %Assigning z-axis electric field parameters
        %******************************************
        if (PSN(6)<PSNM(6))
            kk=0;
            for jj=1:PSNM(6)
                if (PSL(sum(PSNM(1:5))+jj)==0)
                    kk=kk+1;
                    EFP_Z(jj)=PSF(ii,sum(PSN(1:5))+kk);
                else
                    EFP_Z(jj)=PSV(sum(PSNM(1:5))+jj);
                end
            end
        else
            EFP_Z(1:PSNM(6))=PSF(ii,sum(PSN(1:5))+1:sum(PSN(1:6)));
        end

        %**********************************************
        %Defining neutral temperature of Doppler groups
        %**********************************************
        if (PSN(7)<PSNM(7))
            kk=0;
            for jj=1:PSNM(7)
                if (PSL(sum(PSNM(1:6))+jj)==0)
                    kk=kk+1;
                    kT_DOP(jj)=PSF(ii,sum(PSN(1:6))+kk);
                else
                    kT_DOP(jj)=PSV(sum(PSNM(1:6))+jj);
                end
            end
        else
            kT_DOP(1:PSNM(7))=PSF(ii,sum(PSN(1:6))+1:sum(PSN(1:7)));
        end

        %*******************************************
        %Defining wavelength shift of Doppler groups
        %*******************************************
        if (PSN(8)<PSNM(8))
            kk=0;
            for jj=1:PSNM(8)
                if (PSL(sum(PSNM(1:7))+jj)==0)
                    kk=kk+1;
                    X_DOP(jj)=PSF(ii,sum(PSN(1:7))+kk);
                else
                    X_DOP(jj)=PSV(sum(PSNM(1:7))+jj);
                end
            end
        else
            X_DOP(1:PSNM(8))=PSF(ii,sum(PSN(1:7))+1:sum(PSN(1:8)));
        end

        %***********************************************
        %Defining relative intensities of Doppler groups
        %***********************************************
        if (PSN(9)<PSNM(9))
            kk=0;
            for jj=1:PSNM(9)
                if (PSL(sum(PSNM(1:8))+jj)==0)
                    kk=kk+1;
                    I_DOP(jj)=PSF(ii,sum(PSN(1:8))+kk);
                else
                    I_DOP(jj)=PSV(sum(PSNM(1:8))+jj);
                end
            end
        else
            I_DOP(1:PSNM(9))=PSF(ii,sum(PSN(1:8))+1:sum(PSN(1:9)));
        end  

        %**********************************
        %Defining broadening of Lorentzians
        %**********************************
        if (PSN(10)<PSNM(10))
            kk=0;
            for jj=1:PSNM(10)
                if (PSL(sum(PSNM(1:9))+jj)==0)
                    kk=kk+1;
                    GAM_LOR(jj)=PSF(ii,sum(PSN(1:9))+kk);
                else
                    GAM_LOR(jj)=PSV(sum(PSNM(1:9))+jj);
                end
            end
        elseif (PSNM(10)>0)
            GAM_LOR(1:PSNM(10))=PSF(ii,sum(PSN(1:9))+1:sum(PSN(1:10)));
        end

        %****************************************
        %Defining wavelength shift of Lorentzians
        %****************************************
        if (PSN(11)<PSNM(11))
            kk=0;
            for jj=1:PSNM(11)
                if (PSL(sum(PSNM(1:10))+jj)==0)
                    kk=kk+1;
                    X_LOR(jj)=PSF(ii,sum(PSN(1:10))+kk);
                else
                    X_LOR(jj)=PSV(sum(PSNM(1:10))+jj);
                end
            end
        elseif (PSNM(11)>0)
            X_LOR(1:PSNM(11))=PSF(ii,sum(PSN(1:10))+1:sum(PSN(1:11)));
        end

        %*******************************************
        %Defining relative intensities of Lorentians
        %*******************************************
        if (PSN(12)<PSNM(12))
            kk=0;
            for jj=1:PSNM(12)
                if (PSL(sum(PSNM(1:11))+jj)==0)
                    kk=kk+1;
                    I_LOR(jj)=PSF(ii,sum(PSN(1:11))+kk);
                else
                    I_LOR(jj)=PSV(sum(PSNM(1:11))+jj);
                end
            end
        elseif (PSNM(12)>0)
            I_LOR(1:PSNM(12))=PSF(ii,sum(PSN(1:11))+1:sum(PSN(1:12)));
        end    

        %**************************************
        %Defining background emission intensity
        %**************************************
        if (PSL(sum(PSNM(1:13)))==0)
            IB=PSF(ii,sum(PSN(1:13)));
        else
            IB=PSV(sum(PSNM(1:13)));
        end

        %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
        %|||||||||||||||    ASSIGN SPECTRAL MODEL VARIABLES    ||||||||||||||||
        %||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

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

        %************************
        %Calc. instrument profile
        %************************
        DATA=Gauss(X_DOP,kT_DOP,DATA,uu);

        %*******************************
        %Calc. the Lorentzian broadening
        %*******************************   
        if (PSNM(10)>0 && PSNM(11)>0)
            DATA=Lorentz(X_LOR,GAM_LOR,DATA,uu);
        end

        %**********************
        %Calc. the line profile
        %**********************        
        DATA=Cont_1(I_DOP,I_LOR,DATA,uu);

        for jj=1:NB
            %******************************
            %Add background to line profile
            %******************************        
            DATA=Cont_2(IGB(jj,1:NG),IB,DATA,uu);

            if ALGO(2)==1
                %************
                %Fit the data
                %************        
                [~,CHI_T(jj,uu)]=Full_Ins(PARA,DATA,uu);
            elseif ALGO(2)==2
                %*******************************************
                %Define external parameters for fit function
                %*******************************************
                FH_INS=@(PFS_INS)Red_Chi(DATA,PFS_INS,uu);

                %************
                %Fit the data
                %************
                [~,CHI_T(jj,uu)]=fmincon(FH_INS,[1,0],[],[],[],[],PSB_INS(1:2,1),PSB_INS(1:2,2),[],ALGO_OPT{2});
            end
        end         
    end
    
    %*******************************************
    %Assign the reduced chi and background index
    %*******************************************
    [~,PSF_B(ii)]=min(sum(CHI_T,2)); 
end
  

end