function CHI=Red_Chi(DATA,SCALE,uu)

%**************************************************************************
%The Fit_Chi.m function serves to calculate the reduced chi associated with
%the theortical and experimental line profiles given the standard error for 
%each experimental data point. Before the reduced chi is calculated the
%experimental data is scaled and shifted in the following manner:
%
%   IE=IE*SCALE(1)
%   XEC=XEC+SCALE(2)
%
%The theortical line profile is integrated over the pixels to give the most
%accurate reduced chi associated with the theortical and experiment data.
%**************************************************************************
%*******************              INPUTS             **********************
%**************************************************************************
%SCALE - Array of length two. Contains the vertical scale and horizontal
%        shift values respectively.
%
%DATA - Structure. See Fun.m for details. The following field names 
%       are used:
%
%   EXP
%   GRID
%**************************************************************************
%*******************             OUTPUTS             **********************
%**************************************************************************
%CHI - Scalar. The reduced chi associated with the theortical line profile.
%**************************************************************************

%*******************
%Assigning the input
%*******************
IE=DATA.EXP{uu}.IE;
IEE=DATA.EXP{uu}.IEE;

XEC=DATA.EXP{uu}.XEC;
XEW=DATA.EXP{uu}.XEW;

LG=DATA.EXP{uu}.LG;
WT=DATA.EXP{uu}.WT;

NE=DATA.EXP{uu}.NE;
NEF=DATA.EXP{uu}.NEF;

IGT=DATA.GRID{uu}.IGT;
XG=DATA.GRID{uu}.XG;
NG=DATA.GRID{uu}.NG;
GFP=DATA.GRID{uu}.GFP;

%*****************************
%Scaling the experimental data
%*****************************
IE=IE*SCALE(1); 
XEC=XEC+SCALE(2);

%*********************
%Calc. interp. indices
%********************* 
N1=GFP(1)*XEC+GFP(2);

N1=floor(N1);
N1(N1<1)=1;
N1(N1>=NG)=NG-1;
N2=N1+1;

%*******************************
%Interp. to exp. cell boundaries
%*******************************
IGC=IGT(N1)+(XEC-XG(N1)).*(IGT(N2)-IGT(N1))./(XG(N2)-XG(N1));

%***********************************
%Integrate over exp. cell boundaries
%***********************************
jj=1;
kk=0;
IF(1:NE)=0;
for ii=1:NG
    if XG(ii)>XEC(jj) && XG(ii)<=XEC(jj+1)
        if kk==0
            kk=1;
            I=(IGT(ii)+IGC(jj))/2;
            dX=XG(ii)-XEC(jj);
        else
            I=(IGT(ii)+IGT(ii-1))/2;
            dX=XG(ii)-XG(ii-1);
        end
        IF(jj)=IF(jj)+I*dX;
    elseif XG(ii)>XEC(jj+1)
        I=(IGC(jj+1)+IGT(ii-1))/2;
        dX=XEC(jj+1)-XG(ii-1);
        IF(jj)=IF(jj)+I*dX;
        if jj==NE
            break
        else
            jj=jj+1;
            I=(IGT(ii)+IGC(jj))/2;
            dX=XG(ii)-XEC(jj);
            IF(jj)=IF(jj)+I*dX;        
        end
    end
end
IF=IF./XEW;

%*****************
%Calc. reduced chi
%*****************
CHI=(sum((WT(LG==1).*(IF(LG==1)-IE(LG==1))./IEE(LG==1)).^2)/((NEF-1)))^.5;

end