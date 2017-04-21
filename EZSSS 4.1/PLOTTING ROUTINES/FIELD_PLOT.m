clear all
close all
clc

COL={'k','r','b','m','g','c'};

NORM_PLOT=1;

DIS_PLOT=1;
CON_DIS_PLOT=1;
CON_PLOT=1;

LEG_SIZE=18;

TEXT_BOX='on';
TEXT_SIZE=26;

NXTICK=5;
NYTICK=5;

XLIMITS=[];

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||| DEFINE DOPPLER BROADENING OPTIONS |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SPEC.DOP.NTG=1;                       
SPEC.DOP.I=1;                     
SPEC.DOP.X=0*1e-10;               
SPEC.DOP.kT=0;
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||| DEFINE GAUSSIAN BROADENING OPTIONS |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SPEC.GAU.NF=1;                        
SPEC.GAU.I=1;                
SPEC.GAU.X=0*1e-10;               
SPEC.GAU.SIG=0.0033*1e-10;         
SPEC.GAU.NX_SIG=30;                    
SPEC.GAU.NSIG=5; 
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||| DEFINE LORENTZIAN BROADENING OPTIONS ||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SPEC.LOR.NF=0;
SPEC.LOR.I=1;                          
SPEC.LOR.X=0;                          
SPEC.LOR.GAM=.014*1e-10;                  
SPEC.LOR.NX_GAM=30;                    
SPEC.LOR.NGAM=15; 
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||| DEFINE SPECTRUM and PLOT OPTIONS ||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SPEC.CONT=1;
SPEC.NORM=1;

SPEC.SUM.LOGIC=1;
SPEC.SUM.MODE='DEGEN';
SPEC.SUM.DX_RATIO=1e-8;

PLOT.SPEC.LOGIC=0;

PLOT.GEO.LOGIC=0;
PLOT.GEO.TEXT_BOX='on';
PLOT.GEO.FIG_VIEW=[];
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
OBS.MODE='NO_INT';
OBS.VIEW.POLAR=pi/2;
OBS.VIEW.AZIM=0;

OBS.POL.LOGIC=1;
OBS.POL.ANG=0;
OBS.POL.T=[1 0];

RAD.ATOM='H';
RAD.FS=1;
RAD.PQN=[2,4];
RAD.SPIN=.5;

%*************************
%Number of spectra to plot
%*************************
NS=2;

B{1}.MAG=0.03;
EDC{1}.MAG=[0 0 1]*1e5;
ERF{1}.NU=1;
ERF{1}.MAG=[0 0 0]*1e5;
ERF{1}.ANG=[0 0 0];

B{2}.MAG=0.03;
EDC{2}.MAG=[0 1 0]*1e5;
ERF{2}.NU=1;
ERF{2}.MAG=[0 0 0]*1e5;
ERF{2}.ANG=[0 0 0];

VAR=cell(1,NS);
for ii=1:NS
    VAR{ii}.B=B{ii};
    VAR{ii}.EDC=EDC{ii};
    VAR{ii}.ERF=ERF{ii};
    VAR{ii}.OBS=OBS;
    VAR{ii}.RAD=RAD;
end
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%*******************************************
%Generate parameter information for text box
%*******************************************
TEXT{1}=['[$\theta,\phi$]=[' num2str(OBS.VIEW.POLAR*180/pi,'%3.0f') ',' num2str(OBS.VIEW.AZIM*180/pi,'%3.0f') '] degrees'];
if OBS.POL.LOGIC==0
    TEXT{2}='Unpolarized';
else
    TEXT{2}=['$\theta_{P}\hspace{.26cm}$ =' num2str(OBS.POL.ANG*180/pi,'%3.0f') ' degrees $-$ [$T_1,T_2$]=[' num2str(OBS.POL.T(1)*100,'%3.1f') ',' num2str(OBS.POL.T(2)*100,'%3.1f') '] $\%$'];
end

%***************
%Generate legend
%***************
LEG=cell(1,NS);
for ii=1:NS
    LEG{ii}=char('   ',...
                ['B_z=' num2str(B{ii}.MAG,'%3.1f') ' T'],...
                ['E_{DC}=[' num2str(EDC{ii}.MAG(1)/1e5,'%3.1f') ',' num2str(EDC{ii}.MAG(2)/1e5,'%3.1f') ',' num2str(EDC{ii}.MAG(3)/1e5,'%3.1f') '] kV/cm'],...
                ['E_{RF} =[' num2str(ERF{ii}.MAG(1)/1e5,'%3.1f') ',' num2str(ERF{ii}.MAG(2)/1e5,'%3.1f') ',' num2str(ERF{ii}.MAG(3)/1e5,'%3.1f') '] kV/cm'],...
                '   '); 
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
DATA=cell(1,NS);
for ii=1:NS
    [DATA{ii},~]=EZSSS(VAR{ii},OPT);
end

%************************
%Assign the spectral data
%************************
AXIS=cell(1,NS);
DISC=cell(1,NS);
CONT=cell(1,NS);

I_D=cell(1,NS);
X_D=cell(1,NS);
NT_D(1:NS)=0;
DEG=cell(1,NS);

I_C=cell(1,NS);
X_C=cell(1,NS);

NG(1:NS)=0;
I_D_MAX=cell(1,NS);
I_C_MAX=cell(1,NS);
XL=cell(1,NS);
XU=cell(1,NS);
for ii=1:NS
    AXIS{ii}=DATA{ii}.SPECTRA.AXIS;
    DISC{ii}=DATA{ii}.SPECTRA.DISC;
    CONT{ii}=DATA{ii}.SPECTRA.CONT;

    I_D{ii}=DISC{ii}.SUM.I;
    X_D{ii}=DISC{ii}.SUM.X;
    NT_D(ii)=DISC{ii}.SUM.NT;
    DEG{ii}=DISC{ii}.SUM.ND;

    I_C{ii}=CONT{ii}.I;
    X_C{ii}=CONT{ii}.X;

    NG(ii)=AXIS{ii}.NG;
    I_D_MAX{ii}=AXIS{ii}.I_D_MAX;
    I_C_MAX{ii}=AXIS{ii}.I_C_MAX;
    XL{ii}=AXIS{ii}.XL;
    XU{ii}=AXIS{ii}.XU;
end

%***********************************************************
%Assign indice associated with max number of spectral groups
%***********************************************************
[~,IND]=max(NG);

XL_TEMP(1:NS)=0;
XU_TEMP(1:NS)=0;
I_D_MAX_TEMP(1:NS)=0;
I_C_MAX_TEMP(1:NS)=0;
DEG_TEMP(1:NS)=0;

PH(1:NS)=0;

for ii=1:NG(IND)
    %***********
    %Axis limits
    %***********
    for jj=1:NS
        XL_TEMP(jj)=XL{jj}(ii);
        XU_TEMP(jj)=XU{jj}(ii);
        I_D_MAX_TEMP(jj)=I_D_MAX{jj}(ii);
        I_C_MAX_TEMP(jj)=I_C_MAX{jj}(ii);
        DEG_TEMP(jj)=max(DEG{jj});
    end
    AL1=min(XL_TEMP)*1e10;
    AL2=max(XU_TEMP)*1e10;
    AL3=max(I_D_MAX_TEMP);
    AL4=max(I_C_MAX_TEMP);
    AL5=max(DEG_TEMP);
    
    %**********************************
    %Define user x-limits if applicable
    %**********************************
    if isempty(XLIMITS)==0
        AL1=XLIMITS(1);
        AL2=XLIMITS(2);
    end
    
    %**************************
    %Calc. normalization factor 
    %**************************
    if NORM_PLOT==1
        NORM_D=AL3;
        NORM_C=AL4;
        
        AL3=AL3/NORM_D;
        AL4=AL4/NORM_C;
    else
        NORM_D=1;
        NORM_C=1;
    end        
    
    AM1=[[AL1 AL2],[0 AL3]*1.05];
    AM2=[[AL1 AL2],0,AL5+1];
    AM3=[[AL1 AL2],[-AL4 AL4]*1.05];
    AM4=[[AL1 AL2],[0 AL4]*1.05];
    
    %*****************************
    %Discrete line profile scaling
    %***************************** 
    SCALE=AL4/AL3;
    
    %**********************
    %X and Y-Tick locations
    %**********************    
    T1=linspace(AL1,AL2,NXTICK);
    T2=linspace(-AL4,0,NYTICK);
    T3=linspace(0,AL4,NYTICK);

    XTICK=T1;
    YTICK=[T2(1:NYTICK-1) T3(1:NYTICK)]; 

    %*******************
    %X and Y-Tick labels
    %*******************    
    XTICKLABEL=cell(1,NXTICK);
    YTICKLABEL=cell(1,2*NYTICK+1);
    
    XFORMAT='%4.2f';
    if AL4==1
        YFORMAT='%2.2f';
    else
        YFORMAT='%2.1E';
    end 
    
    for jj=1:NXTICK
        XTICKLABEL{jj}=num2str(XTICK(jj),XFORMAT);
    end  
    
    for jj=1:2*NYTICK-1
        if (jj<NYTICK)
            YTICKLABEL{jj}=' ';
        elseif (jj==NYTICK)
            YTICKLABEL{jj}='0';
        else
            YTICKLABEL{jj}=num2str(YTICK(jj),YFORMAT);
        end
    end  

    if DIS_PLOT==1 
        if NS==1
            SIZE=38;
        elseif NS==2
            SIZE=24;
        elseif NS==3
            SIZE=16;
        else
            SIZE=12;
        end
        
        figure      
        for kk=1:NS
            %*********************
            %Discrete line profile
            %*********************             
            subplot(2,NS,kk)
            hold on
            for jj=1:NT_D(kk)
                PH(kk)=plot([X_D{kk}(jj) X_D{kk}(jj)]*1e10,[0 I_D{kk}(jj)]/NORM_D,COL{kk},'LineWidth',3);
            end
            hold off
            if strcmpi(TEXT_BOX,'on')==1 && kk==1
                annotation('textbox',[0.135 0.71 0.25 0.2],'LineStyle','none','FontSize',SIZE, 'Interpreter', 'latex','string',TEXT);
            end
            legend(PH(kk),LEG(kk),'Location','NorthEast','Box','off','FontSize',SIZE)
            xlabel(['Wavelength (' char(197) ')'],'FontSize',SIZE)
            ylabel('Intensity (a.u.)','FontSize',SIZE)
            axis(AM1)
            grid on
            AH=gca;
            AH.XTick=XTICK;
            AH.XTickLabel=XTICKLABEL;
            AH.FontSize=SIZE;

            %************************
            %Degeneracy of transition
            %************************    
            subplot(2,NS,NS+kk)
            plot(X_D{kk}*1e10,DEG{kk},'o','MarkerEdgeColor',COL{kk},'MarkerFaceColor',COL{kk})
            xlabel(['Wavelength (' char(197) ')'],'FontSize',SIZE)
            ylabel('Degeneracy','FontSize',SIZE)
            axis(AM2)
            grid on
            AH=gca;
            AH.XTick=XTICK;
            AH.XTickLabel=XTICKLABEL;
            AH.FontSize=SIZE;
        end
    end

    if CON_DIS_PLOT==1
        %***********************************
        %Broadened and discrete line profile
        %***********************************  
        figure
        hold on
        for kk=1:NS
            PH(kk)=plot(X_C{kk}*1e10,I_C{kk}/NORM_C,COL{kk},'LineWidth',4.5);
            for jj=1:NT_D(kk)
                plot([X_D{kk}(jj) X_D{kk}(jj)]*1e10,[0 -I_D{kk}(jj)]*SCALE/NORM_D,COL{kk},'LineWidth',4.5)
            end
        end
        hold off
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.25 0.2],'LineStyle','none','FontSize',TEXT_SIZE, 'Interpreter', 'latex','string',TEXT);
        end
        legend(PH,LEG,'Location','NorthEast','Box','off','FontSize',LEG_SIZE)
        xlabel(['Wavelength (' char(197) ')'],'FontSize',38)
        ylabel('Intensity (a.u.)','FontSize',38)
        axis(AM3)
        grid on
        AH=gca;
        AH.XTick=XTICK;
        AH.XTickLabel=XTICKLABEL;
        AH.YTick=YTICK;
        AH.YTickLabel=YTICKLABEL;  
        AH.FontSize=38;
    end
       
    if CON_PLOT==1
        %**********************
        %Broadened line profile
        %********************** 
        figure
        hold on
        for kk=1:NS
            PH(kk)=plot(X_C{kk}*1e10,I_C{kk}/NORM_C,COL{kk},'LineWidth',4.5);
        end
        hold off
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.25 0.2],'LineStyle','none','FontSize',TEXT_SIZE, 'Interpreter', 'latex','string',TEXT);
        end
        legend(PH,LEG,'Location','NorthEast','Box','off','FontSize',LEG_SIZE)
        xlabel(['Wavelength (' char(197) ')'],'FontSize',38)
        ylabel('Intensity (a.u.)','FontSize',38)
        axis(AM4)
        grid on
        AH=gca;
        AH.XTick=XTICK;
        AH.XTickLabel=XTICKLABEL;
        AH.YTick=YTICK(NYTICK:2*NYTICK-1);
        AH.YTickLabel=YTICKLABEL(NYTICK:2*NYTICK-1);  
        AH.FontSize=38;
    end
end

%***********
%Remove path
%***********
rmpath(PATH)