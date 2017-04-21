function PLOT_INT(DATA,SPACE,FREQ,PARA)

%************
%Assign input
%************
I_PU=DATA.I_PU;
I_PR=DATA.I_PR;

NXP=SPACE.NXP;
X=SPACE.X;

NFP=FREQ.NFP;
NU=FREQ.NU;

MODE=PARA.MODE;

%**********************************************************
%Calc. the resonant detuning frequncy (centered about zero)
%**********************************************************
NU_RDT=NU-(NU(1)+NU(NFP))/2;

if strcmpi(MODE,'PUMP')==1
    %*********
    %Normalize
    %*********
    I_PU=I_PU/max(max(I_PU));

    %**************************
    %Step size for contour plot
    %**************************
    STEP_PU=(1-min(min(I_PU)))/30;

    %**************
    %Plot pump beam
    %**************
    if NFP>1
        figure 
        plot(NU_RDT/1e9,I_PU(1:NFP,NXP)*100,'-b','LineWidth',5)
        grid on
        xlabel('Resonant Detuning Frequency (GHz)','FontSize',38)
        ylabel('Pump Transmission (%)','FontSize',38)
        set(gca,'FontSize',38)

        figure 
        hold on
        for ii=1:NFP
            plot3(ones(1,NXP)*(NU_RDT(ii))/1e9,X*1000,I_PU(ii,1:NXP)*100,'-b','LineWidth',2)
        end
        grid on
        xlabel('Resonant Detuning Frequency (GHz)','FontSize',38)
        ylabel('Position (mm)','FontSize',38)
        zlabel('Pump Transmission (%)','FontSize',38)
        set(gca,'FontSize',38)

        if NXP>2
            figure 
            hold on
            contourf(X*1000,NU_RDT/1e9,I_PU(1:NFP,1:NXP)*100,'LineStyle','none','LevelStep',100*STEP_PU)
            xlabel('Position (mm)','FontSize',38)
            ylabel('Resonant Detuning Frequency (GHz)','FontSize',38)        
            title('Pump Transmission (%)','FontSize',38)
            colorbar 
            set(gca,'FontSize',38)
        end
    else
        figure 
        hold on
        for ii=1:NFP
            plot(X*1000,I_PU(ii,1:NXP)*100,'-b','LineWidth',2)
        end
        grid on
        xlabel('Position (mm)','FontSize',38)
        ylabel('Pump Transmission (%)','FontSize',38)
        title(['Resonant Detuning Frequency: ' num2str(NU/1e9,'%3.1f') ' GHz'],'FontSize',38)
        set(gca,'FontSize',38)
    end
end

if strcmpi(MODE,'PROBE')==1 || strcmpi(MODE,'BOTH')==1
    %*********
    %Normalize
    %*********
    I_PR=I_PR/max(max(I_PR));

    %**************************
    %Step size for contour plot
    %**************************
    STEP_PR=(1-min(min(I_PR)))/30;

    %**************
    %Plot probe beam
    %**************
    if NFP>1
        figure 
        plot(NU_RDT/1e9,I_PR(1:NFP,NXP)*100,'-b','LineWidth',5)
        grid on
        xlabel('Resonant Detuning Frequency (GHz)','FontSize',38)
        ylabel('Probe Transmission (%)','FontSize',38)
        set(gca,'FontSize',38)

        figure 
        hold on
        for ii=1:NFP
            plot3(ones(1,NXP)*NU_RDT(ii)/1e9,X*1000,I_PR(ii,1:NXP)*100,'-b','LineWidth',2)
        end
        grid on
        xlabel('Resonant Detuning Frequency (GHz)','FontSize',38)
        ylabel('Position (mm)','FontSize',38)
        zlabel('Probe Transmission (%)','FontSize',38)
        set(gca,'FontSize',38)

        if NXP>2
            figure 
            hold on
            contourf(X*1000,NU_RDT/1e9,I_PR(1:NFP,1:NXP)*100,'LineStyle','none','LevelStep',STEP_PR)
            xlabel('Position (mm)','FontSize',38)
            ylabel('Resonant Detuning Frequency (GHz)','FontSize',38)        
            title('Probe Transmission (%)','FontSize',38)
            colorbar 
            set(gca,'FontSize',38)
        end
    else
        figure 
        hold on
        for ii=1:NFP
            plot(X*1000,I_PR(ii,1:NXP)*100,'-b','LineWidth',2)
        end
        grid on
        xlabel('Position (mm)','FontSize',38)
        ylabel('Probe Transmission (%)','FontSize',38)
        title(['Resonant Detuning Frequency: ' num2str(NU/1e9,'%3.1f') ' GHz'],'FontSize',38)
        set(gca,'FontSize',38)
    end
end

end