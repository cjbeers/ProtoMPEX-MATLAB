function CROSS_TOTAL_PLOT(SPECTRA,FORMAT,OPT)

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
PEAK_LOG=strcmpi(DFSS.CROSS.PEAK,'0')~=1;
DIP_LOG=strcmpi(DFSS.CROSS.DIP,'0')~=1;

PLOT_DISC=PLOT.CROSS.DISC;
PLOT_CONT=PLOT.CROSS.CONT;

%***********************
%Assign discrete spectra
%***********************
if SUM_LOG==1
    I_D_ATOM=DISC.SUM.I;
    X_D_ATOM=DISC.SUM.X;
    NT_D_ATOM=DISC.SUM.NT;
    
    if PEAK_LOG==1
        I_D_PEAK=DISC.SUM.PEAK.I;
        X_D_PEAK=DISC.SUM.PEAK.X;
        NT_D_PEAK=DISC.SUM.PEAK.NT;
    end
    
    if DIP_LOG==1
        I_D_DIP=DISC.SUM.DIP.I;
        X_D_DIP=DISC.SUM.DIP.X;
        NT_D_DIP=DISC.SUM.DIP.NT;
    end
else
    I_D_ATOM=DISC.FULL.I;
    X_D_ATOM=DISC.FULL.X;
    NT_D_ATOM=DISC.FULL.NT;
    
    if PEAK_LOG==1
        I_D_PEAK=DISC.FULL.PEAK.I;
        X_D_PEAK=DISC.FULL.PEAK.X;
        NT_D_PEAK=DISC.FULL.PEAK.NT;   
        
        %*******************
        %Assign state labels
        %*******************
        if IND_LOG==1
            IND_PEAK=DISC.FULL.PEAK.STATE.IND;
            QSAN_PEAK=DISC.FULL.PEAK.STATE.QSAN;
            
            IND_LABEL_PEAK=cell(1,NT_D_PEAK);
            for ii=1:NT_D_PEAK
                IND_LABEL_PEAK{ii}=[num2str(IND_PEAK(ii,1)) ',' num2str(IND_PEAK(ii,2)) '-' num2str(QSAN_PEAK(ii))];
            end
        end
    end
    
    if DIP_LOG==1
        I_D_DIP=DISC.FULL.DIP.I;
        X_D_DIP=DISC.FULL.DIP.X;
        NT_D_DIP=DISC.FULL.DIP.NT;
        
        %*******************
        %Assign state labels
        %*******************
        if IND_LOG==1
            IND_DIP=DISC.FULL.DIP.STATE.IND;
            QSAN_DIP=DISC.FULL.DIP.STATE.QSAN;
            
            IND_LABEL_DIP=cell(1,NT_D_DIP);
            for ii=1:NT_D_DIP
                IND_LABEL_DIP{ii}=[num2str(IND_DIP(ii,1)) ',' num2str(IND_DIP(ii,2)) '-' num2str(QSAN_DIP(ii))];
            end
        end        
    end
end

%*************************
%Assign continuous spectra
%*************************
if CONT_LOG==1
    I_C_ATOM=SPECTRA.CONT.I;
    X_C_ATOM=SPECTRA.CONT.X;
    
    if PEAK_LOG==1
        I_C_PEAK=SPECTRA.CONT.PEAK.I;
        X_C_PEAK=SPECTRA.CONT.PEAK.X;
    end
    
    if DIP_LOG==1
        I_C_DIP=SPECTRA.CONT.DIP.I;
        X_C_DIP=SPECTRA.CONT.DIP.X;
    end
    
    I_C_TOT=SPECTRA.CONT.TOTAL.I;
    X_C_TOT=SPECTRA.CONT.TOTAL.X;
end

%**********************************
%Assign the crossover peak/dip sign
%**********************************
SIGN_PK=[' (' DFSS.CROSS.PEAK ')'];
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

%***************
%Allocate memory
%***************
LH(1:4)=0;
LEG=cell(1,4);

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
    
    if PLOT_DISC==1 
        %+++++++++++++++++++++++++++++
        %+++ Discrete line profile +++
        %+++++++++++++++++++++++++++++
        figure
        hold on
        xx=0;
        
        %***********
        %Plot atomic
        %***********
        for jj=1:NT_D_ATOM
            PH_ATOM=plot([X_D_ATOM(jj) X_D_ATOM(jj)]*1e10,[0 I_D_ATOM(jj)],'m','LineWidth',4.5);
            
            if jj==1
                xx=xx+1;
                LH(xx)=PH_ATOM;
                LEG{xx}='Atomic';
            end
        end
        
        if SUM_LOG==0 && IND_LOG==1
            for jj=1:NT_D_ATOM
                text(X_D_ATOM(jj)*1e10,I_D_ATOM(jj),num2str(jj),'Color','m')
            end
        end
        
        %********************
        %Plot crossover peaks
        %********************
        if PEAK_LOG==1
            for jj=1:NT_D_PEAK
                PH_PEAK=plot([X_D_PEAK(jj) X_D_PEAK(jj)]*1e10,[0 -abs(I_D_PEAK(jj))],'r','LineWidth',4.5) ;

                if jj==1
                    xx=xx+1;
                    LH(xx)=PH_PEAK;
                    LEG{xx}=['Crossover Peaks' SIGN_PK];
                end
            end
        
            if SUM_LOG==0 && IND_LOG==1
                for jj=1:NT_D_PEAK
                    text(X_D_PEAK(jj)*1e10,-abs(I_D_PEAK(jj)),IND_LABEL_PEAK{jj},'Color','r')
                end
            end
        end
        
        %*******************
        %Plot crossover dips
        %*******************
        if DIP_LOG==1
            for jj=1:NT_D_DIP
                PH_DIP=plot([X_D_DIP(jj) X_D_DIP(jj)]*1e10,[0 -abs(I_D_DIP(jj))],'b','LineWidth',4.5);

                if jj==1
                    xx=xx+1;
                    LH(xx)=PH_DIP;
                    LEG{xx}=['Crossover Dips' SIGN_DIP];
                end
            end
            
            if SUM_LOG==0 && IND_LOG==1
                for jj=1:NT_D_DIP
                    text(X_D_DIP(jj)*1e10,-abs(I_D_DIP(jj)),IND_LABEL_DIP{jj},'Color','b')
                end
            end
        end
        
        hold off
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
        end
        ylabel(YNAME.DISC,'FontSize',38)
        title('Discrete Spectra','FontSize',38)
        legend(LH(1:xx),LEG(1:xx),'Location','NorthEast')
        set(gca,'XTick',XTICK)
        set(gca,'XTickLabel',[])
        axis(AM.DD)
        grid on   
        set(gca,'FontSize',38)
    end
    
    if PLOT_CONT==1 && CONT_LOG==1
        %+++++++++++++++++++++++++++++++++++++++++++
        %+++ Broadened and discrete line profile +++
        %+++++++++++++++++++++++++++++++++++++++++++
        figure
        hold on
        xx=0;
        
        %**********
        %Plot total
        %**********
        PH_TOT=plot(X_C_TOT*1e10,I_C_TOT,'k','LineWidth',4.5);
        
        xx=xx+1;
        LH(xx)=PH_TOT;
        LEG{xx}='Total';
        
        %***********
        %Plot atomic
        %***********
        for jj=1:NT_D_ATOM
            PH_ATOM=plot([X_D_ATOM(jj) X_D_ATOM(jj)]*1e10,[0 -I_D_ATOM(jj)]*SCALE,'m','LineWidth',4.5);
            
            if jj==1
                xx=xx+1;
                LH(xx)=PH_ATOM;
                LEG{xx}='Atomic';
            end
        end
        
        if SUM_LOG==0 && IND_LOG==1
            for jj=1:NT_D_ATOM
                text(X_D_ATOM(jj)*1e10,-I_D_ATOM(jj)*SCALE,num2str(jj),'Color','m')
            end
        end
        
        %********************
        %Plot crossover peaks
        %********************
        if PEAK_LOG==1
            for jj=1:NT_D_PEAK
                PH_PEAK=plot([X_D_PEAK(jj) X_D_PEAK(jj)]*1e10,[0 -abs(I_D_PEAK(jj))]*SCALE,'r','LineWidth',4.5);

                if jj==1
                    xx=xx+1;
                    LH(xx)=PH_PEAK;
                    LEG{xx}=['Crossover Peaks' SIGN_PK];
                end
            end
            
            if SUM_LOG==0 && IND_LOG==1
                for jj=1:NT_D_PEAK
                    text(X_D_PEAK(jj)*1e10,-abs(I_D_PEAK(jj))*SCALE,IND_LABEL_PEAK{jj},'Color','r')
                end
            end
        end
        
        %*******************
        %Plot crossover dips
        %*******************
        if DIP_LOG==1
            for jj=1:NT_D_DIP
                PH_DIP=plot([X_D_DIP(jj) X_D_DIP(jj)]*1e10,[0 -abs(I_D_DIP(jj))]*SCALE,'b','LineWidth',4.5);

                if jj==1
                    xx=xx+1;
                    LH(xx)=PH_DIP;
                    LEG{xx}=['Crossover Dips' SIGN_DIP];
                end
            end
            
            if SUM_LOG==0 && IND_LOG==1
                for jj=1:NT_D_DIP
                    text(X_D_DIP(jj)*1e10,-abs(I_D_DIP(jj))*SCALE,IND_LABEL_DIP{jj},'Color','b')
                end
            end
        end
        
        hold off
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
        end
        xlabel(XNAME,'FontSize',38)
        ylabel(YNAME.CONT,'FontSize',38)
        title('Continuous Spectra','FontSize',38,'Color','k','FontWeight','Bold')
        legend(LH(1:xx),LEG(1:xx),'Location','NorthEast')
        set(gca,'XTick',XTICK,'YTick',YTICK)
        set(gca,'XTickLabel',XTICKLABEL,'YTickLabel',YTICKLABEL)
        axis(AM.CC)
        grid on
        set(gca,'FontSize',38)

        %++++++++++++++++++++++++++++++
        %+++ Broadened line profile +++
        %++++++++++++++++++++++++++++++  
        figure
        hold on
        xx=0;
        
        %**********
        %Plot total
        %**********
        PH_TOT=plot(X_C_TOT*1e10,I_C_TOT,'k','LineWidth',4.5);
        
        xx=xx+1;
        LH(xx)=PH_TOT;
        LEG{xx}='Total';
        
        %***********
        %Plot atomic
        %***********
        PH_ATOM=plot(X_C_ATOM*1e10,-I_C_ATOM,'m','LineWidth',4.5);
        
        xx=xx+1;
        LH(xx)=PH_ATOM;
        LEG{xx}='Atomic';
        
        %********************
        %Plot crossover peaks
        %********************
        if PEAK_LOG==1
            PH_PEAK=plot(X_C_PEAK*1e10,-abs(I_C_PEAK),'r','LineWidth',4.5);
            
            xx=xx+1;
            LH(xx)=PH_PEAK;
            LEG{xx}=['Crossover Peaks' SIGN_PK];
        end
        
        %*******************
        %Plot crossover dips
        %*******************
        if DIP_LOG==1
            PH_DIP=plot(X_C_DIP*1e10,-abs(I_C_DIP),'b','LineWidth',4.5);
             
            xx=xx+1;
            LH(xx)=PH_DIP;
            LEG{xx}=['Crossover Dips' SIGN_DIP];
        end
            
        hold off
        if strcmpi(TEXT_BOX,'on')==1
            annotation('textbox',[0.135 0.71 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
        end
        xlabel(XNAME,'FontSize',38)
        ylabel(YNAME.CONT,'FontSize',38)
        title('Continuous Spectra','FontSize',38,'Color','k','FontWeight','Bold')
        legend(LH(1:xx),LEG(1:xx),'Location','NorthEast')
        set(gca,'XTick',XTICK,'YTick',YTICK)
        set(gca,'XTickLabel',XTICKLABEL,'YTickLabel',YTICKLABEL)
        axis(AM.CC)
        grid on
        set(gca,'FontSize',38) 
    end
end

end