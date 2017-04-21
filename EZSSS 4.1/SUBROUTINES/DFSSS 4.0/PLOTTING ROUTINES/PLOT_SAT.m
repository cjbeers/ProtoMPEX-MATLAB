function PLOT_SAT(DATA,SPACE,FREQ,PARA)

%************
%Assign input
%************
SAT=DATA.SAT;

NXP=SPACE.NXP;
X=SPACE.X;

NFP=FREQ.NFP;
NU=FREQ.NU;

POP_DEN_LOG=PARA.VELOCITY.POP_DEN_LOGIC;

%*****************************************
%Exit if population density not calculated
%*****************************************
if POP_DEN_LOG==0
    return
end

%**********************************************************
%Calc. the resonant detuning frequncy (centered about zero)
%**********************************************************
NU_RDT=NU-(NU(1)+NU(NFP))/2;

%**************************
%Step size for contour plot
%**************************
STEP=(1-min(min(SAT)))/30;

%**************
%Plot probe beam
%**************
if NFP>1
    figure 
    plot(NU_RDT/1e9,SAT(1:NFP,NXP)*100,'-k','LineWidth',5)
    grid on
    xlabel('Resonant Detuning Frequency (GHz)','FontSize',38)
    ylabel('Saturation (%)','FontSize',38)
    set(gca,'FontSize',38)
    
    if NXP>2
        figure 
        hold on
        for ii=1:NFP
            plot3(ones(1,NXP-1)*NU_RDT(ii)/1e9,X*1000,SAT(ii,2:NXP)*100,'-k','LineWidth',4)
        end
        grid on
        xlabel('Resonant Detuning Frequency (GHz)','FontSize',38)
        ylabel('Position (mm)','FontSize',38)
        zlabel('Saturation (%)','FontSize',38)
        set(gca,'FontSize',38)

        figure 
        hold on
        contourf(X(2:NXP)*1000,NU_RDT/1e9,SAT(1:NFP,2:NXP)*100,'LineStyle','none','LevelStep',STEP)
        xlabel('Position (mm)','FontSize',38)
        ylabel('Resonant Detuning Frequency (GHz)','FontSize',38)        
        title('Saturation (%)','FontSize',38)
        colorbar 
        set(gca,'FontSize',38)
    end
else
    figure 
    hold on
    plot(X(2:NXP)*1000,SAT(1,2:NXP)*100,'-k','LineWidth',4)
    grid on
    xlabel('Position (mm)','FontSize',38)
    ylabel('Saturation (%)','FontSize',38)
    title(['Resonant Detuning Frequency: ' num2str(NU/1e9,'%3.1f') ' GHz'],'FontSize',38)
    set(gca,'FontSize',38)
end

end