
function [FWHM, Residuals, Center, XFIT, IFIT] = ElijahGaussianFit(DATA, lambda_o, lambdaplot)

PLOT_RAW=0;
PLOT_AVG=0;
PLOT_SELECT=0;
PLOT_FIT=0;
PLOT_GAU=0;
FINDIONTEMP=0;

%********************************
%Number of Gaussians for data fit
%********************************
NG=1;
                                         
WC=round((lambda_o*10),0);                                            

START_POINTS=[1 WC .4 .7 WC .2 .6 WC .3];
LOWER_BC=[0 WC-4 .1 0 WC-4 .1 0 WC-4 .1];
UPPER_BC=[10 WC+4 4 10 WC+4 4 10 WC+4 4];

%************************************
%Wavelength bounds for data selection, Wavelength of Spectrum
%************************************
WD=[round(lambdaplot(1,512)*10,0) round(lambdaplot(1,1)*10,0)];                                     

%********************************************
%Wavelength bounds for background subtraction
%********************************************
WB=[WC-15 WC-10];                                   

%**********
%Axis array, Wavelengths to view in plots
%**********
AXIS=[WC-2 WC+2 0 1.1];                          

%****************
%Number of pixels
%****************
NP=512;

%***************
%Number of ROI's
%***************
ROI=1;

%***************
%File parameters
%***************
NF=1;                                              

%FILENAMES={'ARPenlamp'};          

%*********       
%Read data
%*********
I(1:NF)={zeros(NP,ROI)};
X(1:NF)={zeros(NP,ROI)};
for ii=1:NF
    %load([FILENAMES{ii} '.mat'],'DATA');
    
    NA=length(DATA.X(:,1))/(ROI*NP);
    
    for jj=1:ROI
        I{ii}(1:NP,jj)=DATA.I;
        X{ii}(1:NP,jj)=DATA.X*10;
        
        %***********************************
        %Center wavelength of interest at WC
        %***********************************
        LOG=WD(1)<X{ii}(1:NP,jj)&WD(2)>X{ii}(1:NP,jj);
        X_TEMP=X{ii}(LOG,jj);
        
        [~,IND]=max(I{ii}(LOG,jj));

        X{ii}(1:NP,jj)=X{ii}(1:NP,jj)+(WC-X_TEMP(IND));
    end
end

%******************
%Average over files
%******************
IA(1:NP,1:ROI)=0;
XA(1:NP,1:ROI)=0;
for ii=1:NF
    for jj=1:ROI
        IA(1:NP,jj)=IA(1:NP,jj)+I{ii}(1:NP,jj)/NF;
        XA(1:NP,jj)=XA(1:NP,jj)+X{ii}(1:NP,jj)/NF;
    end
end

%*****************
%Remove background
%*****************
for ii=1:NF
    for jj=1:ROI
        LOG=X{ii}(1:NP,jj)>WB(1)&X{ii}(1:NP,jj)<WB(2);
        I{ii}(1:NP,jj)=I{ii}(1:NP,jj)-sum(I{ii}(LOG,jj))/sum(LOG);
    end
end

%*********
%Normalize
%*********
for ii=1:NF
    for jj=1:ROI
        I{ii}(1:NP,jj)=I{ii}(1:NP,jj)/max(I{ii}(1:NP,jj));
    end
end

if PLOT_RAW==1
    %***********
    %Gen. legend
    %***********
    LEG1=cell(1,NF);
    for ii=1:NF
        LEG1{ii}=['File ' num2str(ii)];
    end

    %*************
    %Plot raw data
    %*************
    for jj=1:ROI
        figure
        hold on
        for ii=1:NF
            plot(X{ii}(1:NP,jj),I{ii}(1:NP,jj),'LineWidth',5)
        end
        hold on
        legend(LEG1)
        xlabel(['Wavelength (' char(197) ')'],'FontSize',40)
        ylabel('Normalized Intensity','FontSize',40)
        title(['ROI ' num2str(jj)],'FontSize',40)
        set(gca,'FontSize',40)
        set(gca,'FontSize',40)
        axis(AXIS)
        grid on    
    end
end

%*****************
%Remove background
%*****************
for jj=1:ROI
    LOG=XA(1:NP,jj)>WB(1)&XA(1:NP,jj)<WB(2);
    IA(1:NP,jj)=IA(1:NP,jj)-sum(IA(LOG,jj))/sum(LOG);
end

%*********
%Normalize
%*********
for jj=1:ROI
    IA(1:NP,jj)=IA(1:NP,jj)/max(IA(1:NP,jj));
end

if PLOT_AVG==1
    %***********
    %Gen. legend
    %***********
    LEG2=cell(1,ROI);
    for ii=1:ROI
        LEG2{ii}=['ROI ' num2str(ii)];
    end

    %******************
    %Plot averaged data
    %******************
    figure
    hold on
    for jj=1:ROI
        plot(XA(1:NP,jj),IA(1:NP,jj),'LineWidth',5)
    end
    hold off
    legend(LEG2)
    xlabel(['Wavelength (' char(197) ')'],'FontSize',40)
    ylabel('Normalized Intensity','FontSize',40)
    set(gca,'FontSize',40)
    set(gca,'FontSize',40)
    axis(AXIS)
    grid on
end

%***********************
%Select data of interest
%***********************
NS(1:ROI)=0;
XS=cell(1,ROI);
IS=cell(1,ROI);
for ii=1:ROI
    LOG=XA(1:NP,ii)>WD(1)&XA(1:NP,ii)<WD(2);
    
    NS(ii)=sum(LOG);
    XS{ii}(1:NS(ii))=XA(LOG,ii);
    IS{ii}(1:NS(ii))=IA(LOG,ii);
end

if PLOT_SELECT==1
    %**********************
    %Plot the selected data
    %**********************
    for jj=1:ROI
        figure
        hold on
        plot(XA(1:NP,jj),IA(1:NP,jj),'-r','LineWidth',5);
        plot(XS{jj},IS{jj},'d','Color','k','MarkerFaceColor','k','MarkerSize',18)
        hold off
        legend('Data','Selected Data')
        xlabel(['Wavelength (' char(197) ')'],'FontSize',40)
        ylabel('Normalized Intensity','FontSize',40)
        set(gca,'FontSize',40)
        axis(AXIS)
        grid on        
    end
end

%********************
%Number of fit points
%********************
NFP=3000;

FUN=cell(1,ROI);
COEFF=cell(1,ROI);
IFIT=cell(1,ROI);
XFIT=cell(1,ROI);

for ii=1:ROI
    %************
    %Fit the data
    %************
    
    FUN{ii}=fit(XS{ii}(1:NS(ii)).',IS{ii}(1:NS(ii)).',['Gauss' num2str(NG)],'Start',START_POINTS(1:3*NG),'Lower',LOWER_BC(1:3*NG),'Upper',UPPER_BC(1:3*NG));
    
    %***********************
    %Assign the coefficients
    %***********************
    COEFF{ii}=coeffvalues(FUN{ii});

    %*********************
    %Calc. the fitted peak
    %*********************
    MIN=AXIS(1);
    MAX=AXIS(2);

    XFIT{ii}(1:NFP)=linspace(MIN,MAX,NFP);
    IFIT{ii}(1:NFP)=FUN{ii}(XFIT{ii}(1:NFP));
end

%****************************************
%Sort Guassians coefficients by intensity
%****************************************
HIT(1:NG*3)=0;
COEFF_T=COEFF;
for yy=1:ROI
    HIT(1:NG*3)=0;

    for jj=1:NG
        for kk=1:NG
            if HIT(kk)==0
                MAX=COEFF{yy}(1+(kk-1)*3);
                ll=kk;
                break
            end
        end

        for kk=1:NG
            if (HIT(kk)==0 && COEFF{yy}(1+(kk-1)*3)>MAX)
                MAX=COEFF{yy}(1+(kk-1)*3);
                ll=kk;
                break
            end
        end

        COEFF_T{yy}(1+(jj-1)*3)=COEFF{yy}(1+(ll-1)*3);
        COEFF_T{yy}(2+(jj-1)*3)=COEFF{yy}(2+(ll-1)*3);
        COEFF_T{yy}(3+(jj-1)*3)=COEFF{yy}(3+(ll-1)*3);
        HIT(ll)=1;
    end
end

COEFF=COEFF_T;

INT=cell(1,ROI);
CEN=cell(1,ROI);
SIG=cell(1,ROI);
FWHM=cell(1,ROI);

IFIT_GAU=cell(ROI,NG);
XFIT_GAU=cell(ROI,NG);
for jj=1:ROI
    %*****************************************
    %Assign and calibrate the fit coefficients
    %*****************************************
    for ll=1:NG
        INT{jj}(ll)=COEFF{jj}(1+(ll-1)*3);
        CEN{jj}(ll)=COEFF{jj}(2+(ll-1)*3);
        SIG{jj}(ll)=COEFF{jj}(3+(ll-1)*3);
        FWHM{jj}(ll)=SIG{jj}(ll)*2*log(2)^.5;
    end

    %*****************************************
    %Calc individual Gaussians of fitted peaks
    %*****************************************
    for ll=1:NG
        T1=INT{jj}(ll);
        T2=CEN{jj}(ll);
        T3=SIG{jj}(ll);

        XFIT_GAU{jj,ll}=XFIT{jj};
        IFIT_GAU{jj,ll}(1:NFP)=T1*exp(-(XFIT{jj}(1:NFP)-T2).^2/T3^2);
    end

    %***********************
    %Normalize the intensity
    %***********************
    INT{jj}=INT{jj}/max(INT{jj});
end

%*************************************************
%Subtract line center from wavelength coefficients
%*************************************************
for jj=1:ROI
    for ll=NG:-1:1
        CEN{jj}(ll)=CEN{jj}(ll)-CEN{jj}(1);
    end
end

%**************************************************
%Print Gaussian fit coefficients for selected lines
%**************************************************
%USER turns on if wanting to view Guassian fit data
%{
for jj=1:ROI
    fprintf('\n********************    ROI %1i    ***************************\n\n',jj)
    for ll=1:NG
        fprintf('%8.6f  -  %8.6f  -  %8.6f  -  %8.6f\n',INT{jj}(ll),CEN{jj}(ll),SIG{jj}(ll),FWHM{jj}(ll))
    end
    fprintf('\n')
    fprintf('********************    ROI %1i    ***************************\n\n',jj)
end
%}

LEG=cell(1,ROI);
for ii=1:ROI
    LEG{ii}=['ROI ' num2str(ii)];
end

if FINDIONTEMP==1
EXAMPLE
end

if PLOT_FIT==1
    %************
    %Plot the fit
    %************
    for jj=1:ROI
%         figure
        hold on
        plot(XA(1:NP,jj),IA(1:NP,jj),'ok','MarkerFaceColor','k','MarkerSize',10)
        plot(XS{jj}(1:NS(jj)),IS{jj}(1:NS(jj)),'ok','MarkerFaceColor','k','MarkerSize',18)
        plot(XFIT{jj}(1:NFP),IFIT{jj}(1:NFP),'-r','LineWidth',3)
        if PLOT_GAU==1
            for ii=1:NG
                plot(XFIT_GAU{jj,ii}(1:NFP),IFIT_GAU{jj,ii}(1:NFP),'-b','LineWidth',2)
            end
        end
     
        hold off
        xlabel(['Wavelength (' char(197) ')'],'FontSize',40)
        ylabel('Normalized Intensity','FontSize',40)
        set(gca,'FontSize',40)
        axis(AXIS)
        grid on 
    end
end

FWHM=FWHM(1,1,1);

Residuals=XFIT{jj}-XFIT_GAU{jj};

Center=COEFF_T{1}(2);

XFIT=XFIT{1,1};

IFIT=IFIT{1,1};
end
