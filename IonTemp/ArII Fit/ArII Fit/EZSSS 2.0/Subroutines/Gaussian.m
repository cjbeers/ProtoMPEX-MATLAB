function [I_C,X_C,NX_C]=Gaussian(I_D,X_D,NT_D,XU,XL,NG,UNIV,OPT)

%************
%Assign input
%************
SPEC=OPT.SPEC;

NTG=SPEC.DOP.NTG;
I_DOP=SPEC.DOP.I;
X_DOP=SPEC.DOP.X;
kT_LHS=SPEC.DOP.kT_LHS;
kT_RHS=SPEC.DOP.kT_RHS;

NF_GAU=SPEC.GAU.NF;
I_GAU=SPEC.GAU.I;
X_GAU=SPEC.GAU.X;
SIG_GAU=SPEC.GAU.SIG;

NX_SIG=SPEC.GAU.NX_SIG;

SIG_DOP_LHS(1:NG,1:NTG)=0;
SIG_DOP_RHS(1:NG,1:NTG)=0;
for ii=1:NG
    %***********************
    %Calc. center wavelength
    %***********************
    T1=max(I_D(XL(ii)<=X_D&X_D<=XU(ii)));
    T2=max(X_D(XL(ii)<=X_D&X_D<=XU(ii)));
    Xo=sum(T1.*T2)/sum(T1);
    
    %************************
    %Calc. doppler broadening
    %************************    
    for jj=1:NTG
        %**************************************
        %Left hand side of distrubtion function
        %**************************************
        SIG_DOP_LHS(ii,jj)=Doppler(kT_LHS(jj),Xo,UNIV);
        
        %***************************************
        %Right hand side of distrubtion function
        %***************************************
        SIG_DOP_RHS(ii,jj)=Doppler(kT_RHS(jj),Xo,UNIV);
    end
end


if NF_GAU~=0
    %***************
    %Allocate memory
    %***************
    SIG_LHS(1:NF_GAU,1:NTG,1:NG)=0;
    SIG_RHS(1:NF_GAU,1:NTG,1:NG)=0;
    
    %***********************************
    %Calc. Gaussian broadening parameter
    %***********************************
    for ii=1:NF_GAU
        for jj=1:NTG
            for kk=1:NG
                %******************************
                %Calc. LHS broadening parameter
                %******************************
                SIG_LHS(ii,jj,kk)=(SIG_GAU(ii)^2+SIG_DOP_LHS(kk,jj)^2).^0.5;
                
                %******************************
                %Calc. RHS broadening parameter
                %******************************
                SIG_RHS(ii,jj,kk)=(SIG_GAU(ii)^2+SIG_DOP_RHS(kk,jj)^2).^0.5;
            end
        end
    end
else
    %******************************
    %Calc. LHS broadening parameter
    %******************************
    SIG_LHS=SIG_DOP_LHS.';
    
    %******************************
    %Calc. RHS broadening parameter
    %******************************
    SIG_RHS=SIG_DOP_RHS.';
end

%*******************
%Grid points density
%*******************
NXD=NX_SIG/min([min(min(min(SIG_LHS))),min(min(min(SIG_RHS)))]);

%*************************************
%Calc. number of grid points per group
%*************************************
NXG(1:NG)=0;
for ii=1:NG
    NXG(ii)=round(NXD*(XU(ii)-XL(ii)));
end

%*********************
%Number of grid points
%*********************
NX_C=sum(NXG(1:NG));

X_C(1:NX_C)=0;
IND_DOP(1:NX_C)=0;
for ii=1:NG
    %*************
    %Dummy indices
    %*************      
    if (ii==1) 
        N1=1;
        N2=NXG(ii);
    else
        N1=sum(NXG(1:ii-1))+1;
        N2=sum(NXG(1:ii));
    end
    
    %********************
    %Calc. grid per group
    %********************    
    X_C(N1:N2)=linspace(XL(ii),XU(ii),NXG(ii));
    
    %********************************
    %Assign doppler broadening indice
    %********************************       
    IND_DOP(N1:N2)=ii;
end

%***************
%Allocate memory
%***************
SIGMA(1:NT_D)=0;
I_C(1:NX_C)=0;

if NF_GAU~=0
    for ii=1:NX_C
        for kk=1:NF_GAU
            for ll=1:NTG
                %*******************************
                %Assign LHS broadening parameter
                %*******************************
                LOG=(X_D(1:NT_D)+X_GAU(kk)+X_DOP(ll)-X_C(ii))>=0;
                SIGMA(LOG)=SIG_LHS(kk,ll,IND_DOP(ii));

                %*******************************
                %Assign RHS broadening parameter
                %*******************************
                LOG=(X_D(1:NT_D)+X_GAU(kk)+X_DOP(ll)-X_C(ii))<0;
                SIGMA(LOG)=SIG_RHS(kk,ll,IND_DOP(ii));
                
                %********************************
                %Calc. the continous line profile
                %********************************
                I_C(ii)=I_C(ii)+sum(I_D(1:NT_D)*I_GAU(kk)*I_DOP(ll).*exp(-1*((X_D(1:NT_D)+X_GAU(kk)+X_DOP(ll)-X_C(ii))./SIGMA(1:NT_D)).^2));
            end
        end
    end
else
    for ii=1:NX_C
        for kk=1:NTG
            %*******************************
            %Assign LHS broadening parameter
            %*******************************
            LOG=(X_D(1:NT_D)+X_DOP(kk)-X_C(ii))>=0;
            SIGMA(LOG)=SIG_LHS(kk,IND_DOP(ii));

            %*******************************
            %Assign RHS broadening parameter
            %*******************************
            LOG=(X_D(1:NT_D)+X_DOP(kk)-X_C(ii))<0;
            SIGMA(LOG)=SIG_RHS(kk,IND_DOP(ii));

            %********************************
            %Calc. the continous line profile
            %********************************
            I_C(ii)=I_C(ii)+sum(I_D(1:NT_D)*I_DOP(kk).*exp(-1*((X_D(1:NT_D)+X_DOP(kk)-X_C(ii))./SIGMA(1:NT_D)).^2));
        end
    end
end

end
















