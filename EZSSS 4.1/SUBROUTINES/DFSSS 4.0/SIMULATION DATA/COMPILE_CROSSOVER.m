clear all
close all
clc

A_START=1e2;
A_STOP=1e8;

NU_START=0.5e9;
NU_STOP=15e9;

%**************************
%Number of intensity points
%**************************
NPA_R=3000;
NPA_L=3000;

%**************************
%Number of frequency points
%**************************
NPF=20;

%*****************************
%Assign total number of points
%*****************************
NP=NPA_R*NPA_L*NPF;

%****************************************
%Assign transition probability boundaries
%****************************************
if NPA_R>1
    A_R=10.^(linspace(log10(A_START),log10(A_STOP),NPA_R));
else
    A_R=1e6;
end

if NPA_L>1
    A_L=10.^(linspace(log10(A_START),log10(A_STOP),NPA_L));
else
    A_L=1e6;
end

%******************************
%Assign transition probablities
%******************************
A_0(1:2,1:NPA_R,1:NPA_L)=0;
for ii=1:NPA_R
    for jj=1:NPA_L
        if A_R(ii)>A_L(jj)
            A_0(1:2,ii,jj)=[A_R(ii) A_L(jj)];
        else
            A_0(1:2,ii,jj)=[A_L(jj) A_R(ii)];
        end
    end
end

%*************************
%Assign frequency boundary
%*************************
NU=10.^linspace(log10(NU_START),log10(NU_STOP),NPF);

%*****************************
%Assign transition frequencies
%*****************************
NU_0(1:2,1:NPF)=0;
for ii=1:NPF
    NU_0(1:2,ii)=[-NU(ii) NU(ii)];
end

%********************
%Assign parallel data
%********************
A_PAR=cell(1,NP);
NU_PAR=cell(1,NP);

ll=0;
for ii=1:NPA_R
    for jj=1:NPA_L 
        for kk=1:NPF
            ll=ll+1;
                
            A_PAR{ll}(1:2)=A_0(1:2,ii,jj);
            NU_PAR{ll}(1:2)=NU_0(1:2,kk);
        end
    end
end

%***************
%Allocate memory
%***************
SCALE_PAR(1:NP)=0;

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

%********************
%Calc. the absorption
%********************
PARALLEL_PROGRESS(NP);
parfor ii=1:NP
    PARALLEL_PROGRESS;

    SCALE_PAR(ii)=CROSSOVER(A_PAR{ii},NU_PAR{ii});
end
PARALLEL_PROGRESS(0);

%***********
%Remove path
%***********
rmpath(PATH)
rmpath([PATH filesep 'SUBROUTINES'])

%%

%******************************
%Assign parallel data to matrix
%******************************
SCALE(1:NPA_R,1:NPA_L,1:NPF)=0;

ll=0;
for ii=1:NPA_R
    for jj=1:NPA_L 
        for kk=1:NPF
            ll=ll+1;
            
            SCALE(ii,jj,kk)=SCALE_PAR(ll);
        end
    end
end

%%

if NPA_R>1 && NPA_L>1
    %********************
    %Freq. indice to plot
    %********************
    IND=2;

    figure
    contourf(A_L/1e6,A_R/1e6,SCALE(1:NPA_R,1:NPA_L,IND),'LineStyle','none')
    xlabel('Transition Probability (MHz)','FontSize',38)
    ylabel('Transition Probability (MHz)','FontSize',38)
    title(['Crossover Peak Ratio  -  Transition Spacing ' num2str(2*NU(IND)/1e9) ' GHz'],'FontSize',38,'FontWeight','Normal')
    colorbar
    grid on
    set(gca,'View',[0 90],'FontSize',38)

end

%%

figure
hold on
for kk=1:NPF
    %*****
    %Slope
    %*****
    a=max(max(SCALE(1:NPA_R,1:NPA_L,kk)));

    %*************************
    %Calc. linear relationship
    %*************************
    FIT_RATIO=linspace(0,1,100);
    LIN_FIT=a*FIT_RATIO;

    for ii=1:NPA_R
        for jj=1:NPA_L
            scatter(min([A_R(ii) A_L(jj)])/max([A_R(ii) A_L(jj)]),SCALE(ii,jj,kk),'r','SizeData',100,'MarkerFaceColor','r')
        end
    end

    plot(FIT_RATIO,LIN_FIT,'-k','LineWidth',6)
end
hold off
xlabel('Transition Intensity Ratio','FontSize',38)
ylabel('Crossover Peak Ratio','FontSize',38)
set(gca,'FontSize',38)
grid on

%%

%*****
%Slope
%*****
a=2/-17e9;
b=2;

%*************************
%Calc. linear relationship
%*************************
FIT_FREQ=linspace(0,17e9,100);
LIN_FIT=a*FIT_FREQ+b;

SLOPE(1:NPF)=0;
for ii=1:NPF
    SLOPE(ii)=max(max(SCALE(1:NPA_R,1:NPA_L,ii)));
end

figure
hold on
plot(2*NU/1e9,SLOPE,'-k','LineWidth',6)
plot(FIT_FREQ/1e9,LIN_FIT,'-r','LineWidth',6)
hold off
xlabel('Transition Spacing (MHz)','FontSize',38)
ylabel('Slope','FontSize',38)
title('$I_{crossover}$=$\left[\left(\frac{-2.3}{17 \ \mathrm{GHz}}\right) \Delta\nu +2.3\right] \cdot \frac{I_{\mathrm{min}}}{I_{\mathrm{max}}} \cdot I_{\mathrm{max}}$','Interpreter','latex')
set(gca,'FontSize',38)
grid on

