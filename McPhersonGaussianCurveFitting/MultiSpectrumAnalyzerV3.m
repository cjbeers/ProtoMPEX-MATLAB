%Coded by: Josh Beers, Updated to V3 by Davis Easley
%ORNL use only

%USER MUST HAVE IPEAKS FILES DOWNLOADED IN MATLAB PATH IF USING IPEAKS
%USER MUST HAVE FIT_EXAMPLE IF DOING ION TEMPERATURES

%Code uses a single McPherson .SPE file to view a calibrated 
%counts vs. wavelength and intensity vs. wavelength plot with an edittable 
%peak finder that displays the peaks and their values for both graph types

%Search for "USER" to find locations that need to be changed
%% Start Code

%clear all
fclose all
%close all
format shortG; 
format compact;
tic %starts timing the code
%Turns on=1/off=0 program sections

PLOTPIXELS=0; %plots counts vs. pixel number
PLOTWAVELENGTH=1; %plots counts vs. wavelength
PLOTINTENSITY=0; %plots the absolute intensity vs. wavelength
USEIPEAKS=0; %uses program ipeaks to find wavelength peaks
USEIPEAKSFORINTENSITYPEAKS=0; %uses ipeaks to find the intensity peaks
FINDFWHM=0; %not really needed anymore because ion temp can be found
FINDFLOW=0; % used when looking up and down stream, FINDFWHM must also = 1
FINDIONTEMP=0; %uses Elijah's code to calculate ion temperature
IONTEMPSINGLEFRAME=0; %looks at single frame to fit ion temp
POWERLOSS=0; %uses the intensity to find the power loss for a single spectra from each fiber
VOLUMECALC=0; %Finds the volume of the plasma

%% Read in file of interest

%prompt = 'Grating used (300 or 1800) nm? '; %Two gratings can be used
%Grating = input(prompt);
Spectra.Grating = 1800;  %USER chooses which Grating was used
Spectra.McPherLoc=7575;
Spectra.FileName=('\\mpexserver\ProtoMPEX_Data\McPherson\2021_01_12\Shot_  31434.SPE');
[Spectra.RawDATA,Spectra.ExposureTime,Spectra.Gain] = readSPE(Spectra.FileName); %USER Specifiy Location
try
[Camera.data, Camera.wavelengths, Camera.params]=loadSPE(Spectra.FileName); %If using the PIMAX3 Camera
disp('PIMAX3 Used')
end
%Spectra.McPherLoc=double(string(Spectra.FileName(end-23:end-17))); %USER changes to match file wavelength location on McPherson
%Spectra.RawDATA=flip(Spectra.RawDATA);
Spectra.Length = size(Spectra.RawDATA);
Spectra.RawBGDATA=zeros(512); %readSPE('\\mpexserver\ProtoMPEX_Data\McPherson\calibration\cal_2018_08_03\abs_cal_45.SPE');
%Spectra.RawBGDATA = readSPE('\\mpexserver\ProtoMPEX_Data\McPherson\2018_04_30\D2_6480_30um_21730.SPE');...
%USER Specify Location OR use the same BG spectrum each time



c=299792458; %m/s
h=6.2607E-34; %Js
%E=hc/lambda %in Joules/photon.

if Spectra.Gain==1
    Spectra.RawDATA=Spectra.RawDATA*1.89;
elseif Spectra.Gain==3
    Spectra.RawDATA=Spectra.RawDATA/1.9;
elseif Spectra.Gain==2 
elseif Spectra.Gain ==0
    disp('Gain setting was 0, must be using PIMAX3')
    Spectra.Gain=0;
else
    disp('Error in Gain')
end

if exist('Camera')
Spectra.Gain=double(convertCharsToStrings(Camera.params.SpeFormat.DataHistories.DataHistory.Origin.Experiment.Devices.Cameras.Camera.Intensifier.Gain.Text));
Spectra.ReadOutTime=double(convertCharsToStrings(Camera.params.SpeFormat.DataHistories.DataHistory.Origin.Experiment.Devices.Cameras.Camera.ReadoutControl.Time.Text));
Spectra.Delaytime=double(convertCharsToStrings(Camera.params.SpeFormat.DataHistories.DataHistory.Origin.Experiment.Devices.Cameras.Camera.Intensifier.PhosphorDecayDelay.Text));
Spectra.AnalogGain=convertCharsToStrings(Camera.params.SpeFormat.DataHistories.DataHistory.Origin.Experiment.Devices.Cameras.Camera.Adc.AnalogGain.Text);
Spectra.ExposureTime=(double(convertCharsToStrings(Camera.params.SpeFormat.DataHistories.DataHistory.Origin.Experiment.Devices.Cameras.Camera.Gating.RepetitiveGate.Pulse.Attributes.width)))/1e9;

GainMultiplier=((112.31*Spectra.Gain)+655.7)/768.01;
Spectra.RawDATA=Spectra.RawDATA./GainMultiplier;
end

B_Field = [330 2300 3500 540 3750]; %USER inputs in order: helicon current, current_A, current_B, current_C, current_D in Amps
%Coils 3,4 PS3
%Coils 9-13  PS2
%Coils 7-8 PS1
%Coil 2 TR1
%Coil 1,6 TR2

Spool1 = 1.1432; %[cm to m]
Spool2 = 1.4632;
Spool3 = 1.7462;
Spool4 = 2.0272;
Spool5 = 2.2892;
Spool6 = 2.6662;
Spool7 = 3.0267;
Spool8 = 3.2490;
Spool9 = 3.4903;
Spool10 = 3.6871;
Spool11 = 3.8776;
Spool12=4.1316;

%Fiber in opposite order of Physcial Fiber
Fibers= [Spool12 Spool8 Spool10 Spool12 Spool12];%USER enters all fiber locations for Fibers 1-5 left to right (0 indicates Fiber not in use)

if length(Spectra.Length)==2
    Spectra.Length(1,3)=1;
end

if Spectra.Length(1,3) == 1
    Spectra.FrameOfInterest = 1;
elseif Spectra.Length(1,3) == 2
    Spectra.FrameOfInterest = 2;
elseif Spectra.Length(1,3) == 13
    Spectra.FrameOfInterest = 8;
elseif Spectra.Length(1,3) == 37
    Spectra.FrameOfInterest = 14;
elseif Spectra.Length(1,3) == 50
    Spectra.FrameOfInterest = 25;
elseif Spectra.Length(1,3) == 40
    Spectra.FrameOfInterest = 20;
elseif Spectra.Length(1,3) == 60
    Spectra.FrameOfInterest = 9;
elseif Spectra.Length(1,3) ==20
    Spectra.FrameOfInterest=6;
else
    Spectra.FrameOfInterest = 5;
    %disp('Spectra frames used are weird fix FrameOfInterest');
end
Spectra.FrameOfInterest = 11;

if Spectra.Grating==300
Spectra.Lambda0 = (Spectra.McPherLoc*.4); %What you tunned the Mcpherson to in nanometers!
%Spectra.Lambda0=468.6; %For looking at He II ion temps.
elseif Spectra.Grating == 1800
Spectra.Lambda0 = (Spectra.McPherLoc/15); %USER uses this one if not centering the McPherson
%Spectra.Lambda0=480.6; %For looking at the Ar II line for ion temperatures
%Spectra.Lambda0=468.55; %For looking at He II ion temps.
%Spectra.Lambda0=656.01; %He II
%Spectra.Lambda0=504.8;-IONTEMPSINGLEFRAME
%for when centering the McPherson peak of interest
end

if Spectra.Grating == 300
%Spectra.P0 = 180; %USER put peaklocation here!!! peak location can change it is not the same each time
Spectra.P0 = 210; % 210 for 300nm Grating, 180 for 1800nm Grating, ~230 when centering McPher
elseif Spectra.Grating == 1800
    Spectra.P0= 162; %USER can look at the ipeaks to find the location of their peak of interest
    %Spectra.P0=230; %For when not cetering the McPherson
    %Spectra.P0=275; %For when not cetering the McPherson
end

%Creates a matrix to be filled with raw data
Spectra.RawFiber1=zeros(Spectra.Length(:,3),Spectra.Length(:,2)); %making a matrix that is 50x512 for Fiber 1
Spectra.RawFiber2=zeros(Spectra.Length(:,3),Spectra.Length(:,2)); %making a matrix that is 50x512 for Fiber 2
Spectra.RawFiber3=zeros(Spectra.Length(:,3),Spectra.Length(:,2)); %making a matrix that is 50x512 for Fiber 3
Spectra.RawFiber4=zeros(Spectra.Length(:,3),Spectra.Length(:,2)); %making a matrix that is 50x512 for Fiber 4
Spectra.RawFiber5=zeros(Spectra.Length(:,3),Spectra.Length(:,2)); %making a matrix that is 50x512 for Fiber 5

%Creates a matrix to be filled with raw bg data
Spectra.RawFiberBG1=zeros(Spectra.Length(:,3),Spectra.Length(:,2)); 
Spectra.RawFiberBG2=zeros(Spectra.Length(:,3),Spectra.Length(:,2));
Spectra.RawFiberBG3=zeros(Spectra.Length(:,3),Spectra.Length(:,2));
Spectra.RawFiberBG4=zeros(Spectra.Length(:,3),Spectra.Length(:,2));
Spectra.RawFiberBG5=zeros(Spectra.Length(:,3),Spectra.Length(:,2));
        
for ii = 1:Spectra.Length(:,3) %Breaks raw data into individual fibers
  Spectra.RawFiber1(ii,:) = (double(Spectra.RawDATA(1,:,ii)));
  Spectra.RawFiber2(ii,:) = (double(Spectra.RawDATA(2,:,ii)));
  Spectra.RawFiber3(ii,:) = (double(Spectra.RawDATA(3,:,ii)));
  Spectra.RawFiber4(ii,:) = (double(Spectra.RawDATA(4,:,ii)));
  Spectra.RawFiber5(ii,:) = (double(Spectra.RawDATA(5,:,ii)));
  
  Spectra.RawFiberBG1(1,:) = mean2((double(Spectra.RawBGDATA(1,10:15,1))));
  Spectra.RawFiberBG2(1,:) = mean2((double(Spectra.RawBGDATA(2,10:15,1))));
  Spectra.RawFiberBG3(1,:) = mean2((double(Spectra.RawBGDATA(3,10:15,1))));
  Spectra.RawFiberBG4(1,:) = mean2((double(Spectra.RawBGDATA(4,10:15,1))));
  Spectra.RawFiberBG5(1,:) = mean2((double(Spectra.RawBGDATA(5,10:15,1))));
  
  %Creates the backgournd subtracted files
  Spectra.BGSub1 = Spectra.RawFiber1 - Spectra.RawFiberBG1(1,:); 
  Spectra.BGSub2 = Spectra.RawFiber2 - Spectra.RawFiberBG2(1,:);
  Spectra.BGSub3 = Spectra.RawFiber3 - Spectra.RawFiberBG3(1,:); 
  Spectra.BGSub4 = Spectra.RawFiber4 - Spectra.RawFiberBG4(1,:); 
  Spectra.BGSub5 = Spectra.RawFiber5 - Spectra.RawFiberBG5(1,:); 
  
  %Creates a background array from each frame on each fiber 
  Spectra.SelfBG1(ii,1)=abs(mean2(Spectra.RawFiber1(ii,5:10)));
  Spectra.SelfBG2(ii,1)=abs(mean2(Spectra.RawFiber2(ii,5:10)));
  Spectra.SelfBG3(ii,1)=abs(mean2(Spectra.RawFiber3(ii,5:10)));
  Spectra.SelfBG4(ii,1)=abs(mean2(Spectra.RawFiber4(ii,5:10)));
  Spectra.SelfBG5(ii,1)=abs(mean2(Spectra.RawFiber5(ii,5:10)));
  
  %Creates a data array that has its self backgorund subtracted, 
  %IF A PEAK IS IN THIS BG IT WILL MESS UP FITTINGS
  Spectra.SelfBGSub1(ii,:)=Spectra.RawFiber1(ii,:)-Spectra.SelfBG1(ii,1);
  Spectra.SelfBGSub2(ii,:)=Spectra.RawFiber2(ii,:)-Spectra.SelfBG2(ii,1);
  Spectra.SelfBGSub3(ii,:)=Spectra.RawFiber3(ii,:)-Spectra.SelfBG3(ii,1);
  Spectra.SelfBGSub4(ii,:)=Spectra.RawFiber4(ii,:)-Spectra.SelfBG4(ii,1);
  Spectra.SelfBGSub5(ii,:)=Spectra.RawFiber5(ii,:)-Spectra.SelfBG5(ii,1);
end
  
Spectra.Pixels=(1:512); %Creates an array of pixels to match camera pixels

%% Plots counts vs. pixels

if PLOTPIXELS==1

figure; %Plot corrected signal vs. pixels
plot(Spectra.Pixels,(Spectra.RawFiber1(Spectra.FrameOfInterest,:)));
hold on;
plot(Spectra.Pixels,(Spectra.RawFiber2(Spectra.FrameOfInterest,:)));
plot(Spectra.Pixels,(Spectra.RawFiber3(Spectra.FrameOfInterest,:)));
plot(Spectra.Pixels,(Spectra.RawFiber4(Spectra.FrameOfInterest,:)));
plot(Spectra.Pixels,(Spectra.RawFiber5(Spectra.FrameOfInterest,:)));
ax = gca;
ax.FontSize = 13;
title('Counts vs Corrected Pixels','FontSize',13);
xlabel('Pixel','FontSize',13);
ylabel('Counts','FontSize',13);
xlim([0 512]);
ylim([0 inf]);
set(gcf,'color','w')
hold off;
end

%% Uses dispersion to create wavelength at each pixel

%Creates a pixel array for using dispersion to map wavelength to the pixels
Spectra.PixelsC(1:Spectra.P0,:) = (Spectra.P0-1:-1:0)'; %From 1 to Peak of Interest 
%Spectra.PixelsC(1:Spectra.P0,:)=(0:1:Spectra.P0);
Spectra.PixelsC(Spectra.P0+1:Spectra.Length(1,2),:) = (1:1:(Spectra.Length(1,2)-Spectra.P0))'; %From Peak of Interest to 512

%Creates the Dispersion of the Mcpherson, DO NOT CHANGE
for ii=1:512
      if Spectra.Grating ==300
      Spectra.Disper = -0.055; %For 300nm Grating
      elseif Spectra.Grating==1800
      Spectra.Disper= 25.6/16*(-(0.09354-3.8264E-6*Spectra.Lambda0*10+8.7181E-11*(Spectra.Lambda0*10)^2-1.0366E-14*(Spectra.Lambda0*10)^3-2.5001E-18*(Spectra.Lambda0*10)^4)/10); %For 1800nm Grating, this Grating has been working for everything atm
     end
    Spectra.PixCDisp(ii,1) = Spectra.PixelsC(ii,1)*Spectra.Disper; %The entire file times the dispersion coeff.
end

%Creates the wavelength (lambda) for plotting
Spectra.Lambda(1:Spectra.P0,:) = Spectra.Lambda0 - Spectra.PixCDisp(1:Spectra.P0,:); %Conversion of pixel to wavelength
Spectra.Lambda(Spectra.P0+1:Spectra.Length(1,2),:) = rot90(Spectra.Lambda0 + Spectra.PixCDisp(Spectra.P0+1:Spectra.Length(1,2),:)); %Conversion of pixel to wavelength
Spectra.LambdaPlot=rot90((flip(Spectra.Lambda)));
Spectra.LambdaMin=Spectra.LambdaPlot(1,512); %Used for x min and max in plots
Spectra.LambdaMax=Spectra.LambdaPlot(1,1);
Spectra.PixelSize=Spectra.LambdaPlot(1,1)-Spectra.LambdaPlot(1,2); %Nm/pixel 

%% Peak finder using ipeaks

if USEIPEAKS==1

%For findpeaks
x=Spectra.Lambda;
y=Spectra.SelfBGSub3(1,:); %USER changes to which fiber is observed. 
SlopeThreshold=0.001;
smoothwidth=13;
peakgroup=6;
smoothtype=1;
%USER inps AmpThreshold based on counts of smallest peak being looked at
AmpThreshold=110; %USER changes this if want to see more or less peaks depending on spectrum

CountsPeak=findpeaksL(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype);
if CountsPeak(1,2)==0
    disp('Error in AmpThreshold for Counts')
end
sizeP=size(CountsPeak);
% 
% %%Prints peaks and their respective data
% for ii=1:512    
%    for j=1:sizeP(1,1) 
%         if CountsPeak(j,2) == Spectra.LambdaPlot(ii)
%             %disp('Pixel #,Wavelength,Counts')
%             Words=['Peak#= ',num2str(j), ' CorrectedPixel#=', num2str(correctedtable(1,ii)), ' Wavelength=', num2str(correctedtable(2,ii)), ' Counts=', num2str(correctedtable(3,ii)),];
%             disp(Words)
%             %correctedtable(1,i),correctedtable(2,i),correctedtable(3,i)         
%         end
%    end 
% end

% Ipeak Plotting Tool

%For ipeak %Not used atm, but good for visualising data the first time
PeakD=(0.3/18);
AmpT=110;
SlopeT=0.001;
SmoothW=13;
FitW=6;

  %%  
% for jj=1:Spectra.Length(1,3)
% 
% y=Spectra.SelfBGSub1(jj,:);       
% DataMatrix=[x;y];   
% [Ipeaks]=ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW);
% 
% Areas(1,jj)=max(Ipeaks(:,5));
% 
% end

end

%% Plots counts vs. wavelength

if PLOTWAVELENGTH==1
    
figure; 
plot(Spectra.LambdaPlot,Spectra.SelfBGSub1(Spectra.FrameOfInterest,:));
hold on;
plot(Spectra.LambdaPlot,Spectra.SelfBGSub2(Spectra.FrameOfInterest,:));
plot(Spectra.LambdaPlot,Spectra.SelfBGSub3(Spectra.FrameOfInterest,:));
plot(Spectra.LambdaPlot,Spectra.SelfBGSub4(Spectra.FrameOfInterest,:));
plot(Spectra.LambdaPlot,Spectra.SelfBGSub5(Spectra.FrameOfInterest,:));
ax = gca;
ax.FontSize = 13;
title('Counts vs wavelength','FontSize',13);
xlabel('Wavelength [nm]','FontSize',13);
ylabel('Counts','FontSize',13);
%xlim([Spectra.LambdaMin Spectra.LambdaMax])
ylim([0 inf]);
set(gcf,'color','w')
hold off;
end

%% Intensity calculations
%WL remakes CF for each wavelength looked at with single files
%Intensity in (mW/cm2-micron) converted to (mW/m2) for HL source
%Intenisty in (mW/cm2-sr-nm) converted to (mW/m2) for OL source
%Intensity now in Photons/s/m2

%For 300nm Grating, wihich uses HL to calibrate

%PolTrans=(0.007568*WL^2+38.71*WL+-1.655E4)/(WL+-391.3) %equation for the
%polarizer transmission

if Spectra.Grating ==300
for jj=1:Spectra.Length(1,3)
for ii=1:512
WL=Spectra.LambdaPlot(1,ii);
PolTrans=((0.007568*WL^2+38.71*WL+-1.655E4)/(WL+-391.3))/100; %Transmission of the Polarizer
Spectra.F1CF(1,ii) =(1101630822525047*WL^6)/649037107316853453566312041152512 - (7265777621430527*WL^5)/1267650600228229401496703205376 + (4967798444037317*WL^4)/618970019642690137449562112 - (7213530429423309*WL^3)/1208925819614629174706176 + (5868229780194579*WL^2)/2361183241434822606848 - (5074883106023453*WL)/9223372036854775808 + 7297156861788209/144115188075855872;
Spectra.Intensity1(jj,ii)=(((Spectra.F1CF(1,ii)*(Spectra.SelfBGSub1(jj,ii)))/(Spectra.ExposureTime*1000))*100^2)*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
Spectra.F2CF(1,ii) =(2626695280632411*WL^6)/1298074214633706907132624082305024 - (1076220889837839*WL^5)/158456325028528675187087900672 + (5845266505055671*WL^4)/618970019642690137449562112 - (8418572225483743*WL^3)/1208925819614629174706176 + (3392225726576867*WL^2)/1180591620717411303424 - (5804480930144169*WL)/9223372036854775808 + 4122263530836521/72057594037927936;
Spectra.Intensity2(jj,ii)=(((Spectra.F2CF(1,ii)*(Spectra.SelfBGSub2(jj,ii)))/(Spectra.ExposureTime*1000))*100^2)*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
Spectra.F3CF(1,ii) =(6685689374474273*WL^6)/5192296858534827628530496329220096 - (5538637756507167*WL^5)/1267650600228229401496703205376 + (3809644293763157*WL^4)/618970019642690137449562112 - (2786038952453225*WL^3)/604462909807314587353088 + (4572309193917549*WL^2)/2361183241434822606848 - (3994730768181719*WL)/9223372036854775808 + 5813337095729975/144115188075855872;
Spectra.Intensity3(jj,ii)=(((Spectra.F3CF(1,ii)*(Spectra.SelfBGSub3(jj,ii)))/(Spectra.ExposureTime*1000))*100^2)*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
Spectra.F4CF(1,ii) =(7302221534579973*WL^6)/5192296858534827628530496329220096 - (1512047247641153*WL^5)/316912650057057350374175801344 + (519560686567997*WL^4)/77371252455336267181195264 - (6069351690507449*WL^3)/1208925819614629174706176 + (4967682192603545*WL^2)/2361183241434822606848 - (4324620186983531*WL)/9223372036854775808 + 6262978433970463/144115188075855872;
Spectra.Intensity4(jj,ii)=(((Spectra.F4CF(1,ii)*(Spectra.SelfBGSub4(jj,ii)))/(Spectra.ExposureTime*1000))*100^2)*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
Spectra.F5CF(1,ii) =-(3056574429229055*WL^6)/2596148429267413814265248164610048 + (5619162961737097*WL^5)/1267650600228229401496703205376 - (4231508340035941*WL^4)/618970019642690137449562112 + (3345429297905545*WL^3)/604462909807314587353088 - (5859150790520435*WL^2)/2361183241434822606848 + (5387567721134835*WL)/9223372036854775808 - 8114035101143863/144115188075855872;
Spectra.Intensity5(jj,ii)=(((Spectra.F5CF(1,ii)*(Spectra.SelfBGSub5(jj,ii)))/(Spectra.ExposureTime*1000))*100^2)*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
end
end

%For 1800nm Grating, which uses OL to calibrate 

elseif Spectra.Grating ==1800
for jj=1:Spectra.Length(1,3)
for ii=1:512
WL=Spectra.LambdaPlot(1,ii);
PolTrans=((0.007568*WL^2+38.71*WL+-1.655E4)/(WL+-391.3))/100; %Transmission of the Polarizer
%Spectra.F1CF(1,ii) = -(3243414316440337*WL^6)/10633823966279326983230456482242756608 + (2309603620420301*WL^5)/2596148429267413814265248164610048 - (4965101537564181*WL^4)/5070602400912917605986812821504 + (579661006787533*WL^3)/1237940039285380274899124224 - (272890451144983*WL^2)/4835703278458516698824704 - (3949141763188333*WL)/151115727451828646838272 + 4030589618284611/590295810358705651712;
%Spectra.F1CF(1,ii) = - (1626700260090919*WL^6)/1329227995784915872903807060280344576 + (634948170428757*WL^5)/162259276829213363391578010288128 - (815199951640841*WL^4)/158456325028528675187087900672 + (4402000169273163*WL^3)/1237940039285380274899124224 - (6582553675103433*WL^2)/4835703278458516698824704 + (2581296679043863*WL)/9444732965739290427392 - 1656625345829241/73786976294838206464;
Spectra.F1CF(1,ii) = - (6308936983919491*WL^6)/340282366920938463463374607431768211456 + (3024227450130393*WL^5)/41538374868278621028243970633760768 - (4658155776337057*WL^4)/40564819207303340847894502572032 + (29134831418587*WL^3)/309485009821345068724781056 - (3292259569256441*WL^2)/77371252455336267181195264 + (1524120561927007*WL)/151115727451828646838272 - 2310488757253001/2361183241434822606848;
Spectra.Intensity1(jj,ii)=(((Spectra.F1CF(1,ii)*(Spectra.SelfBGSub1(jj,ii))*100^2*4*pi/PolTrans/0.816)/(Spectra.ExposureTime)))*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
%Spectra.F2CF(1,ii) = -(2395703957625853*WL^6)/10633823966279326983230456482242756608 + (1625869995473377*WL^5)/2596148429267413814265248164610048 - (6317357511792973*WL^4)/10141204801825835211973625643008 + (8577283721094079*WL^3)/39614081257132168796771975168 + (3175833775833093*WL^2)/77371252455336267181195264 - (6887963036818475*WL)/151115727451828646838272 + 4937937996623129/590295810358705651712;
%Spectra.F2CF(1,ii) = - (3023945156908499*WL^6)/2658455991569831745807614120560689152 + (2357778374029259*WL^5)/649037107316853453566312041152512 - (1512169445406641*WL^4)/316912650057057350374175801344 + (1020099380095967*WL^3)/309485009821345068724781056 - (3050167543427729*WL^2)/2417851639229258349412352 + (4785371494504773*WL)/18889465931478580854784 - 6146557317718281/295147905179352825856;
Spectra.F2CF(1,ii) = - (3218994720546037*WL^6)/42535295865117307932921825928971026432 + (5235105452134931*WL^5)/20769187434139310514121985316880384 - (3530981884010797*WL^4)/10141204801825835211973625643008 + (5059892675007901*WL^3)/19807040628566084398385987584 - (2031104944870275*WL^2)/19342813113834066795298816 + (1731743414777697*WL)/75557863725914323419136 - 4891400421602593/2361183241434822606848;
Spectra.Intensity2(jj,ii)=(((Spectra.F2CF(1,ii)*(Spectra.SelfBGSub2(jj,ii))*100^2*4*pi/PolTrans/0.816)/(Spectra.ExposureTime)))*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
%Spectra.F3CF(1,ii) = -(8006662218097889*WL^6)/21267647932558653966460912964485513216 + (93141810256361*WL^5)/81129638414606681695789005144064 - (3448877051813151*WL^4)/2535301200456458802993406410752 + (7538698440583817*WL^3)/9903520314283042199192993792 - (217389890528869*WL^2)/1208925819614629174706176 + (1741527951873869*WL)/2417851639229258349412352 + 1326004963232429/295147905179352825856;
%Spectra.F3CF(1,ii) = - (1765656053182801*WL^6)/1329227995784915872903807060280344576 + (5518894603634123*WL^5)/1298074214633706907132624082305024 - (443587723375963*WL^4)/79228162514264337593543950336 + (4802604591038225*WL^3)/1237940039285380274899124224 - (1801707046935033*WL^2)/1208925819614629174706176 + (88736857234489*WL)/295147905179352825856 - 1833956193745033/73786976294838206464;
Spectra.F3CF(1,ii) = - (2088251208937885*WL^6)/21267647932558653966460912964485513216 + (6620698810601923*WL^5)/20769187434139310514121985316880384 - (2177678135120253*WL^4)/5070602400912917605986812821504 + (3045834615508699*WL^3)/9903520314283042199192993792 - (4778133644256543*WL^2)/38685626227668133590597632 + (3985826836592293*WL)/151115727451828646838272 - 5518043243643893/2361183241434822606848;
Spectra.Intensity3(jj,ii)=(((Spectra.F3CF(1,ii)*(Spectra.SelfBGSub3(jj,ii))*100^2*4*pi/PolTrans/0.816)/(Spectra.ExposureTime)))*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
%Spectra.F4CF(1,ii) = -(8789350527914021*WL^6)/42535295865117307932921825928971026432 + (5905492503948825*WL^5)/10384593717069655257060992658440192 - (2783491648979549*WL^4)/5070602400912917605986812821504 + (204987856063123*WL^3)/1237940039285380274899124224 + (4720037523702579*WL^2)/77371252455336267181195264 - (7531592530322833*WL)/151115727451828646838272 + 1292104971979181/147573952589676412928;
%Spectra.F4CF(1,ii) = - (6831167903460459*WL^6)/5316911983139663491615228241121378304 + (2661610492119359*WL^5)/649037107316853453566312041152512 - (6827733130064633*WL^4)/1267650600228229401496703205376 + (4608390215663531*WL^3)/1237940039285380274899124224 - (6898105029406207*WL^2)/4835703278458516698824704 + (84721503390903*WL)/295147905179352825856 - 3492766303211563/147573952589676412928;
Spectra.F4CF(1,ii) = - (3220915010346721*WL^6)/42535295865117307932921825928971026432 + (5278260314045411*WL^5)/20769187434139310514121985316880384 - (7169347616763475*WL^4)/20282409603651670423947251286016 + (5169049141385233*WL^3)/19807040628566084398385987584 - (4173585398321467*WL^2)/38685626227668133590597632 + (3577125449972917*WL)/151115727451828646838272 - 1269132194609933/590295810358705651712;
Spectra.Intensity4(jj,ii)=(((Spectra.F4CF(1,ii)*(Spectra.SelfBGSub4(jj,ii))*100^2*4*pi/PolTrans/0.816)/(Spectra.ExposureTime)))*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
%Spectra.F5CF(1,ii) = -(8128602229559119*WL^6)/5316911983139663491615228241121378304 + (6770935128186101*WL^5)/1298074214633706907132624082305024 - (4612227632479779*WL^4)/633825300114114700748351602688 + (6554231572492777*WL^3)/1237940039285380274899124224 - (5094898972821211*WL^2)/2417851639229258349412352 + (8142021870704233*WL)/18889465931478580854784 - 2567853893604121/73786976294838206464;
%Spectra.F5CF(1,ii) = - (3711672098962431*WL^6)/1329227995784915872903807060280344576 + (361952161365543*WL^5)/40564819207303340847894502572032 - (7444087705847317*WL^4)/633825300114114700748351602688 + (5041086950209335*WL^3)/618970019642690137449562112 - (7580959031549187*WL^2)/2417851639229258349412352 + (2998061427153507*WL)/4722366482869645213696 - 7787992640024419/147573952589676412928;
Spectra.F5CF(1,ii) = - (6975981277116395*WL^6)/5444517870735015415413993718908291383296 - (8592458623468417*WL^5)/1329227995784915872903807060280344576 + (3449447725407881*WL^4)/162259276829213363391578010288128 - (7197672690592913*WL^3)/316912650057057350374175801344 + (7097492200999303*WL^2)/618970019642690137449562112 - (6768005508421565*WL)/2417851639229258349412352 + 2533024960140057/9444732965739290427392;
Spectra.Intensity5(jj,ii)=(((Spectra.F5CF(1,ii)*(Spectra.SelfBGSub5(jj,ii))*100^2*4*pi/PolTrans/0.816)/(Spectra.ExposureTime)))*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
%Spectra.IntensityAll=Spectra.Intenisty1

end
end
elseif Spectra.Grating ~= 300 && Spectra.Grating ~= 1800
    disp('Error in Grating Chosen')
end

clear WL

%% Plots intensity vs. wavelength

if PLOTINTENSITY==1
figure;
plot(Spectra.LambdaPlot,(Spectra.Intensity1(Spectra.FrameOfInterest,:)))
hold on
plot(Spectra.LambdaPlot,(Spectra.Intensity2(Spectra.FrameOfInterest,:)))
plot(Spectra.LambdaPlot,(Spectra.Intensity3(Spectra.FrameOfInterest,:)))
plot(Spectra.LambdaPlot,(Spectra.Intensity4(Spectra.FrameOfInterest,:)))
plot(Spectra.LambdaPlot,(Spectra.Intensity5(Spectra.FrameOfInterest,:)))
ax = gca;
ax.FontSize = 15;
title('Intensity vs wavelength [nm]','FontSize',15);
xlabel('Wavelength [nm]','FontSize',15);
ylabel('Intensity [Photons/m^2/s]','FontSize',15);
set(gcf,'color','w')
%xlim([Spectra.LambdaMin Spectra.LambdaMax])
ylim([0 inf]);
hold off
end

%% Uses ipeaks to find the peaks in the intensity plot
if USEIPEAKSFORINTENSITYPEAKS==1

x=Spectra.LambdaPlot;
y=(Spectra.Intensity3); %USER changes to which fiber is observed. 
SlopeThreshold=0.0001;
smoothwidth=1.5;
peakgroup=10;
smoothtype=10;
AmpThreshold=50; %USER changes this if want to see more or less peaks depending on spectrum
IntensityPeak=findpeaksL(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype)
if IntensityPeak(1,2)==0
    disp('Error in AmpThreshold for Intensity')
end

PeakD=(0.3/18);
AmpT=1E13;
SlopeT=0.001;
SmoothW=13;
FitW=6;
%[Ipeaks]=ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW);

  %%  
  x=Spectra.LambdaPlot;
for jj=1:Spectra.Length(1,3)

y=Spectra.Intensity1(jj,:);       
DataMatrix=[x;y];   
[Ipeaks]=ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW);

Areas(1,jj)=max(Ipeaks(:,5));

end
end
%% Gaussian Fitting, finds the FWHM of the peaks

if FINDFWHM==1

Gaussian.FWHMarray=zeros(Spectra.Length(1,1),1,Spectra.Length(1,3));
Gaussian.Residuals=zeros(Spectra.Length(1,1),1,Spectra.Length(1,3));
Gaussian.GaussCenter=zeros(Spectra.Length(1,1),1,Spectra.Length(1,3));

DATA.X=(Spectra.LambdaPlot);

for aa=1:Spectra.Length(1,3) %All 512 pixels
for bb=3:3 %Fiber location(s)

DATA.I=flip(double((Spectra.RawDATA(bb,:,aa))));

%Calls ElijahsGaussianFit to find FWHM and center wavelength
try
[Gaussian.FWHMcurrent,Gaussian.residuals,Gaussian.Center] = ElijahGaussianFit(DATA,Spectra.Lambda0, Spectra.LambdaPlot);
if Gaussian.FWHMcurrent{1} >= 6
    Gaussian.FWHMcurrent{1}=0;
end

Gaussian.FWHMarray(bb,1,aa)=Gaussian.FWHMcurrent{1}; % Angstroms
format longg
Gaussian.Residuals(bb,1,aa)=mean(Gaussian.residuals);
Gaussian.GaussCenter(bb,1,aa)=Gaussian.Center; % Angstroms
Gaussian.FWHMcurrent{1}=0;
end
end
end
end

%% Finds the Flow velocity of the plasma, FINDFWHM needs to be 1 also

if FINDFLOW==1
v_c=299790458; %m/s

theta=10; %In degrees'
CenterOfInterest=4806; %(Spectra.McPherLoc/15); %[Angstroms]

    Gaussian.DeltaLambda(:,:,:)=Gaussian.GaussCenter(:,:,:)-CenterOfInterest;
    velocity=(Gaussian.DeltaLambda/CenterOfInterest)*v_c; %m/s
    V_flow=velocity*sind(theta); %uses angle of puck as theta, do in excel
  
end

%% Calculates the ion temperature from Ar II spectra centered around 480.6 nm

if FINDIONTEMP == 1
    
    Spectra.RawDATA=double(Spectra.RawDATA);
    
    CHIarray = zeros(Spectra.Length(1,1)-Spectra.Length(1,3));
    KTNarray = zeros(Spectra.Length(1,1)-Spectra.Length(1,3));
    
    DATA.X = flip(Spectra.LambdaPlot); %DATA structure is passed to fitting code
NumGauss = 1;
INSFUN = [0.2559 0.2521 0.2516 0.2568 0.2658]; %Pin-Lamp instrument function input
[coil1,coil2] = Spool_Finder(Fibers); % line-by-line comments for this section detailed in IonTempSingleFrame
spool=(coil1+coil2)/2; %Finds distance to desired spool 
[zvec, bt] = directions_field_mappingV4(B_Field); % Gets the magnetic field map
zvec = single(zvec);
bt = single(bt); 
BIN = zeros(1,5); % Initialize magnetic field input values

%%
for aa=1:5 % specify fiber(s)
    aa
    if Fibers(:,aa)==0
    else
     [f,idx]= min(abs(zvec(1,:)-spool(:,aa)));
     BIN(1,aa)=bt(1,idx); %Magnetic field at Fiber location
% Adjust BIN designations depending upon magnetic geometry.
    %BIN = [0.4742 0.8703 0.8585 0.4648 0.1317];
    
for bb = 20:60 %specify frame(s)
    
DATA.I = Spectra.RawDATA(aa,:,bb);

%Calls FIT_EXAMPLE to find ion tempeartures and their reduced chi values

[KTN, CHI] = FIT_EXAMPLE_V3(DATA,BIN(1,aa),INSFUN(:,aa),NumGauss); %USER must use correct values within this code

if KTN >= 75 || KTN <= 1E-5
    KTN = 0;
    CHI = 0;
end
KTNarray(bb,1,aa) = KTN; %[eV]
CHIarray(bb,1,aa) = CHI; %Reduced Chi values (Goodness of Fit), above 1 is a bad fit
end
end
end
end

%% For testing a single frame for Ti

if IONTEMPSINGLEFRAME==1

NumGauss=1;
INSFUN = [0.2559 0.2521 0.2516 0.2568 0.2658]; %Pin-Lamp instrument function input
[coil1,coil2] = Spool_Finder(Fibers); % find local coils @ fiber
spool=(coil1+coil2)/2; % convert coils to center of spool
[zvec, bt] = directions_field_mappingV4(B_Field); %grab magnetic flux within machine vs. axial distance
zvec = single(zvec);
bt = single(bt);

%%
ii=3; %Fiber #
for kk=20:20 %Frame being analyzed
    
if Fibers(:,ii)==0
else 
    [f,idx]= min(abs(zvec(1,:)-spool(:,ii)));
    BIN=bt(1,idx); %Adjust BIN designations depending upon magnetic geometry.
    
for jj = 1:1 %# of fits on same data set
    if ii==1
DATA.I = Spectra.RawFiber1(kk,:);
    elseif ii==2
DATA.I = Spectra.RawFiber2(kk,:);
    elseif ii==3
DATA.I = Spectra.RawFiber3(kk,:);
    elseif ii==4
DATA.I = Spectra.RawFiber4(kk,:); 
    elseif ii==5
DATA.I = Spectra.RawFiber5(kk,:);
    end
DATA.X = (Spectra.LambdaPlot);
[KTNarray(jj,kk), CHIarray(jj,kk)] = FIT_EXAMPLE_V3(DATA,BIN,INSFUN(:,ii),NumGauss); %Calls Elijah's code to do the ion temp fitting, USER must edit this code to work with backround location, and peak of interest location
end
end
end
end

%% Calculates powerloss from spectra and/or calculates the plasma volume within the machine

if POWERLOSS==1
    
    VOLUMECALC=1;
end

if VOLUMECALC==1 % Calculates the volume of the plasma near fiber optic
    
[coil1, coil2] = Spool_Finder(Fibers);
h=zeros(1,5); %set up for radii of machine at fiber location

for ii=1:5
    if Fibers(:,ii) == Fiber1_5North | Fiber1_5Top | Fiber2_5North | Fiber2_5Top | Fiber4_5Bottom | Fiber5_5North
        h(:,ii) = 15.2/200; % [h = .5 diameter & converstion from [cm] to [m]
    elseif Fibers(:,ii) == Fiber6_5North || Fiber6_5South
        h(:,ii) = 41/200;
    elseif Fibers(:,ii) == Fiber7_5North | Fiber9_5South | Fiber9_5North | Fiber10_5South | Fiber11_5North
        h(:,ii) = 49/200;
    end
end

L=h*tand(1); %0.5 range of acceptance cone for fiber optic along z-axis
[r,s,ContourValues] = test_calc_flux_mpex_V3(coil1,coil2, B_Field,Fibers,L); %r=radii values for plasma calculations, s=radii values for cone calculations
Area = pi*r.^2;
Area2 = pi*s.^2;
VolumePlasma=zeros(1,5);
VolumeCone=zeros(1,5);

for ii=1:5
    VolumePlasma(:,ii) = sum((Area(:,ii)*(coil2(:,ii)-coil1(:,ii))/nnz(Area(:,ii)))); 
    VolumeCone(:,ii) = sum(Area2(:,ii)*(2*L(:,ii))/nnz(Area2(:,ii)));
end 

Volume = zeros(1,5);
VRatio = zeros(1,5);

for ii=1:5
    if VolumePlasma(:,ii) >= VolumeCone(:,ii)
    Volume(:,ii) = VolumeCone(:,ii);
    elseif VolumePlasma(:,ii) < VolumeCone(:,ii)
    Volume(:,ii) = VolumePlasma(:,ii);
    end
end

if POWERLOSS==1
else
fprintf('Volume = %i\n', Volume);
end
end

%% Plots the powerloss/volume
if POWERLOSS==1   

%Calculates the amount of power lost by using fiber as opposed to looking
%at entire plasma. In cases where the fiber can encompass the whole plasma
%between nearest two coils, the loss is said to be zero. Note that if a
%fiber is not in use for this experiment, the loss should also be zero, so
%use caution when interpreting zero as a return.
Spectra.Loss1=(Spectra.Intensity1/h(:,5))*Volume(:,5);
Spectra.Loss2=(Spectra.Intensity2/h(:,4))*Volume(:,4);
Spectra.Loss3=(Spectra.Intensity3/h(:,3))*Volume(:,3);
Spectra.Loss4=(Spectra.Intensity4/h(:,2))*Volume(:,2);
Spectra.Loss5=(Spectra.Intensity5/h(:,1))*Volume(:,1);

%VRatio must be written in reverse order as shown, as Fibers array lists
%fibers in physical fiber order from 1 to 5, while Intensity is calculated
%in the standard way.

figure;
plot(Spectra.Lambda,(Spectra.Loss1))
hold on
plot(Spectra.Lambda,(Spectra.Loss2))
plot(Spectra.Lambda,(Spectra.Loss3))
plot(Spectra.Lambda,(Spectra.Loss4))
plot(Spectra.Lambda,(Spectra.Loss5))
ax = gca;
ax.FontSize = 15;
title('Power Loss vs wavelength [nm]','FontSize',15);
xlabel('Wavelength [nm]','FontSize',15);
ylabel('Power [mW]','FontSize',15);
xlim([Spectra.LambdaMin Spectra.LambdaMax])
ylim([0 inf]);
set(gcf,'color','w')
hold off
end

%% Testing purposes
% % printthis(1,:)=Spectra.LambdaPlot(:);
% % printthis(2,:)=Spectra.Intensity5(9,:);
% % printthis(3,:)=Spectra.Intensity4(9,:);
% % printthis(4,:)=Spectra.Intensity3(9,:);
% % printthis(5,:)=Spectra.Intensity2(9,:);
% % printthis(6,:)=Spectra.Intensity1(9,:);
% % printthis(7,:)=Spectra.Intensity5(13,:);
% % printthis(8,:)=Spectra.Intensity4(13,:);
% % printthis(9,:)=Spectra.Intensity3(13,:);
% % printthis(10,:)=Spectra.Intensity2(13,:);
% % printthis(11,:)=Spectra.Intensity1(13,:);
% 
% % close all
% % Data=idk-Spectra.BGSub3;
% % %plot(Spectra.LambdaPlot,Data)
% % mean(Spectra.BGSub3./idk)
% % std(Spectra.BGSub3./idk)
% 
% Data.Y=Spectra.SelfBGSub2(:,221); %47 O II, 221 N II
% Data.X=linspace(3.97,(3.97+0.01*120),120);
% Data.X=Data.X';
% 
% figure;
% scatter(Data.X,Data.Y,'k');
% ax = gca;
% ax.FontSize = 13;
% title('O II signal vs time','FontSize',13);
% xlabel('Time (s)','FontSize',13);
% ylabel('Counts','FontSize',13);
% legend('Shot 30091');
% %xlim([Spectra.LambdaMin Spectra.LambdaMax])
% ylim([0 inf]);
% xlim([4.1 4.8])
% set(gcf,'color','w')
% %Plot()
% 
% Data.Hstarty=Data.Y(24:29);
% Data.Hstartx=Data.X(24:29);
% 
% Data.Hmidy=Data.Y(29:54);
% Data.Hmidx=Data.X(29:54);
% 
% Data.Ey=Data.Y(57:61);
% Data.Ex=Data.X(57:61);
% 
% Data.Hendy=Data.Y(62:67);
% Data.Hendx=Data.X(62:67);
% 
% Data.Hallx=Data.X([29:55 62:67]);
% Data.Hally=Data.Y([29:55 62:67]);
% 
% Data.p1=polyfit(Data.Hstartx,Data.Hstarty,1);
% Data.f1=polyval(Data.p1,Data.Hstartx);
% Data.p1(1)
% 
% Data.p2=polyfit(Data.Hmidx,Data.Hmidy,1);
% Data.f2=polyval(Data.p2,Data.Hmidx);
% Data.p2(1)
% 
% Data.p3=polyfit(Data.Ex,Data.Ey,1);
% Data.f3=polyval(Data.p3,Data.Ex);
% Data.p3(1)
% 
% Data.p4=polyfit(Data.Hendx,Data.Hendy,1);
% Data.f4=polyval(Data.p4,Data.Hendx);
% Data.p4(1)
% 
% Data.f5=polyval(Data.p2,Data.Hallx);
% 
% Data.E2H=Data.f5(28)-Data.Hendy(1);
% Data.E2H(1)
% 
% % figure;
% % scatter(Data.X,Data.Y,'k');
% % hold on
% % plot(Data.Hstartx,Data.f1,'-k','LineWidth',4)
% % plot(Data.Hmidx,Data.f2,'-m','LineWidth',4)
% % plot(Data.Ex,Data.f3,'-blue','LineWidth',4)
% % plot(Data.Hendx,Data.f4,'-cyan','LineWidth',4)
% % plot(Data.Hallx,Data.f5,'--r','LineWidth',4)
% % ax = gca;
% % ax.FontSize = 13;
% % title('O II signal vs time','FontSize',13);
% % xlabel('Time (s)','FontSize',13);
% % ylabel('Counts','FontSize',13);
% % legend('Shot 30091');
% % %xlim([Spectra.LambdaMin Spectra.LambdaMax])
% % ylim([0 inf]);
% % xlim([4.1 4.8])
% % set(gcf,'color','w')
% % %Plot()
% % hold off
% 
% 
% 
% 
% %Data.Hslope=(Data.Y(54)-Data.Y(29))/(Data.X(54)-Data.X(29));
% %Data.Eslope=(Data.Y(61)-Data.Y(58))/(Data.X(61)-Data.X(58));
% 
% Data.ShotNumber=[30077
% 30078
% 30079
% 30080
% 30081
% 30082
% 30083
% 30084
% 30086
% 30088
% 30089
% 30090
% 30091];
% 
% % Data.Hvalues=[214.2
% % -58
% % -97.183
% % 82.639
% % -59.5
% % 417.16
% % 337.83
% % 116.36
% % 208.91
% % 110.41
% % 58.839
% % -314.03
% % 96.52
% % 48.26
% % -273.7
% % 40.328
% % -271.06
% % -360.31
% % 380.8
% % -379.48];
% % 
% % Data.Evalues=[-886.99
% % 93.657
% % 121.2
% % -572.96
% % -490.32
% % 5498.2
% % 2071.5
% % -10897
% % -27309
% % -26086
% % -43027
% % -53726
% % -50454
% % -1526
% % -18203
% % 391.16
% % -22070
% % -22726
% % -34543
% % -29133];
% 
% % Data.dxdy=gradient(Data.X)./gradient(Data.Y);
% % 
% % figure
% % plot(Data.ShotNumber,Data.Hvalues,'k');
% % hold on
% % plot(Data.ShotNumber,Data.Evalues,'m')
% % ax = gca;
% % ax.FontSize = 13;
% % title('O II rate of change slope','FontSize',13);
% % xlabel('Shot number','FontSize',13);
% % ylabel('Rate of change','FontSize',13);
% % legend('Helicon only','With ECH');
% % ylim([-inf inf]);
% % %xlim([4.1 4.8])
% % set(gcf,'color','w')
% % Plot()

