function [FIT,PARA]=FITTER(SIM,OPT)

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>       USER OPTIONS     <><><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%********************
%Number of iterations
%********************
NI=3;

%********************************************************
%Number of discretizations for the SIG and GAM parameters
%********************************************************
ND_SIG=15;
ND_GAM=15;

%***********************************************************
%Scales the max boundary for the SIG and GAM parameter space
%***********************************************************
SIG_FACTOR=1.5;
GAM_FACTOR=1.5;

%***********************************************************
%Scales the max and min boundaries of the x-grid for the fit 
%***********************************************************
GRID_FACTOR=1;

%************************************************
%Number of points associated with fitted spectrum
%************************************************
NP=5000;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><><><><><><><><><><>       USER OPTIONS     <><><><><><><><><><><><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%********************
%Assign input options
%********************
if exist('OPT','var')==1
    if isfield(OPT,'NI')==1
        NI=OPT.NI;
    end
    
    if isfield(OPT,'ND_SIG')==1
        ND_SIG=OPT.ND_SIG;
    end

    if isfield(OPT,'ND_GAM')==1
        ND_GAM=OPT.ND_GAM;
    end
    
    if isfield(OPT,'SIG_FACTOR')==1
        SIG_FACTOR=OPT.SIG_FACTOR;
    end
    
    if isfield(OPT,'GAM_FACTOR')==1
        GAM_FACTOR=OPT.GAM_FACTOR;
    end
    
    if isfield(OPT,'GRID_FACTOR')==1
        GRID_FACTOR=OPT.GRID_FACTOR;
    end
    
    if isfield(OPT,'NP')==1
        NP=OPT.NP;
    end
end

%**********************
%Assign simulation data
%**********************
X_DF=SIM.SPEC.X;
I_DF=SIM.SPEC.I;

%**********************
%Normalize the spectrum
%**********************
SPEC_NORM=max(I_DF);
I_DF=I_DF/SPEC_NORM;

%**************************************
%Total number of parameter space points
%**************************************
ND=ND_SIG*ND_GAM;

%*****************************
%Calc. the FWHM of the spectra
%*****************************
[~,IND]=max(I_DF);
X_CENTER=X_DF(IND);

[~,IND]=min(abs(I_DF-0.5));
X_WIDTH=X_DF(IND);

X_FWHM=2*abs(X_CENTER-X_WIDTH);

%**************************************
%Define parameter space for SIG and GAM
%**************************************
SIG_LIM=[0,SIG_FACTOR*X_FWHM];
GAM_LIM=[0,GAM_FACTOR*X_FWHM];

SIG=linspace(SIG_LIM(1),SIG_LIM(2),ND_SIG);
GAM=linspace(GAM_LIM(1),GAM_LIM(2),ND_GAM);

%****************************************************
%Make sure NP is odd ~ so grid point is at the center
%**************************************************** 
NP=2*ceil(NP/2)+1;

%********************
%Generate x-axis grid 
%********************
MIN=min(X_DF);
MAX=max(X_DF);
SHIFT=GRID_FACTOR*(MAX-MIN)/2;

X=linspace(MIN-SHIFT,MAX+SHIFT,NP);

%************************************************************
%Generate intial intensity array ~ delta function at midpoint
%************************************************************
I(1:NP)=0;
I((NP-1)/2+1)=1;

%***************
%Allocate memory
%***************
SIG_PAR(1:ND)=0;
GAM_PAR(1:ND)=0;
I_CONVO=cell(1,ND);
MSE(1,ND)=0;

for uu=1:NI
    %**************
    %Print progress
    %**************
    fprintf('\n***************************************\n')
    fprintf('***       Fit Iteration %1i of %1i      ***\n',uu,NI)
    fprintf('***************************************\n\n')
    
    %**************************
    %Assign parallel parameters
    %**************************
    kk=0;
    for ii=1:ND_SIG
        for jj=1:ND_GAM
            kk=kk+1;

            SIG_PAR(kk)=SIG(ii);
            GAM_PAR(kk)=GAM(jj);
        end
    end
    
    %*****************************
    %Calc. the theortical spectrum
    %*****************************
    PARALLEL_PROGRESS(ND);
    parfor ii=1:ND
        %**************
        %Print progress
        %**************
        PARALLEL_PROGRESS;

        %*******************
        %Perform convolution
        %*******************
        I_CONVO{ii}=GAU_LOR_CONVO(SIG_PAR(ii),GAM_PAR(ii),X,I,NP);
    end
    PARALLEL_PROGRESS(0);

    %*************
    %Calc. the MSE
    %*************
    PARALLEL_PROGRESS(ND);
    parfor ii=1:ND_SIG*ND_GAM
        %**************
        %Print progress
        %**************
        PARALLEL_PROGRESS;

        %*************************************************
        %Interpolate the convoluted data to the input grid
        %*************************************************
        I_CONVO_INT=interp1(X,I_CONVO{ii},X_DF);

        %**************
        %Identify NaN's
        %**************
        IND=isnan(I_CONVO_INT)==0;

        %*************
        %Calc. the MSE
        %*************
        MSE(ii)=sum((I_CONVO_INT(IND)-I_DF(IND)).^2)/sum(IND);
    end
    PARALLEL_PROGRESS(0);

    %*****************************************
    %Assign indice associated with minimum MSE
    %*****************************************
    [~,IND]=min(MSE);
    
    %**********************************************
    %Assign SIG and GAM associated with minimum MSE
    %**********************************************
    SIG_MIN=SIG_PAR(IND);
    GAM_MIN=GAM_PAR(IND);
    
    if uu<NI
        %************************************
        %Calc. current SIG and GAM cell width
        %************************************
        SIG_CELL=SIG(2)-SIG(1);
        GAM_CELL=SIG(2)-SIG(1);
    
        %**********************************
        %Update SIG and GAM parameter space
        %**********************************
        T1=SIG_MIN-SIG_CELL;
        T2=SIG_MIN+SIG_CELL;

        T3=GAM_MIN-GAM_CELL;
        T4=GAM_MIN+GAM_CELL;
        
        if T1<0
            T1=0;
        end
        if T3<0
            T3=0;
        end
        
        SIG=linspace(T1,T2,ND_SIG);
        GAM=linspace(T3,T4,ND_GAM);
    end
end

%*****************
%Calc. uncertainty
%*****************
SIG_ERR=(SIG_LIM(2)-SIG_LIM(1))/ND_SIG*(2/ND_SIG)^(NI-1);
GAM_ERR=(GAM_LIM(2)-GAM_LIM(1))/ND_GAM*(2/ND_GAM)^(NI-1);

%*********************
%Assign MSE of the fit
%*********************
MSE_MIN=MSE(IND);

%**************************************
%Assign fit associated with minimum MSE
%**************************************
I_MIN=I_CONVO{IND};

%*********************************
%Scale fit by normalization factor
%*********************************
I_MIN=I_MIN*SPEC_NORM;

%*************
%Assign output
%*************
FIT.NP=NP;
FIT.X=X;
FIT.I=I_MIN;

PARA.MSE=MSE_MIN;

PARA.LIM.SIG=SIG_LIM;
PARA.LIM.GAM=GAM_LIM;

PARA.MIN.SIG=SIG_MIN;
PARA.MIN.GAM=GAM_MIN;

PARA.ERR.SIG=SIG_ERR;
PARA.ERR.GAM=GAM_ERR;

end
