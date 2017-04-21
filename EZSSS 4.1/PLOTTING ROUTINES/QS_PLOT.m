function QS_PLOT(STATE,FIELD,OPT)

%*************
%Plot fontsize
%*************
FONTSIZE=25;
FONTWEIGHT='Normal';

%**********************
%Machine error estimate
%**********************
EPS_REAL=1e-8;
EPS_IMAG=1e-8;

%*******************************
%Name for lower and upper levels
%*******************************
LEVEL={'Lower Level','Upper Level'};

%************
%Assign input
%************
ND=STATE.ND;
LL=STATE.LL;
UL=STATE.UL;

ERF=FIELD.ERF;

SOLVER=OPT.SOLVER;
PLOT=OPT.PLOT;

%*******************
%Assign solver logic
%*******************
QSA_LOG=SOLVER.QSA_LOGIC;
MAN_LOG=SOLVER.MAN_LOGIC;

%*************************
%Assign loop storage array
%*************************
DATA={LL,UL};

for uu=1:2
    %********************************
    %Assign quantum state information
    %********************************
    QN=DATA{uu}.QN;
    NS=DATA{uu}.NS;
    NB=DATA{uu}.NB;

    EL=DATA{uu}.EL;
    WF=DATA{uu}.WF;
    
    %**********************
    %Calc. min energy level
    %**********************
    EL_0=min(min(EL));

    %****************************
    %Calc. total number of states
    %****************************
    NBS=NS*(2*NB+1);

    %*******************
    %Gen. spectral terms
    %*******************
    TERM=SPEC_TERM(QN,NS);

    %******************************
    %Assign max eigenfunction value
    %******************************
    WF_MAX(1:NS,1:ND)=0;
    for ii=1:NS
        for jj=1:ND
            WF_MAX(ii,jj)=max(abs(WF{ii,jj}));
        end
    end
    WF_MAX=max(max(WF_MAX));

    for ii=1:NS
        for jj=1:NBS
            for kk=1:ND
                if abs(real(WF{ii,kk}(jj)))/WF_MAX<EPS_REAL
                    %*********************
                    %Drop small real terms
                    %*********************
                    WF{ii,kk}(jj)=1i*imag(WF{ii}(jj));
                elseif abs(imag(WF{ii,kk}(jj)))/WF_MAX<EPS_IMAG
                    %*********************
                    %Drop small real terms
                    %*********************
                    WF{ii,kk}(jj)=real(WF{ii,kk}(jj));
                end
            end
        end
    end 

    if ERF.LOGIC==0 && (QSA_LOG==0 || (QSA_LOG==1 && MAN_LOG==0))

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||    Plot non-zero components of the eigenvector   ||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        if PLOT.QS.WF==1
            
            %***************
            %Allocate memory
            %***************
            clear LEG PH
            LEG=cell(1,5);
            PH(1:5)=0;

            figure
            hold on
            for ii=1:NS
                %**************
                %Calc size data
                %**************
                SIZE=abs(WF{ii})/WF_MAX*1000;

                for jj=1:NS
                    if abs(WF{ii}(jj))>0
                        if imag(WF{ii}(jj))<0 && real(WF{ii}(jj))==0
                            LEG{1}='Negative Imaginary';
                            PH(1)=scatter(ii,jj,'o','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',SIZE(jj));
                        elseif imag(WF{ii}(jj))>0 && real(WF{ii}(jj))==0
                            LEG{2}='Positive Imaginary';
                            PH(2)=scatter(ii,jj,'o','MarkerEdgeColor','k','MarkerFaceColor','k','SizeData',SIZE(jj));
                        elseif real(WF{ii}(jj))<0 && imag(WF{ii}(jj))==0
                            LEG{3}='Negative Real';
                            PH(3)=scatter(ii,jj,'o','MarkerEdgeColor','b','MarkerFaceColor','b','SizeData',SIZE(jj));
                        elseif real(WF{ii}(jj))>0 && imag(WF{ii}(jj))==0
                            LEG{4}='Positive Real';
                            PH(4)=scatter(ii,jj,'o','MarkerEdgeColor','g','MarkerFaceColor','g','SizeData',SIZE(jj));
                        elseif real(WF{ii}(jj))~=0 && imag(WF{ii}(jj))~=0
                            LEG{5}='Complex';
                            PH(5)=scatter(ii,jj,'o','MarkerEdgeColor','m','MarkerFaceColor','m','SizeData',SIZE(jj));
                        end
                    end
                end
            end

            %******************************
            %Assign plot handles and legend
            %******************************
            LOG=PH~=0;
            PH=PH(LOG);
            LEG=LEG(LOG);

            grid on
            axis([0 (NS+1) 0 (NS+1)])
            hold off
            xlabel('\Phi_n','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            ylabel('\phi_i','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            title([LEVEL{uu} '   -   <\phi_i|\Phi_n>'],'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            legend(PH,LEG)
            set(gca,'XTick',1:NS)
            set(gca,'YTick',1:NS,'YTickLabel',TERM)
            set(gca,'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)

        end
        
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||    Plot the eigenvalues   ||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        if PLOT.QS.EL==1
    
            figure
            hold on
            for ii=1:NS
                X=[(ii-1)+.1 ii-.1];
                Y=[EL(ii) EL(ii)]-EL_0;
                
                plot(X,Y*1e6,'k','LineWidth',5)
            end
            hold off
            grid on
            xlim([0 NS])
            xlabel('\Phi_n','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            ylabel('Energy (\mueV)','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            title([LEVEL{uu} ' - Offset by ' num2str(EL_0) ' eV'],'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            set(gca,'XTick',1:NS)
            set(gca,'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        
        end

    elseif (ERF.LOGIC==1 || MAN_LOG==1) && QSA_LOG==1

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||    Plot non-zero components of the eigenvector   ||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        if PLOT.QS.WF==1

            %***************
            %Allocate memory
            %***************
            clear LEG PH
            LEG=cell(1,5);
            PH(1:5)=0;

            figure
            hold on
            for ii=1:NS
                for kk=1:ND
                    %**************
                    %Calc size data
                    %**************
                    SIZE=abs(WF{ii,kk})/WF_MAX*1000;

                    for jj=1:NS
                        if abs(WF{ii,kk}(jj))>0
                            if imag(WF{ii,kk}(jj))<0 && real(WF{ii,kk}(jj))==0
                                LEG{1}='Negative Imaginary';
                                PH(1)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',SIZE(jj));
                            elseif imag(WF{ii,kk}(jj))>0 && real(WF{ii,kk}(jj))==0
                                LEG{2}='Positive Imaginary';
                                PH(2)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','k','MarkerFaceColor','k','SizeData',SIZE(jj));
                            elseif real(WF{ii,kk}(jj))<0 && imag(WF{ii,kk}(jj))==0
                                LEG{3}='Negative Real';
                                PH(3)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','b','MarkerFaceColor','b','SizeData',SIZE(jj));
                            elseif real(WF{ii,kk}(jj))>0 && imag(WF{ii,kk}(jj))==0
                                LEG{4}='Positive Real';
                                PH(4)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','g','MarkerFaceColor','g','SizeData',SIZE(jj));
                            elseif real(WF{ii,kk}(jj))~=0 && imag(WF{ii,kk}(jj))~=0
                                LEG{5}='Complex';
                                PH(5)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','m','MarkerFaceColor','m','SizeData',SIZE(jj));
                            end
                        end
                    end
                end
            end

            %******************************
            %Assign plot handles and legend
            %******************************
            LOG=PH~=0;
            PH=PH(LOG);
            LEG=LEG(LOG);

            grid on
            axis([0 ND+1 0 (NS+1) 0 (NS+1)])
            hold off
            xlabel('Time Discretization Indice','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            ylabel('\Phi_n','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            zlabel('\phi_i','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            title([LEVEL{uu} '   -   <\phi_i|\Phi_n>'],'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            legend(PH,LEG)
            set(gca,'YTick',1:NS)
            set(gca,'ZTick',1:NS,'ZTickLabel',TERM)
            set(gca,'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            view([-10,25])
        
        end
        
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%|||||||||||||||||||||    Plot the eigenvalues   ||||||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        if PLOT.QS.EL==1

            figure
            hold on
            for ii=1:NS
                for jj=1:ND
                    X=[(jj-1)+.1 (jj-1)+.1 jj-.1 jj-.1];
                    Y=[(ii-1)+.1 ii-.1 ii-.1 (ii-1)+.1];
                    Z=[EL(ii,jj) EL(ii,jj) EL(ii,jj) EL(ii,jj)]-EL_0;
                    fill3(X,Y,Z*1e6,'k','LineStyle','none')
                end
            end
            hold off
            grid on
            axis([0 ND+1 0 NS+1 min(min(EL-EL_0))*1e6 max(max(EL-EL_0))*1e6])
            xlabel('Time Discretization Indice','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            ylabel('\Phi_n','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            zlabel('Energy (\mueV)','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            title([LEVEL{uu} ' - Offset by ' num2str(EL_0) ' eV'],'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            set(gca,'YTick',1:NS)
            set(gca,'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            view([-50 10])
        
        end
        
    elseif ERF.LOGIC==1 && QSA_LOG==0

    end
end

end