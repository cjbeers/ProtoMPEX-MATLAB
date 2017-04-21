function CONT=GAUSSIAN(DISC,AXIS,UNIV,OPT)

%************
%Assign input
%************
SPEC=OPT.SPEC;

%***********************
%Assign discrete spectra
%***********************
I_D=DISC.I;
X_D=DISC.X;
NT=DISC.NX;

%**********************
%Assign grid boundaries
%**********************
XL=AXIS.XL;
XU=AXIS.XU;
NG=AXIS.NG;

%************************************
%Assign Doppler broadening parameters
%************************************
NTG=SPEC.DOP.NTG;
I_DOP=SPEC.DOP.I;
X_DOP=SPEC.DOP.X;
kT_LHS=SPEC.DOP.kT_LHS;
kT_RHS=SPEC.DOP.kT_RHS;

%**************************
%Assign Gaussian parameters
%**************************
NFG=SPEC.GAU.NF;
I_GAU=SPEC.GAU.I;
X_GAU=SPEC.GAU.X;
SIG_GAU=SPEC.GAU.SIG;
NP_SIG=SPEC.GAU.NP_SIG;

%************************
%Calc. doppler broadening
%************************ 
if NTG>0
    %***************
    %Allocate memory
    %***************
    SIG_DOP_LHS(1:NTG,1:NG)=0;
    SIG_DOP_RHS(1:NTG,1:NG)=0;

    for jj=1:NG
        %***********************
        %Calc. center wavelength
        %***********************
        XO=(XL(jj)+XU(jj))/2;

        for ii=1:NTG
            %**************************************
            %Left hand side of distrubtion function
            %**************************************
            SIG_DOP_LHS(ii,jj)=DOPPLER(kT_LHS(ii),XO,UNIV);

            %***************************************
            %Right hand side of distrubtion function
            %***************************************
            SIG_DOP_RHS(ii,jj)=DOPPLER(kT_RHS(ii),XO,UNIV);
        end
    end
end

%**********************************************
%Calc. convoluted Gaussian broadening parameter
%**********************************************
if NFG>0 && NTG>0
    %***************
    %Allocate memory
    %***************
    SIG_LHS(1:NFG,1:NTG,1:NG)=0;
    SIG_RHS(1:NFG,1:NTG,1:NG)=0;
    
    for ii=1:NFG
        for jj=1:NTG
            for kk=1:NG
                %******************************
                %Calc. LHS broadening parameter
                %******************************
                SIG_LHS(ii,jj,kk)=(SIG_GAU(ii)^2+SIG_DOP_LHS(jj,kk)^2).^0.5;
                
                %******************************
                %Calc. RHS broadening parameter
                %******************************
                SIG_RHS(ii,jj,kk)=(SIG_GAU(ii)^2+SIG_DOP_RHS(jj,kk)^2).^0.5;
            end
        end
    end
end

%*********************
%Assign min broadening
%*********************
if NFG>0 && NTG>0
    MIN_SIG=min([min(min(min(SIG_LHS))),min(min(min(SIG_RHS)))]);
elseif NFG==0 && NTG>0
    MIN_SIG=min([min(min(SIG_DOP_LHS)),min(min(SIG_DOP_RHS))]);
elseif NFG>0 && NTG==0
    MIN_SIG=min([min(SIG_GAU),min(SIG_GAU)]);
end

%************************
%Calc. grid point density
%************************
GPD=NP_SIG/MIN_SIG;

%*************************************
%Calc. number of grid points per group
%*************************************
NX_G(1:NG)=0;
for ii=1:NG
    NX_G(ii)=round(GPD*(XU(ii)-XL(ii)));
end

%*********************************
%Calc. number of total grid points 
%*********************************
NX=sum(NX_G(1:NG));

%********************
%Calc. grid per group
%********************
X_C(1:NX)=0;
IND(1:NX)=0;
for ii=1:NG
    %*************
    %Dummy indices
    %*************      
    if (ii==1) 
        N1=1;
        N2=NX_G(ii);
    else
        N1=sum(NX_G(1:ii-1))+1;
        N2=sum(NX_G(1:ii));
    end
    
    %**********
    %Calc. grid
    %**********    
    X_C(N1:N2)=linspace(XL(ii),XU(ii),NX_G(ii));
    
    %********************************
    %Assign doppler broadening indice
    %********************************       
    IND(N1:N2)=ii;
end

%***************
%Allocate memory
%***************
SIGMA(1:NT)=0;
I_C(1:NX)=0;

if NFG>0 && NTG>0
    for ii=1:NX
        for kk=1:NFG
            for ll=1:NTG
                %*******************************
                %Assign LHS broadening parameter
                %*******************************
                LOG=(X_D(1:NT)+X_GAU(kk)+X_DOP(ll)-X_C(ii))>=0;
                SIGMA(LOG)=SIG_LHS(kk,ll,IND(ii));

                %*******************************
                %Assign RHS broadening parameter
                %*******************************
                LOG=(X_D(1:NT)+X_GAU(kk)+X_DOP(ll)-X_C(ii))<0;
                SIGMA(LOG)=SIG_RHS(kk,ll,IND(ii));
                
                %********************************
                %Calc. the continuous line profile
                %********************************
                I_C(ii)=I_C(ii)+sum(I_D(1:NT)*I_GAU(kk)*I_DOP(ll).*exp(-1*((X_D(1:NT)+X_GAU(kk)+X_DOP(ll)-X_C(ii))./SIGMA(1:NT)).^2));
            end
        end
    end
elseif NFG==0 && NTG>0
    for ii=1:NX
        for ll=1:NTG
            %*******************************
            %Assign LHS broadening parameter
            %*******************************
            LOG=(X_D(1:NT)+X_DOP(ll)-X_C(ii))>=0;
            SIGMA(LOG)=SIG_DOP_LHS(ll,IND(ii));

            %*******************************
            %Assign RHS broadening parameter
            %*******************************
            LOG=(X_D(1:NT)+X_DOP(ll)-X_C(ii))<0;
            SIGMA(LOG)=SIG_DOP_RHS(ll,IND(ii));

            %*********************************
            %Calc. the continuous line profile
            %*********************************
            I_C(ii)=I_C(ii)+sum(I_D(1:NT)*I_DOP(ll).*exp(-1*((X_D(1:NT)+X_DOP(ll)-X_C(ii))./SIGMA(1:NT)).^2));
        end
    end
elseif NFG>0 && NTG==0
    for ii=1:NX
        for kk=1:NFG
            %*********************************
            %Calc. the continuous line profile
            %*********************************
            I_C(ii)=I_C(ii)+sum(I_D(1:NT)*I_GAU(kk).*exp(-1*((X_D(1:NT)+X_GAU(kk)-X_C(ii))/SIG_GAU(kk)).^2));
        end
    end
end

%*************************
%Assign continuous spectra
%*************************
CONT.I=I_C;
CONT.X=X_C;
CONT.NX=NX;

end
