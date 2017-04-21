function PLOT_FIT(SIM,FIT,PARA)

%************
%Assign input
%************
X=SIM.SPEC.X;
I=SIM.SPEC.I;

DB_ABS_PER=SIM.ABS.DB.PERCENT;
DB_ABS_GAM=SIM.ABS.DB.PHOTON;
DF_ABS_PER=SIM.ABS.DF.PERCENT;
DF_ABS_GAM=SIM.ABS.DF.PHOTON;

X_FIT=FIT.X;
I_FIT=FIT.I;

SIG=PARA.MIN.SIG;
GAM=PARA.MIN.GAM;

SIG_ERR=PARA.ERR.SIG;
GAM_ERR=PARA.ERR.GAM;

%***************
%Convert to FWHM
%***************
SIG=SIG*(2*log(2)^.5);
GAM=GAM*2;

SIG_ERR=SIG_ERR*(2*log(2)^.5);
GAM_ERR=GAM_ERR*2;

%*****************
%Print the results
%*****************
fprintf('\n****************************************************************\n')
fprintf('*** Doppler Broadened Maximum Absorption: %3.1f per cent      ***\n',DB_ABS_PER)
fprintf('*** Doppler Broadened Maximum Absorption: %1.2e photons/s ***\n',DB_ABS_GAM)
fprintf('***                                                          ***\n')
fprintf('*** Doppler Free Maximum Absorption: %3.1f per cent           ***\n',DF_ABS_PER)
fprintf('*** Doppler Free Maximum Absorption: %1.2e photons/s      ***\n',DF_ABS_GAM)
fprintf('***                                                          ***\n')
fprintf('*** Gaussian FWHM: %4.3f +/-  %4.3f GHz                      ***\n',SIG,SIG_ERR)
fprintf('*** Lorentzian FWHM: %4.3f +/-  %4.3f GHz                    ***\n',GAM,GAM_ERR)
fprintf('****************************************************************\n')

%**********************************************************
%Calculate normlaization factor to yield absorption percent
%**********************************************************
NORM=DF_ABS_PER/max(I);

%********************
%Plot the fit results
%********************
figure
hold on
plot(X,I*NORM,'dk','MarkerFaceColor','k','MarkerSize',15)
plot(X_FIT,I_FIT*NORM,'-r','LineWidth',5)
hold off
grid on
legend('Simulation','Fit to Simulation')
xlabel('Resonant Detuning Frequency (GHz)','FontSize',38)
ylabel('Absorption Signal (%)','FontSize',38)
title(['Gaussian FWHM=' num2str(SIG,'%4.3f') '\pm' num2str(SIG_ERR,'%4.3f') ' GHz   -   Lorentzian FWHM=' num2str(GAM,'%4.3f') '\pm' num2str(GAM_ERR,'%4.3f') ' GHz'],'FontSize',38,'FontWeight','Normal')
set(gca,'FontSize',38)

end