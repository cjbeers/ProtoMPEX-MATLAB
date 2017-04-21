clear all
close all
clc

WINDOW=[4805.8 4806.2];

NE=8;
NR=0.1;
SI=35000;

PLOT_LOGIC=1;
ERROR='FILL';
TEXT_BOX='on';

SAVE_LOGIC=0;

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
SPEC.LOR.NX_GAM=300;                    
SPEC.LOR.NGAM=15; 
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||||   PARALLEL PROCESSING OPTIONS    ||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
PARALLEL.PAR_LOGIC=0;                     
PARALLEL.NAP=24;  
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||| DEFINE SPECTRUM and PLOT OPTIONS ||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
DFSS.SCALE.LOGIC=0; 
DFSS.CROSS.LOGIC=0; 

TRAN.MIN_RATIO=0;      
TRAN.REF=1.00028;  

SPEC.CONT_LOGIC=1;
SPEC.NORM_LOGIC=1;
SPEC.SUM.LOGIC=0;

PLOT.SPEC.LOGIC=0;
PLOT.HAM.LOGIC=0;  
PLOT.QS.LOGIC=0; 
PLOT.GEO.LOGIC=0;
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||||| DEFINE SOLVER OPTIONS |||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SOLVER.QSA=1;                      
SOLVER.NDT=30;
SOLVER.QSA_LOGIC=1; 
SOLVER.MAN_LOGIC=0; 
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||||| DEFINE FIELD AND ATOM OPTIONS ||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
OBS.MODE='NO_INT';
OBS.VIEW.POLAR=pi/2;
OBS.VIEW.AZIM=0;

OBS.POL.LOGIC=1;
OBS.POL.ANG=0;
OBS.POL.T=[1 0];

B.MAG=1;

EDC.MAG=[0 0 0]*1e5;

ERF.MAG=[0 0 0]*1e5;
ERF.ANG=[0 0 0];
ERF.NU=1;

RAD.ATOM='ArII';
RAD.WAVE='4806A';
RAD.FS=1;
RAD.PQN=[2,4];
RAD.SPIN=.5;

VAR.B=B;
VAR.EDC=EDC;
VAR.ERF=ERF;
VAR.OBS=OBS;
VAR.RAD=RAD;
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%*******************************************
%Generate parameter information for text box
%*******************************************
TEXT{1}=['B\phantom{$_{DC}$} =[0.0,0.0,' num2str(B.MAG,'%3.1f') '] T']; 
TEXT{2}=['E$_{DC}$ =[' num2str(EDC.MAG(1)/1e5,'%3.1f') ',' num2str(EDC.MAG(2)/1e5,'%3.1f') ',' num2str(EDC.MAG(3)/1e5,'%3.1f') '] kV/cm']; 
TEXT{3}=['E$_{RF}$ =[' num2str(ERF.MAG(1)/1e5,'%3.1f') ',' num2str(ERF.MAG(2)/1e5,'%3.1f') ',' num2str(ERF.MAG(3)/1e5,'%3.1f') '] kV/cm']; 
TEXT{4}=['[$\theta,\phi$]=[' num2str(OBS.VIEW.POLAR*180/pi,'%3.0f') ',' num2str(OBS.VIEW.AZIM*180/pi,'%3.0f') '] degrees'];
if OBS.POL.LOGIC==0
    TEXT{5}='Unpolarized';
else
    TEXT{5}=['$\theta_{P}\hspace{.26cm}$ =' num2str(OBS.POL.ANG*180/pi,'%3.0f') ' degrees $-$ [$T_1,T_2$]=[' num2str(OBS.POL.T(1)*100,'%3.1f') ',' num2str(OBS.POL.T(2)*100,'%3.1f') '] $\%$'];
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
OPT.PARALLEL=PARALLEL;
OPT.DFSS=DFSS;
OPT.TRAN=TRAN;
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
AXIS=DATA.SPECTRA.AXIS;
CONT=DATA.SPECTRA.CONT;

I_C=CONT.I;
X_C=CONT.X*1e10;

NG=AXIS.NG;
XL=AXIS.XL*1e10;
XU=AXIS.XU*1e10;

%***********************
%Assign the group number
%***********************
HIT=0;
for ii=1:NG
    if WINDOW(1)>XL(ii)&&WINDOW(1)<XU(ii)
        HIT=ii;
        break
    end
    
    if WINDOW(2)>XL(ii)&&WINDOW(2)<XU(ii)
        HIT=ii;
        break
    end
end
    
if HIT==0
    fprintf('\n*********************************************\n');
    fprintf('** Bad Wavelength Window ~ I PITY THE FOOL **\n');
    fprintf('*********************************************\n');
    return
end

%***********
%Axis limits
%***********
if WINDOW(1)>XL(HIT)
    AL1=WINDOW(1);
else
    AL1=XL(HIT);
end

if WINDOW(2)<XU(HIT)
    AL2=WINDOW(2);
else
    AL2=XU(HIT);
end

%******************
%Assign axis matrix
%******************
AM=[AL1,AL2,0,1.05];

%***********
%Assign data
%***********
LOG=X_C>=AL1&X_C<=AL2;
X_C=X_C(LOG);
I_C=I_C(LOG);

%******************
%Normalize the data 
%******************
I_C=I_C/max(I_C);

%***********************************
%Calc. the cell edge wavelength grid 
%***********************************
XEC=linspace(AL1,AL2,NE+1);

%*****************
%Pixelate the data
%*****************
[XE,IE]=PIXELATE(NE,XEC,X_C,I_C);

%***************
%Calc. the noise
%***************
IEE=(NR+(IE/SI).^5)/2;

%*****************************
%Add the noise to the spectrum
%*****************************
IE=IE+NR*(rand(1,NE)-1/2)+(IE/SI).^5.*(rand(1,NE)-1/2);  

if PLOT_LOGIC==1
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

if SAVE_LOGIC==1
    %*************************************
    %Assign data sturcture for SPECTRA FIT
    %*************************************
    EXP.NE=NE;
    EXP.XE=XE;
    EXP.IE=IE;
    EXP.IEE=IEE;

    %*******************
    %Save data structure
    %*******************
    %save('FIT_DATA.mat','EXP')
end

%***********
%Remove path
%***********
rmpath(PATH)
