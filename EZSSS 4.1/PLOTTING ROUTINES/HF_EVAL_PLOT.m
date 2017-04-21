function FH_EVal_Plot(DATA,ss,H_PARA,F_PARA,FH)

nu=DATA{1};

EV=DATA{2}{1};
EV_FULL=DATA{2}{2};
EV_IND=DATA{2}{3};

EV_PO=DATA{3}{1};
EV_DM=DATA{3}{2};
EV_LC=DATA{3}{3};

ND=DATA{4}{1};
NB=DATA{4}{2};
NBS=DATA{4}{3};
TI=DATA{4}{4};
M_TI=DATA{4}{5};
DEG=DATA{4}{6};
NS_DEG=DATA{4}{7};

%**************************************************************************
%                           Universal Constants
%**************************************************************************
hbar=1.054571628e-34;
q=1.602176487e-19;

%**************************************************************************
%Fundamental frequency of dynamic electric field
%**************************************************************************
nu_o=F_PARA{5};

%**************************************************************************
%Defining the Hamiltonian parameters
%**************************************************************************
NS=H_PARA{2}{1}(ss);
n=H_PARA{2}{3}{4}(ss);

NBS_MAX=H_PARA{3}{2}(ss);
NB_MAX=H_PARA{3}{1}(ss);

shape={'o','o','o','o','o','o','d','d','d','d','d','d','s','s','s','s','s','s','o','o','o','o','o','o','d','d','d','d','d','d','s','s','s','s','s','s'};
color={'r','k','b','m','c','g','r','k','b','m','c','g','r','k','b','m','c','g','r','k','b','m','c','g','r','k','b','m','c','g','r','k','b','m','c','g'};

%**************************************************************************
%Plotting all the scaling as a function of frequency
%**************************************************************************
figure
plot(nu(1:TI,1)/1e9,M_TI(1:TI),'-kd','MarkerFaceColor','k','MarkerEdgeColor','k')
title('Frequency Step Size Scaling','FontSize',28,'FontWeight','Bold')
xlabel('Frequency (GHz)','FontSize',26,'FontWeight','Bold')
ylabel('Scaling','FontSize',26,'FontWeight','Bold')
xlim([nu(TI,1) nu(1,1)]/1e9)
set(gca,'FontSize',22)

% **************************************************************************
% Plotting eigenvalue predictor order as a function of frequency
% **************************************************************************
jj=0;
SUM=0;
figure
hold on
for ii=1:NS
    if (ii>SUM)
        jj=jj+1;
        SUM=SUM+DEG(ii);
    end
    plot(nu(1:TI,1)/1e9,EV_PO(ii,1:TI)-1,['-' color{jj} shape{jj}],'MarkerFaceColor',color{jj},'MarkerEdgeColor',color{jj},'LineWidth',1.5,'MarkerSize',2)
end
hold off
title('Number of Derivatives Utilized for Extrapolation','FontSize',28,'FontWeight','Bold')
xlabel('Frequency (GHz)','FontSize',26,'FontWeight','Bold')
ylabel('Derivative Order','FontSize',26,'FontWeight','Bold')
xlim([nu(TI,1) nu(1,1)]/1e9)
set(gca,'FontSize',22)

% **************************************************************************
% Plotting eigenvalue predictor error as a function of frequency
% **************************************************************************
jj=0;
SUM=0;
figure
hold on
for ii=1:NS
    if (ii>SUM)
        jj=jj+1;
        SUM=SUM+DEG(ii);
    end
    plot(nu(1:TI,1)/1e9,EV_DM(ii,1:TI)*100,['-' color{jj} shape{jj}],'MarkerFaceColor',color{jj},'MarkerEdgeColor',color{jj},'LineWidth',2,'MarkerSize',2)
end
hold off
title('Predictor Error','FontSize',28,'FontWeight','Bold')
xlabel('Frequency (GHz)','FontSize',26,'FontWeight','Bold')
ylabel('Predictor Error (%)','FontSize',26,'FontWeight','Bold')
xlim([nu(TI,1) nu(1,1)]/1e9)
set(gca,'FontSize',22)

% **************************************************************************
% Plotting eigenvalue predictor error as a function of frequency
% **************************************************************************
PH(1:3)=0;
figure
hold on
for ii=1:NS
    for jj=1:ii-1
        if (EV_LC(ii,jj)==0) && (NS_DEG(ii)~=NS_DEG(jj))
            PH(1)=scatter(ii,jj,'x','MarkerFaceColor','k','MarkerEdgeColor','k','SizeData',200);
        elseif (EV_LC(ii,jj)==1)
            PH(2)=scatter(ii,jj,'o','MarkerFaceColor','r','MarkerEdgeColor','r','SizeData',200);
        elseif (EV_LC(ii,jj)==2)
            PH(3)=scatter(ii,jj,'d','MarkerFaceColor','b','MarkerEdgeColor','b','SizeData',200);
        end
    end
end

for ii=1:NS
    for jj=1:ii-1;
        if (jj+1<=ii-1)
            if (NS_DEG(jj)==NS_DEG(jj+1)) && (NS_DEG(ii)~=NS_DEG(jj))
                plot([ii ii],[jj jj+1],'-k','LineWidth',1.5)
            end
        end
    end
    
    for jj=ii+1:NS
        if (jj+1<=NS)
            if (NS_DEG(jj)==NS_DEG(jj+1)) && (NS_DEG(ii)~=NS_DEG(jj))
                plot([jj jj+1],[ii ii],'-k','LineWidth',1.5)
            end
        end
    end     
end

hold off
jj=0;
LEG={'Unknown','Crossing States','Anticrossing States'};
temp1(1:3)=0;
temp2=cell(1,3);
for ii=1:3
    if (PH(ii)~=0)
        jj=jj+1;
        temp1(jj)=PH(ii);
        temp2{jj}=LEG{ii};
    end
end
title('Quantum State Interaction Matrix','FontSize',28,'FontWeight','Bold')
xlabel('Quantum State Indice','FontSize',26,'FontWeight','Bold')
ylabel('Quantum State Indice','FontSize',26,'FontWeight','Bold')
axis([1 NS 1 NS])
legend(temp1(1:jj),temp2{1:jj},'Location','NorthWest')
set(gca,'FontSize',22)

%**************************************************************************
% Plotting all the scaling as a function of frequency
%**************************************************************************
EV_IND_T(1:NS,1:TI)=0;
for ii=1:NS
    for jj=1:TI
        EV_IND_T(ii,jj)=NS*(NB(TI)-NB(jj))+EV_IND(ii,jj);
    end
end

jj=0;
SUM=0;
figure
hold on
for ii=1:NS
    if (ii>SUM)
        jj=jj+1;
        SUM=SUM+DEG(ii);
    end
    plot(nu(1:TI,1)/1e9,EV_IND_T(ii,1:TI),['-' color{jj} shape{jj}],'MarkerFaceColor',color{jj},'MarkerEdgeColor',color{jj},'LineWidth',2,'MarkerSize',2)
end
hold off
title('Eigenvalue Indice as function of Frequency','FontSize',28,'FontWeight','Bold')
xlabel('Frequency (GHz)','FontSize',26,'FontWeight','Bold')
ylabel('Eigenvalue Indice','FontSize',26,'FontWeight','Bold')
xlim([nu(TI,1) nu(1,1)]/1e9)
set(gca,'FontSize',22)

%**************************************************************************
%Plotting all of the eigenvalues of the Floquet Matrix
%**************************************************************************
figure
hold on
temp(1:NBS_MAX)=0;
for ii=1:TI
    temp(1:NBS(ii))=nu(ii,1);
    plot(temp(1:NBS(ii))/1e9,EV_FULL(1:NBS(ii),ii)*1e6,'.k')
end

jj=0;
SUM=0;
for ii=1:NS
    if (ii>SUM)
        jj=jj+1;
        SUM=SUM+DEG(ii);
    end
    plot(nu(1:TI,1)/1e9,EV(ii,1:TI,1)*1e6,['-' color{jj} shape{jj}],'MarkerFaceColor',color{jj},'MarkerEdgeColor',color{jj},'LineWidth',2,'MarkerSize',2)
end
hold off
title(['Eigenvalues of the Floquet Matrix for n=' num2str(n)],'FontSize',28,'FontWeight','Bold')
xlabel('Frequency (GHz)','FontSize',26,'FontWeight','Bold')
ylabel('Eigenvalue (\mueV)','FontSize',26,'FontWeight','Bold')
xlim([nu(TI,1) nu(1,1)]/1e9)
set(gca,'FontSize',22)

%**************************************************************************
%Plotting the selected eigenvalues of the Floquet Matrix
%**************************************************************************
SN=[0 1];
for vv=1:2
    figure
    hold on
    for ss=1:2*SN(vv)+1
        clear temp1
        temp1(1:TI)=(SN(vv)+1-ss)*2*pi*hbar/q*nu(1:TI,1);

        jj=0;
        SUM=0;
        for ii=1:NS
            clear temp2 temp3
            temp2(1:TI)=EV(ii,1:TI,1);
            temp3=temp1+temp2;
            if (ii>SUM)
                jj=jj+1;
                SUM=SUM+DEG(ii);
            end
            if (ss==SN(vv)+1)
                if (vv==1)
                    LW=1;
                else
                    LW=2;
                end                   
                plot(nu(1:TI,1)/1e9,temp3*1e6,['-' color{jj} shape{jj}],'MarkerFaceColor',color{jj},'MarkerEdgeColor',color{jj},'LineWidth',LW,'MarkerSize',2)
            else
                plot(nu(1:TI,1)/1e9,temp3*1e6,['-' color{jj}],'LineWidth',1)
            end
        end
    end
    hold off
    title(['Desired Eigenvalues of Floquet Matrix for n=' num2str(n)],'FontSize',28,'FontWeight','Bold')
    xlabel('Frequency (GHz)','FontSize',26,'FontWeight','Bold')
    ylabel('Eigenvalue (\mueV)','FontSize',26,'FontWeight','Bold')
    legend(['B=' num2str(F_PARA{1}) ' T - E_{DC}=' num2str(F_PARA{2}(3)/1e5) ' kV/cm - E_{RF}=' num2str(F_PARA{3}(3)/1e5) ' kV/cm - \omega/2\pi=' num2str(nu_o/1e9) ' GHz'])
    xlim([nu(TI,1) nu(1,1)]/1e9)
    set(gca,'FontSize',22)
end

%**************************************************************************
%Plotting the selected eigenvalues of the Floquet Matrix
%**************************************************************************
% SN=30;
% for vv=1
%     jj=0;
%     SUM=0;
%     for ii=1:NS    
%         figure
%         hold on
% 
%         for ss=1:2*SN(vv)+1
%             clear temp1
%             temp1(1:TI)=(SN(vv)+1-ss)*2*pi*hbar/q*nu(1:TI,1);            
%             clear temp2 temp3
%             temp2(1:TI)=EV(ii,1:TI,1);
%             temp3=temp1+temp2;
%             if (ii>SUM)
%                 jj=jj+1;
%                 SUM=SUM+DEG(ii);
%             end
%             if (ss==SN(vv)+1)
%                 if (vv==1)
%                     LW=2;
%                 else
%                     LW=2;
%                 end                   
%                 plot(nu(1:TI,1)/1e9,temp3*1e6,['-' color{jj} shape{jj}],'MarkerFaceColor',color{jj},'MarkerEdgeColor',color{jj},'LineWidth',LW,'MarkerSize',2)
%             else
%                 plot(nu(1:TI,1)/1e9,temp3*1e6,['-' color{jj}],'LineWidth',LW)
%             end
%         end
%     end
%     hold off
%     title(['Desired Eigenvalues of Floquet Matrix for n=' num2str(n)],'FontSize',28,'FontWeight','Bold')
%     xlabel('Frequency (GHz)','FontSize',26,'FontWeight','Bold')
%     ylabel('Eigenvalue (\mueV)','FontSize',26,'FontWeight','Bold')
%     legend(['B=' num2str(F_PARA{1}) ' T - E_{DC}=' num2str(F_PARA{2}(3)/1e5) ' kV/cm - E_{RF}=' num2str(F_PARA{3}(3)/1e5) ' kV/cm - \omega/2\pi=' num2str(nu_o/1e9) ' GHz'])
%     xlim([nu(TI,1) nu(1,1)]/1e9)
%     set(gca,'FontSize',22)
% end

NP(1:NS,1:NB(TI))=0;
NPC(1:NS,1:NB(TI))=0;
EMP(1:NS,1:2*(2*NB(TI)+1),1:NB(TI))=0;
EMPD(1:NS,1:2*(2*NB(TI)+1),1:NB(TI))=0;
EV_FULLT(1:NBS_MAX,1:NB(TI))=0;
EVT(1:NS,1:NB(TI))=0;
NBST(1:NB(TI))=0;
NBT(1:NB(TI))=0;

FE=2*pi*hbar*nu(TI,1)/q;
EPS=FE*1e-7;
yy=0;
for zz=NB(TI):-1:1
    yy=yy+1;
    NBST(yy)=NS*(2*zz+1);
    NBT(yy)=zz;
    
    N1=NS*(NB_MAX-zz)+1;
    N2=NBS_MAX-NS*(NB_MAX-zz);

    

    FH_temp=FH(N1:N2,N1:N2);
    for jj=1:2*NBT(yy)+1
        N1=1+NS*(jj-1);
        N2=NS*jj;
        N3=-NBT(yy)+(jj-1);
        FH_temp(N1:N2,N1:N2)=FH_temp(N1:N2,N1:N2)-eye(NS)*N3*FE;
    end

    EV_FULLT(1:NBST(yy),yy)=eig(FH_temp);
    
    for ii=1:NS
        
        if (yy==1)
            [~,IND1]=min(abs(EV_FULLT(1:NBST(yy),yy)-EV(ii,TI,1)));
            [~,IND2]=min(abs(EV_FULLT(1:NBST(yy),yy)-EV(ii,TI,1)-FE));
            [~,IND3]=min(abs(EV_FULLT(1:NBST(yy),yy)-EV(ii,TI,1)+FE));
            [~,IND4]=min(abs(EV_FULLT(1:NBST(yy),yy)-EV(ii,TI,1)-2*FE));
            [~,IND5]=min(abs(EV_FULLT(1:NBST(yy),yy)-EV(ii,TI,1)+2*FE));
            EVT1(ii,yy)=EV_FULLT(IND1,yy);
            EVT2(ii,yy)=EV_FULLT(IND2,yy);
            EVT3(ii,yy)=EV_FULLT(IND3,yy);
            EVT4(ii,yy)=EV_FULLT(IND4,yy);
            EVT5(ii,yy)=EV_FULLT(IND5,yy);
        else
            [~,IND1]=min(abs(EV_FULLT(1:NBST(yy),yy)-EVT1(ii,yy-1)));
            [~,IND2]=min(abs(EV_FULLT(1:NBST(yy),yy)-EVT2(ii,yy-1)));
            [~,IND3]=min(abs(EV_FULLT(1:NBST(yy),yy)-EVT3(ii,yy-1)));
            [~,IND4]=min(abs(EV_FULLT(1:NBST(yy),yy)-EVT4(ii,yy-1)));
            [~,IND5]=min(abs(EV_FULLT(1:NBST(yy),yy)-EVT5(ii,yy-1)));            
            EVT1(ii,yy)=EV_FULLT(IND1,yy);
            EVT2(ii,yy)=EV_FULLT(IND2,yy);
            EVT3(ii,yy)=EV_FULLT(IND3,yy);
            EVT4(ii,yy)=EV_FULLT(IND4,yy);
            EVT5(ii,yy)=EV_FULLT(IND5,yy);            
        end
    end

    for ii=1:NS
        for jj=1:NBST(yy)
            for kk=1:NBT(yy)+1
                if (abs(abs(EV_FULLT(jj,yy)-EVT1(ii,yy))-kk*FE)<=EPS) || (abs(abs(EV_FULLT(jj,yy)-EVT2(ii,yy))-kk*FE)<=EPS) || (abs(abs(EV_FULLT(jj,yy)-EVT3(ii,yy))-kk*FE)<=EPS) || (abs(abs(EV_FULLT(jj,yy)-EVT4(ii,yy))-kk*FE)<=EPS) || (abs(abs(EV_FULLT(jj,yy)-EVT5(ii,yy))-kk*FE)<=EPS) 
                    NP(ii,yy)=NP(ii,yy)+1;
                    EMP(ii,NP(ii,yy),yy)=EV_FULLT(jj,yy);
                  
                    break
                elseif (abs(EV_FULLT(jj,yy)-EVT1(ii,yy))<=EPS)
                    NPC(ii,yy)=NP(ii,yy)+1;
                    NP(ii,yy)=NP(ii,yy)+1;
                    EMP(ii,NP(ii,yy),yy)=EV_FULLT(jj,yy);
                    break
                end
            end
        end
    end

    for ii=1:NS
        for jj=1:NP(ii,yy)-1
            EMPD(ii,jj,yy)=abs(EMP(ii,jj+1,yy)-EMP(ii,jj,yy))-FE;
        end
    end
end
NT=yy;

NIP(1:NS,1:max(max(NP)))=0;
ERRP(1:NS,1:max(max(NP)),1:NT)=0;
NTT(1:NS,1:max(max(NP)),1:NT)=0;
PE(1:NS,1:max(max(NP)),1:NT)=0;
for ii=1:NS
    for jj=1:1
        for kk=1:NP(ii,jj)
            for mm=1:NT
                for ll=1:NP(ii,mm)
                    if (abs(EMP(ii,kk,jj)-EMP(ii,ll,mm))<=abs(1e-3*FE))
                        NIP(ii,kk)=NIP(ii,kk)+1;
                        NTT(ii,kk,NIP(ii,kk))=NBT(mm);
                        ERRP(ii,kk,NIP(ii,kk))=abs(EMP(ii,kk,jj)-EMP(ii,ll,mm));
                        PE(ii,kk)=round((EMP(ii,kk,jj)-EVT1(ii,jj))/FE);
                        break
                    end
                end
            end
        end
    end
end

for ii=1:NS
%     ph(1:NP(ii,1))=0;
%     figure
%     hold on
%     for kk=1:NP(ii,1)
%         if (NIP(ii,kk)>1)
%             if (kk>length(color))
%                 ww=length(color);
%             else
%                 ww=kk;
%             end
%             T3(1:NIP(ii,kk))=ERRP(ii,kk,1:NIP(ii,kk));
%             T4(1:NIP(ii,kk))=NTT(ii,kk,1:NIP(ii,kk));
%             ph(kk)=plot(T4(1:NIP(ii,kk)),T3(1:NIP(ii,kk)),['-' color{ww} shape{ww}],'MarkerFaceColor',color{ww},'MarkerEdgeColor',color{ww},'LineWidth',2);
%         end
%     end
%     ll=0;
%     leg=cell(1,NP(ii,1));
%     for kk=1:NP(ii,1)
%         if (ph(kk)>0)
%             ll=ll+1;
%             leg{ll}=[num2str(PE(ii,kk)) ' MPP'];
%         end
%     end
%     legend(leg(1:ll))
%     hold off
    
    figure
    hold on
    plot(PE(ii,1:NP(ii,1)),NIP(ii,1:NP(ii,1)),['-' color{1} shape{1}],'MarkerFaceColor',color{1},'MarkerEdgeColor',color{1},'LineWidth',2);
    plot([0 0],[min(NIP(ii,1:NP(ii,1))) max(NIP(ii,1:NP(ii,1)))],'-k','LineWidth',2)
    hold off
%     
%     figure
%     hold on
%     for kk=1:NT
%         if (NP(ii,kk))>=3
%             T=EMPD(ii,1:NP(ii,kk)-1,kk);
%             N1(1:2)=0;
%             N2(1:2)=0;
%             for jj=1:2
%                 [N1(jj) N2(jj)]=min(T);
%                 T(N2(jj))=Inf;
%             end
%             N2=N2+.5;
%             if (kk>length(color))
%                 ww=length(color);
%             else
%                 ww=kk;
%             end
%             plot((1:NP(ii,kk)-1)+.5,EMPD(ii,1:NP(ii,kk)-1,kk),['-' color{1}],'LineWidth',1.5)
%             plot([NPC(ii,kk) NPC(ii,kk)],[min(EMPD(ii,1:NP(ii,kk)-1,kk)) max(EMPD(ii,1:NP(ii)-1,kk))],['-' color{ww+1}],'LineWidth',2)
%             scatter(N2(1),N1(1),[color{kk+1} shape{kk+1}],'MarkerFaceColor',color{ww+1},'MarkerEdgeColor',color{ww+1})
%             scatter(N2(2),N1(2),[color{kk+1} shape{kk+1}],'MarkerFaceColor',color{ww+1},'MarkerEdgeColor',color{ww+1})
%         end
%     end
%     hold off
%     grid on
end

%**************************************************************************
%Plotting the eigenvalues derivatives with respect to freqency 
%**************************************************************************
for ii=1:ND
    if (ii==1)
        sub='st';
    elseif (ii==2)
        sub='nd';
    elseif (ii==3)
        sub='rd';
    else
        sub='th';
    end
    
    kk=0;
    SUM=0;
    figure
    hold on
    for jj=1:NS
    if (jj>SUM)
        kk=kk+1;
        SUM=SUM+DEG(jj);
    end
        plot(nu(ii+1:TI,ii+1)/1e9,EV(jj,1+ii:TI,ii+1)*1e6*1e9^ii,['-' color{kk} shape{kk}],'MarkerFaceColor',color{kk},'MarkerEdgeColor',color{kk},'LineWidth',1,'MarkerSize',2) 
    end
    hold off
    title([num2str(ii,1) '^{' sub '} Derivative of Eigenvalue with Respect to Frequency'],'FontSize',28,'FontWeight','Bold')
    xlabel('Frequency (GHz)','FontSize',26,'FontWeight','Bold')
    if (ii==1)
        ylabel('dEdf (ueV/GHz)','FontSize',26,'FontWeight','Bold')
    else
        ylabel(['d^{' num2str(ii,1) '}Edf^{' num2str(ii,1) '} (ueV/GHz^{' num2str(ii,1) '})'],'FontSize',26,'FontWeight','Bold')
    end
    xlim([nu(TI,ii+1) nu(ii+1,ii+1)]/1e9)
    set(gca,'FontSize',22)
end

%**************************************************************************
%Plotting all of the eigenvalues of the Floquet Hamiltonian at the 
%frequency of interest.
%**************************************************************************
temp(1:NBS(TI))=0;
for ii=1:NS
    temp(EV_IND(ii),TI)=1;
end

figure
hold on
for ii=1:NBS(TI)
    if (temp(ii)==0)
        scatter(ii,EV_FULL(ii,TI)*1e6,'x','MarkerEdgeColor','k','MarkerFaceColor','k')
    end
end

jj=0;
SUM=0;
for ii=1:NS
    if (ii>SUM)
        jj=jj+1;
        SUM=SUM+DEG(ii);
    end  
    scatter(EV_IND(ii,TI),EV(ii,TI,1)*1e6,shape{jj},'MarkerEdgeColor',color{jj},'MarkerFaceColor',color{jj},'SizeData',80)
end
hold off
xlabel('Eigenvalue Number','FontSize',26,'FontWeight','Bold'); 
ylabel('Eigenvalue (\mueV)','FontSize',26,'FontWeight','Bold');
title(['Eigenvalues of the Floquet Matrix for n=' num2str(n)],'FontSize',28,'Color','k','FontWeight','Bold');
legend(['B=' num2str(F_PARA{1}) ' T - E_{RF}=' num2str(F_PARA{3}(3)/1e5) ' kV/cm - \omega/2\pi=' num2str(nu_o/1e9) ' GHz'])
grid on
set(gca,'FontSize',22,'FontWeight','Bold')

%**************************************************************************
%Plotting the selected eigenvalues of the Floquet Hamiltonian at the 
%frequency of interest.
%**************************************************************************
jj=0;
SUM=0;
MIN=min(EV_IND(1:NS,TI));
figure
hold on
for ii=1:NS
    if (ii>SUM)
        jj=jj+1;
        SUM=SUM+DEG(ii);
    end
    scatter(EV_IND(ii,TI)-MIN+1,EV(ii,TI,1)*1e6,shape{jj},'MarkerEdgeColor',color{jj},'MarkerFaceColor',color{jj})
end
hold off
xlabel('Eigenvalue Number','FontSize',26,'FontWeight','Bold'); 
ylabel('Eigenvalue (\mueV)','FontSize',26,'FontWeight','Bold');
title(['Selected Eigenvalues of the Floquet Matrix for n=' num2str(n)],'FontSize',28,'Color','k','FontWeight','Bold');
legend(['E_{RF}=' num2str(F_PARA{3}(3)/1e5) ' kV/cm - \omega/2\pi=' num2str(nu_o/1e9) ' GHz'])
grid on
set(gca,'FontSize',22,'FontWeight','Bold')

end