function CONT=LORENTZIAN(DISC,AXIS,OPT)

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

%****************************
%Assign Lorentzian parameters
%****************************
NFL=SPEC.LOR.NF;
I_LOR=SPEC.LOR.I;
X_LOR=SPEC.LOR.X;
GAM_LOR=SPEC.LOR.GAM;
NP_GAM=SPEC.LOR.NP_GAM;

%*******************
%Grid points density
%*******************
GPD=NP_GAM/min(GAM_LOR);

%*************************************
%Calc. number of grid points per group
%*************************************
NX_G(1:NG)=0;
for ii=1:NG
    NX_G(ii)=round(GPD*(XU(ii)-XL(ii)));
end

%*********************
%Number of grid points
%*********************
NX=sum(NX_G(1:NG));

%********************
%Calc. grid per group
%********************
X_C(1:NX)=0;
for ii=1:NG
    %*************
    %Dummy indices
    %*************        
    if ii==1
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
end

%********************************
%Calc. the continous line profile
%********************************
I_C(1:NX)=0;
for ii=1:NX
    for kk=1:NFL
        I_C(ii)=I_C(ii)+sum(I_D(1:NT)*I_LOR(kk)./(1+((X_D(1:NT)+X_LOR(kk)-X_C(ii))/GAM_LOR(kk)).^2));
    end
end

%*************************
%Assign continuous spectra
%*************************
CONT.I=I_C;
CONT.X=X_C;
CONT.NX=NX;

end