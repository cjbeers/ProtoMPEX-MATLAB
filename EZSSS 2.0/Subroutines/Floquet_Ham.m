function FH=Floquet_Ham(H,PARA,FIELD,UNIV,DIAG)

%**************************************************************************
%**************************************************************************
%This function calculates the Floquet matrix given the pertrubed
%Hamiltonian, H, and the number of Floquet blocks, NB.  The unperturbed
%Hamiltonian is not induced in the Flqouet matrix.
%**************************************************************************

%************
%Assign input
%************
NS=PARA.NS;
NB=PARA.NB;
NBS=PARA.NBS;
n=PARA.RAD.PQN;

NH=FIELD.ERF.NH;
NU=FIELD.ERF.NU;

hbar=UNIV.hbar;
q=UNIV.q;

%***************
%Allocate memory
%***************
FH=cell(2,1);
for ii=1:2
    FH{ii}(1:NBS(ii),1:NBS(ii))=0;
end

%****************
%Energy of photon
%****************
FE=2*pi*hbar*NU/q;

%***********************************
%Formulating the Floquet Hamiltonian
%***********************************
for ii=1:2
    for jj=1:2*NB(ii)+1
        for kk=1:2*NB(ii)+1
            if (jj==kk)
                ll=1;
            elseif (kk==jj+1) || (kk==jj-1)
                ll=2;
            else
                ll=0;
                for mm=2:NH
                    if (kk==jj+mm)
                        ll=1+mm;
                        break
                    end
                    if (kk==jj-mm)
                        ll=NH+mm;
                        break
                    end
                end
            end

            if (ll==1)
                FH{ii}(1+NS(ii)*(jj-1):NS(ii)*jj,1+NS(ii)*(kk-1):NS*kk)=H{ii,ll}-eye(NS(ii))*(-NB(ii)+(jj-1))*FE;
            elseif (ll>1) && (ll<=2*NH+1)
                FH{ii}(1+NS(ii)*(jj-1):NS(ii)*jj,1+NS(ii)*(kk-1):NS(ii)*kk)=H{ii,ll};
            end
        end
    end
end

%*********************
%Hermitian matrix test
%*********************
if (DIAG(1)==1)
    for ii=1:2
        HC=FH{ii}-FH{ii}';
        if (sum(sum(abs(HC),2),1)>0)
            fprintf('\n**************************************************************************\n')
            fprintf('                  Floquet Matrix is not Hermitian for n= %1i\n',n(ii))
            fprintf('**************************************************************************\n\n')

            for jj=1:NBS(ii)
                for kk=1:NBS(ii)
                    if (abs(HC(jj,kk))>0)       
                        fprintf('**************************************************************************\n')
                        fprintf('                    <%2i|%2i> = %21.16e\n',jj,kk,HC(jj,kk))
                        fprintf('**************************************************************************\n')
                    end
                end
            end
        end
    end
end

%***********************************************
%Plot non-zero compenents of Floquet Hamiltonian
%***********************************************
if (DIAG(2)==1)
    for ii=1:2
        x_label=cell(1,2*NB(ii)+1);
        y_label=cell(1,2*NB(ii)+1);
        for jj=1:2*NB(ii)+1
            x_label{1,jj}=num2str(jj-(NB(ii)+1));
            y_label{1,jj}=num2str(NB(ii)+1-jj);
        end

        figure
        hold on
        for jj=1:NBS(ii)
            for kk=1:NBS(ii)
                if (abs(FH(jj,kk))>0)
                    if (FH(jj,kk)>0)
                        scatter(jj,NBS(ii)+1-kk,'o','MarkerEdgeColor','r','MarkerFaceColor','r','SizeData',20)
                    else
                        scatter(jj,NBS(ii)+1-kk,'o','MarkerEdgeColor','k','MarkerFaceColor','k','SizeData',20)
                    end
                end
            end
        end
        grid on
        axis([0 NBS(ii) 0 NBS(ii)])
        hold off
        set(gca,'XTick',NS(ii)/2:NS(ii):NBS(ii)-NS(ii)/2)
        set(gca,'XTickLabel',x_label)
        set(gca,'YTick',NS(ii)/2:NS(ii):NBS(ii)-NS(ii)/2)
        set(gca,'YTickLabel',y_label)
        title(['Non-Zero Components of the Floquet Matrix for n=' num2str(n(ii))],'FontSize',38,'FontWeight','Bold')
        xlabel('Floquet Block (s)','FontSize',38,'FontWeight','Bold')
        ylabel('Floquet Block (s)','FontSize',38,'FontWeight','Bold')
        set(gca,'FontSize',36)
    end
end

end