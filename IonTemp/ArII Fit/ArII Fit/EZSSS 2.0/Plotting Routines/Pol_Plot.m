clear all
close all
clc

COL={'k','r','b'};

NORM_PLOT=1;

PLOT_UNPOL=1;

DIS_PLOT=1;
CON_DIS_PLOT=1;
CON_PLOT=1;

LEG_SIZE=30;

TEXT_BOX='on';
TEXT_SIZE=26;

NXTICK=5;
NYTICK=5;

XLIMITS=[4861.61 4863.76];

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
SPEC.NORM=0;

PLOT.SPEC.LOGIC=0;

PLOT.GEO.LOGIC=1;
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
VAR.VIEW=[pi/3.36 0];
VAR.B_MAG=3.5;
VAR.EDC_MAG=[0 0 0]*1e5;
VAR.NU=1;
VAR.ERF_MAG=[0 0 0]*1e5;
VAR.ERF_ANG=[0 0 0];
VAR.LINE={2  'H'  .5  [2 4]};

POL{1}=[1 0];
POL{2}=[1 pi/2];
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%*****************
%Number of spectra
%*****************
if PLOT_UNPOL==0
    NS=2;
else
    NS=3;
    POL{3}=0;
end

%*******************************************
%Generate parameter information for text box
%*******************************************
TEXT{1}=['B\phantom{$_{DC}$} =[0.0,0.0,' num2str(VAR.B_MAG,'%3.1f') '] T']; 
TEXT{2}=['E$_{DC}$ =[' num2str(VAR.EDC_MAG(1)/1e5,'%3.1f') ',' num2str(VAR.EDC_MAG(2)/1e5,'%3.1f') ',' num2str(VAR.EDC_MAG(3)/1e5,'%3.1f') '] kV/cm']; 
TEXT{3}=['E$_{RF}$ =[' num2str(VAR.ERF_MAG(1)/1e5,'%3.1f') ',' num2str(VAR.ERF_MAG(2)/1e5,'%3.1f') ',' num2str(VAR.ERF_MAG(3)/1e5,'%3.1f') '] kV/cm']; 
TEXT{4}=['[$\theta,\phi$]=[' num2str(VAR.VIEW(1)*180/pi,'%3.0f') ',' num2str(VAR.VIEW(2)*180/pi,'%3.0f') '] degrees'];

%***************
%Generate legend
%***************
LEG=cell(1,NS);
for ii=1:NS
    if POL{ii}(1)==0
        LEG{ii}='Unpolarized';
    elseif length(POL{ii})<4
        LEG{ii}=['\theta_{POL}=' num2str(POL{ii}(2)*180/pi,'%3.0f') '\circ'];
    else
        LEG{ii}=['\theta_{POL}=' num2str(POL{ii}(2)*180/pi,'%3.0f') '\circ - T_1=' num2str(POL{ii}(3),'%3.2f') ' - T_2=' num2str(POL{ii}(4),'%3.2f')];
    end
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

%*****************************************
%Calculate the two orthognal polarizations
%*****************************************
DATA=cell(1,NS);
for ii=1:NS
    VAR.POL=POL{ii};

    [DATA{ii},~]=EZSSS(VAR,OPT);
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
    AXIS{ii}=DATA{ii}.AXIS;
    DISC{ii}=DATA{ii}.DISC;
    CONT{ii}=DATA{ii}.CONT;

    I_D{ii}=DISC{ii}.I;
    X_D{ii}=DISC{ii}.X;
    NT_D(ii)=DISC{ii}.NT;
    DEG{ii}=DISC{ii}.DEG;

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
        if jj~=3
            I_D_MAX_TEMP(jj)=I_D_MAX{jj}(ii);
        end
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
    
    AM1=[[AL1 AL2],[-AL3 AL3]*1.05];
    AM2=[[AL1 AL2],-AL5-.1,AL5+.1];
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
        %*********************
        %Sign for double plots
        %*********************
        SIGN=[1,-1]; 

        %*********************
        %Discrete line profile
        %*********************    
        figure
        hold on
        for kk=1:2
            for jj=1:NT_D(kk)
                PH(kk)=plot([X_D{kk}(jj) X_D{kk}(jj)]*1e10,[0 SIGN(kk)*I_D{kk}(jj)]/NORM_D,COL{kk},'LineWidth',3);
            end
        end
        hold off
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.25 0.2],'LineStyle','none','FontSize',TEXT_SIZE, 'Interpreter', 'latex','string',TEXT);
        end
        legend(PH(1:2),LEG(1:2),'Location','NorthEast','Box','off','FontSize',LEG_SIZE)
        xlabel(['Wavelength (' char(197) ')'],'FontSize',38)
        ylabel('Intensity (a.u.)','FontSize',38)
        axis(AM1)
        grid on
        AH=gca;
        AH.XTick=XTICK;
        AH.XTickLabel=XTICKLABEL;
        AH.YTick=AH.YTick;
        AH.YTickLabel=abs(AH.YTick);  
        AH.FontSize=38;  

        %************************
        %Degeneracy of transition
        %************************    
        figure
        hold on
        for kk=1:2
            PH(kk)=plot(X_D{kk}*1e10,SIGN(kk)*DEG{kk},'o','MarkerEdgeColor',COL{kk},'MarkerFaceColor',COL{kk});
        end
        hold off
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.25 0.2],'LineStyle','none','FontSize',TEXT_SIZE, 'Interpreter', 'latex','string',TEXT);
        end
        legend(PH(1:2),LEG(1:2),'Location','NorthEast','Box','off','FontSize',LEG_SIZE)
        xlabel(['Wavelength (' char(197) ')'],'FontSize',38)
        ylabel('Degeneracy','FontSize',38)
        axis(AM2)
        grid on
        AH=gca;
        AH.XTick=XTICK;
        AH.XTickLabel=XTICKLABEL;
        AH.YTick=AH.YTick;
        AH.YTickLabel=abs(AH.YTick);  
        AH.FontSize=38;
    end

    if CON_DIS_PLOT==1
        %***********************************
        %Broadened and discrete line profile
        %***********************************  
        figure
        hold on
        for kk=1:NS
            PH(kk)=plot(X_C{kk}*1e10,I_C{kk}/NORM_C,COL{kk},'LineWidth',4.5);
        end
        for kk=1:2
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