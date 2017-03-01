function Spec_Plot(DATA,OBS,FIELD,OPT)

%**************************************************************************
%This function plots the line profile for a Guassian instrument function
%with full width at half maximum=FWHM
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
%                       deg - number of degenerate transitions with energy
%                             dE
%
%**************************************************************************

%***********************
%Assign input structures
%***********************
PLOT=OPT.PLOT;
SPEC=OPT.SPEC;

DISC=DATA.DISC;
if SPEC.CONT==1
    CONT=DATA.CONT;
    AXIS=DATA.AXIS;
end

POL=OBS.POL;
VIEW=OBS.VIEW;

B=FIELD.B;
EDC=FIELD.EDC;
ERF=FIELD.ERF;

%*****************
%Assign input data
%*****************
I_D=DISC.I;
X_D=DISC.X;
NT_D=DISC.NT;
DEG=DISC.DEG;

if SPEC.CONT==1
    I_C=CONT.I;
    X_C=CONT.X;

    NG=AXIS.NG;
    I_D_MAX=AXIS.I_D_MAX;
    I_C_MAX=AXIS.I_C_MAX;
    XL=AXIS.XL;
    XU=AXIS.XU;
else
    NG=1;
    I_D_MAX=max(I_D);
    I_C_MAX=max(I_D);
    XL=min(X_D);
    XU=max(X_D);
end

NXTICK=PLOT.SPEC.NXTICK;
NYTICK=PLOT.SPEC.NYTICK;
TEXT_BOX=PLOT.SPEC.TEXT_BOX;

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

for ii=1:NG
    %***********
    %Axis limits
    %***********
    AL1=XL(ii)*1e10;
    AL2=XU(ii)*1e10;
    AL3=I_D_MAX(ii);
    AL4=I_C_MAX(ii);
    AL5=max(DEG);     
    
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

    %*********************
    %Discrete line profile
    %*********************    
    figure
    subplot(6,1,1:3)
    hold on
    for jj=1:NT_D
        plot([X_D(jj) X_D(jj)]*1e10,[0 I_D(jj)],'k','LineWidth',4.5)
    end
    hold off
    if strcmpi(TEXT_BOX,'on')==1
        annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
    end
    ylabel('Intensity (a.u.)','FontSize',38)
    title('Discrete Spectra','FontSize',38)
    set(gca,'XTick',XTICK)
    set(gca,'XTickLabel',[])
    axis(AM1)
    grid on   
    set(gca,'FontSize',38)
    
    %************************
    %Degeneracy of transition
    %************************    
    subplot(6,1,4:6)
    hold on
    plot(X_D*1e10,DEG,'o','MarkerEdgeColor','k','MarkerFaceColor','k')
    hold off
    xlabel(['Wavelength (' char(197) ')'],'FontSize',38)
    ylabel('Degeneracy','FontSize',38)
    set(gca,'XTick',XTICK)
    set(gca,'XTickLabel',XTICKLABEL)
    axis(AM2)
    grid on
    set(gca,'FontSize',38)

    if SPEC.CONT==1
    %***********************************
    %Broadened and discrete line profile
    %***********************************    
        figure
        hold on
        plot(X_C*1e10,I_C,'k','LineWidth',4.5);
        for jj=1:NT_D
            plot([X_D(jj) X_D(jj)]*1e10,[0 -I_D(jj)]*SCALE,'k','LineWidth',4.5)
        end
        hold off
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
        end
        xlabel(['Wavelength (' char(197) ')'],'FontSize',38)
        ylabel('Intensity (a.u.)','FontSize',38)
        title('Continuous Spectra','FontSize',38,'Color','k','FontWeight','Bold')
        set(gca,'XTick',XTICK,'YTick',YTICK)
        set(gca,'XTickLabel',XTICKLABEL,'YTickLabel',YTICKLABEL)
        axis(AM3)
        grid on
        set(gca,'FontSize',38)

        %**********************
        %Broadened line profile
        %**********************    
        figure
        plot(X_C*1e10,I_C,'k','LineWidth',4.5);
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
        end
        xlabel(['Wavelength (' char(197) ')'],'FontSize',38)
        ylabel('Intensity (a.u.)','FontSize',38)
        title('Continuous Spectra','FontSize',38,'Color','k','FontWeight','Bold')
        set(gca,'XTick',XTICK,'YTick',YTICK(NYTICK:2*NYTICK-1))
        set(gca,'XTickLabel',XTICKLABEL,'YTickLabel',YTICKLABEL(NYTICK:2*NYTICK-1))
        axis(AM4)
        grid on
        set(gca,'FontSize',38)   
    end
end

end
