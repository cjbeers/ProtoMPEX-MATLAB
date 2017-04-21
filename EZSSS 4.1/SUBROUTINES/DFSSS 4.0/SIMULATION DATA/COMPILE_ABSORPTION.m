clear all
close all

%***********************************************************
%Logic to control the saving of the interpolation table data
%***********************************************************
SAVE=1;

%*****************************
%Logic to control the plotting
%*****************************
PLOT=1;

%****************
%Number of points
%****************
NP=10000;

%**********************
%Transition probability
%**********************
A=10.^(linspace(log10(1),log10(1e8),NP));

%***************
%Allocate memory
%***************
I_DF(1:NP)=0;
I_DB(1:NP)=0;

%*****************************
%Define the parent folder path
%*****************************
PATH=pwd;
for ii=length(PATH):-1:1
    if strcmpi(PATH(ii),filesep)==1
        PATH=PATH(1:ii-1);
        
        break
    end
end

%********
%Add path
%********
addpath(PATH)
addpath([PATH filesep 'SUBROUTINES'])

PARALLEL_PROGRESS(NP);
parfor ii=1:NP
    PARALLEL_PROGRESS;

    %********************
    %Calc. the absorption
    %********************
    [I_DF(ii),I_DB(ii)]=ABSORPTION(A(ii));
end
PARALLEL_PROGRESS(0);

%***********
%Remove path
%***********
rmpath(PATH)
rmpath([PATH filesep 'SUBROUTINES'])

%%

%*****
%Slope
%*****
a=max(I_DF)/max(A);

%*************************
%Calc. linear relationship
%*************************
LIN_DF=a*A;

%*************************
%Calc. linear relationship
%*************************
S=I_DF./LIN_DF;

%%

if SAVE==1
    
    save('SCALE_DATA.mat','A','S','NP')
    
end

%%

if PLOT==1

%**************************************************************************
%***********              Linear plot to the data               ***********  
%**************************************************************************

    FUN_DF=fit(A',I_DF','poly1');
    FUN_DB=fit(A',I_DB','poly1');

    figure
    hold on
    plot(A/1e6,I_DF*100,'-r','LineWidth',8)
    PH1=plot(A/1e6,FUN_DF(A)*100,'-b','LineWidth',5);
    plot(A/1e6,I_DB*100,'-k','LineWidth',8)
    PH2=plot(A/1e6,FUN_DB(A)*100,'-g','LineWidth',5);

    PH1.Color(4)=.6;
    PH2.Color(4)=.6;

    hold off
    legend('Doppler Free','Linear Fit to Doppler Free','Doppler Broadened','Linear fit to Doppler Broadened')
    xlabel('Transition Probablity (MHz)','FontSize',38)
    ylabel('Signal Intensity (%)','FontSize',38)
    title('1D Calculation','FontSize',38,'FontWeight','Normal')
    set(gca,'FontSize',38)
    grid on

%**************************************************************************
%***********             Nonlinear plot to the data             ***********  
%**************************************************************************

    %***********
    %Fit options
    %***********
    FIT_OPT=fitoptions('Method','NonlinearLeastSquares',...
                       'Startpoint',[1 .5 0]);

    %************
    %Fit equation
    %************
    FIT_EQ=fittype('a*x^n+b','dependent',{'y'},'independent',{'x'},'coefficients',{'a','n','b'},'options',FIT_OPT);

    %******************
    %Fit the scale data
    %******************
    FUN_S=fit(A'/1e6,S',FIT_EQ);
    CV_S=coeffvalues(FUN_S);

    %***************
    %Calc. the error
    %***************
    ERR_LIN=(LIN_DF-I_DF)/max(I_DF);
    ERR_NONLIN=(FUN_S(A/1e6)'-S)/max(S);

    %******************
    %Plot the DF signal
    %******************
    figure
    hold on
    plot(A/1e6,I_DF*100,'-k','LineWidth',8)
    PH1=plot(A/1e6,LIN_DF*100,'-r','LineWidth',5);

    PH1.Color(4)=.6;

    hold off
    legend('Simulation','Linear Relationship')
    xlabel('Transition Probablity (MHz)','FontSize',38)
    ylabel('Signal Intensity (%)','FontSize',38)
    title('1D Calculation','FontSize',38,'FontWeight','Normal')
    set(gca,'FontSize',38)
    grid on

    %*********************
    %Plot the scale factor
    %*********************
    figure
    hold on
    plot(A/1e6,S,'-k','LineWidth',8)
    PH1=plot(A/1e6,FUN_S(A/1e6)','-r','LineWidth',8);

    PH1.Color(4)=.6;

    hold off
    xlabel('Transition Probablity (MHz)','FontSize',38)
    ylabel('Scale Factor','FontSize',38)
    title('1D Calculation','FontSize',38,'FontWeight','Normal')
    legend('Simulation',['Fit: ' num2str(CV_S(1)) 'A^{' num2str(CV_S(2)) '}+' num2str(CV_S(3))])
    set(gca,'FontSize',38)
    grid on

    %*****************************************
    %Plot the error in the fitted scale factor
    %*****************************************
    figure
    hold on
    plot(A/1e6,ERR_LIN*100,'-k','LineWidth',8)
    plot(A/1e6,ERR_NONLIN*100,'-r','LineWidth',8)
    hold off
    xlabel('Transition Probablity (MHz)','FontSize',38)
    ylabel('Error (%)','FontSize',38)
    title('1D Calculation','FontSize',38,'FontWeight','Normal')
    legend('Linear Relationship','Nonlinear Relationship')
    set(gca,'FontSize',38)
    grid on

end
