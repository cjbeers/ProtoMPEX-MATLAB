function H_Diag(H,PARA,Ho)

%**************************************************************************
%This function serves as a diagnostic for calculations of the matrix
%elements associated with an operator H.
%**************************************************************************

%**************************************************************************
%Determines if the matrix elements, eigenvalues, eigenvectors are written
%to a file.  write_data=0 off / write_data=1 on
%**************************************************************************
write_data=0;

%**************************************************************************
%Showing non-zero components of the eigenvectors of H    
%
%Dropping all terms that have a relative magnitude less than eps with
%respect to the max magnitude - this drops terms due to machine error.
%**************************************************************************
err=1e-8;

LEVEL=1;

%*******************
%Assigning the input
%*******************
NS=PARA.NS(LEVEL);
QN=PARA.QN(LEVEL,1:NS);
if isfield(PARA.RAD,'PQN')==1
    n=PARA.RAD.PQN(LEVEL);
else
    n=PARA.RAD.WAVE;
end
    
H=H{LEVEL}+Ho{LEVEL};

TERM=cell(NS,1);
L={'S','P','D','F','G','H','J'};
for ii=1:NS
    S=num2str(QN{ii}(2)*2+1);
    
    if floor(QN{ii}(4))~=QN{ii}(4)
        if QN{ii}(4)==.5
            J='1/2';
        elseif QN{ii}(4)==1.5
            J='3/2';
        elseif QN{ii}(4)==2.5
            J='5/2';
        elseif QN{ii}(4)==3.5
            J='7/2';
        elseif QN{ii}(4)==4.5
            J='9/2';
        elseif QN{ii}(4)==5.5
            J='11/2';
        elseif QN{ii}(4)==6.5
            J='13/2';
        end
    else
        J=num2str(QN{ii}(4));
    end
    
    if floor(QN{ii}(5))~=QN{ii}(5)
        if abs(QN{ii}(5))==.5
            if QN{ii}(5)<0
                MJ='-1/2';
            else
                MJ='1/2';
            end
        elseif abs(QN{ii}(5))==1.5
            if QN{ii}(5)<0
                MJ='-3/2';
            else
                MJ='3/2';
            end
        elseif abs(QN{ii}(5))==2.5
            if QN{ii}(5)<0
                MJ='-5/2';
            else
                MJ='5/2';
            end
        elseif abs(QN{ii}(5))==3.5
            if QN{ii}(5)<0
                MJ='-7/2';
            else
                MJ='7/2';
            end
        elseif abs(QN{ii}(5))==4.5
            if QN{ii}(5)<0
                MJ='-9/2';
            else
                MJ='9/2';
            end
        elseif abs(QN{ii}(5))==5.5
            if QN{ii}(5)<0
                MJ='-11/2';
            else
                MJ='11/2';
            end
        elseif abs(QN{ii}(5))==6.5
            if QN{ii}(5)<0
                MJ='-13/2';
            else
                MJ='13/2';
            end
        end
    else
        MJ=num2str(QN{ii}(5));
    end

    TERM{ii}=['^' S L{QN{ii}(3)+1} '_{' J '}^{' MJ '}'];
end

%*************************************
%Plotting non-zero components of the H 
%*************************************
figure
hold on
for ii=1:NS
    for jj=1:NS
        if (abs(H(ii,jj))>0)
            if (H(ii,jj)>0)
                scatter(ii,jj,'o','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',100)
            else
                scatter(ii,jj,'o','MarkerEdgeColor','k','MarkerFaceColor','k','SizeData',100)
            end
        end
    end
end
grid on
axis([0 (NS) 0 (NS)])
hold off
set(gca,'XTick',1:NS,'XTickLabel',[ ])
set(gca,'YTick',1:NS,'YTickLabel',[ ])
%title(['Non-Zero Components of <\phi_i|H^o+H^*|\phi_j> for n=' num2str(n)],'FontSize',28,'FontWeight','Bold')
title('<\phi_i|H^o+H^*|\phi_j>','FontSize',28,'FontWeight','Bold')
xlabel('\phi_j','FontSize',28,'FontWeight','Bold')
ylabel('\phi_i','FontSize',28,'FontWeight','Bold')
set(gca,'FontSize',22,'FontWeight','Bold')
for ii=1:NS
    text(-.85,ii,TERM{ii},'FontSize',18,'FontWeight','Bold')
    text(ii-.5,-.5,TERM{ii},'FontSize',18,'FontWeight','Bold')
end
%text(-1.5,NS/2,'\phi','FontSize',28,'FontWeight','Bold','Rotation',90)    
%text(NS/2,-1.5,'\Phi','FontSize',28,'FontWeight','Bold') 

%************************
%Calc. the EVec/EVal of H
%************************
[EVec,EVal]=eig(H);

%****************************************
%Plotting non-zero components of the EVec 
%****************************************
EVec_max(1:NS)=0;
for ii=1:NS
    EVec_max(ii)=abs(EVec(ii,1));
end

for ii=1:NS
    for jj=1:NS
        if (abs(EVec(ii,jj))>EVec_max(ii))
            EVec_max(ii)=abs(EVec(ii,jj));
        end
    end
end

EVec_plot(1:NS,1:NS)=0;
for ss=1:NS
    for kk=1:NS
        if ((abs(EVec(ss,kk))/EVec_max(ss))<err)
            EVec_plot(ss,kk)=0;
        else
            EVec_plot(ss,kk)=EVec(ss,kk);
        end
    end
end

figure
hold on
for ii=1:NS
    SIZE=abs(EVec_plot(ii,1:NS))/max(abs(EVec_plot(ii,1:NS)))*1000;
    for jj=1:NS
        if (abs(EVec_plot(ii,jj))>0)
            if (EVec_plot(ii,jj)>0)
                scatter(ii,jj,'o','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',SIZE(jj))
            else
                scatter(ii,jj,'o','MarkerEdgeColor','k','MarkerFaceColor','k','SizeData',SIZE(jj))
            end
        end
    end
end
grid on
axis([0 (NS+1) 0 (NS+1)])
hold off
set(gca,'XTick',1:NS)
set(gca,'YTick',1:NS,'YTickLabel',[ ])
%title('Non-Zero Components of the L2 Norm <\phi_i|\Phi_n>','FontSize',22,'FontWeight','Bold')
title('<\phi_i|\Phi_n>','FontSize',22,'FontWeight','Bold')
xlabel('\Phi_n','FontSize',18,'FontWeight','Bold')
ylabel('\phi_i','FontSize',18,'FontWeight','Bold')
set(gca,'FontSize',22,'FontWeight','Bold')
for ii=1:NS
    text(-.95,ii,TERM{ii},'FontSize',18,'FontWeight','Bold')
end
%text(-1.5,NS/2,'\phi_i','FontSize',28,'FontWeight','Bold','Rotation',90)    


%*********************************
%Checking orthonormality of EVec's
%*********************************
%Orthonormal(EVec,NS)

%*******************
%Plotting the EVal's
%*******************
EV(1:NS)=0;
for ii=1:NS
    EV(ii)=EVal(ii,ii);
end
EVal=EV;

figure
hold on
for ii=1:NS
    plot([(ii-1)+.1 ii-.1],[EVal(ii) EVal(ii)],'k','LineWidth',2.5)
end
hold off
ylabel('Energy (eV)','FontSize',26,'FontWeight','Bold');
title(['n=' num2str(n) ' Quantum State Energies for H'],'FontSize',28,'Color','k','FontWeight','Bold');
grid on
set(gca,'FontSize',22,'FontWeight','Bold')
xlim([0 NS])
set(gca,'XTick',1:NS)
xlabel('\Phi_n','FontSize',18,'FontWeight','Bold')

%*****************
%Writing to a file
%*****************
if (write_data==1)
    H_out=cell(NS+1);
    EVec_out=cell(NS+1);
    EVal_out=cell(NS+1,1);
    
    EVal_out{1,2}='Eigenvalues (eV)';
    for ii=1:NS
        H_out{ii+1,1}=['| ' num2str(QN{ii}(1)) ', ' num2str(QN{ii}(2)) ', ' num2str(QN{ii}(3)) ', ' num2str(QN{ii}(4)) ', ' num2str(QN{ii}(5)) ' >'];
        H_out{1,ii+1}=['| ' num2str(QN{ii}(1)) ', ' num2str(QN{ii}(2)) ', ' num2str(QN{ii}(3)) ', ' num2str(QN{ii}(4)) ', ' num2str(QN{ii}(5)) ' >'];
        EVec_out{1,ii+1}=['Eigenvector ' num2str(ii)];
        EVec_out{ii+1,1}=['| ' num2str(QN{ii}(1)) ', ' num2str(QN{ii}(2)) ', ' num2str(QN{ii}(3)) ', ' num2str(QN{ii}(4)) ', ' num2str(QN{ii}(5)) ' >'];
        EVal_out{ii+1,1}=['Eigenvalue ' num2str(ii)];
        EVal_out{ii+1,2}=EVal(ii);
        for jj=1:NS
            H_out{ii+1,jj+1}=H(ii,jj);
            EVec_out{ii+1,jj+1}=EVec_plot(ii,jj);
        end
    end
    file_name=['Hamiltonian_Data_n=' num2str(n) '.xlsx'];
    xlswrite(file_name,H_out,'Matrix Elements')
    xlswrite(file_name,EVec_out,'Eigenvectors')
    xlswrite(file_name,EVal_out,'Eigenvalues')    
end

end