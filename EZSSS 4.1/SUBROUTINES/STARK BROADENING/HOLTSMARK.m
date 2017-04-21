function [WN,E0]=HOLTSMARK(NI,EN,NP)

PLOT=0;

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
%This program calculates the normalized electric field distribution 
%function at an electric field intensity of E produced by an ion density of 
%N and experienced by a neutral atom.
%
%                             W(E)=1/E0*Wr(E/E0)
%
%The details are given in Plasma Spectroscopy by Griem (1964) on page 73 
%with the tabulated electric field distribution funciton on page 442.
%
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!          INPUTS          !!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
%NI=scalar - The ion density in m^(-3).                       
%
%EN=scalar - The normalized electric field. 
%
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!         OUTPUTS          !!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
%WN=scalar - The normalized electric field distrubtion function.                              
%
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%*******************
%Universal constants
%*******************
e=1.60217657e-19;
eo=8.85418782e-12;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Electric field distribution funciton Wr(X) presented in Plasma 
%Spectroscopy by Griem (1964) page 442.  
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

EN_TAB(1)=0.1;
EN_TAB(2)=0.2;
EN_TAB(3)=0.3;
EN_TAB(4)=0.4;
EN_TAB(5)=0.5;
EN_TAB(6)=0.6;
EN_TAB(7)=0.7;
EN_TAB(8)=0.8;
EN_TAB(9)=0.9;
EN_TAB(10)=1.0;
EN_TAB(11)=1.1;
EN_TAB(12)=1.2;
EN_TAB(13)=1.3;
EN_TAB(14)=1.4;
EN_TAB(15)=1.5;
EN_TAB(16)=1.6;
EN_TAB(17)=1.8;
EN_TAB(18)=2.0;
EN_TAB(19)=2.2;
EN_TAB(20)=2.4;
EN_TAB(21)=2.6;
EN_TAB(22)=2.8;
EN_TAB(23)=3.0;
EN_TAB(24)=3.25;
EN_TAB(25)=3.50;
EN_TAB(26)=3.75;
EN_TAB(27)=4.00;
EN_TAB(28)=4.25;
EN_TAB(29)=4.50;
EN_TAB(30)=4.75;
EN_TAB(31)=5.00;
EN_TAB(32)=5.25;
EN_TAB(33)=5.50;
EN_TAB(34)=5.75;
EN_TAB(35)=6.00;
EN_TAB(36)=6.50;
EN_TAB(37)=7.00;
EN_TAB(38)=7.50;
EN_TAB(39)=8.00;
EN_TAB(40)=8.50;
EN_TAB(41)=9.00;
EN_TAB(42)=9.50;
EN_TAB(43)=10.0;

WN_TAB(1)=0.00422;
WN_TAB(2)=0.01667;
WN_TAB(3)=0.03664;
WN_TAB(4)=0.06308;
WN_TAB(5)=0.09460;
WN_TAB(6)=0.12959;
WN_TAB(7)=0.16636;
WN_TAB(8)=0.20323;
WN_TAB(9)=0.23864;
WN_TAB(10)=0.27122;
WN_TAB(11)=0.29987;
WN_TAB(12)=0.32378;
WN_TAB(13)=0.34246;
WN_TAB(14)=0.35570;
WN_TAB(15)=0.36357;
WN_TAB(16)=0.36633;
WN_TAB(17)=0.35850;
WN_TAB(18)=0.33694;
WN_TAB(19)=0.30684;
WN_TAB(20)=0.27275;
WN_TAB(21)=0.23822;
WN_TAB(22)=0.20557;
WN_TAB(23)=0.17606;
WN_TAB(24)=0.14437;
WN_TAB(25)=0.11837;
WN_TAB(26)=0.09741;
WN_TAB(27)=0.08067;
WN_TAB(28)=0.06733;
WN_TAB(29)=0.05667;
WN_TAB(30)=0.04811;
WN_TAB(31)=0.04118;
WN_TAB(32)=0.03553;
WN_TAB(33)=0.03089;
WN_TAB(34)=0.02704;
WN_TAB(35)=0.02380;
WN_TAB(36)=0.01879;
WN_TAB(37)=0.01514;
WN_TAB(38)=0.01241;
WN_TAB(39)=0.01032;
WN_TAB(40)=0.00870;
WN_TAB(41)=0.00741;
WN_TAB(42)=0.00638;
WN_TAB(43)=0.00554;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%*****************************************
%Calc. the normal electric field intensity
%*****************************************
E0=(4*pi*NI/3)^(2/3)*e/(4*pi*eo);

%*************
%Assign memory
%*************
WN(1:NP)=0;

if any(EN<=10)==1
    %************
    %Assign logic
    %************
    LOG=EN<=10;
    
    %******************************************************
    %Interpolate/extrapolate the distrubtion function to EN
    %******************************************************
    WN(LOG)=interp1(EN_TAB,WN_TAB,EN(LOG),'spline','extrap');
end

if any(EN>10)==1 
    %*******************
    %Lower limit for fit
    %*******************
    EN_LIM=3;
    
    %***************
    %Select fit data
    %***************
    EN_FIT=EN_TAB(EN_TAB>=EN_LIM);
    WN_FIT=WN_TAB(EN_TAB>=EN_LIM);    
    
    %************
    %Fit the data
    %************
    WN_FUN=fit(EN_FIT.',WN_FIT.','exp2');

    %************
    %Assign logic
    %************
    LOG=EN>10;
    
    %******************************************
    %Extrapolate the distrubtion function to EN
    %******************************************
    WN(LOG)=WN_FUN(EN(LOG));
end

if PLOT==1   
    %*****************************
    %Plot the distrubtion function
    %*****************************
    figure
    hold on
    
    xx=1;
    PH(xx)=plot(EN_TAB,WN_TAB,'dk','MarkerFaceColor','k','MarkerSize',20);
    LEG{xx}='Tabulated Data';

    if any(EN(EN<=10))==1
        xx=xx+1;
        PH(xx)=plot(EN(EN<=10),WN(EN<=10),'-r','LineWidth',8);
        LEG{xx}='Spline Fit';
    end

    if any(EN(EN>10))==1
        xx=xx+1;
        PH(xx)=plot(EN(EN>10),WN(EN>10),'-b','LineWidth',8);
        LEG{xx}='Exponential Extrapolation Fit';
    end

    hold off
    grid on
    legend(PH(1:xx),LEG(1:xx))
    xlabel('Normalized Electric Field','FontSize',50)
    ylabel('Holtsmark Distrubtion','FontSize',50)
    title(['Nominal Electric Field ' num2str(E0/100,'%5.1f') ' (V/cm)'],'FontSize',50)
    set(gca,'FontSize',50)
end

end