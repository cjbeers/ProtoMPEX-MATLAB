function FIT=Var_Back_Fit(PARA,PARA_BACK_CON,PARA_BACK_VAR,FIT,BGN) 

if BGN==1
    PARA_BACK=PARA_BACK_CON;
elseif BGN==2
    PARA_BACK=PARA_BACK_VAR; 
end

%*******************
%Assigning the input
%*******************
NS=PARA.FP.NS;
NI=PARA.FP.NI;

PSN=PARA_BACK.FP.PSN;
PSNM=PARA_BACK.FP.PSNM;
PSL=PARA_BACK.FP.PSL;
NV=PARA_BACK.NP.NV;
NSPF=PARA_BACK.NP.NSPF;

PSF_B=FIT.MIN.PSF_B{NI};

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

VAR(1:NS,1:NV)=0;

for uu=1:NSPF    
    %**********************************
    %Assign spectra specific parameters
    %**********************************
    PSV=PARA_BACK.FP.PSV{uu};

    for ii=1:NS
        %****************************
        %Assigning observation angles
        %****************************
        if (PSN(1)<PSNM(1))
            kk=0;
            for jj=1:PSNM(1)
                if (PSL(jj)==0)
                    kk=kk+1;
                    VIEW(jj)=PSF_B(ii,kk);
                else
                    VIEW(jj)=PSV(jj);
                end
            end
        else
            VIEW(1:PSNM(1))=PSF_B(ii,1:PSN(1));
        end    

        %**********************
        %Assigning polarization
        %**********************
        if (PSN(2)<PSNM(2))
            kk=0;
            for jj=1:PSNM(2)
                if (PSL(PSNM(1)+jj)==0)
                    kk=kk+1;
                    POL(jj)=PSF_B(ii,PSN(1)+kk);
                else
                    POL(jj)=PSV(PSNM(1)+jj);
                end
            end
        else
            POL(1:PSNM(1))=PSF_B(ii,PSN(1)+1:sum(PSN(1:2)));
        end

        %*******************************
        %Assigning z-axis magnetic field
        %*******************************
        if (PSL(sum(PSNM(1:3)))==0)
            B_Z=PSF_B(ii,sum(PSN(1:3)));
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
                    EFP_X(jj)=PSF_B(ii,sum(PSN(1:3))+kk);
                else
                    EFP_X(jj)=PSV(sum(PSNM(1:3))+jj);
                end
            end
        else
            EFP_X(1:PSNM(4))=PSF_B(ii,sum(PSN(1:3))+1:sum(PSN(1:4)));
        end

        %******************************************
        %Assigning y-axis electric field parameters
        %******************************************
        if (PSN(5)<PSNM(5))
            kk=0;
            for jj=1:PSNM(5)
                if (PSL(sum(PSNM(1:4))+jj)==0)
                    kk=kk+1;
                    EFP_Y(jj)=PSF_B(ii,sum(PSN(1:4))+kk);
                else
                    EFP_Y(jj)=PSV(sum(PSNM(1:4))+jj);
                end
            end
        else
            EFP_Y(1:PSNM(5))=PSF_B(ii,sum(PSN(1:4))+1:sum(PSN(1:5)));
        end

        %******************************************
        %Assigning z-axis electric field parameters
        %******************************************
        if (PSN(6)<PSNM(6))
            kk=0;
            for jj=1:PSNM(6)
                if (PSL(sum(PSNM(1:5))+jj)==0)
                    kk=kk+1;
                    EFP_Z(jj)=PSF_B(ii,sum(PSN(1:5))+kk);
                else
                    EFP_Z(jj)=PSV(sum(PSNM(1:5))+jj);
                end
            end
        else
            EFP_Z(1:PSNM(6))=PSF_B(ii,sum(PSN(1:5))+1:sum(PSN(1:6)));
        end

        %**********************************************
        %Defining neutral temperature of Doppler groups
        %**********************************************
        if (PSN(7)<PSNM(7))
            kk=0;
            for jj=1:PSNM(7)
                if (PSL(sum(PSNM(1:6))+jj)==0)
                    kk=kk+1;
                    kT_DOP(jj)=PSF_B(ii,sum(PSN(1:6))+kk);
                else
                    kT_DOP(jj)=PSV(sum(PSNM(1:6))+jj);
                end
            end
        else
            kT_DOP(1:PSNM(7))=PSF_B(ii,sum(PSN(1:6))+1:sum(PSN(1:7)));
        end

        %*******************************************
        %Defining wavelength shift of Doppler groups
        %*******************************************
        if (PSN(8)<PSNM(8))
            kk=0;
            for jj=1:PSNM(8)
                if (PSL(sum(PSNM(1:7))+jj)==0)
                    kk=kk+1;
                    X_DOP(jj)=PSF_B(ii,sum(PSN(1:7))+kk);
                else
                    X_DOP(jj)=PSV(sum(PSNM(1:7))+jj);
                end
            end
        else
            X_DOP(1:PSNM(8))=PSF_B(ii,sum(PSN(1:7))+1:sum(PSN(1:8)));
        end

        %***********************************************
        %Defining relative intensities of Doppler groups
        %***********************************************
        if (PSN(9)<PSNM(9))
            kk=0;
            for jj=1:PSNM(9)
                if (PSL(sum(PSNM(1:8))+jj)==0)
                    kk=kk+1;
                    I_DOP(jj)=PSF_B(ii,sum(PSN(1:8))+kk);
                else
                    I_DOP(jj)=PSV(sum(PSNM(1:8))+jj);
                end
            end
        else
            I_DOP(1:PSNM(9))=PSF_B(ii,sum(PSN(1:8))+1:sum(PSN(1:9)));
        end  

        %**********************************
        %Defining broadening of Lorentzians
        %**********************************
        if (PSN(10)<PSNM(10))
            kk=0;
            for jj=1:PSNM(10)
                if (PSL(sum(PSNM(1:9))+jj)==0)
                    kk=kk+1;
                    GAM_LOR(jj)=PSF_B(ii,sum(PSN(1:9))+kk);
                else
                    GAM_LOR(jj)=PSV(sum(PSNM(1:9))+jj);
                end
            end
        elseif (PSNM(10)>0)
            GAM_LOR(1:PSNM(10))=PSF_B(ii,sum(PSN(1:9))+1:sum(PSN(1:10)));
        end

        %****************************************
        %Defining wavelength shift of Lorentzians
        %****************************************
        if (PSN(11)<PSNM(11))
            kk=0;
            for jj=1:PSNM(11)
                if (PSL(sum(PSNM(1:10))+jj)==0)
                    kk=kk+1;
                    X_LOR(jj)=PSF_B(ii,sum(PSN(1:10))+kk);
                else
                    X_LOR(jj)=PSV(sum(PSNM(1:10))+jj);
                end
            end
        elseif (PSNM(11)>0)
            X_LOR(1:PSNM(11))=PSF_B(ii,sum(PSN(1:10))+1:sum(PSN(1:11)));
        end

        %*******************************************
        %Defining relative intensities of Lorentians
        %*******************************************
        if (PSN(12)<PSNM(12))
            kk=0;
            for jj=1:PSNM(12)
                if (PSL(sum(PSNM(1:11))+jj)==0)
                    kk=kk+1;
                    I_LOR(jj)=PSF_B(ii,sum(PSN(1:11))+kk);
                else
                    I_LOR(jj)=PSV(sum(PSNM(1:11))+jj);
                end
            end
        elseif (PSNM(12)>0)
            I_LOR(1:PSNM(12))=PSF_B(ii,sum(PSN(1:11))+1:sum(PSN(1:12)));
        end    

        %********************
        %Assign fit variables
        %********************	
        VAR(ii,1:NV)=[VIEW POL B_Z EFP_X EFP_Y EFP_Z kT_DOP X_DOP I_DOP GAM_LOR X_LOR I_LOR];         
    end

    %*******************
    %Assiging the output
    %*******************
    if BGN==1
        FIT.VAR_BACK_CON{uu}=VAR;
    elseif BGN==2
        FIT.VAR_BACK_VAR{uu}=VAR;
    end
end

end