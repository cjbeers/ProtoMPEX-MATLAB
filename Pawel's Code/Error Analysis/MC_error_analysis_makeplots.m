clearvars; close all;
tic 
%%%Specify the grating here
Grating = 1800;
%%%Specify where the McPherson is centered at
Center_lambda = 7217; 
lambda0 = Center_lambda/15-0.5;
%%%Read raw data
Ti  = linspace(0,40,101);
S2N = linspace(1,100,100);
MC  = 1000;

%%Create wavelength vector [nm] dpix is from Josh's dispersion calculation
dpix = (0.09354-3.8264E-6*lambda0*10+8.7181E-11*(lambda0*10)^2-1.0366E-14*(lambda0*10)^3-2.5001E-18*(lambda0*10)^4)/10; %%%Pixel length in nm
lambda = (4.823400321227452e+02 :-dpix: 4.785239101711453e+02);

%%Choose region of interest
indx = (200:260);
XX   = (lambda(indx));
Signal_Sim = zeros(length(Ti),length(S2N),length(XX));
% errn = 
opts = optimset('Display','off');
Ti_new = zeros(length(Ti),length(S2N),MC);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ii = 30:30
    param = [Ti(ii),0,1.0,lambda0];
    Signal_Clean = Fit2Gauss_shifted(param,XX);
    tic
    for jj = 15:15
        for kk = 1:MC
            NOISE = (rand(1,length(XX))./S2N(jj)*2-1./S2N(jj));
            Signal_Sim = Signal_Clean+NOISE;
            Signal_Sim = Signal_Sim./max(Signal_Sim);
            guess = [5,0,1,lambda0];
            LB    = [0,-1/2/S2N(jj),1-1/2/S2N(jj),lambda0-0.5];
            UB    = [100,1/2/S2N(jj),1+1/2/S2N(jj),lambda0+0.5];
            [param,RESNORM,RESIDUAL] = lsqcurvefit('Fit2Gauss_shifted',guess,XX,Signal_Sim,LB,UB,opts);
            Ti_new(ii,jj,kk) = param(1);
        end
    end
    toc      
end
save('MC_Error_HighRes')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Create Initial Te Fitting
% for ii = 1:length(Ti)
%     for jj = 1:length(S2N)
%         XX = data(ii,indx,jj);
%         Signal = XX./max(XX);
%         Signal2(ii,:,jj) = Signal;
%         S2N = max(XX)/abs(min(XX));
%         guess = [5,0,1,lambda0];
%         LB    = [0,-1/2/S2N,1-1/2/S2N,lambda0-0.5];
%         UB    = [40,1/2/S2N,1+1/2/S2N,lambda0+0.5];
%         [param,RESNORM,RESIDUAL] = lsqcurvefit('Fit2Gauss_shifted',guess,lambda(indx),Signal,LB,UB);
%         Signal_Fit(ii,:,jj) = Fit2Gauss_shifted(param,Xnew);
%         RN(ii,jj)    = RESNORM;
%         if RESNORM<1.0;
%         Ti(ii,jj)    = param(1);
%         end
%         LS(ii,jj)    = param(4);
%         Sig2N(ii,jj) = S2N;
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
