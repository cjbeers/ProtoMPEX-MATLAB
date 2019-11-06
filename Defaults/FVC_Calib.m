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
cleanup
FilterInfo.Camera='BW1'; %Possibilities: BW1, BW2, Color1
FilterInfo.CameraLens='35mm'; %Possibilities 35mm and 50mm 
%50 mm near target 35mm at central chamber
FilterInfo.ID='410'; %Possibilities: 410,434,486,656,670,706,728 to come

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
        
        switch FilterInfo.Camera
            case 'BW1'
        FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_.mov');
        FilterInfo.SS=1/75000; %s
        
        % no data
            case 'BW2'
               %FilterInfo.Video=importdata(
               %FilterInfo.SS=1/5000; %s 
            case 'Color1'
               %FilterInfo.Video=importdata(
               %FilterInfo.SS=1/5000; %s 
               
        end
        
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
       
       switch FilterInfo.Camera
            case 'BW1'  
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540998836.mov');
       FilterInfo.SS=1/1050; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540993948.mov');
       FilterInfo.SS=1/1250; %s    
                        
                end
                
           case 'BW2' 
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540998223.mov');
       FilterInfo.SS=1/1050; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540995312.mov');
       FilterInfo.SS=1/1250; %s    
                        
                end
                
           case 'Color1'
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540996496.mov');
       FilterInfo.SS=1/1050; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540997352.mov');
       FilterInfo.SS=1/1050; %s    
                        
                end
       end
       
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
          
           switch FilterInfo.Camera
            case 'BW1'  
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540998781.mov');
       FilterInfo.SS=1/1250; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540994072.mov');
       FilterInfo.SS=1/1250; %s    
                        
                end
                
           case 'BW2' 
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540998134.mov');
       FilterInfo.SS=1/1250; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540995244.mov');
       FilterInfo.SS=1/1250; %s    
                        
                end
                
           case 'Color1'
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540996376.mov');
       FilterInfo.SS=1/1250; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540997282.mov');
       FilterInfo.SS=1/1250; %s    
                        
                end
               
          end
          
    case '486'
        x1=470;
        x2=500; 
        
       a0 =       21.29;
       a1 =      -27.38;
       b1 =       18.09;
       a2 =       5.303;
       b2 =      -11.77;
       a3 =     -0.6525;
       b3 =      -1.085;
       a4 =       3.591;
       b4 =       3.048;
       a5 =      -2.656;
       b5 =      -0.363;
       a6 =      0.2393;
       b6 =    -0.01643;
       a7 =      0.4928;
       b7 =      -1.215;
       a8 =      0.2165;
       b8 =        1.18;
       w =      0.2247;
        
       FilterEquation=a0 + a1*cos(xx.*w) + b1*sin(xx.*w) + a2*cos(2*xx.*w) + b2*sin(2*xx.*w) + a3*cos(3*xx.*w) + b3*sin(3*xx.*w) + a4*cos(4*xx.*w) + b4*sin(4*xx.*w) + a5*cos(5*xx.*w) + b5*sin(5*xx.*w) + a6*cos(6*xx.*w) + b6*sin(6*xx.*w) + a7*cos(7*xx.*w) + b7*sin(7*xx.*w) + a8*cos(8*xx.*w) + b8*sin(8*xx.*w);       
       FilterEquation=FilterEquation/100;
       
       switch FilterInfo.Camera
            case 'BW1'  
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540998720.mov');
       FilterInfo.SS=1/5000; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540993787.mov');
       FilterInfo.SS=1/10000; %s    
                        
                end
                
           case 'BW2' 
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540998026.mov');
       FilterInfo.SS=1/5000; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540995176.mov');
       FilterInfo.SS=1/10000; %s    
                        
                end
                
           case 'Color1'
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540996308.mov');
       FilterInfo.SS=1/1250; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540997226.mov');
       FilterInfo.SS=1/1250; %s    
                        
                end
                
       end
          
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
        
       switch FilterInfo.Camera
            case 'BW1'  
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540998649.mov');
       FilterInfo.SS=1/25000; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540993385.mov');
       FilterInfo.SS=1/25000; %s    
                        
                end
                
           case 'BW2' 
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540997909.mov');
       FilterInfo.SS=1/25000; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540994991.mov');
       FilterInfo.SS=1/25000; %s    
                        
                end
                
           case 'Color1'
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540996147.mov');
       FilterInfo.SS=1/15000; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540997063.mov');
       FilterInfo.SS=1/10000; %s    
                        
                end
                
        end
        
    case '670'
        x1=650;
        x2=690;  
        
       a1 =       17.01;
       b1 =       671.8;
       c1 =       5.721;
       a2 =        1863;
       b2 =       671.3;
       c2 =       2.229;
       a3 =       -2260;
       b3 =       671.3;
       c3 =       2.325;
       a4 =       43.11;
       b4 =       672.8;
       c4 =       1.612;
       a5 =       43.48;
       b5 =       674.5;
       c5 =       2.404;
       a6 =       429.3;
       b6 =         671;
       c6 =       2.833;
        
        FilterEquation= a1*exp(-((xx-b1)/c1)^2) + a2*exp(-((xx-b2)/c2)^2) + a3*exp(-((xx-b3)/c3)^2) + a4*exp(-((xx-b4)/c4)^2) + a5*exp(-((xx-b5)/c5)^2) + a6*exp(-((xx-b6)/c6)^2);
      
        FilterEquation=FilterEquation/100;
        
       switch FilterInfo.Camera
            case 'BW1'  
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540998956.mov');
       FilterInfo.SS=1/15000; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540994322.mov');
       FilterInfo.SS=1/25000; %s    
                        
                end
                
           case 'BW2' 
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540998344.mov');
       FilterInfo.SS=1/15000; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540995476.mov');
       FilterInfo.SS=1/25000; %s    
                        
                end
                
           case 'Color1'
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540996727.mov');
       FilterInfo.SS=1/7500; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540997557.mov');
       FilterInfo.SS=1/7500; %s    
                        
                end
                
        end
        
    case '706'
        x1=695;
        x2=725;  
        
       a1 =        3.07;
       b1 =       709.9;
       c1 =       0.558;
       a2 =       12.15;
       b2 =       710.7;
       c2 =      0.8302;
       a3 =       26.84;
       b3 =       711.9;
       c3 =       1.121;
       a4 =       7.281;
       b4 =       713.1;
       c4 =      0.8158;
       a5 =       53.58;
       b5 =       714.6;
       c5 =       2.411;
       a6 =       57.77;
       b6 =       708.8;
       c6 =        2.42;
        
        FilterEquation=a1*exp(-((xx-b1)/c1)^2) + a2*exp(-((xx-b2)/c2)^2) + a3*exp(-((xx-b3)/c3)^2) + a4*exp(-((xx-b4)/c4)^2) + a5*exp(-((xx-b5)/c5)^2) + a6*exp(-((xx-b6)/c6)^2);
        FilterEquation=FilterEquation/100;
        
        switch FilterInfo.Camera
            case 'BW1'  
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540999007.mov');
       FilterInfo.SS=1/15000; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540994430.mov');
       FilterInfo.SS=1/25000; %s    
                        
                end
                
           case 'BW2' 
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540998425.mov');
       FilterInfo.SS=1/25000; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540995548.mov');
       FilterInfo.SS=1/15000; %s    
                        
                end
                
           case 'Color1'
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540996805.mov');
       FilterInfo.SS=1/7500; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540997671.mov');
       FilterInfo.SS=1/7500; %s    
                        
                end
                
        end
        
    case '728'
        x1=705;
        x2=735;  

       a1 =       6.653;
       b1 =       719.5;
       c1 =      0.9013;
       a2 =       56.41;
       b2 =       717.8;
       c2 =        2.52;
       a3 =       16.39;
       b3 =       720.7;
       c3 =        1.22;
       a4 =      -14.37;
       b4 =       723.5;
       c4 =       1.311;
       a5 =       66.32;
       b5 =       723.5;
       c5 =       2.921;
        
        FilterEquation=a1*exp(-((xx-b1)/c1)^2) + a2*exp(-((xx-b2)/c2)^2) + a3*exp(-((xx-b3)/c3)^2) + a4*exp(-((xx-b4)/c4)^2) + a5*exp(-((xx-b5)/c5)^2);
        FilterEquation=FilterEquation/100;
        
       switch FilterInfo.Camera
            case 'BW1'  
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540999060.mov');
       FilterInfo.SS=1/15000; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m\slomo_1540994544_31_9-02-26.mov');
       FilterInfo.SS=1/25000; %s    
                        
                end
                
           case 'BW2' 
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540998494.mov');
       FilterInfo.SS=1/15000; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31m2\slomo_1540995623.mov');
       FilterInfo.SS=1/25000; %s    
                        
                end
                
           case 'Color1'
                switch FilterInfo.CameraLens
                    case '35mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540996883.mov');
       FilterInfo.SS=1/7500; %s
       
                    case '50mm'
       FilterInfo.Video=importdata('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_10_31c\slomo_1540997722.mov');
       FilterInfo.SS=1/7500; %s    
                        
                end
                
        end
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
FilterInfo.Image=rgb2gray(FilterInfo.Video(:,:,:,5));
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




