clear all
clc

NE=75;
NR=0.1;
SI=35000;

CON_PLOT=1;

ERROR='FILL';

TEXT_BOX='on';

XLIMITS=[4805.8 4806.2];

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||| DEFINE DOPPLER BROADENING OPTIONS |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SPEC.DOP.NTG=1;                       
SPEC.DOP.I=1;                     
SPEC.DOP.X=0*1e-10;               
SPEC.DOP.kT=.85;
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||| DEFINE GAUSSIAN BROADENING OPTIONS |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SPEC.GAU.NF=1;                        
SPEC.GAU.I=1;                
SPEC.GAU.X=0*1e-10;               
SPEC.GAU.SIG=0.12*1e-10;         
SPEC.GAU.NX_SIG=300;                    
SPEC.GAU.NSIG=5; 
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||| DEFINE LORENTZIAN BROADENING OPTIONS ||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SPEC.LOR.NF=0;
SPEC.LOR.I=1;                          
SPEC.LOR.X=0;                          
SPEC.LOR.GAM=.014*1e-10;                  
SPEC.LOR.NX_GAM=3000;                    
SPEC.LOR.NGAM=15; 
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||| DEFINE SPECTRUM and PLOT OPTIONS ||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SPEC.NORM=1;

PLOT.SPEC.LOGIC=0;

PLOT.GEO.LOGIC=0;
PLOT.GEO.TEXT_BOX='on';
PLOT.GEO.FIG_VIEW=[0,0];
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||||| DEFINE SOLVER OPTIONS |||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SOLVER.QSA=1;                      
SOLVER.NDT=30;
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||||| DEFINE FIELD AND ATOM OPTIONS ||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
VAR.VIEW=[pi/2 0];
VAR.POL=[1 0];
VAR.B_MAG=0.874;
VAR.EDC_MAG=[0 0 0]*1e5;
VAR.NU=1;
VAR.ERF_MAG=[0 0 0]*1e5;
VAR.ERF_ANG=[0 0 0];
VAR.LINE.ATOM='ArII';
VAR.LINE.WAVE='4806A';
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%*******************************************
%Generate parameter information for text box
%*******************************************
TEXT{1}=['B\phantom{$_{DC}$} =[0.0,0.0,' num2str(VAR.B_MAG,'%3.1f') '] T']; 
TEXT{2}=['E$_{DC}$ =[' num2str(VAR.EDC_MAG(1)/1e5,'%3.1f') ',' num2str(VAR.EDC_MAG(2)/1e5,'%3.1f') ',' num2str(VAR.EDC_MAG(3)/1e5,'%3.1f') '] kV/cm']; 
TEXT{3}=['E$_{RF}$ =[' num2str(VAR.ERF_MAG(1)/1e5,'%3.1f') ',' num2str(VAR.ERF_MAG(2)/1e5,'%3.1f') ',' num2str(VAR.ERF_MAG(3)/1e5,'%3.1f') '] kV/cm']; 
TEXT{4}=['[$\theta,\phi$]=[' num2str(VAR.VIEW(1)*180/pi,'%3.0f') ',' num2str(VAR.VIEW(2)*180/pi,'%3.0f') '] degrees'];
if VAR.POL(1)==0
    TEXT{5}='Unpolarized';
elseif length(VAR.POL)<4
    TEXT{5}=['$\theta_{P}\hspace{.26cm}$ =' num2str(VAR.POL(2)*180/pi,'%3.0f') ' degrees'];
else
    TEXT{5}=['$\theta_{P}\hspace{.26cm}$ =' num2str(VAR.POL(2)*180/pi,'%3.0f') ' degrees $-$ [$T_1,T_2$]=[' num2str(VAR.POL(3)*100,'%3.1f') ',' num2str(VAR.POL(4)*100,'%3.1f') '] $\%$'];
end

%****************************
%Generate path name for EZSSS
%****************************
PATH=pwd;
for ii=length(PATH):-1:1
    if strcmpi(PATH(ii),filesep)==1
        PATH=PATH(1:ii-1);
        break
    end
end

%********
%Add path
%********
addpath(PATH)

%******************
%Assign the options
%******************
OPT.SOLVER=SOLVER;
OPT.SPEC=SPEC;
OPT.PLOT=PLOT;

%*********************
%Calculate the spectra
%*********************
[DATA,~]=EZSSS(VAR,OPT);

%************************
%Assign the spectral data
%************************
AXIS=DATA.AXIS;
CONT=DATA.CONT;

I_C=CONT.I;
X_C=CONT.X*1e10;

NG=AXIS.NG;
XL=AXIS.XL;
XU=AXIS.XU;

AL1=XLIMITS(1);
AL2=XLIMITS(2);

AM=[AL1,AL2,0,1.3];

%******************
%Normalize the data 
%******************
IND=X_C>=AL1&X_C<=AL2;
I_C=I_C/max(I_C(IND));

%***********************************
%Calc. the cell edge wavelength grid 
%***********************************
XEC=linspace(AL1,AL2,NE+1);

%*****************
%Pixelate the data
%*****************
[~,IE,XE]=Pixelate_Data(XEC,I_C,X_C);

%***************
%Calc. the noise
%***************
IEE=(NR+(IE/SI).^.5)/2;

%*****************************
%Add the noise to the spectrum
%*****************************
IE=IE+NR*(rand(1,NE)-1/2)+(IE/SI).^.5.*(rand(1,NE)-1/2);  

if CON_PLOT==1
    %**********************
    %Broadened line profile
    %********************** 
    figure
    hold on
    plot(X_C,I_C,'k','LineWidth',4.5);
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
    axis(AM)
    grid on
end

% %**********************
% %Prompt user for action
% %**********************
% IN=input('Save Data? Y/N [N]: ','s');
% 
% if strcmpi(IN,'Y')==1
%     %*************************************
%     %Assign data sturcture for SPECTRA FIT
%     %*************************************
%     EXP.NE=NE;
%     EXP.XE=XE;
%     EXP.IE=IE;
%     EXP.IEE=IEE;
% 
%     %*******************
%     %Save data structure
%     %*******************
%     save('FIT_DATA.mat','EXP')
% end


%***********
%Remove path
%***********
rmpath(PATH)
