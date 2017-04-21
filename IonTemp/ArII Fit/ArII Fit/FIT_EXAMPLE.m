
function [KTN, CHI] = FIT_EXAMPLE(DATA,BIN)

%**************************************************************************
%Start Code
%**************************************************************************
 
PLOTIONFIT=1;

%*****************************************
%Theortical center wavelength of transtion
%*****************************************
CW=4806.02;

%***********
%Assign data
%***********
X=DATA.X*10;
I=DATA.I;

%******************************************
%Data range of interest (based on raw data)
%******************************************
BD_X=[4805.8 4806.2];

%************************************************
%Background range of interest (based on raw data)
%************************************************
BD_BK=[4808 4809];

%***************
%Remove baseline
%***************
LOG=X>=BD_BK(1)&X<=BD_BK(2);
I=I-sum(I(LOG))/sum(LOG);

%************************
%Remove non-relevant data
%************************
LOG=X>=BD_X(1)&X<=BD_X(2);
N=sum(LOG);
X=X(LOG);
I=I(LOG);

%*******************************************************
%Shift the data to be center about theortical wavelength
%*******************************************************
[~,IND]=max(I);
X=X+(CW-X(IND));

%*******************
%Normalize intensity
%*******************
I=I/max(I);

%************************************************************************
%Assign intensity error ~ example, calculate from noise and possion stat.
%************************************************************************
IE(1:N)=0.05;

%************************************
%Assign the data to the EXP structure
%************************************
EXP.NE=N;
EXP.XE=X;
EXP.IE=I;
EXP.IEE=IE;

%**************************************************************************
%**************************************************************************

%--------------------------------------------------------------------------
%NOTE this parameter (SIG) is defined as f(x)=I*exp(-(x-LAM)^2/SIG^2), the
%nominal Gaussian function is f(x)=I*exp(-(x-LAM)^2/(2*SIG_NOMINAL^2))
%--------------------------------------------------------------------------

%******************************
%Assign the insturment function 
%******************************
INS{1}=1;         %Scalar - Number of Gaussian functions
INS{2}=1;         %Array - I of Guassian Functions
INS{3}=0;         %Array - LAM of Guassian Functions
INS{4}=0.16;      %Array - SIG of Guassian Functions



%************
%Fit the data
%************
[B,KTN,CHI,RESULTS]=FIT_DATA(EXP,INS,BIN);


if PLOTIONFIT==1;
 
figure
hold on
plot(RESULTS.XG,RESULTS.IG,'-k','LineWidth',5)
plot(EXP.XE,EXP.IE,'sk','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',18)
hold off
xlabel(['Wavelength (' char(197) ')'],'FontSize',40) 
ylabel('Intensity (a.u.)','FontSize',40)
title(['\chi= ' num2str(CHI) ' and KT=' num2str(KTN) ' eV' ' and B=' num2str(B) ' T'],'FontSize',40,'FontWeight','Normal')
grid on
set(gca,'FontSize',40)
axis tight
end
end