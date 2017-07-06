function DATA=Continuous(DATA,UNIV,OPT)

%**************************************************************************
%This function calculates the line profile assuming that the instrument
%function is Guassian
%**************************************************************************

%**************************************************************************
%                               INPUTS
%**************************************************************************
%Trans=[I dE NT] - is a cell array containing the calculated intensities 
%                  and energies associated transitions. The intensities can
%                  have arbitary units and the energies MUST be in eV.                          
%
%                       I - array of length NT containing the intensites of
%                           the transitions. 
%                                
%                       dE - array of length NT containing the  energies of  
%                            the transitions.
%                                
%                       NT - number of transitions
%
%FWHM - is the full width at half maximum of the GAUSSIAN INSTRUMENT
%       function.  The units must be meters.
%
%NX - is the number of grid points the line profile will be calculated on.
%     The output vectors x and Int both have length=NX
%
%**************************************************************************
%                               OUTPUTS
%**************************************************************************
%INS_RES={x,Int,x_axis} -- cell arrary of length three. Contains the
%                           output data.
%
%x - is the WAVELENGTH vector associated with the line proile.  This vector
%    has a length of NX.  The units are meters.
%
%Int - is the INTENSITY vector associated with the line proile.  This 
%      vector has a length of NX.  The units are arbitary.
%
%x_axis - is an array of length two. Contains x-axis limits for plotting
%         purposes
%
%**************************************************************************

%************
%Assign input
%************
DISC=DATA.DISC;
SPEC=OPT.SPEC;

I_D=DISC.I;
X_D=DISC.X;
NT_D=DISC.NT;

NTG=SPEC.DOP.NTG;
X=SPEC.DOP.X;
kT_LHS=SPEC.DOP.kT_LHS;
kT_RHS=SPEC.DOP.kT_RHS;

NF_GAU=SPEC.GAU.NF;
X_GAU=SPEC.GAU.X;
SIG_GAU=SPEC.GAU.SIG;
NSIG=SPEC.GAU.NSIG;

NF_LOR=SPEC.LOR.NF;
X_LOR=SPEC.LOR.X;
GAM_LOR=SPEC.LOR.GAM;
NGAM=SPEC.LOR.NGAM;

XLIM=SPEC.XLIM;

%**********************
%Max doppler broadening
%**********************
SIG_DOP_LHS=Doppler(kT_LHS(1:NTG),max(X_D),UNIV);
SIG_DOP_RHS=Doppler(kT_RHS(1:NTG),max(X_D),UNIV);

%*********************************
%Max Gaussian broadening parameter
%*********************************
if NF_GAU>0
    SIG=(max(SIG_GAU(1:NF_GAU))^2+max([max(SIG_DOP_LHS(1:NTG)),max(SIG_DOP_RHS(1:NTG))])^2)^0.5;
else
    SIG=max([max(SIG_DOP_LHS(1:NTG)),max(SIG_DOP_RHS(1:NTG))]);
end

%***********************************
%Max Lorentzian broadening parameter
%***********************************
if (NF_LOR>0)
    GAM=max(GAM_LOR(1:NF_LOR));
else
    GAM=0;
end

%*********************
%Sort wavelength array
%*********************
XS=sort(X_D,'ascend');

%****************
%Broadening width
%****************
WIDTH=NSIG*SIG+NGAM*GAM;

%********************
%Assign group spacing 
%********************
if (XLIM<2*WIDTH)
    XLIM=2*WIDTH;
end

%***********************
%Calc. group grid limits
%***********************
NG=1;
XL(NG)=XS(1)-NSIG*SIG-NGAM*GAM;
XU(NG)=XS(1)+NSIG*SIG+NGAM*GAM;
for ii=1:NT_D-1
    if (abs(XS(ii)-XS(ii+1))>XLIM)
        NG=NG+1;

        XL(NG)=XS(ii+1)-WIDTH;
        XU(NG)=XS(ii+1)+WIDTH;
    else
        XU(NG)=XS(ii+1)+WIDTH;
    end
end

%***********************
%Shift group grid limits
%***********************
if (NTG~=0)
    if (NF_GAU~=0 && NF_LOR~=0)
        T1=min(X_GAU(1:NF_GAU));
        T2=min(X_LOR(1:NF_LOR));
        T3=min(X(1:NTG));
        T4=max(X_GAU(1:NF_GAU));
        T5=max(X_LOR(1:NF_LOR));
        T6=max(X(1:NTG));

        if T3<0
            if T1<0 && T2<0
                XL=XL+T1+T2+T3;
            elseif T1<0
                XL=XL+T1+T3;
            elseif T2<0
                XL=XL+T2+T3;
            else
                XL=XL+T3;
            end
        else
            if T1<0 && T2<0
                XL=XL+T1+T2;
            elseif T1<0
                XL=XL+T1;
            elseif T2<0
                XL=XL+T2;
            else
                XL=XL+min([T1,T2,T3]);
            end
        end

        if T6>0
            if T4>0 && T5>0;
                XU=XU+T4+T5+T6;
            elseif T4>0
                XU=XU+T4+T6;
            elseif T5>0
                XU=XU+T5+T6;
            else
                XU=XU+T6;
            end
        else
            if T4>0 && T5>0;
                XU=XU+T4+T5+T6;
            elseif T4>0
                XU=XU+T4+T6;
            elseif T5>0
                XU=XU+T5+T6;
            else
                XU=XU+max([T4,T5,T6]);
            end
        end
    elseif NF_GAU~=0
        T1=min(X_GAU(1:NF_GAU));
        T2=min(X(1:NTG));
        T3=max(X_GAU(1:NF_GAU));
        T4=max(X(1:NTG));

        if T1<0 && T2<0
            XL=XL+T1+T2;
        elseif T1<0
            XL=XL+T1;
        elseif T2<0
            XL=XL+T2;
        else
            XL=XL+min(T1,T2);
        end

        if T3>0 && T4>0;
            XU=XU+T3+T4;
        elseif T3>0
            XU=XU+T3;
        elseif T4>0
            XU=XU+T4;
        else
            XU=XU+max(T3,T4);
        end
    elseif NF_LOR~=0
        T1=min(X_LOR(1:NF_LOR));
        T2=min(X(1:NTG));
        T3=max(X_LOR(1:NF_LOR));
        T4=max(X(1:NTG));

        if T1<0 && T2<0
            XL=XL+T1+T2;
        elseif T1<0
            XL=XL+T1;
        elseif T2<0
            XL=XL+T2;
        else
            XL=XL+min([T1,T2]);
        end

        if T3>0 && T4>0;
            XU=XU+T3+T4;
        elseif T3>0
            XU=XU+T3;
        elseif T4>0
            XU=XU+T4;
        else
            XU=XU+max([T3,T4]);
        end   
    end
else
    if (NF_GAU~=0 && NF_LOR~=0)
        T1=min(X_GAU(1:NF_GAU));
        T2=min(X_LOR(1:NF_LOR));
        T3=max(X_GAU(1:NF_GAU));
        T4=max(X_LOR(1:NF_LOR));

        if T1<0 && T2<0
            XL=XL+T1+T2;
        elseif T1<0
            XL=XL+T1;
        elseif T2<0
            XL=XL+T2;
        else
            XL=XL+min([T1,T2]);
        end

        if T3>0 && T4>0;
            XU=XU+T3+T4;
        elseif T3>0
            XU=XU+T3;
        elseif T4>0
            XU=XU+T4;
        else
            XU=XU+max([T3,T4]);
        end
    elseif NF_GAU~=0
        T1=min(X_GAU(1:NF_GAU));
        T2=max(X_GAU(1:NF_GAU));

        XL=XL+T1;
        XU=XU+T2;
    elseif NF_LOR~=0
        T1=min(X_LOR(1:NF_LOR));
        T2=max(X_LOR(1:NF_LOR));

        XL=XL+T1;
        XU=XU+T2;    
    end    
end

if NF_GAU~=0 || (NF_GAU==0 && min(kT_LHS(1:NTG))~=0 && min(kT_RHS(1:NTG))~=0)
    %***********************************
    %Convolute with Gaussian function(s)
    %***********************************
    [I_C,X_C,NX_C]=Gaussian(I_D,X_D,NT_D,XU,XL,NG,UNIV,OPT);
    
    if NF_LOR~=0
        %***********************************
        %Convolute with Gaussian function(s)
        %***********************************
        [I_C,X_C,NX_C]=Lorentzian(I_C,X_C,NX_C,XU,XL,NG,OPT);   
    end
elseif NF_LOR~=0
    %***********************************
    %Convolute with Gaussian function(s)
    %***********************************
    [I_C,X_C,NX_C]=Lorentzian(I_D,X_D,NT_D,XU,XL,NG,OPT);
end

if SPEC.NORM==1
    %*****************************
    %Normalize continuous spectrum
    %*****************************   
    MAX=max(I_C);
    I_C=I_C/MAX;
end

%*************************
%Calc. group max intensity
%*************************
I_D_MAX(1:NG)=0;
I_C_MAX(1:NG)=0;
for ii=1:NG
    I_D_MAX(ii)=max(I_D(XL(ii)<=X_D&X_D<=XU(ii)));
    I_C_MAX(ii)=max(I_C(XL(ii)<=X_C&X_C<=XU(ii)));
end

%*************
%Assign output
%*************
AXIS.NG=NG;
AXIS.I_D_MAX=I_D_MAX;
AXIS.I_C_MAX=I_C_MAX;
AXIS.XL=XL;
AXIS.XU=XU;

CONT.I=I_C;
CONT.X=X_C;
CONT.NX=NX_C;

DATA.AXIS=AXIS;
DATA.DISC=DISC;
DATA.CONT=CONT;

end