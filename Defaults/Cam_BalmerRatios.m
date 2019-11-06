%% Initialize Code
%Coded by Josh Beers for ONRL use on the fast BW 1 edgertronic camera

%Reads in edgertronic camera data to get Balmer Ratios

%% Initialize Functionality
% 0=off, 1=on

viewfullmovie=0;
viewmoviepeices=0;

%% Initialize Variables

InterestFrame=200;
SSTarget=0;
SiCTarget=1;
GraphiteTarget=0;
plotGammas=0;
plotRatios=0;

%% Load Video Data

[FILENAME1, PATHNAME] = uigetfile('*.mov;*.mp4;', 'Choose alpha filtered color camera file');
videoFileName1=[PATHNAME FILENAME1];
AlphaVideo.RawData=importdata(videoFileName1);

[FILENAME1, PATHNAME] = uigetfile('*.txt', 'Choose alpha filtered color camera file');
AlphaVideo.CameraData=table2array(readtable([PATHNAME FILENAME1]));
AlphaVideo.CameraData=strrep( AlphaVideo.CameraData(:,:),'"','');

[FILENAME2, PATHNAME] = uigetfile('*.mov;*.mp4;', 'Choose beta filtered color camera file');
videoFileName2=[PATHNAME FILENAME2];
BetaVideo.RawData=importdata(videoFileName2);

[FILENAME2, PATHNAME] = uigetfile('*.txt', 'Choose beta filtered color camera file');
BetaVideo.CameraData=table2array(readtable([PATHNAME FILENAME1]));
BetaVideo.CameraData=strrep( BetaVideo.CameraData(:,:),'"','');

[FILENAME3, PATHNAME] = uigetfile('*.mov;*.mp4;', 'Choose gamma filtered color camera file');
videoFileName3=[PATHNAME FILENAME3];
GammaVideo.RawData=importdata(videoFileName3);

[FILENAME3, PATHNAME] = uigetfile('*.txt', 'Choose gamma filtered color camera file');
GammaVideo.CameraData=table2array(readtable([PATHNAME FILENAME1]));
GammaVideo.CameraData=strrep( GammaVideo.CameraData(:,:),'"','');

%% Takes 3 rgb channel data and makes a BW image of the frame of interest 

AlphaVideo.InterestFrame=(double(rgb2gray((AlphaVideo.RawData(:,:,:,InterestFrame)))));
BetaVideo.InterestFrame=(double(rgb2gray((BetaVideo.RawData(:,:,:,InterestFrame)))));
GammaVideo.InterestFrame=(double(rgb2gray((GammaVideo.RawData(:,:,:,InterestFrame)))));

ImageSize=size(AlphaVideo.InterestFrame);

%% Gets shutter speed (1/s)

%Uses txt file to get shutter speed into variable of type double
AlphaVideo.ShutterTime=AlphaVideo.CameraData(3,2);
AlphaVideo.ShutterTime=cell2mat(AlphaVideo.ShutterTime);
AlphaVideo.ShutterTime=str2num(AlphaVideo.ShutterTime);

%Same for beta
BetaVideo.ShutterTime=BetaVideo.CameraData(3,2);
BetaVideo.ShutterTime=cell2mat(BetaVideo.ShutterTime);
BetaVideo.ShutterTime=str2num(BetaVideo.ShutterTime);

%Same for gamma
GammaVideo.ShutterTime=GammaVideo.CameraData(3,2);
GammaVideo.ShutterTime=cell2mat(GammaVideo.ShutterTime);
GammaVideo.ShutterTime=str2num(GammaVideo.ShutterTime);

%% Gets other important camera details

%Camera Frame Rate in Hz
AlphaVideo.Hz=AlphaVideo.CameraData(4,2);
AlphaVideo.Hz=cell2mat(AlphaVideo.Hz);
AlphaVideo.Hz=str2num(AlphaVideo.Hz);

AlphaVideo.Duration=AlphaVideo.CameraData(8,2);
AlphaVideo.Duration=cell2mat(AlphaVideo.Duration);
AlphaVideo.Duration=str2num(AlphaVideo.Duration);

AlphaVideo.FrameTime=(0:(1/AlphaVideo.Hz):AlphaVideo.Duration)+4;

BetaVideo.Hz=BetaVideo.CameraData(4,2);
BetaVideo.Hz=cell2mat(BetaVideo.Hz);
BetaVideo.Hz=str2num(BetaVideo.Hz);

BetaVideo.Duration=BetaVideo.CameraData(8,2);
BetaVideo.Duration=cell2mat(BetaVideo.Duration);
BetaVideo.Duration=str2num(BetaVideo.Duration);

BetaVideo.FrameTime=(0:(1/BetaVideo.Hz):BetaVideo.Duration)+4;

GammaVideo.Hz=GammaVideo.CameraData(4,2);
GammaVideo.Hz=cell2mat(GammaVideo.Hz);
GammaVideo.Hz=str2num(GammaVideo.Hz);

GammaVideo.Duration=GammaVideo.CameraData(8,2);
GammaVideo.Duration=cell2mat(GammaVideo.Duration);
GammaVideo.Duration=str2num(GammaVideo.Duration);

GammaVideo.FrameTime=(0:(1/GammaVideo.Hz):GammaVideo.Duration)+4;

%% Get calibration matrix of filters, resize to data, and apply calibratiosn to data

CameraCorrFact=load('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\1_Calibration\CameraCalibMatrices');

AlphaVideo.CamCorr=imresize(CameraCorrFact.BW1_50_656,ImageSize);
BetaVideo.CamCorr=imresize(CameraCorrFact.BW1_50_486,ImageSize);
GammaVideo.CamCorr=imresize(CameraCorrFact.BW1_50_434,ImageSize);

AlphaVideo.AbsCalibImage=AlphaVideo.CamCorr.*(AlphaVideo.InterestFrame./AlphaVideo.ShutterTime);
BetaVideo.AbsCalibImage=BetaVideo.CamCorr.*(BetaVideo.InterestFrame/BetaVideo.ShutterTime);
GammaVideo.AbsCalibImage=GammaVideo.CamCorr.*(GammaVideo.InterestFrame./GammaVideo.ShutterTime);

%% Plots Alpha,Beta,Gamma line out

if SSTarget==1

figure;
plot(374-9.77+((300:750)*0.0134),AlphaVideo.AbsCalibImage(450,300:750),'r');
hold on
plot(374-9.77+((300:750)*0.0134),BetaVideo.AbsCalibImage(450,300:750),'g');
plot(374-9.77+((300:750)*0.0134),GammaVideo.AbsCalibImage(450,300:750),'b');
set(gca,'yscale','log')
xlim([368 375])
%ylim([0 5E17]);
ylabel('Intensity [Photons/s/m^{2}]')
xlabel('Machine z-location [cm]')
legend('Alpha','Beta','Gamma','Location','north');
vline(374,'k','Target Location')
hold off

%% Plots Gamma/Alpha line out

RatioImage=GammaVideo.AbsCalibImage./AlphaVideo.AbsCalibImage;

%yy4=smooth(374-9.75+((300:750)*0.0134),RatioImage(450,300:750),'rlowess');

figure 
plot(374-9.77+((300:750)*0.0134),(GammaVideo.AbsCalibImage(430,300:750)./(AlphaVideo.AbsCalibImage(430,300:750))),'m');

vline(374,'k','Target Location')
%set(gca,'yscale','log')
xlim([368 375])
ylim([0 1]);
ylabel('Balmer Ratio [Ab. Units]')
xlabel('Machine z-location [cm]')
legend('Stainless Steel','Location','north');
end

%%
if SiCTarget==1

figure
plot((374-7.70+((200:600)*0.0134)),(AlphaVideo.AbsCalibImage(430,200:600)),'r')
hold on
plot((374-5.2+((200:600)*0.0134)),(BetaVideo.AbsCalibImage(430,275:675)),'g')
plot((374-6.15+((100:500)*0.0134)),(GammaVideo.AbsCalibImage(444,300:700)),'b')

set(gca,'yscale','log')
xlim([368 375])
ylim([5e14 1E18]);
ylabel('Intensity [Photons/s/m^{2}]')
xlabel('Machine z-location [cm]')
legend('Alpha','Beta','Gamma','Location','north');
vline(374,'k','Target Location')
hold off

%% 
RatioImage=GammaVideo.AbsCalibImage./AlphaVideo.AbsCalibImage;

figure 
plot((374-7.5+((200:600)*0.0134)),(GammaVideo.AbsCalibImage(444,300:700)./(AlphaVideo.AbsCalibImage(430,200:600))),'m')

vline(374,'k','Target Location')
%set(gca,'yscale','log')
xlim([368 375])
%ylim([0 2]);
ylabel('Balmer Ratio [Ab. Units]')
xlabel('Machine z-location [cm]')
legend('SiC Target','Location','north');
end

%%
if GraphiteTarget==1
    
figure;
plot(374-7.5+((200:700)*0.0108),(AlphaVideo.AbsCalibImage(412,200:700)),'r')
hold on
plot(374-7.5+((200:700)*0.0108),(BetaVideo.AbsCalibImage(412,200:700)),'g')
plot(374-7.5+((200:700)*0.0108),((GammaVideo.AbsCalibImage(412,200:700))),'b')
set(gca, 'YScale', 'log')
vline(374,'k','Target Location')

xlim([368 375])
%ylim([5E16 5E18]);
ylabel('Intensity [Photons/s/m^{2}]')
xlabel('Machine z-location [cm]')
legend('Alpha','Beta','Gamma','Location','north');
hold off

%%
RatioImage=GammaVideo.AbsCalibImage./AlphaVideo.AbsCalibImage;

figure 
plot(374-7.5+((200:700)*0.0108),(RatioImage(412,200:700)),'m')

vline(374,'k','Target Location')
%set(gca,'yscale','log')
xlim([368 375])
%ylim([0 2]);
ylabel('Balmer Ratio [Ab. Units]')
xlabel('Machine z-location [cm]')
legend('Graphite Target','Location','north');
end

%% Plots combined Ratio line out
 
if plotRatios==1

%ygammalpha=smooth(GammaVideo.AbsCalibImage(430,300:750)./(AlphaVideo.AbsCalibImage(430,300:750)),'rlowess');

figure    
plot(374-7.55+((200:700)*0.0108),(C.ga(412,200:700)),'k');
hold on;
plot(374-10+((300:750)*0.0134),(SS.ga(430,300:750)),'m');
plot((374-7.5+((200:600)*0.0134)),(ygammalpha),'c')


xlim([371 374.25])
ylim([0 0.2]);
vline(374,'k','Target Location')
ylim([1E-2 2E-1]);
set(gca,'yscale','log')
ylabel('D_{\gamma}/ D_{\alpha} Ratio')
xlabel('Machine z-location [cm]')
legend('Graphite Target','SS Target','SiC Target','Location','north');
hold off
end
%% Plots combined Gamma line out
 
if plotGammas==1

ygamma=smooth(GammaVideo.AbsCalibImage(444,300:700),'lowess');

figure    
plot(374-7.55+((200:700)*0.0108),(C.g(412,200:700)),'k')
hold on;
plot(374-10+((300:750)*0.0134),(SS.g(430,300:750)),'m');
plot((374-7.5+((200:600)*0.0134)),ygamma,'c')

xlim([371 374.25])
ylim([1E14 1E17]);
set(gca,'yscale','log')
ylabel('D_{\gamma} [Photons/s/m^{2}]')
xlabel('Machine z-location [cm]')
legend('Graphite Target','SS Target','SiC Target','Location','north');
vline(374,'k','Target Location')
hold off

end