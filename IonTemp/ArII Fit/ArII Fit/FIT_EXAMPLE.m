
function [KTN, CHI] = FIT_EXAMPLE(DATA,BIN)

%**************************************************************************
%Start Code
%**************************************************************************
 
PLOTIONFIT=1;
FINDERROR=0;
PLOTERROR=0;

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
BD_X=[4804.1 4804.7];

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

%-------------------------------------------------------------------

if FINDERROR==1
WINDOW=[4805.6 4806.3];

NE=8;
NR=0.1;
SI=45000;

ERROR='FILL';
TEXT_BOX='off';

IE=I;
XE=X;
%***************
%Calc. the noise
%***************
IEE=(NR+(IE/SI).^5)/2;

%*****************************
%Add the noise to the spectrum
%*****************************
IE=IE+NR*(rand(1,NE)-1/2)+(IE/SI).^5.*(rand(1,NE)-1/2);


if PLOTERROR ==1
    %**********************
    %Broadened line profile
    %********************** 
    figure
    hold on
    plot(X,I,'k','LineWidth',4.5);
    plot(XE,IE,'rd','MarkerFaceColor','r','MarkerSize',13);
    if strcmpi(ERROR,'BAR')==1
        for jj=1:NE
            plot([XE(jj) XE(jj)],[-IEE(jj) IEE(jj)]+IE(jj),'-r','LineWidth',4)
        end
    elseif strcmpi(ERROR,'FILL')==1
        XE_FILL=[XE fliplr(XE)];
        IEE_FILL=[IEE -fliplr(IEE)]+[IE fliplr(IE)];

        fill(XE_FILL,IEE_FILL,'r','EdgeColor','none','FaceAlpha',.3)
    end
    hold off
    if strcmpi(TEXT_BOX,'on')==1
        annotation('textbox',[0.135 0.71 0.25 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
    end
    legend({'Continuous','Pixelated'},'Location','NorthEast','Box','off')
    xlabel(['Wavelength (' char(197) ')'],'FontSize',38)
    ylabel('Intensity (a.u.)','FontSize',38)
    set(gca,'FontSize',38)
    grid on
end
    IE(1:N)=IE;
end

%-------------------------------------------------------------------

%************************************************************************
%Assign intensity error ~ example, calculate from noise and possion stat.
%************************************************************************
if FINDERROR == 0
IE(1:N)=0.05;
end

%************************************
%Assign the data to the EXP structure
%************************************
EXP.NE=N;
EXP.XE=X;
EXP.IE=I;
EXP.IEE=IE;

%EXP.IE=I-IDK.INEW;

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