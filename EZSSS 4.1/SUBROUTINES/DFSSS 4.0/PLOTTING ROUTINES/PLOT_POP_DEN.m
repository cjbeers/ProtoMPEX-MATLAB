function PLOT_POP_DEN(DATA,SPACE,FREQ,PARA)

                    %%%%%%%%%%%%%%%%%%%%%%%%%
                    %%% Plotting options  %%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%

PLOT_3D=1;
PLOT_2D_FREQ=0;  
PLOT_2D_SPACE=0;  
                    
NORM_LOGIC=1;
FONTSIZE=24;

                    %%%%%%%%%%%%%%%%%%%%%%%%%
                    %%% Plotting options  %%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%

%************
%Assign input
%************
POP_DEN=DATA.POP_DEN;

NXP=SPACE.NXP;
X=SPACE.X;

NFP=FREQ.NFP;
NU=FREQ.NU;

POP_DEN_LOG=PARA.VELOCITY.POP_DEN_LOGIC;
NVXD=PARA.VELOCITY.NVXD;
NVYD=PARA.VELOCITY.NVYD;

%**********************************************************
%Calc. the resonant detuning frequncy (centered about zero)
%**********************************************************
NU_RDT=NU-(NU(1)+NU(NFP))/2;

%*****************************************
%Exit if population density not calculated
%*****************************************
if (NVXD==1 && NVYD==1) || POP_DEN_LOG==0
    return
end

%*********************************************************
%Normalized population density to equilibrium ground state
%*********************************************************
if NORM_LOGIC==1
    MAX=max(max(POP_DEN{1,1}.NG));
    for ii=1:NFP
        for jj=1:NXP
            POP_DEN{ii,jj}.NG=POP_DEN{ii,jj}.NG./MAX;
            POP_DEN{ii,jj}.NE=POP_DEN{ii,jj}.NE./MAX;
        end
    end
    
    UNITS='normalized';
else
    UNITS='m^{-3}';
end

if PLOT_3D==1
    END=0;
    while END==0
        %********************************
        %Prompt user for frequency indice
        %********************************
        fprintf('\n*****************************************************************\n')
        fprintf('\n***********                 3D PLOTS                  ***********\n')
        fprintf('\n*****************************************************************\n')
        fprintf('**  Frequency= %4.2f to %4.2f GHz having %4i steps             **\n',NU_RDT(1)/1e9,NU_RDT(NFP)/1e9,NFP)
        fprintf('**                                                             **\n')
        NU_IND=input('**  Enter the frequency indice of interest: ');
        if NU_IND<10
            fprintf('\b                  **\n')
        elseif NU_IND<100
            fprintf('\b                 **\n')
        else
            fprintf('\b                **\n')
        end
        fprintf('*****************************************************************\n')

        if NU_IND>NFP
            NU_IND=NFP;
        end

        if NU_IND<1 
            NU_IND=1;
        end

        if isempty(NU_IND)==1 || ischar(NU_IND)==1 || length(NU_IND)>1 
            NU_IND=1;
        end

        %******************************
        %Prompt user for spatial indice
        %******************************
        fprintf('\n*****************************************************************\n')
        fprintf('**  Space= %5.2f to %5.2f cm having %4i steps                 **\n',X(1)*100,X(NXP)*100,NXP)
        fprintf('**                                                             **\n')
        X_IND=input('**  Enter the spatial indice of interest: ');
        if X_IND<10
            fprintf('\b                    **\n')
        elseif X_IND<100
            fprintf('\b                   **\n')
        else
            fprintf('\b                  **\n')
        end
        fprintf('*****************************************************************\n')

        if X_IND>NXP
            X_IND=NXP;
        end

        if X_IND<1
            X_IND=1;
        end

        if isempty(X_IND)==1 || ischar(X_IND)==1 || length(X_IND)>1 
            X_IND=1;
        end

        %***********************
        %Assign data of interest
        %***********************
        VX=POP_DEN{NU_IND,X_IND}.VX;
        VY=POP_DEN{NU_IND,X_IND}.VY;
        NG=POP_DEN{NU_IND,X_IND}.NG;
        NE=POP_DEN{NU_IND,X_IND}.NE;

        %********************
        %Prompt for plot type
        %********************
        if NVXD>1 && NVYD>1
            fprintf('\n*****************************************************************\n')
            TYPE=input('Input plot type ~ CONTOUR (c) or SURFACE (s) ','s');
            fprintf('*****************************************************************\n')

            if strcmpi(TYPE,'c')==1
                FH=figure;
                subplot(1,2,1)
                contourf(VX/1000,VY/1000,NG','LineStyle','none')
                colorbar
                xlabel('V_x (km/s)','FontSize',FONTSIZE)
                ylabel('V_y (km/s)','FontSize',FONTSIZE)
                title(['Gound State Density (' UNITS ')'],'FontSize',FONTSIZE,'FontWeight','Normal')
                set(gca,'FontSize',FONTSIZE)

                subplot(1,2,2)
                contourf(VX/1000,VY/1000,NE','LineStyle','none')
                colorbar
                xlabel('V_x (km/s)','FontSize',FONTSIZE)
                ylabel('V_y (km/s)','FontSize',FONTSIZE)
                title(['Excited State Density (' UNITS ')'],'FontSize',FONTSIZE,'FontWeight','Normal')
                set(gca,'FontSize',FONTSIZE)
            else
                FH=figure;
                subplot(1,2,1)
                surf(VX/1000,VY/1000,NG','LineStyle','none')
                xlabel('V_x (km/s)','FontSize',FONTSIZE)
                ylabel('V_y (km/s)','FontSize',FONTSIZE)
                title(['Gound State Density (' UNITS ')'],'FontSize',FONTSIZE,'FontWeight','Normal')
                set(gca,'FontSize',FONTSIZE)

                subplot(1,2,2)
                surf(VX/1000,VY/1000,NE','LineStyle','none')
                xlabel('V_x (km/s)','FontSize',FONTSIZE)
                ylabel('V_y (km/s)','FontSize',FONTSIZE)
                title(['Excited State Density (' UNITS ')'],'FontSize',FONTSIZE,'FontWeight','Normal')
                set(gca,'FontSize',FONTSIZE)
            end
        elseif NVXD>1

            fprintf('\n#### ONLY 1D VELOCITY DATA IS AVAILALBE ####\n')

            FH=figure;
            subplot(1,2,1)
            plot(VX/1000,NG,'-k','LineWidth',5)
            xlabel('V_x (km/s)','FontSize',FONTSIZE)
            ylabel(['Gound State Density (' UNITS ')'],'FontSize',FONTSIZE)
            grid on
            set(gca,'FontSize',FONTSIZE)

            subplot(1,2,2)
            plot(VX/1000,NE,'-k','LineWidth',5)
            xlabel('V_x (km/s)','FontSize',FONTSIZE)
            ylabel(['Excited State Density (' UNITS ')'],'FontSize',FONTSIZE)
            grid on
            set(gca,'FontSize',FONTSIZE)
        elseif NVYD>1

            fprintf('\n#### ONLY 1D VELOCITY DATA IS AVAILALBE ####\n')

            FH=figure;
            subplot(1,2,1)
            plot(VY/1000,NG,'-k','LineWidth',5)
            xlabel('V_y (km/s)','FontSize',FONTSIZE)
            ylabel(['Gound State Density (' UNITS ')'],'FontSize',FONTSIZE)
            grid on
            set(gca,'FontSize',FONTSIZE)

            subplot(1,2,2)
            plot(VY/1000,NE,'-k','LineWidth',5)
            xlabel('V_y (km/s)','FontSize',FONTSIZE)
            ylabel(['Excited State Density (' UNITS ')'],'FontSize',FONTSIZE)
            grid on
            set(gca,'FontSize',FONTSIZE)
        end

        %*******************
        %Prompt user to quit
        %*******************
        fprintf('\n*****************************************************************\n')
        CONT=input('Continue (y/n): ','s');
        fprintf('\b                                              **\n')
        fprintf('*****************************************************************\n')
        if strcmpi(CONT,'y')==1
            END=0;

            try
                close(FH)
            catch
            end
        else
            END=1;
        end
    end
end

if PLOT_2D_FREQ==1
    END=0;
    while END==0
        %********************************
        %Prompt user for frequency indice
        %********************************
        fprintf('\n*****************************************************************\n')
        fprintf('\n***********           2D PLOTS - FREQUENCY            ***********\n')
        fprintf('\n*****************************************************************\n')
        fprintf('**  Frequency= %4.2f to %4.2f GHz having %4i steps             **\n',NU_RDT(1)/1e9,NU_RDT(NFP)/1e9,NFP)
        fprintf('**                                                             **\n')
        NU_IND=input('**  Enter the frequency indice(s) of interest: ');
        fprintf('*****************************************************************\n')

        NU_IND(NU_IND>NFP)=NFP;

        NU_IND(NU_IND<1)=1;

        if isempty(NU_IND)==1 || ischar(NU_IND)==1 
            NU_IND=1;
        end

        NPLOT=length(NU_IND);

        %******************************
        %Prompt user for spatial indice
        %******************************
        fprintf('\n*****************************************************************\n')
        fprintf('**  Space= %5.2f to %5.2f cm having %4i steps                 **\n',X(1)*100,X(NXP)*100,NXP)
        fprintf('**                                                             **\n')
        X_IND=input('**  Enter the spatial indice of interest: ');
        if X_IND<10
            fprintf('\b                    **\n')
        elseif X_IND<100
            fprintf('\b                   **\n')
        else
            fprintf('\b                  **\n')
        end
        fprintf('*****************************************************************\n')

        if X_IND>NXP
            X_IND=NXP;
        end

        if X_IND<1
            X_IND=1;
        end

        if isempty(X_IND)==1 || ischar(X_IND)==1 || length(X_IND)>1 
            X_IND=1;
        end

        %***********************
        %Assign data of interest
        %***********************
        clear VX VY NG NE

        VX(1:NPLOT,1:NVXD)=0;
        VY(1:NPLOT,1:NVYD)=0;
        NG=cell(1,NPLOT);
        NE=cell(1,NPLOT);
        for ii=1:NPLOT
            VX(ii,1:NVXD)=POP_DEN{NU_IND(ii),X_IND}.VX;
            VY(ii,1:NVYD)=POP_DEN{NU_IND(ii),X_IND}.VY;
            NG{ii}=POP_DEN{NU_IND(ii),X_IND}.NG;
            NE{ii}=POP_DEN{NU_IND(ii),X_IND}.NE;
        end

        COL={'k','b','r','m','g','c','y'};
        for ii=8:NPLOT
            COL{ii}=[rand(1,1),rand(1,1),rand(1,1)];
        end

        if NVXD>1 && NVYD>1
            %*************************************
            %Prompt user for phase space selection
            %*************************************
            fprintf('\n*****************************************************************\n')                                                           
            VEL_DIM=input('**  Enter the velocity axis to plot Vx (x) or Vy (y): ','s');
            fprintf('\b        **\n')
            fprintf('*****************************************************************\n')

            if ischar(VEL_DIM)==0 || (strcmpi(VEL_DIM,'x')==0 && strcmpi(VEL_DIM,'y')==0)
                VEL_DIM='x';
            end

            VX_MIN=max(VX(1:NPLOT,1));
            VX_MAX=min(VX(1:NPLOT,NVXD));
            VY_MIN=max(VY(1:NPLOT,1));
            VY_MAX=min(VY(1:NPLOT,NVYD));
            if strcmpi(VEL_DIM,'x')==1
                fprintf('\n*****************************************************************\n')
                fprintf('**  Vy= %5.2f to %5.2f km/s having %4i steps                  **\n',VY_MIN/1000,VY_MAX/1000,NVYD)
                fprintf('**                                                             **\n')
                VY_PLOT=input('**  Enter the Vy of interest: ');
                
                LEN=33-length(num2str(VY_PLOT));
                PAD(1:LEN)=' ';
                
                fprintf(['\b' PAD '**\n'])
                fprintf('*****************************************************************\n')

                VY_HIT(1:NPLOT)=0;
                for ii=1:NPLOT
                    [~,IND]=min(abs(VY(ii,1:NVYD)-VY_PLOT*1000));
                    VY_HIT(ii)=VY(ii,IND);
                    NG{ii}=NG{ii}(1:NVXD,IND);
                    NE{ii}=NE{ii}(1:NVXD,IND);
                end  

                LEG=cell(1,NPLOT);
                for ii=1:NPLOT
                    LEG{ii}=['\nu= ' num2str(NU_RDT(NU_IND(ii))/1e9,'%4.2f') ' GHz - V_y= ' num2str(VY_HIT(ii)/1000,'%4.2f') ' km/s'];
                end

                FH=figure;
                subplot(1,2,1)
                hold on
                for ii=1:NPLOT
                    plot(VX(ii,1:NVXD)/1000,NG{ii},'-','Color',COL{ii},'LineWidth',5)
                end
                hold off
                xlabel('V_x (km/s)','FontSize',FONTSIZE)
                ylabel(['Gound State Density (' UNITS ')'],'FontSize',FONTSIZE)
                legend(LEG)
                grid on
                set(gca,'FontSize',FONTSIZE)

                subplot(1,2,2)
                hold on
                for ii=1:NPLOT
                    plot(VX(ii,1:NVXD)/1000,NE{ii},'-','Color',COL{ii},'LineWidth',5)
                end
                hold off
                xlabel('V_x (km/s)','FontSize',FONTSIZE)
                ylabel(['Excited State Density (' UNITS ')'],'FontSize',FONTSIZE)
                grid on
                set(gca,'FontSize',FONTSIZE)
            elseif strcmpi(VEL_DIM,'y')==1
                fprintf('\n*****************************************************************\n')
                fprintf('**  Vx= %5.2f to %5.2f km/s having %4i steps               n   **\n',VX_MIN/1000,VX_MAX/1000,NVXD)
                fprintf('**                                                             **\n')
                VX_PLOT=input('**  Enter the Vy of interest: ');
                
                
                LEN=33-length(num2str(VX_PLOT));
                PAD(1:LEN)=' ';
                
                fprintf(['\b' PAD '**\n'])
                fprintf('*****************************************************************\n')

                VX_HIT(1:NPLOT)=0;
                for ii=1:NPLOT
                    [~,IND]=min(abs(VX(ii,1:NVXD)-VX_PLOT*1000));
                    VX_HIT(ii)=VX(ii,IND);
                    NG{ii}=NG{ii}(IND,1:NVYD);
                    NE{ii}=NE{ii}(IND,1:NVYD);
                end   

                LEG=cell(1,NPLOT);
                for ii=1:NPLOT
                    LEG{ii}=['\nu= ' num2str(NU_RDT(NU_IND(ii))/1e9,'%4.2f') ' GHz - V_x= ' num2str(VX_HIT(ii)/1000,'%4.2f') ' km/s'];
                end

                FH=figure;
                subplot(1,2,1)
                hold on
                for ii=1:NPLOT
                    plot(VY(ii,1:NVYD)/1000,NG{ii},'-','Color',COL{ii},'LineWidth',5)
                end
                hold off
                xlabel('V_y (km/s)','FontSize',FONTSIZE)
                ylabel(['Gound State Density (' UNITS ')'],'FontSize',FONTSIZE)
                legend(LEG)
                grid on
                set(gca,'FontSize',FONTSIZE)

                subplot(1,2,2)
                hold on
                for ii=1:NPLOT
                    plot(VY(ii,1:NVYD)/1000,NE{ii},'-','Color',COL{ii},'LineWidth',5)
                end
                hold off
                xlabel('V_y (km/s)','FontSize',FONTSIZE)
                ylabel(['Excited State Density (' UNITS ')'],'FontSize',FONTSIZE)
                grid on
                set(gca,'FontSize',FONTSIZE)
            end
        elseif NVXD==1
            LEG=cell(1,NPLOT);
            for ii=1:NPLOT
                LEG{ii}=['\nu= ' num2str(NU_RDT(NU_IND(ii))/1e9,'%4.2f') ' GHz - V_x= ' num2str(VX(ii)/1000,'%4.2f') ' km/s'];
            end

            FH=figure;
            subplot(1,2,1)
            hold on
            for ii=1:NPLOT
                plot(VY(ii,1:NVYD)/1000,NG{ii},'-','Color',COL{ii},'LineWidth',5)
            end
            hold off
            xlabel('V_y (km/s)','FontSize',FONTSIZE)
            ylabel(['Gound State Density (' UNITS ')'],'FontSize',FONTSIZE)
            legend(LEG)
            grid on
            set(gca,'FontSize',FONTSIZE)

            subplot(1,2,2)
            hold on
            for ii=1:NPLOT
                plot(VY(ii,1:NVYD)/1000,NE{ii},'-','Color',COL{ii},'LineWidth',5)
            end
            hold off
            xlabel('V_y (km/s)','FontSize',FONTSIZE)
            ylabel(['Excited State Density (' UNITS ')'],'FontSize',FONTSIZE)
            grid on
            set(gca,'FontSize',FONTSIZE)
        elseif NVYD==1
            LEG=cell(1,NPLOT);
            for ii=1:NPLOT
                LEG{ii}=['\nu= ' num2str(NU_RDT(NU_IND(ii))/1e9,'%4.2f') ' GHz - V_y= ' num2str(VY(ii)/1000,'%4.2f') ' km/s'];
            end

            FH=figure;
            subplot(1,2,1)
            hold on
            for ii=1:NPLOT
                plot(VX(ii,1:NVXD)/1000,NG{ii},'-','Color',COL{ii},'LineWidth',5)
            end
            hold off
            xlabel('V_x (km/s)','FontSize',FONTSIZE)
            ylabel(['Gound State Density (' UNITS ')'],'FontSize',FONTSIZE)
            legend(LEG)
            grid on
            set(gca,'FontSize',FONTSIZE)

            subplot(1,2,2)
            hold on
            for ii=1:NPLOT
                plot(VX(ii,1:NVXD)/1000,NE{ii},'-','Color',COL{ii},'LineWidth',5)
            end
            hold off
            xlabel('V_x (km/s)','FontSize',FONTSIZE)
            ylabel(['Excited State Density (' UNITS ')'],'FontSize',FONTSIZE)
            grid on
            set(gca,'FontSize',FONTSIZE)
        end

        %*******************
        %Prompt user to quit
        %*******************
        fprintf('\n*****************************************************************\n')
        CONT=input('Continue (y/n): ','s');
        fprintf('\b                                              **\n')
        fprintf('*****************************************************************\n')
        if strcmpi(CONT,'y')==1
            END=0;

            try
                close(FH)
            catch
            end
        else
            END=1;
        end
    end
end

if PLOT_2D_SPACE==1
    END=0;
    while END==0
        %********************************
        %Prompt user for frequency indice
        %********************************
        fprintf('\n*****************************************************************\n')
        fprintf('\n***********           2D PLOTS - SPATIAL              ***********\n')
        fprintf('\n*****************************************************************\n')
        fprintf('**  Frequency= %4.2f to %4.2f GHz having %4i steps             **\n',NU_RDT(1)/1e9,NU_RDT(NFP)/1e9,NFP)
        fprintf('**                                                             **\n')
        NU_IND=input('**  Enter the frequency indice of interest: ');
        if NU_IND<10
            fprintf('\b                  **\n')
        elseif NU_IND<100
            fprintf('\b                 **\n')
        else
            fprintf('\b                **\n')
        end
        fprintf('*****************************************************************\n')

        if NU_IND>NFP
            NU_IND=NFP;
        end

        if NU_IND<1
            NU_IND=1;
        end

        if isempty(NU_IND)==1 || ischar(NU_IND)==1 || length(NU_IND)>1 
            NU_IND=1;
        end

        %******************************
        %Prompt user for spatial indice
        %******************************
        fprintf('\n*****************************************************************\n')
        fprintf('**  Space= %5.2f to %5.2f cm having %4i steps                 **\n',X(1)*100,X(NXP)*100,NXP)
        fprintf('**                                                             **\n')
        X_IND=input('**  Enter the spatial indice(s) of interest: ');
        fprintf('*****************************************************************\n')
        
        X_IND(X_IND>NXP)=NXP;

        X_IND(X_IND<1)=1;

        if isempty(X_IND)==1 || ischar(X_IND)==1 
            X_IND=1;
        end

        NPLOT=length(X_IND);
        
        %***********************
        %Assign data of interest
        %***********************
        clear VX VY NG NE

        VX(1:NPLOT,1:NVXD)=0;
        VY(1:NPLOT,1:NVYD)=0;
        NG=cell(1,NPLOT);
        NE=cell(1,NPLOT);
        for ii=1:NPLOT
            VX(ii,1:NVXD)=POP_DEN{NU_IND,X_IND(ii)}.VX;
            VY(ii,1:NVYD)=POP_DEN{NU_IND,X_IND(ii)}.VY;
            NG{ii}=POP_DEN{NU_IND,X_IND(ii)}.NG;
            NE{ii}=POP_DEN{NU_IND,X_IND(ii)}.NE;
        end

        COL={'k','b','r','m','g','c','y'};
        for ii=8:NPLOT
            COL{ii}=[rand(1,1),rand(1,1),rand(1,1)];
        end

        if NVXD>1 && NVYD>1
            %*************************************
            %Prompt user for phase space selection
            %*************************************
            fprintf('\n*****************************************************************\n')                                                           
            VEL_DIM=input('**  Enter the velocity axis to plot Vx (x) or Vy (y): ','s');
            fprintf('\b        **\n')
            fprintf('*****************************************************************\n')

            if ischar(VEL_DIM)==0 || (strcmpi(VEL_DIM,'x')==0 && strcmpi(VEL_DIM,'y')==0)
                VEL_DIM='x';
            end

            VX_MIN=max(VX(1:NPLOT,1));
            VX_MAX=min(VX(1:NPLOT,NVXD));
            VY_MIN=max(VY(1:NPLOT,1));
            VY_MAX=min(VY(1:NPLOT,NVYD));
            if strcmpi(VEL_DIM,'x')==1
                fprintf('\n*****************************************************************\n')
                fprintf('**  Vy= %5.2f to %5.2f km/s having %4i steps                  **\n',VY_MIN/1000,VY_MAX/1000,NVYD)
                fprintf('**                                                             **\n')
                VY_PLOT=input('**  Enter the Vy of interest: ');
                
                LEN=33-length(num2str(VY_PLOT));
                PAD(1:LEN)=' ';
                
                fprintf(['\b' PAD '**\n'])
                fprintf('*****************************************************************\n')

                VY_HIT(1:NPLOT)=0;
                for ii=1:NPLOT
                    [~,IND]=min(abs(VY(ii,1:NVYD)-VY_PLOT*1000));
                    VY_HIT(ii)=VY(ii,IND);
                    NG{ii}=NG{ii}(1:NVXD,IND);
                    NE{ii}=NE{ii}(1:NVXD,IND);
                end  

                LEG=cell(1,NPLOT);
                for ii=1:NPLOT
                    LEG{ii}=['x= ' num2str(X(X_IND(ii))*100,'%4.2f') ' cm - V_y= ' num2str(VY_HIT(ii)/1000,'%4.2f') ' km/s'];
                end

                FH=figure;
                subplot(1,2,1)
                hold on
                for ii=1:NPLOT
                    plot(VX(ii,1:NVXD)/1000,NG{ii},'-','Color',COL{ii},'LineWidth',5)
                end
                hold off
                xlabel('V_x (km/s)','FontSize',FONTSIZE)
                ylabel(['Gound State Density (' UNITS ')'],'FontSize',FONTSIZE)
                legend(LEG)
                grid on
                set(gca,'FontSize',FONTSIZE)

                subplot(1,2,2)
                hold on
                for ii=1:NPLOT
                    plot(VX(ii,1:NVXD)/1000,NE{ii},'-','Color',COL{ii},'LineWidth',5)
                end
                hold off
                xlabel('V_x (km/s)','FontSize',FONTSIZE)
                ylabel(['Excited State Density (' UNITS ')'],'FontSize',FONTSIZE)
                grid on
                set(gca,'FontSize',FONTSIZE)
            elseif strcmpi(VEL_DIM,'y')==1
                fprintf('\n*****************************************************************\n')
                fprintf('**  Vx= %5.2f to %5.2f km/s having %4i steps               n   **\n',VX_MIN/1000,VX_MAX/1000,NVXD)
                fprintf('**                                                             **\n')
                VX_PLOT=input('**  Enter the Vy of interest: ');
                
                
                LEN=33-length(num2str(VX_PLOT));
                PAD(1:LEN)=' ';
                
                fprintf(['\b' PAD '**\n'])
                fprintf('*****************************************************************\n')

                VX_HIT(1:NPLOT)=0;
                for ii=1:NPLOT
                    [~,IND]=min(abs(VX(ii,1:NVXD)-VX_PLOT*1000));
                    VX_HIT(ii)=VX(ii,IND);
                    NG{ii}=NG{ii}(IND,1:NVYD);
                    NE{ii}=NE{ii}(IND,1:NVYD);
                end   

                LEG=cell(1,NPLOT);
                for ii=1:NPLOT
                    LEG{ii}=['x= ' num2str(X(X_IND(ii))*100,'%4.2f') ' cm - V_x= ' num2str(VX_HIT(ii)/1000,'%4.2f') ' km/s'];
                end

                FH=figure;
                subplot(1,2,1)
                hold on
                for ii=1:NPLOT
                    plot(VY(ii,1:NVYD)/1000,NG{ii},'-','Color',COL{ii},'LineWidth',5)
                end
                hold off
                xlabel('V_y (km/s)','FontSize',FONTSIZE)
                ylabel(['Gound State Density (' UNITS ')'],'FontSize',FONTSIZE)
                legend(LEG)
                grid on
                set(gca,'FontSize',FONTSIZE)

                subplot(1,2,2)
                hold on
                for ii=1:NPLOT
                    plot(VY(ii,1:NVYD)/1000,NE{ii},'-','Color',COL{ii},'LineWidth',5)
                end
                hold off
                xlabel('V_y (km/s)','FontSize',FONTSIZE)
                ylabel(['Excited State Density (' UNITS ')'],'FontSize',FONTSIZE)
                grid on
                set(gca,'FontSize',FONTSIZE)
            end
        elseif NVXD==1
            LEG=cell(1,NPLOT);
            for ii=1:NPLOT
                LEG{ii}=['x= ' num2str(X(X_IND(ii))/100,'%4.2f') ' cm - V_x= ' num2str(VX(ii)/1000,'%4.2f') ' km/s'];
            end

            FH=figure;
            subplot(1,2,1)
            hold on
            for ii=1:NPLOT
                plot(VY(ii,1:NVYD)/1000,NG{ii},'-','Color',COL{ii},'LineWidth',5)
            end
            hold off
            xlabel('V_y (km/s)','FontSize',FONTSIZE)
            ylabel(['Gound State Density (' UNITS ')'],'FontSize',FONTSIZE)
            legend(LEG)
            grid on
            set(gca,'FontSize',FONTSIZE)

            subplot(1,2,2)
            hold on
            for ii=1:NPLOT
                plot(VY(ii,1:NVYD)/1000,NE{ii},'-','Color',COL{ii},'LineWidth',5)
            end
            hold off
            xlabel('V_y (km/s)','FontSize',FONTSIZE)
            ylabel(['Excited State Density (' UNITS ')'],'FontSize',FONTSIZE)
            grid on
            set(gca,'FontSize',FONTSIZE)
        elseif NVYD==1
            LEG=cell(1,NPLOT);
            for ii=1:NPLOT
                LEG{ii}=['x= ' num2str(X(X_IND(ii))*100,'%4.2f') ' GHz - V_y= ' num2str(VY(ii)/1000,'%4.2f') ' km/s'];
            end

            FH=figure;
            subplot(1,2,1)
            hold on
            for ii=1:NPLOT
                plot(VX(ii,1:NVXD)/1000,NG{ii},'-','Color',COL{ii},'LineWidth',5)
            end
            hold off
            xlabel('V_x (km/s)','FontSize',FONTSIZE)
            ylabel(['Gound State Density (' UNITS ')'],'FontSize',FONTSIZE)
            legend(LEG)
            grid on
            set(gca,'FontSize',FONTSIZE)

            subplot(1,2,2)
            hold on
            for ii=1:NPLOT
                plot(VX(ii,1:NVXD)/1000,NE{ii},'-','Color',COL{ii},'LineWidth',5)
            end
            hold off
            xlabel('V_x (km/s)','FontSize',FONTSIZE)
            ylabel(['Excited State Density (' UNITS ')'],'FontSize',FONTSIZE)
            grid on
            set(gca,'FontSize',FONTSIZE)
        end

        %*******************
        %Prompt user to quit
        %*******************
        fprintf('\n*****************************************************************\n')
        CONT=input('Continue (y/n): ','s');
        fprintf('\b                                              **\n')
        fprintf('*****************************************************************\n')
        if strcmpi(CONT,'y')==1
            END=0;

            try
                close(FH)
            catch
            end
        else
            END=1;
        end
    end
end

end