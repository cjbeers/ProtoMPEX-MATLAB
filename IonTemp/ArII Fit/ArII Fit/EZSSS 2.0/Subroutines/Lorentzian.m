function [I_C,X_C,NX_C]=Lorentzian(I_D,X_D,NT_D,XU,XL,NG,OPT)

%************
%Assign input
%************
SPEC=OPT.SPEC;

NF_LOR=SPEC.LOR.NF;
I_LOR=SPEC.LOR.I;
X_LOR=SPEC.LOR.X;
GAM_LOR=SPEC.LOR.GAM;

NX_GAM=SPEC.LOR.NX_GAM;

%*******************
%Grid points density
%*******************
NXD=NX_GAM/min(GAM_LOR);

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
end

%********************************
%Calc. the continous line profile
%********************************
I_C(1:NX_C)=0;
for ii=1:NX_C
    for kk=1:NF_LOR
        I_C(ii)=I_C(ii)+sum(I_D(1:NT_D)*I_LOR(kk)/GAM_LOR(kk)./(1+((X_D(1:NT_D)+X_LOR(kk)-X_C(ii))/GAM_LOR(kk)).^2));
    end
end

end