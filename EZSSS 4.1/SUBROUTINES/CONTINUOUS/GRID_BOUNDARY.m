function AXIS=GRID_BOUNDARY(DISC,UNIV,OPT)

%************
%Assign input
%************
SPEC=OPT.SPEC;

%***********************
%Assign discrete spectra
%***********************
X=DISC.X;
NT=DISC.NX;

%************************************
%Assign Doppler broadening parameters
%************************************
NTG=SPEC.DOP.NTG;
X_DOP=SPEC.DOP.X;
kT_LHS=SPEC.DOP.kT_LHS;
kT_RHS=SPEC.DOP.kT_RHS;

%**************************
%Assign Gaussian parameters
%**************************
NFG=SPEC.GAU.NF;
X_GAU=SPEC.GAU.X;
SIG_GAU=SPEC.GAU.SIG;
NSIG=SPEC.GAU.NSIG;

%****************************
%Assign Lorentzian parameters
%****************************
NFL=SPEC.LOR.NF;
X_LOR=SPEC.LOR.X;
GAM_LOR=SPEC.LOR.GAM;
NGAM=SPEC.LOR.NGAM;

DX_GROUP=SPEC.DX_GROUP;

%**********************
%Max doppler broadening
%**********************
if NTG>0
    DOP_LHS=DOPPLER(kT_LHS(1:NTG),max(X),UNIV);
    DOP_RHS=DOPPLER(kT_RHS(1:NTG),max(X),UNIV);

    MAX_DOP_LHS=max(DOP_LHS);
    MAX_DOP_RHS=max(DOP_RHS);

    MAX_DOP=max([MAX_DOP_LHS MAX_DOP_RHS]);
else
    MAX_DOP=0;
end

%*********************************
%Max Gaussian broadening parameter
%*********************************
if NFG>0
    MAX_GAU=max(SIG_GAU(1:NFG));
else
    MAX_GAU=0;
end

%*****************************
%Calc. max Gaussian broadening
%*****************************
MAX_SIG=(MAX_GAU^2+MAX_DOP^2)^0.5;

%***********************************
%Max Lorentzian broadening parameter
%***********************************
if NFL>0
    MAX_GAM=max(GAM_LOR(1:NFL));
else
    MAX_GAM=0;
end

%*********************
%Sort wavelength array
%*********************
XS=sort(X,'ascend');

%****************
%Broadening width
%****************
WIDTH=NSIG*MAX_SIG+NGAM*MAX_GAM;

%********************
%Assign group spacing 
%********************
if DX_GROUP<2*WIDTH
    DX_GROUP=2*WIDTH;
end

%***********************
%Calc. group grid limits
%***********************
NG=1;
XL(NG)=XS(1)-WIDTH;
XU(NG)=XS(1)+WIDTH;
for ii=1:NT-1
    if abs(XS(ii)-XS(ii+1))>DX_GROUP
        NG=NG+1;

        XL(NG)=XS(ii+1)-WIDTH;
        XU(NG)=XS(ii+1)+WIDTH;
    else
        XU(NG)=XS(ii+1)+WIDTH;
    end
end

%**********************
%Assign min shift array
%**********************
xx=0;
if NFG~=0
    xx=xx+1;
    MIN(xx)=min(X_GAU(1:NFG));
end
if NFL~=0
    xx=xx+1;
    MIN(xx)=min(X_LOR(1:NFL));
end
if NTG~=0
    xx=xx+1;
    MIN(xx)=min(X_DOP(1:NTG));
end

%**********************
%Assign max shift array
%**********************
xx=0;
if NFG~=0
    xx=xx+1;
    MAX(xx)=max(X_GAU(1:NFG));
end
if NFL~=0
    xx=xx+1;
    MAX(xx)=max(X_LOR(1:NFL));
end
if NTG~=0
    xx=xx+1;
    MAX(xx)=max(X_DOP(1:NTG));
end

%********************
%Shift lower boundary
%********************
LOG=MIN<0;
if sum(LOG)>0
    XL=XL+sum(MIN(LOG));
else
    XL=XL+min(MIN);
end

%********************
%Shift upper boundary
%********************
LOG=MAX>0;
if sum(LOG)>0
    XU=XU+sum(MAX(LOG));
else
    XU=XU+max(MAX);
end

%*************
%Assign output
%*************
AXIS.NG=NG;
AXIS.XL=XL;
AXIS.XU=XU;

end