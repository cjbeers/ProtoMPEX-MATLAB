%% Visible Camera Calibration
% Coded by: Josh Beers
% For ORNL use on the Edgertronic color camera on the Proto-MPEX experiment

% The integrating sphere 455 is used with the the edgertornic cameras to
% get a single frame that is then used to map the DN value to the
% W/cm2-sr-s-nm. This data is then used with the narrowband filters on the
% cameras. Each filter has a nanometer band pass that is allows light
% through. This mapping has been done with the halogen lamp light
% generator by shining the light into the McPherson spetrometer and scaning
% the McPherson high resolution grating through wavelengths to map the end
% points at which the camera sees light.

%% Start Code
%Initialize variables and functionality

FilterInfo.ID='none'; %Possibilities: none,410,434,490,656

c=299792458; %m/s
h=6.2607E-34; %Js
%E=hc/lambda %in Joules/photon.


%% Calibration curve of the Int.sphere455

syms xx yy FilterEquation

%Wavelength of OL calibration curve from factory
OL455.Wavelength=(350:10:1100); %nm
%Spectral Radiance [(W/(sr*cm^2*nm))]
OL455.SpecRad=[8.679E-07,0.000001147,0.000001443,0.000001887,0.000002376,0.000002987,0.000003691,0.000004453,0.000005254,0.000006125,0.000007071,0.000008132,0.000009196,0.00001029,0.00001143,0.00001261,0.00001381,0.00001503,0.00001628,0.00001755,0.00001886,0.00002011,0.0000213,0.00002258,0.00002388,0.00002498,0.00002627,0.00002755,0.00002871,0.00002989,0.00003103,0.00003211,0.00003313,0.00003414,0.0000351,0.00003603,0.00003687,0.00003722,0.00003842,0.00003907,0.00003995,0.00004012,0.00004061,0.00004115,0.00004162,0.00004208,0.00004246,0.0000428,0.00004304,0.00004337,0.00004369,0.00004401,0.0000443,0.00004461,0.00004487,0.00004521,0.00004551,0.00004569,0.00004577,0.00004583,0.00004605,0.0000462,0.00004631,0.00004637,0.00004643,0.00004648,0.00004649,0.00004643,0.00004621,0.00004594,0.00004579,0.00004553,0.00004521,0.00004489,0.00004468,0.00004425];

%Fit to the OL Spectral Radiance curve
yy=-4E-21*xx.^6 + 1E-17*xx.^5 - 2E-14*xx.^4 + 2E-11*xx.^3 - 6E-09*xx.^2 + 9E-07*xx - 5E-05; 
%R^2 of 0.9999 for 6 order polynomial

%More precise evaluation of the Int. sphere
%Fit to the OL Spectral Radiance curve [Photons/(s*m2*nm)]

       a1 =   3.016e+17;
       b1 =        1098;
       c1 =       308.2;
       a2 =   9.325e+16;
       b2 =       762.9;
       c2 =       194.2;
       a3 =   2.763e+16;
       b3 =       603.2;
       c3 =       147.9;

yy2=a1*exp(-((xx-b1)/c1)^2) + a2*exp(-((xx-b2)/c2)^2) + a3*exp(-((xx-b3)/c3)^2);
%R^2 of 1 for 3 term guassian fit

%% NarrowBand Filter Info

switch FilterInfo.ID
    %x1-x2 is range of filter transmisstion
    %FilterEquations in % then converted to decimal
    case 'none'
        x1=330;
        x2=860;
        
        FilterEquation=1;
        FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_01_25m\slomo_1516906084_25_1-48-06.mov');
        FilterInfo.SS=1/250000; %s
        
    case '410'
       x1=400;
       x2=425;  
       
       a1 =       18.72;
       b1 =       412.5;
       c1 =       1.876;
       a2 =       44.21;
       b2 =       409.5;
       c2 =       2.864;
       a3 =       47.49;
       b3 =       415.6;
       c3 =       2.994;
       
       FilterEquation=a1*exp(-((xx-b1)/c1)^2) + a2*exp(-((xx-b2)/c2)^2) + a3*exp(-((xx-b3)/c3)^2);
       FilterEquation=FilterEquation/100;
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_01_25m\slomo_1516906863_25_2-01-06.mov');
       FilterInfo.SS=1/7500; %s
        
    case '434'
        x1=425;
        x2=450; 
        
       a1 =      -826.4;
       b1 =       439.6;
       c1 =       2.996;
       a2 =      -53.86;
       b2 =       436.1;
       c2 =         1.9;
       a3 =           0;
       b3 =       446.8;
       c3 =    0.006998;
       a4 =       513.3;
       b4 =         440;
       c4 =       2.699;
       a5 =       409.8;
       b5 =       438.6;
       c5 =       3.686;
       a6 =       2.903;
       b6 =         442;
       c6 =      0.1392;
        
          FilterEquation=a1*exp(-((xx-b1)/c1)^2) + a2*exp(-((xx-b2)/c2)^2) + a3*exp(-((xx-b3)/c3)^2) + a4*exp(-((xx-b4)/c4)^2) + a5*exp(-((xx-b5)/c5)^2) + a6*exp(-((xx-b6)/c6)^2);
          FilterEquation=FilterEquation/100;  
          FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_01_25m\slomo_1516906382_25_1-53-04.mov');
          FilterInfo.SS=1/5000; %s 
          
    case '490'
        x1=480;
        x2=504; 
        
       a1 =       19.35;
       b1 =     0.03864;
       c1 =       20.24;
       a2 =       29.06;
       b2 =        0.17;
       c2 =     -0.3691;
       a3 =        17.7;
       b3 =       0.35;
       c3 =      -7.701;
       a4 =       5.434;
       b4 =      0.8213;
       c4 =      -78.81;
       a5 =       3.326;
       b5 =      0.4916;
       c5 =       4.845;
       a6 =       1.606;
       b6 =       1.479;
       c6 =      -78.26;
       a7 =       3.856;
       b7 =       1.045;
       c7 =      -25.42;
       a8 =      0.9638;
       b8 =       1.686;
       c8 =      -98.81;
        
       FilterEquation=a1*sin(b1*xx+c1) + a2*sin(b2*xx+c2) + a3*sin(b3*xx+c3) +  a4*sin(b4*xx+c4) + a5*sin(b5*xx+c5) + a6*sin(b6*xx+c6) + a7*sin(b7*xx+c7) + a8*sin(b8*xx+c8);
       FilterEquation=FilterEquation/100;
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_01_25m\slomo_1516906348_25_1-52-30.mov');
       FilterInfo.SS=1/5000; %s 
          
    case '656'
        x1=648;
        x2=672;  
        
       a1 =       53.24;
       b1 =       664.9;
       c1 =       2.523;
       a2 =      -15.5;
       b2 =       660.1;
       c2 =       1.648;
       a3 =       75.65;
       b3 =       660.1;
       c3 =       3.358;
        
        FilterEquation= a1*exp(-((xx-b1)/c1)^2) + a2*exp(-((xx-b2)/c2)^2) + a3*exp(-((xx-b3)/c3)^2);
        FilterEquation=FilterEquation/100;
        FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_01_25m\slomo_1516906205_25_1-50-08.mov');
        FilterInfo.SS=1/40000; %s 
        
end

%% Inherient Number Calc.

OLThroughFilter=yy2.*FilterEquation; %Multiples the Int. sphere output
%through the transmission filter to get the equation of light through 
%the filter from the Int. sphere

%Convert to Photons/cm2

PhotonsThroughFilter=OLThroughFilter;%*(xx/(h*c));

%Inherient number or total spectral radiance through the filter
InherientNum=vpaintegral(PhotonsThroughFilter,xx,x1,x2);
InherientNum=double(InherientNum); %Spectral Radiance [(Photons/(s*sr*cm^2))]

%% Absolute Calibration of Camera

%Puts camera data to grayscale double for matrix use
FilterInfo.Image=rgb2gray(FilterInfo.Video(:,:,:,9));
FilterInfo.Image=double(FilterInfo.Image);

% %Plots the grayscale data of the camera in a color with a colormap
% figure;
% imagesc(CameraCorrection)
% colorbar

%FVC_CorrFact=(InherientNum./FilterInfo.SS.*4.*pi./(100^2))./CameraCorrection; %[(Photons/(s*m^2))/DN]

FVC_CorrFact=(InherientNum./(FilterInfo.Image./FilterInfo.SS));  %[(Photons/(s*m^2))/(DN/s)]

% imagesc(FVC_CorrFact)
% colormap(jet)
% colorbar
% %caxis([1E11 3E11])
% 
% figure;
% FVC_CorrFact.*(FilterInfo.Image./FilterInfo.SS);
% imagesc(ans)
% colormap(jet)
% colorbar


