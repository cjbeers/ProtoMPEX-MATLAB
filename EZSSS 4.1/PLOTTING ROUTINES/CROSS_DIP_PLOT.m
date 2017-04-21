function CROSS_DIP_PLOT(SPECTRA,FORMAT,OPT)

%***********************
%Assign input structures
%***********************
DISC=SPECTRA.DISC;

PLOT=OPT.PLOT;
SPEC=OPT.SPEC;
DFSS=OPT.DFSS;

%************
%Assign logic
%************
CONT_LOG=SPEC.CONT_LOGIC;
SUM_LOG=SPEC.SUM.LOGIC;
IND_LOG=PLOT.CROSS.INDEX;

PLOT_LL=PLOT.CROSS.LL;
PLOT_UL=PLOT.CROSS.UL;
PLOT_QSA=PLOT.CROSS.QSA;
PLOT_SUM=PLOT.CROSS.SUM;
PLOT_DISC=PLOT.CROSS.DISC;
PLOT_CONT=PLOT.CROSS.CONT;

%***************************************
%Assign spectra quantum state parameters
%***************************************
X_ST=DISC.FULL.DIP.X;
LL_ST=DISC.FULL.DIP.STATE.LL;
UL_ST=DISC.FULL.DIP.STATE.UL;
QSAN_ST=DISC.FULL.DIP.STATE.QSAN;
IND_ST=DISC.FULL.DIP.STATE.IND;

if SUM_LOG==1
    %*************************
    %Assign the atomic spectra
    %*************************
    I_D_ATOM=DISC.SUM.I;
    X_D_ATOM=DISC.SUM.X;
    NT_D_ATOM=DISC.SUM.NT;
    
    %****************************
    %Assign the crossover spectra
    %****************************
    I_D=DISC.SUM.DIP.I;
    X_D=DISC.SUM.DIP.X;
    NT_D=DISC.SUM.DIP.NT;
    ND_D=DISC.SUM.DIP.ND;
    
    %***********************
    %Assign degeneracy label
    %***********************
    if IND_LOG==1
        ND_LABEL=cell(1,NT_D);
        for ii=1:NT_D
            ND_LABEL{ii}=['ND ' num2str(ND_D(ii))];
        end
    end
else
    %*************************
    %Assign the atomic spectra
    %*************************
    I_D_ATOM=DISC.FULL.I;
    X_D_ATOM=DISC.FULL.X;
    NT_D_ATOM=DISC.FULL.NT;
    
    %****************************
    %Assign the crossover spectra
    %****************************
    I_D=DISC.FULL.DIP.I;
    X_D=DISC.FULL.DIP.X;
    NT_D=DISC.FULL.DIP.NT;
    ND_D=[];
    
    %*******************
    %Assign state labels
    %*******************
    if IND_LOG==1
        ST_LABEL=cell(1,NT_D);
        for ii=1:NT_D
            ST_LABEL{ii}={['LL ' num2str(LL_ST(ii,1)) ',' num2str(LL_ST(ii,2))],['UL ' num2str(UL_ST(ii))],['QS ' num2str(QSAN_ST(ii))]};
        end
        
        IND_LABEL=cell(1,NT_D);
        for ii=1:NT_D
            IND_LABEL{ii}=[num2str(IND_ST(ii,1)) ',' num2str(IND_ST(ii,2)) '-' num2str(QSAN_ST(ii))];
        end
    end
end

if CONT_LOG==1
    I_C=SPECTRA.CONT.DIP.I;
    X_C=SPECTRA.CONT.DIP.X;
end

%***************************
%Return if no crossover dips
%***************************
if NT_D==0
    return
end

%**********************************
%Assign the crossover peak/dip sign
%**********************************
SIGN_DIP=[' (' DFSS.CROSS.DIP ')'];

%*********************
%Assign text box logic
%*********************
TEXT_BOX=PLOT.SPEC.TEXT_BOX;

%*********************************
%Assign constant format parameters
%*********************************
NG=FORMAT.NG;
TEXT=FORMAT.TEXT;
XNAME=FORMAT.XNAME;
YNAME=FORMAT.YNAME;

for ii=1:NG
    %***************************************
    %Assign group specific format parameters
    %***************************************
    AM=FORMAT.AM{ii};
    SCALE=FORMAT.SCALE(ii);
    XTICK=FORMAT.XTICK{ii};
    YTICK=FORMAT.YTICK{ii};
    XTICKLABEL=FORMAT.XTICKLABEL{ii};
    YTICKLABEL=FORMAT.YTICKLABEL{ii};
    
    if PLOT_DISC==1 && PLOT_LL==1
        %*********************
        %Discrete line profile
        %*********************    
        figure
        subplot(6,1,1:3)
        hold on
        for jj=1:NT_D
            plot([X_D(jj) X_D(jj)]*1e10,[0 abs(I_D(jj))],'k','LineWidth',4.5)
        end
        hold off
        if SUM_LOG==0 && IND_LOG==1
            for jj=1:NT_D
                text(X_D(jj)*1e10,I_D(jj),ST_LABEL{jj}{1})
            end
        end
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
        end
        ylabel(YNAME.DISC,'FontSize',38)
        title(['Discrete Crossover Dip Spectra' SIGN_DIP],'FontSize',38)
        set(gca,'XTick',XTICK)
        set(gca,'XTickLabel',[])
        axis(AM.D)
        grid on   
        set(gca,'FontSize',38)

        %**************************************
        %Lower level state indice of transition
        %**************************************    
        subplot(6,1,4:6)
        hold on
        plot(X_ST*1e10,LL_ST(:,1),'o','MarkerEdgeColor','k','MarkerFaceColor','k')
        plot(X_ST*1e10,LL_ST(:,2),'o','MarkerEdgeColor','k','MarkerFaceColor','k')
        hold off
        xlabel(XNAME,'FontSize',38)
        ylabel('LL State Indice','FontSize',38)
        set(gca,'XTick',XTICK)
        set(gca,'XTickLabel',XTICKLABEL)
        axis(AM.UL)
        grid on
        set(gca,'FontSize',38)
    end
    
    if PLOT_DISC==1 && PLOT_UL==1
        %*********************
        %Discrete line profile
        %*********************    
        figure
        subplot(6,1,1:3)
        hold on
        for jj=1:NT_D
            plot([X_D(jj) X_D(jj)]*1e10,[0 abs(I_D(jj))],'k','LineWidth',4.5)
        end
        hold off
        if SUM_LOG==0 && IND_LOG==1
            for jj=1:NT_D
                text(X_D(jj)*1e10,I_D(jj),ST_LABEL{jj}{2})
            end
        end
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
        end
        ylabel(YNAME.DISC,'FontSize',38)
        title(['Discrete Crossover Dip Spectra' SIGN_DIP],'FontSize',38)
        set(gca,'XTick',XTICK)
        set(gca,'XTickLabel',[])
        axis(AM.D)
        grid on   
        set(gca,'FontSize',38)

        %**************************************
        %Upper level state indice of transition
        %**************************************    
        subplot(6,1,4:6)
        hold on
        plot(X_ST*1e10,UL_ST,'o','MarkerEdgeColor','k','MarkerFaceColor','k')
        hold off
        xlabel(XNAME,'FontSize',38)
        ylabel('UL State Indice','FontSize',38)
        set(gca,'XTick',XTICK)
        set(gca,'XTickLabel',XTICKLABEL)
        axis(AM.UL)
        grid on
        set(gca,'FontSize',38)
    end
    
    if PLOT_DISC==1 && PLOT_QSA==1
        %*********************
        %Discrete line profile
        %*********************    
        figure
        subplot(6,1,1:3)
        hold on
        for jj=1:NT_D
            plot([X_D(jj) X_D(jj)]*1e10,[0 abs(I_D(jj))],'k','LineWidth',4.5)
        end
        hold off
        if SUM_LOG==0 && IND_LOG==1
            for jj=1:NT_D
                text(X_D(jj)*1e10,I_D(jj),ST_LABEL{jj}{3})
            end
        end
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
        end
        ylabel(YNAME.DISC,'FontSize',38)
        title(['Discrete Crossover Dip Spectra' SIGN_DIP],'FontSize',38)
        set(gca,'XTick',XTICK)
        set(gca,'XTickLabel',[])
        axis(AM.D)
        grid on   
        set(gca,'FontSize',38)

        %**************************************
        %Upper level state indice of transition
        %**************************************    
        subplot(6,1,4:6)
        hold on
        plot(X_ST*1e10,QSAN_ST,'o','MarkerEdgeColor','k','MarkerFaceColor','k')
        hold off
        xlabel(XNAME,'FontSize',38)
        ylabel('QSA Indice','FontSize',38)
        set(gca,'XTick',XTICK)
        set(gca,'XTickLabel',XTICKLABEL)
        axis(AM.QSAN)
        grid on
        set(gca,'FontSize',38)
    end
    
    if PLOT_DISC==1 && PLOT_SUM==1 && SUM_LOG==1
        %*********************
        %Discrete line profile
        %*********************    
        figure
        subplot(6,1,1:3)
        hold on
        for jj=1:NT_D
            plot([X_D(jj) X_D(jj)]*1e10,[0 abs(I_D(jj))],'k','LineWidth',4.5)
        end
        hold off
        if IND_LOG==1
            for jj=1:NT_D
                text(X_D(jj)*1e10,I_D(jj),ND_LABEL{jj})
            end
        end
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
        end
        ylabel(YNAME.DISC,'FontSize',38)
        title(['Discrete Crossover Dip Spectra' SIGN_DIP],'FontSize',38)
        set(gca,'XTick',XTICK)
        set(gca,'XTickLabel',[])
        axis(AM.D)
        grid on   
        set(gca,'FontSize',38)

        %************************
        %Degeneracy of transition
        %************************    
        subplot(6,1,4:6)
        hold on
        plot(X_D*1e10,ND_D,'o','MarkerEdgeColor','k','MarkerFaceColor','k')
        hold off
        xlabel(XNAME,'FontSize',38)
        ylabel('Degeneracy','FontSize',38)
        set(gca,'XTick',XTICK)
        set(gca,'XTickLabel',XTICKLABEL)
        axis(AM.ND)
        grid on
        set(gca,'FontSize',38)
    end
    
    if PLOT_DISC==1
        %*********************
        %Discrete line profile
        %*********************    
        figure
        hold on
        for jj=1:NT_D
            plot([X_D(jj) X_D(jj)]*1e10,[0 abs(I_D(jj))],'k','LineWidth',4.5)
        end
        hold off
        if SUM_LOG==0 && IND_LOG==1
            for jj=1:NT_D
                text(X_D(jj)*1e10,I_D(jj),ST_LABEL{jj})
            end
        end
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
        end
        xlabel(XNAME,'FontSize',38)
        ylabel(YNAME.DISC,'FontSize',38)
        title(['Discrete Crossover Dip Spectra' SIGN_DIP],'FontSize',38)
        set(gca,'XTick',XTICK)
        set(gca,'XTickLabel',XTICKLABEL)
        axis(AM.D)
        grid on   
        set(gca,'FontSize',38)

        %**************************************
        %Discrete line profile with atomic data
        %**************************************    
        figure
        hold on
        for jj=1:NT_D_ATOM
            PH1=plot([X_D_ATOM(jj) X_D_ATOM(jj)]*1e10,[0 I_D_ATOM(jj)],'k','LineWidth',4.5);
        end
        if SUM_LOG==0 && IND_LOG==1
            for jj=1:NT_D_ATOM
                text(X_D_ATOM(jj)*1e10,I_D_ATOM(jj),num2str(jj))
            end
        end
        for jj=1:NT_D
            PH2=plot([X_D(jj) X_D(jj)]*1e10,[0 -abs(I_D(jj))],'r','LineWidth',4.5);
        end
        hold off
        if SUM_LOG==0 && IND_LOG==1
            for jj=1:NT_D
                text(X_D(jj)*1e10,-I_D(jj),IND_LABEL{jj},'Color','r')
            end
        end
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
        end
        legend([PH1 PH2],{'Atomic',['Crossover Dip' SIGN_DIP]})
        xlabel(XNAME,'FontSize',38)
        ylabel(YNAME.DISC,'FontSize',38)
        title('Discrete Spectra','FontSize',38)
        set(gca,'XTick',XTICK)
        set(gca,'XTickLabel',XTICKLABEL)
        axis(AM.DD)
        grid on   
        set(gca,'FontSize',38)
    end
    
    if PLOT_CONT==1 && CONT_LOG==1
        %***********************************
        %Broadened and discrete line profile
        %***********************************    
        figure
        hold on
        plot(X_C*1e10,abs(I_C),'k','LineWidth',4.5);
        for jj=1:NT_D
            plot([X_D(jj) X_D(jj)]*1e10,[0 -abs(I_D(jj))]*SCALE,'k','LineWidth',4.5)
        end
        hold off
        if SUM_LOG==0 && IND_LOG==1
            for jj=1:NT_D
                text(X_D(jj)*1e10,-I_D(jj),ST_LABEL{jj})
            end
        end
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
        end
        xlabel(XNAME,'FontSize',38)
        ylabel(YNAME.CONT,'FontSize',38)
        title(['Continuous Crossover Dip Spectra' SIGN_DIP],'FontSize',38,'Color','k','FontWeight','Bold')
        set(gca,'XTick',XTICK,'YTick',YTICK)
        set(gca,'XTickLabel',XTICKLABEL,'YTickLabel',YTICKLABEL)
        axis(AM.CC)
        grid on
        set(gca,'FontSize',38)

        %**********************
        %Broadened line profile
        %**********************    
        figure
        plot(X_C*1e10,abs(I_C),'k','LineWidth',4.5);
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
        end
        xlabel(XNAME,'FontSize',38)
        ylabel(YNAME.CONT,'FontSize',38)
        title(['Continuous Crossover Dip Spectra' SIGN_DIP],'FontSize',38,'Color','k','FontWeight','Bold')
        set(gca,'XTick',XTICK,'YTick',YTICK)
        set(gca,'XTickLabel',XTICKLABEL,'YTickLabel',YTICKLABEL)
        axis(AM.C)
        grid on
        set(gca,'FontSize',38)   
    end
end

end