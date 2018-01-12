function OPT=Plot_Fit(PARA,DATA,FIT,OPT)

%**********
%Error type
%**********
ERROR='FILL';

%**********
%Plot logic
%**********
MSE=1;
PIXEL=1;
COMPONENTS=1;
RESID=1;

%**************************
%Plot type (MULTI or SINGLE)
%**************************
TYPE='MULTI';

if nargin==4
    if isfield(OPT,'PLOT')==1
        if isfield(OPT.PLOT,'ERROR')==1
            ERROR=OPT.PLOT.ERROR;
        else
            OPT.PLOT.ERROR=ERROR;
        end

        if isfield(OPT.PLOT,'LOGIC')==1
            if isfield(OPT.PLOT.LOGIC,'MSE')==1
                MSE=OPT.PLOT.LOGIC.MSE;
            else
                OPT.PLOT.LOGIC.MSE=MSE;
            end
            
            if isfield(OPT.PLOT.LOGIC,'PIXEL')==1
                PIXEL=OPT.PLOT.LOGIC.PIXEL;
            else
                OPT.PLOT.LOGIC.PIXEL=PIXEL;
            end
            
            if isfield(OPT.PLOT.LOGIC,'COMPONENTS')==1
                COMPONENTS=OPT.PLOT.LOGIC.COMPONENTS;
            else
                OPT.PLOT.LOGIC.COMPONENTS=COMPONENTS;
            end
            
            if isfield(OPT.PLOT.LOGIC,'RESID')==1
                RESID=OPT.PLOT.LOGIC.RESID;
            else
                OPT.PLOT.LOGIC.RESID=RESID;
            end
        end
        
        if isfield(OPT.PLOT,'TYPE')==1
            TYPE=OPT.PLOT.TYPE;
        else
            OPT.PLOT.TYPE=TYPE;
        end
    else
        OPT.PLOT.ERROR=ERROR;
        
        OPT.PLOT.LOGIC.CHI=MSE;
        OPT.PLOT.LOGIC.PIXEL=PIXEL;
        OPT.PLOT.LOGIC.COMPONENTS=COMPONENTS;
        OPT.PLOT.LOGIC.RESIDE=RESID;
        
        OPT.PLOT.TYPE=TYPE;
    end
end

%*******************
%Assigning the input
%*******************
NS=PARA.FP.NS;

NSPF=PARA.NP.NSPF;

%****************
%Gen. color array
%****************
COL=cell(1,NSPF);
for uu=1:NSPF
    COL{uu}=[rand(1,1) rand(1,1) rand(1,1)];
end
COL(1:4)={'k','r','b','g'};

%****************
%Gen. color array
%****************
LEG=cell(1,NSPF);
for uu=1:NSPF
    LEG{uu}=['Spectra ' num2str(uu)];
end

%***************
%Allocate memory
%***************
PH_CHI(1:NSPF)=0;
PH(1:3)=0;

FH_SINGLE(1:NS)=0;
PH_SINGLE(1:2*NSPF)=0;
LEG_SINGLE=cell(1,2*NSPF);
FH_RESID(1:NS)=0;
PH_RESID(1:NSPF)=0;
LEG_RESID=cell(1,NSPF);
MIN_X(1:NS)=Inf;
MAX_X(1:NS)=-Inf;
MAX_I(1:NS)=-Inf;
for uu=1:NSPF
    %*********************************
    %Assign spectra specific variables
    %*********************************
    CHI=FIT.CHI{uu};
    PROFILE=FIT.PROFILE{uu};
    EXP=DATA.EXP{uu};

    %************************
    %Assign experimental data
    %************************
    IE=EXP.IE;
    IEE=EXP.IEE;
    XE=EXP.XE;
    LG=EXP.LG;
    NE=EXP.NE; 

    if NS>1 && MSE==1
        %**************
        %Plot the CHI's
        %**************  
        if uu==1
            FH=figure;
        else
            figure(FH);
        end
        hold on
        PH_CHI(uu)=plot(1:NS,CHI(1:NS),['-' COL{uu} 's'],'LineWidth',6,'MarkerFaceColor',COL{uu},'MarkerEdgeColor',COL{uu},'MarkerSize',30);
        hold off
        if uu==NSPF
            xlabel('Minima Number','FontSize',34,'FontWeight','Bold') 
            ylabel('Reduced \chi','FontSize',34,'FontWeight','Bold')
            title('Reduced \chi','FontSize',34,'Color','k','FontWeight','Bold')
            legend(PH_CHI(1:NSPF),LEG)
            grid on
            set(gca,'FontSize',34,'FontWeight','Bold')
        end
    end

    for ii=1:NS 
        %*********************
        %Assign fitted spectra
        %*********************
        IG=PROFILE{ii}.IG;
        IGB_CON=PROFILE{ii}.IGB_CON;
        IGB_VAR=PROFILE{ii}.IGB_VAR;
        IGT=PROFILE{ii}.IGT;
        XG=PROFILE{ii}.XG;
        NG=PROFILE{ii}.NG;
        
        %*******************
        %Assign max and mins
        %*******************
        MIN_X_TEMP=min(XE);
        MAX_X_TEMP=max(XE);
        MAX_I_TEMP=max([max(IE) max(IGT)]);
        if MIN_X(ii)>MIN_X_TEMP
            MIN_X(ii)=MIN_X_TEMP;
        end
        if MAX_X(ii)<MAX_X_TEMP
            MAX_X(ii)=MAX_X_TEMP;
        end
        if MAX_I(ii)<MAX_I_TEMP
            MAX_I(ii)=MAX_I_TEMP;
        end       
        
        %*************************
        %Background plotting logic
        %*************************
        if max(IGB_CON(1:NG))>0 || max(IGB_VAR(1:NG))>0
            BACK_LOG=1;
        else
            BACK_LOG=0;
        end

        %***********************    
        %Calc. pixelated spectra
        %***********************
        IS=Cont_3(EXP,PROFILE{ii});

        if strcmpi(TYPE,'MULTI')==1
            if PIXEL==1
                %*******************************************
                %Plot the experimental and fit line profiles
                %*******************************************
                figure
                hold on
                PH(1)=plot(XE(LG(1:NE)==1),IE(LG(1:NE)==1),'rs','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',18);
                plot(XE(LG(1:NE)==0),IE(LG(1:NE)==0),'ms','MarkerFaceColor','m','MarkerEdgeColor','m','MarkerSize',18)
                PH(2)=plot(XE(1:NE),IS(1:NE),'kd','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',18);
                PH(3)=plot(XG(1:NG),IGT(1:NG),'-k','LineWidth',6);
                if strcmpi(ERROR,'BAR')==1
                    for jj=1:NE
                        plot([XE(jj) XE(jj)],[-IEE(jj) IEE(jj)]+IE(jj),'-r','LineWidth',8)
                    end
                elseif strcmpi(ERROR,'FILL')==1
                    XE_FILL=[XE fliplr(XE)];
                    IEE_FILL=[IEE -fliplr(IEE)]+[IE fliplr(IE)];

                    fill(XE_FILL,IEE_FILL,'r','EdgeColor','none','FaceAlpha',.3)
                end
                hold off
                xlabel(['Wavelength (' char(197) ')'],'FontSize',40) 
                ylabel('Intensity (a.u.)','FontSize',40)
                title(['Spectra: ' num2str(uu) '   -   Minima Number: ' num2str(ii) '   -   \chi: ' num2str(CHI(ii),4)],'FontSize',40,'Color','k','FontWeight','Normal')
                legend(PH(1:3),'Experimental','Fit - Pixelated','Fit - Continuous')
                grid on
                set(gca,'FontSize',40)
                axis([min(XE) max(XE) 0 max([max(IGT) max(IE)])*1.05])
            end

            if COMPONENTS==1
                %*******************************************
                %Plot the experimental and fit line profiles
                %*******************************************
                figure
                hold on
                PH(1)=plot(XE(LG(1:NE)==1),IE(LG(1:NE)==1),'rs','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',18);
                plot(XE(LG(1:NE)==0),IE(LG(1:NE)==0),'ms','MarkerFaceColor','m','MarkerEdgeColor','m','MarkerSize',18)
                PH(2)=plot(XG(1:NG),IG(1:NG),'-k','LineWidth',6);
                if BACK_LOG==1
                    PH(3)=plot(XG(1:NG),IGB_CON(1:NG),'-b','LineWidth',6);
                    PH(4)=plot(XG(1:NG),IGB_VAR(1:NG),'-g','LineWidth',6);
                end
                if strcmpi(ERROR,'BAR')==1
                    for jj=1:NE
                        plot([XE(jj) XE(jj)],[-IEE(jj) IEE(jj)]+IE(jj),'-r','LineWidth',8)
                    end
                elseif strcmpi(ERROR,'FILL')==1
                    XE_FILL=[XE fliplr(XE)];
                    IEE_FILL=[IEE -fliplr(IEE)]+[IE fliplr(IE)];

                    fill(XE_FILL,IEE_FILL,'r','EdgeColor','none','FaceAlpha',.3)
                end
                hold off
                xlabel(['Wavelength (' char(197) ')'],'FontSize',40) 
                ylabel('Intensity (a.u.)','FontSize',40)
                title(['Spectra: ' num2str(uu) '   -   Minima Number: ' num2str(ii) '   -   \chi: ' num2str(CHI(ii),4)],'FontSize',40,'Color','k','FontWeight','Normal')
                if BACK_LOG==1
                    legend(PH(1:4),'Experimental','Fit - Main','Fit - Background 1','Fit - Background 2')
                else
                    legend(PH(1:2),'Experimental','Fit')
                end
                grid on
                set(gca,'FontSize',40)
                if BACK_LOG==1
                    axis([min(XE) max(XE) 0 max([max(IE) max(IG) max(IGB_CON) max(IGB_VAR)])*1.05])
                else
                    axis([min(XE) max(XE) 0 max([max(IE) max(IG)])*1.05]) 
                end
            end
        elseif strcmpi(TYPE,'SINGLE')==1
            %*******************************************
            %Plot the experimental and fit line profiles
            %*******************************************
            if uu==1
                FH_SINGLE(ii)=figure;
            end
            figure(FH_SINGLE(ii))
            
            hold on
            PH_SINGLE(1+2*(uu-1))=plot(XE(LG(1:NE)==1),IE(LG(1:NE)==1),[COL{uu} 's'],'MarkerFaceColor',COL{uu},'MarkerEdgeColor',COL{uu},'MarkerSize',18);
            plot(XE(LG(1:NE)==0),IE(LG(1:NE)==0),'ms','MarkerFaceColor','m','MarkerEdgeColor','m','MarkerSize',18)
            PH_SINGLE(2*uu)=plot(XG(1:NG),IGT(1:NG),['-' COL{uu}],'LineWidth',6);
            if strcmpi(ERROR,'BAR')==1
                for jj=1:NE
                    plot([XE(jj) XE(jj)],[-IEE(jj) IEE(jj)]+IE(jj),['-' COL{uu}],'LineWidth',8)
                end
            elseif strcmpi(ERROR,'FILL')==1
                XE_FILL=[XE fliplr(XE)];
                IEE_FILL=[IEE -fliplr(IEE)]+[IE fliplr(IE)];

                fill(XE_FILL,IEE_FILL,COL{uu},'EdgeColor','none','FaceAlpha',.3)
            end
            hold off
            
            LEG_SINGLE(1+2*(uu-1):2*uu)={['Experiment: ' num2str(uu)],['Fit: ' num2str(uu)]};
            
            if uu==NSPF
                xlabel(['Wavelength (' char(197) ')'],'FontSize',40) 
                ylabel('Intensity (a.u.)','FontSize',40)
                title(['Minima Number: ' num2str(ii) '   -   \chi: ' num2str(CHI(ii),4)],'FontSize',40,'Color','k','FontWeight','Normal')
                legend(PH_SINGLE(1:2*NSPF),LEG_SINGLE)
                grid on
                set(gca,'FontSize',40)
                axis([MIN_X(ii) MAX_X(ii) 0 MAX_I(ii)*1.05])
            end
        end
        
        if RESID==1
            %**************************************
            %Plot the relative residuals of the fit
            %**************************************
            if strcmpi(TYPE,'SINGLE')==1
                if uu==1
                    FH_RESID(ii)=figure;
                end
            elseif strcmpi(TYPE,'MULTI')==1
                FH_RESID(ii)=figure;
            end
            
            LEG_RESID(uu)={['Spectrum ' num2str(uu)]};
            
            figure(FH_RESID(ii))
            
            hold on
            PH_RESID(uu)=plot(XE(1:NE),(IE(1:NE)-IS(1:NE))./IEE(1:NE),['-' COL{uu} 's'],'LineWidth',6,'MarkerFaceColor',COL{uu},'MarkerEdgeColor',COL{uu},'MarkerSize',18);
            hold off
            
            if uu==NSPF || strcmpi(TYPE,'MULTI')==1
                xlabel(['Wavelength (' char(197) ')'],'FontSize',40) 
                ylabel('Relative Residual','FontSize',40)
                title(['Minima Number: ' num2str(ii) '   -   \chi: ' num2str(CHI(ii),4)],'FontSize',40,'Color','k','FontWeight','Normal')
                if strcmpi(TYPE,'MULTI')==1
                    legend(PH_RESID(uu),LEG_RESID(uu))
                elseif strcmpi(TYPE,'SINGLE')==1
                    legend(PH_RESID(1:NSPF),LEG_RESID(1:NSPF))
                end
                grid on
                set(gca,'FontSize',40)
                xlim([MIN_X(ii) MAX_X(ii)])
            end
        end
    end
end

end