function Orthonormal(EVec,PARA,DIAG)

%**************************************************************************
%Checking orthonormality of eigenvectors
%**************************************************************************
eps=[1e-12 1e-8];


%************
%Assign input
%************
NS=PARA.NS;
NBS=PARA.NBS;
n=PARA.RAD{4};

PLOT_ON=DIAG(2);

%***************
%Allocate memory
%***************
L2=cell(2,1);
for ii=1:2
    L2{ii}(1:NS(ii),1:NS(ii))=0;
end

%*****************
%Calc. the L2 norm
%*****************
for ii=1:2
    for jj=1:NS(ii)
        for kk=1:NS(ii)
            L2{ii}(jj,kk)=EVec(1:NBS(ii),jj)'*EVec(1:NBS(ii),kk);
        end
    end
end

%****************
%Initialize logic
%****************
EXIT=0;

for ii=1:2
    for jj=1:NS(ii)
        for kk=1:NS(ii) 
            %*********************************
            %Removing imaginary roundoff error
            %*********************************
            if (abs(imag(L2{ii}(kk,jj)))<eps(1))  
                L2{ii}(kk,jj)=real(L2{ii}(kk,jj));
            end

            %****************************
            %Removing real roundoff error
            %****************************
            if (abs(L2{ii}(kk,jj))<eps(1))
                L2{ii}(kk,jj)=0;
            end

            %***************************
            %Checking the orthonormality
            %***************************
            if (abs(L2{ii}(kk,jj))>0)
                if (abs(kk-jj)>0)
                    fprintf('*********************WARNING********************\n')
                    fprintf('    The eigenfunctions are not orthoganal\n')
                    fprintf('*********************WARNING********************\n\n')

                    %****************
                    %Turn on plotting
                    %****************
                    PLOT_ON=1;

                    %****
                    %Exit
                    %****
                    EXIT=1;
                    break
                else
                    if (abs(L2{ii}(kk,jj)-1)>eps(2))
                        fprintf('*********************WARNING********************\n')
                        fprintf('    The eigenfunctions are not normalized\n')
                        fprintf('*********************WARNING********************\n\n')

                        %****************
                        %Turn on plotting
                        %****************
                        PLOT_ON=1;

                        %****
                        %Exit
                        %****
                        EXIT=1;
                        break
                    end
                end
            end
        end

        %****
        %Exit
        %****
        if (EXIT==1)
            break
        end
    end

    %********************
    %Plotting the L2 norm
    %********************
    if (PLOT_ON==1)
        figure
        hold on
        for jj=1:NS(ii)
            scatter3(1:NS(ii),jj*ones(1,NS(ii)),L2{ii}(:,jj),'o','MarkerEdgeColor','k','MarkerFaceColor','k')
        end
        hold off
        grid on
        xlabel('i','FontSize',38,'FontWeight','Bold')
        ylabel('j','FontSize',38,'FontWeight','Bold')
        zlabel(['n= ' num2str(n(ii),1) '   -   <\Phi_j|\Phi_i>'],'FontSize',38,'FontWeight','Bold')
        set(gca,'FontSize',36)
    end
    
    %**************
    %Reassign input
    %**************
    PLOT_ON=ORTHO.PLOT;    
    
    %****************
    %Initialize logic
    %****************
    EXIT=0;    
end

end