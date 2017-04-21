function [Phi E]=FH_Solver(Ho,H,FH,PARA,FIELD,UNIV)

NCS=3;
eps_NZ=1e-6;
eps_CT=[1e-6 0.2];
opt(1:3)=0;


%************
%Assign input
%************
NS=PARA.NS;
NB_MAX=PARA.NB;
NBS_MAX=PARA.NBS;
FS=PARA.RAD{1};

B_ON=FIELD.B.LOGIC;
EDC=FIELD.EDC.MAG;
EDC_ON=FIELD.EDC.LOGIC;
ERF=FIELD.ERF.MAG;

%**************************************************************************
%When fine sturcture is not considered and when the static field is
%parallel to the dynamic field the energy eigenvalues are no longer a
%function of frequency and a simpler method can be used to extract the
%correct group of eigenvalues - Below is the logic which controls what
%alogrithum to impelement
%**************************************************************************
if (FS==1)
    if (B_ON==0)
        ERF_test=0;
        for ii=1:3
            if (sum(abs(ERF(:,ii)),1)>0)
                ERF_test=ERF_test+1;
            end
        end

        if (EDC_ON==0) && (ERF_test==1)
            TRACKER=1;
        elseif (sum(sum(abs(ERF(:,1:2)),1),2)==0) && (sum(abs(EDC(1:2)))==0)
            TRACKER=2;
        elseif (sum(sum(abs(ERF(:,2:3)),1),2)==0) && (sum(abs(EDC(2:3)))==0)
            TRACKER=2;
        elseif (sum(abs(ERF(:,1)))+sum(abs(ERF(:,3)))==0) && (abs(EDC(1))+abs(EDC(3))==0)
            TRACKER=2;
        else
            TRACKER=0;
        end
    else
        if (sum(sum(abs(ERF(:,1:2)),1),2)==0) && (sum(abs(EDC(1:2)))==0)
            TRACKER=2;
        else
            TRACKER=0;
        end
    end
else
    TRACKER=0;
end

%**************************************************************************
%Tracking the eigenvaules from a frequency where naturally grouping occurs
%to the frequency of interest.  The tracking routine is based on the logic
%determined above, TRACKER.
%**************************************************************************
if (TRACKER~=1)
    [EV_track IND_track NB_track]=FH_EVal_Track(TRACKER,ss,FH,H,H_PARA,F_PARA);
elseif (TRACKER==1)
    IND_track(1:NS)=NS*NB_MAX+1:NS*NB_MAX+NS;
    NB_track=NB_MAX;
end

%**************************************************************************
%Calculating the number of Floquet blocks associated with the convergence 
%test.  The number of Floquet blocks increases linearly from NB_track to 
%NB_MAX by NCS steps. NOTE the 'meshed' Floquet block value is rounded to 
%the nearest whole number. 
%**************************************************************************
if (opt(1)==1)
    NB_CT(1:NCS)=0;
    NBS_CT(1:NCS)=0;

    NB_CT(1)=NB_track;
    NBS_CT(1)=(2*NB_CT(1)+1)*NS;

    if (NB_MAX==NB_track)
        [EVec,EVal]=eig(FH);

        Phi(1:NBS_MAX,1:NS)=0;
        E(1:NS)=0;
        for ii=1:NS
            Phi(1:NBS_MAX,ii)=EVec(1:NBS_MAX,IND_track(ii));
            E(ii)=Ho(ii,ii,ss)+EVal(IND_track(ii),IND_track(ii));
        end
        clear EVec EVal

        return
    elseif ((NB_MAX-NB_track)/(NCS-1)<=1)
        for jj=2:NB_MAX-NB_track+1
            NB_CT(jj)=NB_CT(jj-1)+1;
            NBS_CT(jj)=(2*NB_CT(jj)+1)*NS;
            NCS=NB_MAX-NB_track+1;
        end
    else
        for jj=2:NCS;
            NB_CT(jj)=NB_CT(1)+round((NB_MAX-NB_track)/(NCS-1)*(jj-1));
            NBS_CT(jj)=(2*NB_CT(jj)+1)*NS;
        end
    end

    %**************************************************************************
    %Calculating the eigenvalues associated with the Floquet Hamiltonian having
    %the number of Floquet blocks defined above - for the convergence test.
    %**************************************************************************
    EV_CT(1:NBS_CT(NCS),1:NCS)=0;

    EV_CT(1:NBS_CT(1),1)=EV_track;
    for ii=2:NCS
        N1=NS*(NB_CT(NCS)-NB_CT(ii))+1;
        N2=NBS_CT(NCS)-NS*(NB_CT(NCS)-NB_CT(ii));
        FH_temp=FH(N1:N2,N1:N2);

        EV_CT(1:NBS_CT(ii),ii)=eig(FH_temp);
    end

    %**************************************************************************
    %Calculating the indicies at which the eigenvalues of interest are located.
    %NOTE:  This will only be true if the ordering of the eigenvalues is
    %uneffected by having insufficient Floquet blocks for convergence.
    %**************************************************************************
    IND_CT(1:NCS,1:NS)=0;

    IND_CT(1:NS,1)=IND_track;
    for ii=1:NS
        for jj=2:NCS
            IND_CT(ii,jj)=NS*(NB_CT(jj)-NB_CT(1))+IND_track(ii);
        end
    end

    %**************************************************************************
    %Determining if the eigenvalues have converged when the number of Floquet
    %blocks is equal to NB_MAX
    %**************************************************************************
    temp(1:NS)=0;
    for ii=1:NS
        for jj=1:NCS
            temp(ii,jj)=abs(EV_CT(IND_CT(ii,jj),jj));
        end
    end
    MAX_EV_CT=max(max(temp));

    error(1:NS,1:NCS-1)=0;
    for ii=1:NS
        for jj=1:NCS-1
            if (abs(EV_CT(IND_CT(ii,jj+1),jj+1))/MAX_EV_CT>eps_NZ)
                error(ii,jj)=(EV_CT(IND_CT(ii,jj),jj)-EV_CT(IND_CT(ii,jj+1),jj+1))/EV_CT(IND_CT(ii,jj+1),jj+1);
            end
        end
    end

    CT=0;
    for ii=1:NS
        if (max(abs(error(ii,:)))>eps_CT(1))
            for jj=1:NCS-2
                if (abs(error(ii,jj+1))>abs(error(ii,jj)))
                    CT=1;
                end
            end
        end
    end

    for ii=1:NS
        if (error(ii,NCS-1)>0)
            if (abs(error(ii,NCS-1))>eps_CT(2))
                fprintf('************************************WARNING**********************************\n')
                fprintf('      ------------------ The solution has not converged ------------------\n\n')
                fprintf('                   Increasing the number of Floquet blocks\n')
                fprintf('************************************WARNING**********************************\n\n')
                break
            end
        end
    end

    if (CT==1) 
        fprintf('************************************WARNING**********************************\n')
        fprintf('Error in eigenvalues is not monotonically decreasing as the number of Floquet\n')
        fprintf('blocks is increased.  Convergence to correct solution not guaranteed!\n')
        fprintf('************************************WARNING**********************************\n\n')
    end
end

%**************************************************************************
%Calculating the eigenvalues and eigenvectors of the Floquet Hamiltonian
%having the required number of Floquet blocks for a converged solution, 
%NB_MAX.  NOTE --- Adding unperturbed eigenvalues to pertrubed eigenvalues.
%**************************************************************************
[EVec,EVal]=eig(FH);

IND_sol(1:NS)=0;
Phi(1:NBS_MAX,1:NS)=0;
for ii=1:NS
    IND_sol(ii)=NS*(NB_MAX-NB_track)+IND_track(ii);
    Phi(1:NBS_MAX,ii)=EVec(1:NBS_MAX,IND_sol(ii));
    E(ii)=Ho(ii,ii,ss)+EVal(IND_sol(ii),IND_sol(ii));
end

if (opt(2)==1)
    FH_EVec_Plot(ss,EVec,IND_sol,H_PARA)
end
clear EVec EVal

if (opt(3)==1)
    shape={'o','o','o','o','o','o','d','d','d','d','d','d','s','s','s','s','s','s','o','o','o','o','o','o','d','d','d','d','d','d','s','s','s','s','s','s'};
    color={'r','k','b','m','c','r','k','r','y','b','m','c','k','r','k','b','m','c','r','k','b','m','c','r','k','r','y','b','m','c','k','r','k','b','m','c'};

    figure
    hold on
    for jj=1:NCS
        plot(NS*(NB_CT(NCS)-NB_CT(jj))+1:NS*(NB_CT(NCS)-NB_CT(jj))+NBS_CT(jj),EV_CT(1:NBS_CT(jj),jj)*1e6,'-kd','MarkerEdgeColor','k')
    end
    for jj=1:NCS
        for ii=1:NS
            scatter(NS*(NB_CT(NCS)-NB_CT(jj))+IND_CT(ii,jj),EV_CT(IND_CT(ii,jj),jj)*1e6,'o','MarkerEdgeColor',color{ii},'MarkerFaceColor',color{ii},'SizeData',80)
        end
    end
    hold off
    xlabel('Eigenvalue Number','FontSize',26,'FontWeight','Bold'); 
    ylabel('Eigenvalue (\mueV)','FontSize',26,'FontWeight','Bold');
    title(['Eigenvalues of the Floquet Matrix for n=' num2str(n)],'FontSize',28,'Color','k','FontWeight','Bold');
    grid on
    set(gca,'FontSize',22,'FontWeight','Bold')

    E_temp(1:NS,1:NCS)=0;
    for ii=1:NS
        for jj=1:NCS
            E_temp(ii,jj)=EV_CT(IND_CT(ii,jj),jj);
        end
    end

    figure
    hold on
    for ii=1:NS
        plot(NB_CT(1:NCS),E_temp(ii,1:NCS)*1e6,['-' color{ii} shape{ii}],'MarkerFaceColor',color{ii},'MarkerEdgeColor',color{ii},'LineWidth',2,'MarkerSize',2)
    end
    hold off
    xlabel('Number of Floquet Blocks','FontSize',26,'FontWeight','Bold'); 
    ylabel('Eigenvalue (\mueV)','FontSize',26,'FontWeight','Bold');
    title(['Eigenvalues of the Floquet Matrix for n=' num2str(n)],'FontSize',28,'Color','k','FontWeight','Bold');
    grid on
    set(gca,'FontSize',22,'FontWeight','Bold')

    figure
    hold on
    for ii=1:NS
        plot(NB_CT(1:NCS-1),10*log10(abs(error(ii,1:NCS-1))),['-' color{ii} shape{ii}],'MarkerFaceColor',color{ii},'MarkerEdgeColor',color{ii},'LineWidth',2,'MarkerSize',2)
    end
    hold off
    xlabel('Number of Floquet Blocks','FontSize',26,'FontWeight','Bold'); 
    ylabel('Relative Eigenvalue Difference (dB)','FontSize',26,'FontWeight','Bold');
    title(['Relative Difference in Eigenvalues of the Floquet Matrix for n=' num2str(n)],'FontSize',28,'Color','k','FontWeight','Bold');
    grid on
    set(gca,'FontSize',22,'FontWeight','Bold')
end

end