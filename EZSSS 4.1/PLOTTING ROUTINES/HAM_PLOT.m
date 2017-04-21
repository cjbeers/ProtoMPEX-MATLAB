function HAM_PLOT(HAM,PARA,FIELD,OPT)

%*************
%Plot fontsize
%*************
FONTSIZE=25;
FONTWEIGHT='Normal';

%*******************************
%Name for lower and upper levels
%*******************************
LEVEL={'Lower Level','Upper Level'};

%************
%Assign input
%************
HB=HAM.B;
HEDC=HAM.EDC;
HEQSA=HAM.EQSA;

Ho=HAM.UNPERTURBED;
H=HAM.TOTAL;
HF=HAM.FLOQ;

NS=PARA.NS;
NB=PARA.NB;
NBS=PARA.NBS;
ND=PARA.ND;
QN=PARA.QN;

B=FIELD.B;
EDC=FIELD.EDC;
ERF=FIELD.ERF;

SOLVER=OPT.SOLVER;
PLOT=OPT.PLOT;

%*******************
%Assign solver logic
%*******************
QSA_LOG=SOLVER.QSA_LOGIC;
MAN_LOG=SOLVER.MAN_LOGIC;

%******************************
%Assign number of ERF harmonics
%******************************
NH=ERF.NH;

%**************************************
%Add the unperturbed Hamiltonian matrix
%**************************************
if PLOT.HAM.ADD_H0==1
    for ii=1:2
        HB{ii}=HB{ii}+Ho{ii};
        HEDC{ii}=HEDC{ii}+Ho{ii};

        if ERF.LOGIC==1 && QSA_LOG==1
            for jj=1:ND
                HEQSA{ii,jj}=HEQSA{ii,jj}+Ho{ii};
            end
        elseif ERF.LOGIC==1 && QSA_LOG==0
            for jj=1:1+2*(NB(ii)+1)
                %*************
                %Assign indice
                %*************
                IND1=1+(jj-1)*NS(ii);
                IND2=jj*NS(ii);

                %***************************
                %Add to diagonal blocks only
                %***************************
                HF(IND1:IND2,IND1:IND2)=HF(IND1:IND2,IND1:IND2)+Ho{ii};
            end
        end
    end
end

%*************************
%Assign loop storage array
%*************************
H_DATA={HB,HEDC};

LOG_B=B.LOGIC;
LOG_EDC=(EDC.LOGIC==1&&ERF.LOGIC==0)||(EDC.LOGIC==1&&ERF.LOGIC==1&&QSA_LOG==0);

LOGIC_FIELD={LOG_B,LOG_EDC};
LOGIC_PLOT={PLOT.HAM.B,PLOT.HAM.EDC};
H_NAME={'B Field','E_{DC} Field'};

for uu=1:2
    %************
    %Assign logic
    %************
    LOG_FIELD=LOGIC_FIELD{uu};
    LOG_PLOT=LOGIC_PLOT{uu};
    
    %***********
    %Assign name
    %***********
    NAME=H_NAME{uu};
    
    if LOG_FIELD==1 && LOG_PLOT==1   
        for vv=1:2
            %***********************
            %Assign Hamiltonian data
            %***********************
            HPLOT=H_DATA{uu}{vv};

            %*******************
            %Gen. spectral terms
            %*******************
            TERM=SPEC_TERM(QN(vv,1:NS(vv)),NS(vv));

            %****************************
            %Assign max Hamiltonian value
            %****************************
            H_MAX=max(max(abs(HPLOT)));

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||    Plot non-zero components of the Hamiltonian   ||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

            %***************
            %Allocate memory
            %***************
            clear LEG PH
            LEG=cell(1,5);
            PH(1:5)=0;

            figure
            hold on
            for ii=1:NS(vv)
                for jj=1:NS(vv)
                    if abs(HPLOT(ii,jj))>0
                        %**************
                        %Calc size data
                        %**************
                        SIZE=abs(HPLOT(ii,jj))/H_MAX*1000;
                        
                        if imag(HPLOT(ii,jj))<0 && real(HPLOT(ii,jj))==0
                            LEG{1}='Negative Imaginary';
                            PH(1)=scatter(ii,jj,'o','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',SIZE);
                        elseif imag(HPLOT(ii,jj))>0 && real(HPLOT(ii,jj))==0
                            LEG{2}='Positive Imaginary';
                            PH(2)=scatter(ii,jj,'o','MarkerEdgeColor','k','MarkerFaceColor','k','SizeData',SIZE);
                        elseif real(HPLOT(ii,jj))<0 && imag(HPLOT(ii,jj))==0
                            LEG{3}='Negative Real';
                            PH(3)=scatter(ii,jj,'o','MarkerEdgeColor','b','MarkerFaceColor','b','SizeData',SIZE);
                        elseif real(HPLOT(ii,jj))>0 && imag(HPLOT(ii,jj))==0
                            LEG{4}='Positive Real';
                            PH(4)=scatter(ii,jj,'o','MarkerEdgeColor','g','MarkerFaceColor','g','SizeData',SIZE);
                        elseif real(HPLOT(ii,jj))~=0 && imag(HPLOT(ii,jj))~=0
                            LEG{5}='Complex';
                            PH(5)=scatter(ii,jj,'o','MarkerEdgeColor','m','MarkerFaceColor','m','SizeData',SIZE);
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
            axis([0 (NS(vv)+1) 0 (NS(vv)+1)])
            hold off
            xlabel('\phi_k','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            ylabel('\phi_i','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            title(['Hamiltonian for ' NAME '   -   ' LEVEL{vv} '   -   <\phi_i|H|\phi_k>'],'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            legend(PH,LEG)
            set(gca,'XTick',1:NS(vv),'XTickLabel',TERM)
            set(gca,'YTick',1:NS(vv),'YTickLabel',TERM)
            set(gca,'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)

        end
    end
end

if (ERF.LOGIC==1 || MAN_LOG==1) && QSA_LOG==1 && PLOT.HAM.EQSA==1 
    for vv=1:2
        %******************
        %Assign Hamiltonian
        %******************
        HPLOT=HEQSA(vv,1:ND);
        
        %*******************
        %Gen. spectral terms
        %*******************
        TERM=SPEC_TERM(QN(vv,1:NS(vv)),NS(vv));

        %****************************
        %Assign max Hamiltonian value
        %****************************
        H_MAX(1:ND)=0;
        for ii=1:ND
            H_MAX(ii)=max(max(abs(H{ii})));
        end
        H_MAX=max(H_MAX);

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||    Plot non-zero components of the Hamiltonian   ||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        %***************
        %Allocate memory
        %***************
        clear LEG PH
        LEG=cell(1,5);
        PH(1:5)=0;

        figure
        hold on
        for ii=1:NS(vv)
            for jj=1:NS(vv)
                for kk=1:ND
                    %**************
                    %Calc size data
                    %**************
                    SIZE=abs(HPLOT{kk}(ii,jj))/H_MAX*1000;
                    
                    if abs(HPLOT{kk}(ii,jj))>0
                        if imag(HPLOT{kk}(ii,jj))<0 && real(HPLOT{kk}(ii,jj))==0
                            LEG{1}='Negative Imaginary';
                            PH(1)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',SIZE);
                        elseif imag(HPLOT{kk}(ii,jj))>0 && real(HPLOT{kk}(ii,jj))==0
                            LEG{2}='Positive Imaginary';
                            PH(2)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','k','MarkerFaceColor','k','SizeData',SIZE);
                        elseif real(HPLOT{kk}(ii,jj))<0 && imag(HPLOT{kk}(ii,jj))==0
                            LEG{3}='Negative Real';
                            PH(3)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','b','MarkerFaceColor','b','SizeData',SIZE);
                        elseif real(HPLOT{kk}(ii,jj))>0 && imag(HPLOT{kk}(ii,jj))==0
                            LEG{4}='Positive Real';
                            PH(4)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','g','MarkerFaceColor','g','SizeData',SIZE);
                        elseif real(HPLOT{kk}(ii,jj))~=0 && imag(HPLOT{kk}(ii,jj))~=0
                            LEG{5}='Complex';
                            PH(5)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','m','MarkerFaceColor','m','SizeData',SIZE);
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
        axis([0 ND+1 0 (NS(vv)+1) 0 (NS(vv)+1)])
        hold off
        xlabel('Time Discretization Indice','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        ylabel('\phi_k','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        zlabel('\phi_i','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        title(['Hamiltonian for QSA of E_{RF}   -   ' LEVEL{vv} '   -   <\phi_i|H|\phi_k>'],'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        legend(PH,LEG)
        set(gca,'YTick',1:NS(vv),'YTickLabel',TERM)
        set(gca,'ZTick',1:NS(vv),'ZTickLabel',TERM)
        set(gca,'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        view([-10,25])
    end
end

if ERF.LOGIC==0 && PLOT.HAM.TOTAL==1   
    for vv=1:2
        %******************
        %Assign Hamiltonian
        %******************
        HPLOT=H{vv,1};
        
        %*******************
        %Gen. spectral terms
        %*******************
        TERM=SPEC_TERM(QN(vv,1:NS(vv)),NS(vv));

        %****************************
        %Assign max Hamiltonian value
        %****************************
        H_MAX=max(max(abs(HPLOT)));

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||    Plot non-zero components of the Hamiltonian   ||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        %***************
        %Allocate memory
        %***************
        clear LEG PH
        LEG=cell(1,5);
        PH(1:5)=0;

        figure
        hold on
        for ii=1:NS(vv)
            for jj=1:NS(vv)
                if abs(HPLOT(ii,jj))>0
                    %**************
                    %Calc size data
                    %**************
                    SIZE=abs(HPLOT(ii,jj))/H_MAX*1000;

                    if imag(HPLOT(ii,jj))<0 && real(HPLOT(ii,jj))==0
                        LEG{1}='Negative Imaginary';
                        PH(1)=scatter(ii,jj,'o','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',SIZE);
                    elseif imag(HPLOT(ii,jj))>0 && real(HPLOT(ii,jj))==0
                        LEG{2}='Positive Imaginary';
                        PH(2)=scatter(ii,jj,'o','MarkerEdgeColor','k','MarkerFaceColor','k','SizeData',SIZE);
                    elseif real(HPLOT(ii,jj))<0 && imag(HPLOT(ii,jj))==0
                        LEG{3}='Negative Real';
                        PH(3)=scatter(ii,jj,'o','MarkerEdgeColor','b','MarkerFaceColor','b','SizeData',SIZE);
                    elseif real(HPLOT(ii,jj))>0 && imag(HPLOT(ii,jj))==0
                        LEG{4}='Positive Real';
                        PH(4)=scatter(ii,jj,'o','MarkerEdgeColor','g','MarkerFaceColor','g','SizeData',SIZE);
                    elseif real(HPLOT(ii,jj))~=0 && imag(HPLOT(ii,jj))~=0
                        LEG{5}='Complex';
                        PH(5)=scatter(ii,jj,'o','MarkerEdgeColor','m','MarkerFaceColor','m','SizeData',SIZE);
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
        axis([0 (NS(vv)+1) 0 (NS(vv)+1)])
        hold off
        xlabel('\phi_k','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        ylabel('\phi_i','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        title(['Total Hamiltonian   -   ' LEVEL{vv} '   -   <\phi_i|H|\phi_k>'],'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        legend(PH,LEG)
        set(gca,'XTick',1:NS(vv),'XTickLabel',TERM)
        set(gca,'YTick',1:NS(vv),'YTickLabel',TERM)
        set(gca,'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
    end
    
elseif (ERF.LOGIC==1 || MAN_LOG==1) && QSA_LOG==1 && PLOT.HAM.TOTAL==1 
    
    for vv=1:2
        %******************
        %Assign Hamiltonian
        %******************
        HPLOT=H(vv,1:ND);
        
        %*******************
        %Gen. spectral terms
        %*******************
        TERM=SPEC_TERM(QN(vv,1:NS(vv)),NS(vv));

        %****************************
        %Assign max Hamiltonian value
        %****************************
        H_MAX(1:ND)=0;
        for ii=1:ND
            H_MAX(ii)=max(max(abs(HPLOT{ii})));
        end
        H_MAX=max(H_MAX);

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||    Plot non-zero components of the Hamiltonian   ||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        %***************
        %Allocate memory
        %***************
        clear LEG PH
        LEG=cell(1,5);
        PH(1:5)=0;

        figure
        hold on
        for ii=1:NS(vv)
            for jj=1:NS(vv)
                for kk=1:ND
                    %**************
                    %Calc size data
                    %**************
                    SIZE=abs(HPLOT{kk}(ii,jj))/H_MAX*1000;
                    
                    if abs(HPLOT{kk}(ii,jj))>0
                        if imag(HPLOT{kk}(ii,jj))<0 && real(HPLOT{kk}(ii,jj))==0
                            LEG{1}='Negative Imaginary';
                            PH(1)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',SIZE);
                        elseif imag(HPLOT{kk}(ii,jj))>0 && real(HPLOT{kk}(ii,jj))==0
                            LEG{2}='Positive Imaginary';
                            PH(2)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','k','MarkerFaceColor','k','SizeData',SIZE);
                        elseif real(HPLOT{kk}(ii,jj))<0 && imag(HPLOT{kk}(ii,jj))==0
                            LEG{3}='Negative Real';
                            PH(3)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','b','MarkerFaceColor','b','SizeData',SIZE);
                        elseif real(HPLOT{kk}(ii,jj))>0 && imag(HPLOT{kk}(ii,jj))==0
                            LEG{4}='Positive Real';
                            PH(4)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','g','MarkerFaceColor','g','SizeData',SIZE);
                        elseif real(HPLOT{kk}(ii,jj))~=0 && imag(HPLOT{kk}(ii,jj))~=0
                            LEG{5}='Complex';
                            PH(5)=scatter3(kk,ii,jj,'o','MarkerEdgeColor','m','MarkerFaceColor','m','SizeData',SIZE);
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
        axis([0 ND+1 0 (NS(vv)+1) 0 (NS(vv)+1)])
        hold off
        xlabel('Time Discretization Indice','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        ylabel('\phi_k','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        zlabel('\phi_i','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        title(['Total Hamiltonian for QSA   -   ' LEVEL{vv} '   -   <\phi_i|H|\phi_k>'],'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        legend(PH,LEG)
        set(gca,'YTick',1:NS(vv),'YTickLabel',TERM)
        set(gca,'ZTick',1:NS(vv),'ZTickLabel',TERM)
        set(gca,'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        view([-10,25])
    end   
    
elseif ERF.LOGIC==1 && QSA_LOG==0 && PLOT.HAM.TOTAL==1 
    
    for vv=1:2
        for uu=1:1+2*NH
            %******************
            %Assign Hamiltonian
            %******************
            HPLOT=H{vv,uu};

            %*******************
            %Gen. spectral terms
            %*******************
            TERM=SPEC_TERM(QN(vv,1:NS(vv)),NS(vv));

            %****************************
            %Assign max Hamiltonian value
            %****************************
            H_MAX=max(max(abs(HPLOT)));

    %<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    %||||||||||||    Plot non-zero components of the Hamiltonian   ||||||||||||
    %>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

            %***************
            %Allocate memory
            %***************
            clear LEG PH
            LEG=cell(1,5);
            PH(1:5)=0;

            figure
            hold on
            for ii=1:NS(vv)
                for jj=1:NS(vv)
                    if abs(HPLOT(ii,jj))>0
                        %**************
                        %Calc size data
                        %**************
                        SIZE=abs(HPLOT(ii,jj))/H_MAX*1000;

                        if imag(HPLOT(ii,jj))<0 && real(HPLOT(ii,jj))==0
                            LEG{1}='Negative Imaginary';
                            PH(1)=scatter(ii,jj,'o','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',SIZE);
                        elseif imag(HPLOT(ii,jj))>0 && real(HPLOT(ii,jj))==0
                            LEG{2}='Positive Imaginary';
                            PH(2)=scatter(ii,jj,'o','MarkerEdgeColor','k','MarkerFaceColor','k','SizeData',SIZE);
                        elseif real(HPLOT(ii,jj))<0 && imag(HPLOT(ii,jj))==0
                            LEG{3}='Negative Real';
                            PH(3)=scatter(ii,jj,'o','MarkerEdgeColor','b','MarkerFaceColor','b','SizeData',SIZE);
                        elseif real(HPLOT(ii,jj))>0 && imag(HPLOT(ii,jj))==0
                            LEG{4}='Positive Real';
                            PH(4)=scatter(ii,jj,'o','MarkerEdgeColor','g','MarkerFaceColor','g','SizeData',SIZE);
                        elseif real(HPLOT(ii,jj))~=0 && imag(HPLOT(ii,jj))~=0
                            LEG{5}='Complex';
                            PH(5)=scatter(ii,jj,'o','MarkerEdgeColor','m','MarkerFaceColor','m','SizeData',SIZE);
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

            %**************************
            %Calc. Floquet block indice
            %**************************
            if uu<=1+NH
                IND=uu-1;
            else
                IND=(1+NH)-uu;
            end
            
            grid on
            axis([0 (NS(vv)+1) 0 (NS(vv)+1)])
            hold off
            xlabel('\phi_k','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            ylabel('\phi_i','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            title(['Total Hamiltonian for Floquet Block ' num2str(IND) '   -   ' LEVEL{vv} '   -   <\phi_i|H|\phi_k>'],'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            legend(PH,LEG)
            set(gca,'XTick',1:NS(vv),'XTickLabel',TERM)
            set(gca,'YTick',1:NS(vv),'YTickLabel',TERM)
            set(gca,'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        end
    end
    
end

if ERF.LOGIC==1 && QSA_LOG==0 && PLOT.HAM.FLOQUET==1 
    
    for vv=1:2
        %******************
        %Assign Hamiltonian
        %******************
        HPLOT=HF{vv};

        %********************
        %Generate axis labels
        %********************
        TERM=cell(1,2*NB(vv)+1);
        for ii=1:2*NB(vv)+1
            TERM{ii}=num2str((NB(vv)+1)-ii);
        end
        
        %****************************
        %Assign max Hamiltonian value
        %****************************
        H_MAX=max(max(abs(HPLOT)));

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||    Plot non-zero components of the Floquet Hamiltonian   ||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        %***************
        %Allocate memory
        %***************
        clear LEG PH
        LEG=cell(1,5);
        PH(1:5)=0;
        
        figure
        hold on
        for ii=1:NBS(vv)
            for jj=1:NBS(vv)
                if abs(HPLOT(ii,jj))>0
                    %**************
                    %Calc size data
                    %**************
                    SIZE=abs(HPLOT(ii,jj))/H_MAX*1000;

                    if imag(HPLOT(ii,jj))<0 && real(HPLOT(ii,jj))==0
                        LEG{1}='Negative Imaginary';
                        PH(1)=scatter(jj,ii,'o','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',SIZE);
                    elseif imag(HPLOT(ii,jj))>0 && real(HPLOT(ii,jj))==0
                        LEG{2}='Positive Imaginary';
                        PH(2)=scatter(jj,ii,'o','MarkerEdgeColor','k','MarkerFaceColor','k','SizeData',SIZE);
                    elseif real(HPLOT(ii,jj))<0 && imag(HPLOT(ii,jj))==0
                        LEG{3}='Negative Real';
                        PH(3)=scatter(jj,ii,'o','MarkerEdgeColor','b','MarkerFaceColor','b','SizeData',SIZE);
                    elseif real(HPLOT(ii,jj))>0 && imag(HPLOT(ii,jj))==0
                        LEG{4}='Positive Real';
                        PH(4)=scatter(jj,ii,'o','MarkerEdgeColor','g','MarkerFaceColor','g','SizeData',SIZE);
                    elseif real(HPLOT(jj,ii))~=0 && imag(HPLOT(ii,jj))~=0
                        LEG{5}='Complex';
                        PH(5)=scatter(ii,jj,'o','MarkerEdgeColor','m','MarkerFaceColor','m','SizeData',SIZE);
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
        axis([0 (NBS(vv)+1) 0 (NBS(vv)+1)])
        hold off
        xlabel('Floquet Block (s)','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        ylabel('Floquet Block (s)','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        title(['Floquet Hamiltonian   -   ' LEVEL{vv} '   -   <\phi_i|HF|\phi_k>'],'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
        legend(PH,LEG)
        set(gca,'XTick',NS(vv)/2:NS(vv):NBS(vv)-NS(vv)/2,'XTickLabel',TERM)
        set(gca,'YTick',NS(vv)/2:NS(vv):NBS(vv)-NS(vv)/2,'YTickLabel',TERM)
        set(gca,'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
    end
    
end

end