function FH_EVec_Plot(ss,EVec,IND_sol,H_PARA)

%*******************
%Assigning the input
%*******************
NS=H_PARA{2}{1}(ss);

NB_MAX=H_PARA{3}{1}(ss);
NBS_MAX=H_PARA{3}{2}(ss);

EVec_sum(1:NBS_MAX,1)=0;
for ii=1:NBS_MAX
    EVec_sum(ii,1)=sum(EVec(NS*NB_MAX+1:NS*(NB_MAX+1),ii).^2);
end

temp(1:NBS_MAX,1:2*NB_MAX+1)=0;
IND(1:NBS_MAX)=0;
for ii=1:NBS_MAX
    for jj=1:2*NB_MAX+1
        temp(ii,jj)=sum(EVec(NS*(jj-1)+1:NS*(jj),ii).^2);
    end
    
    mm=1;
    EVec_sum(ii,2)=temp(ii,1);
    for jj=1:2*NB_MAX+1
        if (EVec_sum(ii,2)<temp(ii,jj))
            EVec_sum(ii,2)=temp(ii,jj);
            mm=jj;
        end
    end
    IND(ii)=mm;
end

IND_max(1:NS,1:2)=0;
for ww=1:2
    HIT(1:NBS_MAX)=0;
    for ii=1:NS        
        for jj=1:NBS_MAX
            if (HIT(jj)==0)
                MAX=EVec_sum(jj,ww);
                mm=jj;
                break
            end
        end

        for kk=1:NBS_MAX
            if (HIT(kk)==0) && (MAX<EVec_sum(kk,ww))   
                MAX=EVec_sum(kk,ww);
                mm=kk;
            end
        end

        IND_max(ii,ww)=mm;
        HIT(mm)=1;
    end
end

temp1=sort(IND_max(1:NS,1));
temp2=sort(IND_max(1:NS,2));
temp3=sort(IND_sol);

figure
hold on
plot(1:NS,temp1,'-rs','MarkerFaceColor','r','MarkerEdgeColor','r','LineWidth',2,'MarkerSize',4)
plot(1:NS,temp3,'-bo','MarkerFaceColor','r','MarkerEdgeColor','b','LineWidth',2,'MarkerSize',4)
hold off
xlabel('Eigenvector Number','FontSize',26,'FontWeight','Bold'); 
ylabel('Indice of Eigenvector','FontSize',26,'FontWeight','Bold');
title('Indice of Eigenvector of Interest','FontSize',28,'Color','k','FontWeight','Bold');
legend('Maximum Value Method','Tracking Method')
grid on
set(gca,'FontSize',22,'FontWeight','Bold')

figure
hold on
plot(1:NBS_MAX,EVec_sum(:,1),'-ks','MarkerFaceColor','k','MarkerEdgeColor','k','LineWidth',2,'MarkerSize',4)
for ii=1:NS
    h1=plot([IND_max(ii,1) IND_max(ii,1)],[max(EVec_sum(:,1))*1.05 max(EVec_sum(:,1))*1.25],'-r','LineWidth',2);
    h2=plot([IND_sol(ii) IND_sol(ii)],[max(EVec_sum(:,1))*1.25 max(EVec_sum(:,1))*1.45],'-b','LineWidth',2);
end
hold off
xlabel('Indice of Eigenvector','FontSize',26,'FontWeight','Bold'); 
ylabel('Squared Sum of 0^{th} FB','FontSize',26,'FontWeight','Bold');
title('Squared Sum of 0^{th} FB','FontSize',28,'Color','k','FontWeight','Bold');
axis([0 NBS_MAX min(EVec_sum(:,1))*.95 max(EVec_sum(:,1))*1.5])
legend([h1,h2],'Maximum Value Method','Tracking Method')
grid on
set(gca,'FontSize',22,'FontWeight','Bold')

figure
subplot(2,1,1)
plot(1:NBS_MAX,EVec_sum(:,2),'-ks','MarkerFaceColor','r','MarkerEdgeColor','r','LineWidth',2,'MarkerSize',4)  
ylabel('Squared Sum of i^{th} FB','FontSize',22,'FontWeight','Bold');
title('Maximum Squared Sum of FB','FontSize',26,'Color','k','FontWeight','Bold');
axis ([0 NBS_MAX min(EVec_sum(:,2))*.99 max(EVec_sum(:,2))*1.01])
grid on
set(gca,'FontSize',22,'FontWeight','Bold')

subplot(2,1,2)
plot(1:NBS_MAX,IND-(NB_MAX+1),'-ks','MarkerFaceColor','r','MarkerEdgeColor','r','LineWidth',2,'MarkerSize',4)
xlabel('Indice of Eigenvector','FontSize',22,'FontWeight','Bold');  
ylabel('i^{th} Floquet Block','FontSize',22,'FontWeight','Bold');
axis([0 NBS_MAX -(NB_MAX+1) NB_MAX+1])
grid on
set(gca,'FontSize',22,'FontWeight','Bold')

end