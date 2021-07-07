close all;

%%%Read in Data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Define paths
PATHNAME = '\\mpexserver\ProtoMPEX_Data\McPherson\2017_01_04\';
FILENAME = sprintf('D2Ar_7220_30um_%0.0f.SPE',shot);
%%%Read raw data
[image, header] = readSPE([PATHNAME FILENAME]);
data = im2double(image);
dim_size = size(data);
frame_rate = 1/dim_size(3);
time_vec   = (3.97:.02:4.47);
%%%Get background data 
PATHNAME = '\\mpexserver\ProtoMPEX_Data\McPherson\calibration\cal_2016_08_01\';
FILENAME = 'abs_calib_20um_1s_bg_1.SPE';
data_bkg = im2double(readSPE([PATHNAME FILENAME]));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Create wavelength vector [nm]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Pixel width [nm] from dispersion
dpix = (0.09354-3.8264E-6*lambda0*10+8.7181E-11*(lambda0*10)^2-...
    1.0366E-14*(lambda0*10)^3-2.5001E-18*(lambda0*10)^4)/10; 
%%%Creating lambda vector (cheating a bit)
lambda = (4.823400321227452e+02 :-dpix: 4.785239101711453e+02);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%subtract background and here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ii = 1:dim_size(3)
    data(:,:,ii) = data(:,:,ii)-data_bkg; %%this too
    %%subtract the baseline
    baseline = mean(data(:,400:512,ii),2);
    for jj =1:dim_size(1)
        data(jj,:,ii) = data(jj,:,ii)-baseline(jj);
    end
end
clear baseline data_bkg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Setup Fitting Here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Choose region of interest
indx = (160:250);
%%%Check region of interest here
if 1==1
    Fiber = 5;
    Frame = 13;
    figure(2)
    plot(lambda,data(Fiber,:,Frame),'ko')
    hold on;
    plot(lambda(indx),data(Fiber,indx,Frame),'ro')
    legend('All Data','Interesting Data')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Prealocate Data Vectors Here
Ti      = zeros(dim_size(1),dim_size(3));
Err_Ti  = zeros(dim_size(1),dim_size(3));
LS      = zeros(dim_size(1),dim_size(3));
RN      = zeros(dim_size(1),dim_size(3));
Sig2N   = zeros(dim_size(1),dim_size(3));

Signal_Fit  = zeros(dim_size(1),length(lambda(indx)),dim_size(3));
Signal_Data = zeros(dim_size(1),length(lambda(indx)),dim_size(3));
opts        = optimset('Display','off','Algorithm','trust-region-reflective');
%%%My calibrated values
% IF = fliplr([0.2732,0.2565,0.2579,0.2530,0.2562].*1e-10);
IF = [0.2562,0.2530,0.2579,0.2565,0.2732].*1e-10;
%%%Joshes calibrated values
% IF = fliplr([0.2658,0.2568,0.2516,0.2521,0.2559].*1e-10);
% IF = fliplr([0.25,0.25,0.25,0.25,0.25].*1e-10);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Load MC Error interpolation table%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('Table_MC_Error_Pixelated.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Choose intial gueses for fitting routine

for ii = 1:dim_size(1)
    tic
    for jj = 1:dim_size(3)
        %%%Finish Data Massaging Here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%Take only relevant wavelength chosen by indx
        XX = lambda(indx);
        %%%Take only relevant intensity chosen by indx
        YY = data(ii,indx,jj);
        %%%Normalize the Signal
        Signal = YY./max(YY);
        %%%Find the Signal to Noise Ratio
        S2N = 1.0/abs(min(Signal));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%Pixelated Fitting Routine Is Run Here%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%Initial guess is given here
        guess = [10*1e-1,lambda0,dpix/2*1e2];
        %%%Lower bounds of fitting parameters
        LB    = [0*1e-1,lambda0-0.1,0];
        %%%Upper bounds of fitting parameters
        UB    = [20*1e-1,lambda0+0.1,dpix*1e2];
        %%%Fitting routine is now populated here
        if S2N>5
        [param,RESNORM,RESIDUAL] = lsqcurvefit(@(guess,XX) ...
            Fit2Gauss_pixelated2(guess,XX,IF(ii)),guess,XX,Signal,LB,UB,opts);
        end
        if S2N<5
            RESNORM = 1e3;
            param = [0,0,0];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%Save Data Here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%Save the norm of the residual here
        RN(ii,jj)    = RESNORM;
        %%%Save Signal to Noise Ratio
        Sig2N(ii,jj) = S2N;
        %%%Use the norm of the residual to throw away BS data
        if RESNORM<0.25
            %%%Save Ion Temperature [eV]
            Ti(ii,jj)    = param(1)*1e1;
            %%%Save Wavelength Location [eV]
            LS(ii,jj)    = param(2);
            %%%Interpolate Ti Error From MC interpolation table
            Err_Ti(ii,jj) = interp2(S2N_MC,Ti_MC,SSS,S2N,param(1)*1e1);
            if Ti(ii,jj) > 19
                Err_Ti(ii,jj) = interp2(S2N_MC,Ti_MC,SSS,S2N,19);
            end 
            %%%Save The Processed Signal Data Given to Fitting Routine
            Signal_Data(ii,:,jj) = Signal;
            %%%Save The Fit Data
            Signal_Fit(ii,:,jj) = Fit2Gauss_pixelated2(param,XX,IF(ii));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    toc
end
%%%Save data to .m file
save('Spectroscopy_Results')
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%Plot Data Here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
subplot(3,2,1); hold on;
errorbar(Ti(1,:),Err_Ti(1,:),'o')
% plot(Sig2N(1,:))
subplot(3,2,2); hold on;
errorbar(Ti(2,:),Err_Ti(2,:),'o')
% plot(Sig2N(2,:))
subplot(3,2,3); hold on;
errorbar(Ti(3,:),Err_Ti(3,:),'o')
% plot(Sig2N(3,:))
subplot(3,2,4); hold on;
errorbar(Ti(4,:),Err_Ti(4,:),'o')
% plot(Sig2N(4,:))
subplot(3,2,5); hold on;
errorbar(Ti(5,:),Err_Ti(5,:),'o')
% plot(Sig2N(5,:))


