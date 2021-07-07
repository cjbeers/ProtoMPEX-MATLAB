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
MC  = 100;

%%Create wavelength vector [nm] dpix is from Josh's dispersion calculation
dpix = (0.09354-3.8264E-6*lambda0*10+8.7181E-11*(lambda0*10)^2-1.0366E-14*(lambda0*10)^3-2.5001E-18*(lambda0*10)^4)/10; %%%Pixel length in nm
lambda = (4.823400321227452e+02 :-dpix: 4.785239101711453e+02);

%%Choose region of interest
indx = (210:250);
XX   = (lambda(indx));
Signal_Sim = zeros(length(Ti),length(S2N),length(XX));
% errn = 
opts       = optimset('Display','off','Algorithm','trust-region-reflective');
Ti_new = zeros(length(Ti),length(S2N),MC);
IF = 0.25e-10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ii = 1:length(Ti)
    param = [Ti(ii)*1e-1,lambda0,dpix*(rand)*1e2];
    Signal_Clean = Fit2Gauss_pixelate(param,XX);
    for jj = 1:length(S2N)
        tic
        for kk = 1:MC
            NOISE = (rand(1,length(XX))./S2N(jj)*2-1./S2N(jj));
            Signal_Sim = Signal_Clean+NOISE;
            Signal_Sim = Signal_Sim./max(Signal_Sim);
            guess = [10*1e-1,lambda0,dpix/2*1e2];
            LB    = [0*1e-1,lambda0-0.1,0];
            UB    = [20*1e-1,lambda0+0.1,dpix*1e2];
            [param,RESNORM,RESIDUAL] = ...
                lsqcurvefit(@(guess,XX) Fit2Gauss_pixelated(guess,XX,IF(ii)),guess,XX,Signal_Sim,LB,UB,opts);
            Ti_new(ii,jj,kk) = param(1)*1e1;
        end
        toc 
    end      
end
save('MC_Error_Pixelated')
