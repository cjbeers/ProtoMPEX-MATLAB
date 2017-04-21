function SPEC_PLOT(SPECTRA,OBS,FIELD,OPT)

%************
%Assign input
%************
DISC=SPECTRA.DISC;
AXIS=SPECTRA.AXIS;

POL=OBS.POL;
VIEW=OBS.VIEW;

B=FIELD.B;
EDC=FIELD.EDC;
ERF=FIELD.ERF;

PLOT=OPT.PLOT;
SPEC=OPT.SPEC;
DFSS=OPT.DFSS;

%************
%Assign logic
%************
CONT_LOG=SPEC.CONT_LOGIC;
NORM_LOG=SPEC.NORM_LOGIC;
SUM_LOG=SPEC.SUM.LOGIC;
SC_LOG=DFSS.SCALE.LOGIC;
CR_LOG=DFSS.CROSS.LOGIC;
PEAK_LOG=strcmpi(DFSS.CROSS.PEAK,'0')~=1;
DIP_LOG=strcmpi(DFSS.CROSS.DIP,'0')~=1;

PLOT_AT=PLOT.ATOMIC.LOGIC;
PLOT_CR=PLOT.CROSS.LOGIC;

PLOT_PEAK=PLOT.CROSS.PEAK;
PLOT_DIP=PLOT.CROSS.DIP;
PLOT_TOT=PLOT.CROSS.TOTAL;

%******************************************
%Assign transition quantum state parameters
%******************************************
LL_ST=DISC.FULL.STATE.LL;
UL_ST=DISC.FULL.STATE.UL;
QSAN_ST=DISC.FULL.STATE.QSAN;

%***************************
%Assign degeneracy parameter
%***************************
if SUM_LOG==1
    ND_D=DISC.SUM.ND;    
else
    ND_D=[];
end

%**********************
%Define axis parameters
%**********************
NG=AXIS.NG;
XL=AXIS.XL;
XU=AXIS.XU;
I_D_MIN=AXIS.I_D_MIN;
I_D_MAX=AXIS.I_D_MAX;
if CONT_LOG==1  
    I_C_MIN=AXIS.I_C_MIN;
    I_C_MAX=AXIS.I_C_MAX;
else
    I_C_MIN(1:NG)=0;
    I_C_MAX(1:NG)=0;
end

%***************************
%Assign number of axis ticks
%***************************
NXTICK=PLOT.SPEC.NXTICK;
NYTICK=PLOT.SPEC.NYTICK;

%*******************************************
%Generate parameter information for text box
%*******************************************
TEXT{1}=['B\phantom{$_{DC}$} =[0.0,0.0,' num2str(B.MAG,'%3.1f') '] T']; 
TEXT{2}=['E$_{DC}$ =[' num2str(EDC.MAG(1)/1e5,'%3.1f') ',' num2str(EDC.MAG(2)/1e5,'%3.1f') ',' num2str(EDC.MAG(3)/1e5,'%3.1f') '] kV/cm']; 
TEXT{3}=['E$_{RF}$ =[' num2str(sum(ERF.MAG(:,1))/1e5,'%3.1f') ',' num2str(sum(ERF.MAG(:,2))/1e5,'%3.1f') ',' num2str(sum(ERF.MAG(:,3))/1e5,'%3.1f') '] kV/cm']; 
TEXT{4}=['[$\theta,\phi$]=[' num2str(VIEW.POLAR*180/pi,'%3.0f') ',' num2str(VIEW.AZIM*180/pi,'%3.0f') '] degrees'];
if POL.T(1)==POL.T(2)
    TEXT{5}='Unpolarized';
elseif POL.T(2)==0
    TEXT{5}=['$\theta_{P}\hspace{.26cm}$ =' num2str(POL.ANG*180/pi,'%3.0f') ' degrees'];
else
    TEXT{5}=['$\theta_{P}\hspace{.26cm}$ =' num2str(POL.ANG*180/pi,'%3.0f') ' degrees $-$ [$T_1,T_2$]=[' num2str(POL.T(1)*100,'%3.1f') ',' num2str(POL.T(2)*100,'%3.1f') '] $\%$'];
end

%*****************
%Assign axis names
%*****************
XNAME=['Wavelength (' char(197) ')'];
if NORM_LOG==0 && SC_LOG==0
    YNAME.DISC='A_{ij} (Hz)';
    YNAME.CONT='Intensity (a.u.)';
elseif NORM_LOG==1 && SC_LOG==0
    YNAME.DISC='Normalized A_{ij}';
    YNAME.CONT='Normalized Intensity';
elseif NORM_LOG==0 && SC_LOG==1
    YNAME.DISC='DFSS A_{ij} (Hz)';
    YNAME.CONT='Intensity (a.u.)';
elseif NORM_LOG==1 && SC_LOG==1
    YNAME.DISC='Normalized DFSS A_{ij}';
    YNAME.CONT='Normalized Intensity';
end

%***************
%Allocate memory
%***************
AM=cell(1,NG);
SCALE(1:NG)=0;
XTICK=cell(1,NG);
YTICK=cell(1,NG);
XTICKLABEL=cell(1,NG);
YTICKLABEL=cell(1,NG);

for ii=1:NG
    %***********
    %Axis limits
    %***********
    AL_XL=XL(ii)*1e10;
    AL_XU=XU(ii)*1e10;
    
    AL_D_MIN=I_D_MIN(ii);
    AL_D_MAX=I_D_MAX(ii);
    AL_D=max(abs([AL_D_MIN AL_D_MAX]));
    
    AL_C_MIN=I_C_MIN(ii);
    AL_C_MAX=I_C_MAX(ii);
    AL_C=max(abs([AL_C_MIN AL_C_MAX]));
    
    AL_ND=max(ND_D); 
    AL_LL=max(LL_ST); 
    AL_UL=max(UL_ST); 
    AL_QSAN=max(QSAN_ST); 
    
    AM{ii}.D=[[AL_XL AL_XU],[0 AL_D]*1.05];
    AM{ii}.DD=[[AL_XL AL_XU],[-AL_D AL_D]*1.05];
    AM{ii}.C=[[AL_XL AL_XU],[0 AL_C]*1.05];
    AM{ii}.CC=[[AL_XL AL_XU],[-AL_C AL_C]*1.05];
    AM{ii}.ND=[[AL_XL AL_XU],0,AL_ND+1];
    AM{ii}.LL=[[AL_XL AL_XU],0,AL_LL+1];
    AM{ii}.UL=[[AL_XL AL_XU],0,AL_UL+1];
    AM{ii}.QSAN=[[AL_XL AL_XU],0,AL_QSAN+1];
    
    %*****************************
    %Discrete line profile scaling
    %***************************** 
    SCALE(ii)=AL_C/AL_D;
    
    %**********************
    %X and Y-Tick locations
    %**********************    
    T1=linspace(AL_XL,AL_XU,NXTICK);
    T2=linspace(-AL_C,AL_C,2*NYTICK+1);

    XTICK{ii}=T1;
    YTICK{ii}=T2; 
   
    %*******************
    %X and Y-Tick labels
    %*******************    
    XTICKLABEL{ii}=cell(1,NXTICK);
    YTICKLABEL{ii}=cell(1,2*NYTICK+1);
    
    XFORMAT='%4.2f';
    if AL_C==1
        YFORMAT='%2.2f';
    else
        YFORMAT='%2.1E';
    end 
    
    for jj=1:NXTICK
        XTICKLABEL{ii}{jj}=num2str(XTICK{ii}(jj),XFORMAT);
    end  
    
    for jj=1:2*NYTICK+1
        if jj<=NYTICK
            YTICKLABEL{ii}{jj}=' ';
        elseif jj==NYTICK+1
            YTICKLABEL{ii}{jj}='0';
        else
            YTICKLABEL{ii}{jj}=num2str(YTICK{ii}(jj),YFORMAT);
        end
    end  
end

%************************************
%Assign FORMAT structure for plotting
%************************************
FORMAT.NG=NG;
FORMAT.TEXT=TEXT;
FORMAT.XNAME=XNAME;
FORMAT.YNAME=YNAME;
FORMAT.AM=AM;
FORMAT.SCALE=SCALE;
FORMAT.XTICK=XTICK;
FORMAT.YTICK=YTICK;
FORMAT.XTICKLABEL=XTICKLABEL;
FORMAT.YTICKLABEL=YTICKLABEL;

%***********************
%Plot the atomic spectra
%***********************
if PLOT_AT==1
    ATOMIC_PLOT(SPECTRA,FORMAT,OPT)
end

if PLOT_CR==1 && CR_LOG==1 
    %********************************
    %Plot the crossover peaks spectra
    %********************************
    if PLOT_PEAK==1 && PEAK_LOG==1
        CROSS_PEAK_PLOT(SPECTRA,FORMAT,OPT)
    end
    
    %*******************************
    %Plot the crossover dips spectra
    %*******************************
    if PLOT_DIP==1  && DIP_LOG==1
        CROSS_DIP_PLOT(SPECTRA,FORMAT,OPT)
    end

    %*********************************
    %Plot the atomic+crossover spectra
    %*********************************
    if PLOT_TOT==1 && (PEAK_LOG>0 || DIP_LOG>0)
        CROSS_TOTAL_PLOT(SPECTRA,FORMAT,OPT)
    end
end

end
