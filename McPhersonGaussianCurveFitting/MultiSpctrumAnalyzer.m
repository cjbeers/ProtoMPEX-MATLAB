%Coded by: Josh Beers
%ORNL

%USER MUST HAVE IPEAKS FILES DOWNLOADED IN MATLAB PATH

%Code uses a single 255kb size McPherson .SPE file to view a calibrated 
%counts vs. wavelength and intensity vs. wavelength plot with an edittable 
%peak finder that displays the peaks and their values for both graph types

%Search for "USER" to find locations that need to be changed each time the
%code is ran

%% Start Code
clear all
%clearvars('-except', 'Fiberall', 'Fiberall2', 'IDK')
format shortG; 
format compact;
tic
%Turns on=1/off=0 program sections
PLOTPIXELS=0;
PLOTWAVELENGTH=1;
FINDPEAKS=0;
FINDINTENSITYPEAKS=0;
PLOTINTENSITY=0;
FINDFWHM=0;
FINDFLOW=0; %FINDFWHM must also = 1
FINDIONTEMP=0;

% Read in interested raw data file and background file
%Match raw with background, example, _1820_ matched to _1820_bg

%prompt = 'Grating used (300 or 1800) nm? ';
%Grating = input(prompt);
Grating = 1800; %USER chooses which Grating was used

Wavelength=(7217); %USER changes to match file wavelength location on McPherson
[Raw_data,exposure] = readSPE('Z:\McPherson\2017_01_09\D2Ar_7217_30um_12620.SPE');...
    %USER Specifiy Location
length = size(Raw_data);
Raw_data_bg = readSPE('Z:\McPherson\calibration\cal_2016_08_04\ROIs\abs_calib_20um_1s_bg_1.SPE');...
    %USER Specify Location
%Raw_data_bg = zeros(5, 512);

if Grating == 300
lambda_o = (Wavelength*.4); %USER puts wavelength here, what you tunned the Mcpherson to in nanometers!
elseif Grating == 1800
%lambda_o = (Wavelength/15); %For 1800nm Grating
lambda_o=480.6; %USER adjusts if centering the McPher, meaning the peak is not the gear position on McPher
end

if Grating == 300
%P_o = 180; %USER put peaklocation here!!! peak location can change it is not the same each time
P_o = 210; %For 300nm Grating, 132 for 1800nm Grating
elseif Grating == 1800
    P_o= 261;
end

%USE ONLY IF YOU HAVE A 5 X 512 X 50 matrix!!!!!!!!!!!!!
Fiber1=zeros(length(:,3),length(:,2)); %making a matrix that is 50x512 for Fiber 1
Fiber2=zeros(length(:,3),length(:,2)); %making a matrix that is 50x512 for Fiber 2
Fiber3=zeros(length(:,3),length(:,2)); %making a matrix that is 50x512 for Fiber 3
Fiber4=zeros(length(:,3),length(:,2)); %making a matrix that is 50x512 for Fiber 4
Fiber5=zeros(length(:,3),length(:,2)); %making a matrix that is 50x512 for Fiber 5

%making a matrix equal to that of the above matrix so that I can
%subtract the background fromt the raw. In matlab matrix but be equal in 
%dimentions to subtract
Fiber1bg=zeros(length(:,3),length(:,2)); 
Fiber2bg=zeros(length(:,3),length(:,2));
Fiber3bg=zeros(length(:,3),length(:,2));
Fiber4bg=zeros(length(:,3),length(:,2));
Fiber5bg=zeros(length(:,3),length(:,2));

for i = 1:length(:,3) %filling in the empty matrix above with the raw data
  Fiber1(i,:) = double(Raw_data(1,:,i));
  Fiber2(i,:) = double(Raw_data(2,:,i));
  Fiber3(i,:) = double(Raw_data(3,:,i));
  Fiber4(i,:) = double(Raw_data(4,:,i));
  Fiber5(i,:) = double(Raw_data(5,:,i));
end

%All Info
Fiberall=zeros(length(1,3),512,5);
Fiberall(:,:,1)=Fiber1(:,:);
Fiberall(:,:,2)=Fiber2(:,:);
Fiberall(:,:,3)=Fiber3(:,:);
Fiberall(:,:,4)=Fiber4(:,:);
Fiberall(:,:,5)=Fiber5(:,:);

% %All Info
% Fiberall2=zeros(50,512,5);
% Fiberall2(:,:,1)=Fiber1(:,:);
% Fiberall2(:,:,2)=Fiber2(:,:);
% Fiberall2(:,:,3)=Fiber3(:,:);
% Fiberall2(:,:,4)=Fiber4(:,:);
% Fiberall2(:,:,5)=Fiber5(:,:);

for i = 1:length(:,3) %filling in the empty matrix above with the bg data
  Fiber1bg(1,:) = double(Raw_data_bg(1,:));
  Fiber2bg(2,:) = double(Raw_data_bg(2,:));
  Fiber3bg(3,:) = double(Raw_data_bg(3,:));
  Fiber4bg(4,:) = double(Raw_data_bg(4,:));
  Fiber5bg(5,:) = double(Raw_data_bg(5,:));
end

%All info
Fiberallbg=zeros(length(1,3),1,5);
for i =1:length(1,3)
Fiberallbg(i,1,1)=abs(mean2(Fiberall(i,1:30,1)));
Fiberallbg(i,1,2)=abs(mean2(Fiberall(i,1:30,2)));
Fiberallbg(i,1,3)=abs(mean2(Fiberall(i,1:30,3)));
Fiberallbg(i,1,4)=abs(mean2(Fiberall(i,1:30,4)));
Fiberallbg(i,1,5)=abs(mean2(Fiberall(i,1:30,5)));
end

%USE ONLY IF YOU HAVE A 5 X 512 matrix! I.E. if you set the Mcpherson frame
%to 1. In the above matrix 5 x 512 x 50 it was set to 50 hence 50...here
%there is only 1 hence there is no need for the for loop. 
%{
Fiber1 = double(Raw_data(1,:));
Fiber2 = double(Raw_data(2,:));
Fiber3 = double(Raw_data(3,:));
Fiber4 = double(Raw_data(4,:));
Fiber5 = double(Raw_data(5,:));

Fiber1bg = double(Raw_data_bg(1,:));
Fiber2bg = double(Raw_data_bg(2,:));
Fiber3bg = double(Raw_data_bg(3,:));
Fiber4bg = double(Raw_data_bg(4,:));
Fiber5bg = double(Raw_data_bg(5,:));
%}

%Corrected signal raw - background with a matrix size of 50x512
% 50 points in time: 1-50 = 10 - 500 ms
% 512 pixels: 1 - 512 pixels 
cor_f1 = Fiber1 - Fiber1bg; %[50x512]
cor_f2 = Fiber2 - Fiber2bg;
cor_f3 = Fiber3 - Fiber3bg;
cor_f4 = Fiber4 - Fiber4bg;
cor_f5 = Fiber5 - Fiber5bg;


%Background self corrected in corall, not sure what cor1-5 really is
corall=zeros(length(1,3),512,5);
corall(:,:,1)=Fiberall(:,:,1)-Fiberallbg(:,1,1);
cor1=corall(:,:,1);
corall(:,:,2)=Fiberall(:,:,2)-Fiberallbg(:,1,2);
cor2=corall(:,:,2);
corall(:,:,3)=Fiberall(:,:,3)-Fiberallbg(:,1,3);
cor3=corall(:,:,3);
corall(:,:,4)=Fiberall(:,:,4)-Fiberallbg(:,1,4);
cor4=corall(:,:,4);
corall(:,:,5)=Fiberall(:,:,5)-Fiberallbg(:,1,5);
cor5=corall(:,:,5);

% Ocean Optics HL-2000-CAL calibration data from Ocean Optics
% calibration:  12/13/2010
% bare optical fiber
% luminace at calibration:  
%STILL WORK IN PROGRESS, Done in absolute_calib_1spectrum_beers

%{
lamp_wav = [300.,310.,320.,330.,340.,350.,360.,370.,380.,390.,400.,...
    420.,440.,460.,480.,500.,525.,550.,575.,600.,650.,700.,750.,800.,...
    850.,900.,950.,1000.,1050.]';
%spectral radiance in (mW/cm2-micron)  Note:  NOT (mW/cm2-sr-micron)
lamp_rad=[1.133E-3,2.9943E-3,1.5788E-3,2.2974E-3,3.3536E-3,3.3032E-3,...
    3.6701E-3,4.7932E-3,5.9676E-3,8.4063E-3,1.0012E-2,1.6006E-2,...
    2.4115E-2,3.4534E-2,4.828E-2,6.5426E-2,9.2719E-2,1.2801E-1,...
    1.7096E-1,2.2219E-1,3.4197E-1,4.8906E-1,7.09E-1,9.4987E-1,1.2389E0,...
    1.5841E0,1.975E0,2.5359E0,3.0529E0]';
calib_size = size(lamp_rad);
scatter(lamp_wav,lamp_rad);
%}

pixel = (1:1:512)'; %# of pixels in the file 1- 512
pixelplot = rot90(pixel);

if PLOTPIXELS==1
%Since the corrected data is displaying the intensity over time you need 
%to pick a good time to view the data. 27 is a solid choice!!!
figure; %Plot corrected signal vs. pixels
plot(pixel,(cor1(8,:)));
hold on;
plot(pixel,(cor2(8,:))); 
plot(pixel,(cor3(8,:)));
plot(pixel,(cor4(8,:)));
plot(pixel,(cor5(8,:)));
ax = gca;
ax.FontSize = 13;
title('Counts vs Corrected Pixels','FontSize',13);
xlabel('Pixel','FontSize',13);
ylabel('Counts','FontSize',13);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvP_706.png')
hold off;
end
%See line 45 to turn this plot on
%{ 
figure; %Plot corrected signal vs. pixels
plot(pixel,cor_f1(1,:));
hold on;
plot(pixel,cor_f2(1,:));
plot(pixel,cor_f3(1,:));
plot(pixel,cor_f4(1,:));
plot(pixel,cor_f5(1,:));
ax = gca;
ax.FontSize = 13;
title('Counts vs Pixel','FontSize',13);
xlabel('Pixel','FontSize',13);
ylabel('Counts','FontSize',13);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvP_706.png')
hold off;
%}

%Find POI for this Particular FILE determine its pixel location,
%remember that 204 is center for the 300mm grating which is mostly
%likely where your POI is located +/- 10 pixels.

%dispersion using file 14 distance between H beta and He I nm/pixel
%DO NOT CHANGE THIS VALUE

pixels_c(1:P_o,:) = (P_o-1:-1:0)'; %From 1 to Peak of Interest 
pixels_c(P_o+1:length(1,2),:) = (1:1:(length(1,2)-P_o))'; %From Peak of Interest to 512


for i=1:512
      if Grating ==300
      Disper = -0.055; %For 300nm Grating
      elseif Grating==1800
      Disper= -(0.09354-3.8264E-6*lambda_o*10+8.7181E-11*(lambda_o*10)^2-1.0366E-14*(lambda_o*10)^3-2.5001E-18*(lambda_o*10)^4)/10; %For 1800nm Grating, this Grating has been working for everything atm
     end
    pix_c_dis(i,1) = pixels_c(i,1)*Disper; %The entire file times the dispersion coeff.
end

lambda(1:P_o,:) = lambda_o - pix_c_dis(1:P_o,:); %Conversion of pixel to wavelength
lambda(P_o+1:length(1,2),:) = lambda_o + pix_c_dis(P_o+1:length(1,2),:); %Conversion of pixel to wavelength
lambdaplot=(rot90(lambda));
xmin=lambdaplot(1,512);
xmax=lambdaplot(1,1);
PixelSize=lambdaplot(1)-lambdaplot(2); %Nm/pixel 

%Since the corrected data is displaying the intensity over time you need 
%to pick a good time to view the data. 27 is a solid choice!!!

%Attempt to use MATLAB fittings to curve fitting
%{
%GuassianPixelFit(lambdaplot,cor);
figure;
ft=fittype('gauss4');
f=fit(lambdaplot.', cor.', ft);
plot(f,lambdaplot, cor);
ax = gca;
ax.FontSize = 15;
title('Counts vs wavelength [nm]','FontSize',15);
legend('Data', 'Fitted');
xlabel('Wavelength [nm]','FontSize',15);
ylabel('Counts','FontSize',15);
grid on;
%}

%
%Uses findpeaks in MATLAB to list peaks for calculating dispersion
%[pks,locs] = findpeaks(flip(cor), lambdaplot, 'MinPeakHeight',1500,'MinPeakDistance',10);
correctedtable = zeros(7,512);
correctedtable(1,:)=pixelplot;
correctedtable(2,:)=flip(lambdaplot);
correctedtable(3,:)=flip(cor_f1(1,:));
correctedtable(4,:)=flip(cor_f2(1,:));
correctedtable(5,:)=flip(cor_f3(1,:));
correctedtable(6,:)=flip(cor_f4(1,:));
correctedtable(7,:)=flip(cor_f5(1,:));
%

%Uses the ipeaks zip folder .m files to produce the gaussian fitted peaks
%and their corresponding information
%Turn on findpeaks if wanting to interativly play with your spectrum
%fittings to optimize variables below
%ipeak(mydata)
%See
%http://terpconnect.umd.edu/~toh/spectrum/PeakFindingandMeasurement.htm#idpeaks
%to understand below variables

%% Peak finder

if FINDPEAKS==1

%For findpeaks
x=lambdaplot;
y=flip(cor1(14,:)); %USER changes to which fiber is observed. 
SlopeThreshold=0.001;
smoothwidth=9;
peakgroup=6;
smoothtype=1;
%USER inps AmpThreshold based on counts of smallest peak being looked at
AmpThreshold=1000; %USER changes this if want to see more or less peaks depending on spectrum

CountsPeak=findpeaksL(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype);
if CountsPeak(1,2)==0
    disp('Error in AmpThreshold for Counts')
end
sizeP=size(CountsPeak);

%%Prints peaks and their respective data
for i=1:512    
   for j=1:sizeP(1,1) 
        if CountsPeak(j,2) == correctedtable(2,i)
            %disp('Pixel #,Wavelength,Counts')
            Words=['Peak#= ',num2str(j), ' CorrectedPixel#=', num2str(correctedtable(1,i)), ' Wavelength=', num2str(correctedtable(2,i)), ' Counts=', num2str(correctedtable(3,i)),];
            disp(Words)
            %correctedtable(1,i),correctedtable(2,i),correctedtable(3,i)         
        end
   end 
end

%% Ipeak Plotting Tool

%For ipeak %Not used atm, but good for visualising data the first time
PeakD=(0.3/18);
AmpT=2000;
SlopeT=0.001;
SmoothW=9;
FitW=10;
DataMatrix=[x;y];
%ipeak(DataMatrix,PeakD,AmpT,SlopeT,SmoothW,FitW)
end

%%
if PLOTWAVELENGTH==1;
figure; %Plot corrected signal vs. wavelength
plot(lambdaplot,cor1(8,:));
hold on;
plot(lambdaplot,cor2(8,:));
plot(lambdaplot,cor3(8,:));
plot(lambdaplot,cor4(8,:));
plot(lambdaplot,cor5(8,:));
ax = gca;
ax.FontSize = 13;
title('Counts vs wavelength','FontSize',13);
xlabel('Wavelength [nm]','FontSize',13);
ylabel('Counts','FontSize',13);
xlim([xmin xmax])
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvW_706.png')
hold off;
end
%%
%{
%See line 45 and 109
figure; %Plot corrected signal vs. wavelength
plot(lambda,cor_f1(1,:));
hold on;
plot(lambda,cor_f2(1,:));
plot(lambda,cor_f3(1,:));
plot(lambda,cor_f4(1,:));
plot(lambda,cor_f5(1,:));
ax = gca;
ax.FontSize = 13;
title('Counts vs wavelength [nm]','FontSize',13);
xlabel('Wavelength [nm]','FontSize',13);
ylabel('Counts','FontSize',13);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvW_706.png')
hold off;
%}


time = transpose([10:10:500]);% 1 - 50 now is 10 to 500 by 10s

% Peak of interest in all of time
POI_f1 = cor1(:,P_o);
POI_f2 = cor2(:,P_o);
POI_f3 = cor3(:,P_o);
POI_f4 = cor4(:,P_o);
POI_f5 = cor5(:,P_o);

%{
figure;
plot(time,POI_f1);
hold on;
plot(time,POI_f2);
plot(time,POI_f3);
plot(time,POI_f4);
plot(time,POI_f5);
%legend([Fiber1,Fiber2,Fiber3,Fiber4,Fiber5],'Fiber 1','Fiber 2','Fiber 3','Fiber 4','Fiber 5');
ax = gca;
ax.FontSize = 13;
title('Counts vs Time','FontSize',13);
xlabel('Time (ms)','FontSize',13);
ylabel('Counts','FontSize',13);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvT_706.png')
hold off;
%}
%to write to excel the cor_f# must be transposed 
%USER DEFINED TO TURN ON
%{
f1 = cor_f1';
f2 = cor_f2';
f3 = cor_f3';
f4 = cor_f4';
f5 = cor_f5';

sheet = 10;
xlRange_t = 'A1:A50';
xlRange_wav = 'B1:B512';
xlRange_f2 = 'C1';
t = time;
wav = lambda;
f2_c = f2;
filename = '\\tshome\~\My Documents\MATLAB\Beast_analysis\Holly_data.xls';
xlswrite(filename,t,sheet,xlRange_t);
xlswrite(filename,wav,sheet,xlRange_wav);
xlswrite(filename,f2_c,sheet,xlRange_f2);
%}


%% Intensity calculations
%WL remakes CF for each wavelength looked at with single files
%Intensity in (mW/cm2-micron) converted now to (mW/m2) for HL source
%Intenisty in (mW/cm2-sr-nm) converted now to (mW/m2-sr) for OL source

%For 300nm Grating:

if Grating ==300
for i=1:512
WL=lambdaplot(1,i);
F1CF(1,i) =(1101630822525047*WL^6)/649037107316853453566312041152512 - (7265777621430527*WL^5)/1267650600228229401496703205376 + (4967798444037317*WL^4)/618970019642690137449562112 - (7213530429423309*WL^3)/1208925819614629174706176 + (5868229780194579*WL^2)/2361183241434822606848 - (5074883106023453*WL)/9223372036854775808 + 7297156861788209/144115188075855872;
Intensity1(1,i)=((F1CF(1,i)*flip(cor1(8,i)))/(exposure*1000))*100^2;
F2CF(1,i) =(2626695280632411*WL^6)/1298074214633706907132624082305024 - (1076220889837839*WL^5)/158456325028528675187087900672 + (5845266505055671*WL^4)/618970019642690137449562112 - (8418572225483743*WL^3)/1208925819614629174706176 + (3392225726576867*WL^2)/1180591620717411303424 - (5804480930144169*WL)/9223372036854775808 + 4122263530836521/72057594037927936;
Intensity2(1,i)=((F2CF(1,i)*flip(cor2(8,i)))/(exposure*1000))*100^2;
F3CF(1,i) =(6685689374474273*WL^6)/5192296858534827628530496329220096 - (5538637756507167*WL^5)/1267650600228229401496703205376 + (3809644293763157*WL^4)/618970019642690137449562112 - (2786038952453225*WL^3)/604462909807314587353088 + (4572309193917549*WL^2)/2361183241434822606848 - (3994730768181719*WL)/9223372036854775808 + 5813337095729975/144115188075855872;
Intensity3(1,i)=((F3CF(1,i)*flip(cor3(8,i)))/(exposure*1000))*100^2;
F4CF(1,i) =(7302221534579973*WL^6)/5192296858534827628530496329220096 - (1512047247641153*WL^5)/316912650057057350374175801344 + (519560686567997*WL^4)/77371252455336267181195264 - (6069351690507449*WL^3)/1208925819614629174706176 + (4967682192603545*WL^2)/2361183241434822606848 - (4324620186983531*WL)/9223372036854775808 + 6262978433970463/144115188075855872;
Intensity4(1,i)=((F4CF(1,i)*flip(cor4(8,i)))/(exposure*1000))*100^2;
F5CF(1,i) =-(3056574429229055*WL^6)/2596148429267413814265248164610048 + (5619162961737097*WL^5)/1267650600228229401496703205376 - (4231508340035941*WL^4)/618970019642690137449562112 + (3345429297905545*WL^3)/604462909807314587353088 - (5859150790520435*WL^2)/2361183241434822606848 + (5387567721134835*WL)/9223372036854775808 - 8114035101143863/144115188075855872;
Intensity5(1,i)=((F5CF(1,i)*flip(cor5(8,i)))/(exposure*1000))*100^2;
end

%For 1800nm Grating:

elseif Grating ==1800
for i=1:512
WL=lambdaplot(1,i);
F1CF(1,i) = (8639858633378925*WL^6)/162259276829213363391578010288128 - (6752534369187517*WL^5)/39614081257132168796771975168 + (4371564017049417*WL^4)/19342813113834066795298816 - (1500140754751339*WL^3)/9444732965739290427392 + (1151024590460689*WL^2)/18446744073709551616 - (1872109269432241*WL)/144115188075855872 + 5042492432869085/4503599627370496;
Intensity1(1,i)=((F1CF(1,i)*flip(cor1(8,i)))/(exposure*1000))*100^2;
F2CF(1,i) =(633581297858053*WL^6)/5070602400912917605986812821504 - (8121773701465285*WL^5)/19807040628566084398385987584 + (2690009207465985*WL^4)/4835703278458516698824704 - (7542774615408457*WL^3)/18889465931478580854784 + (2950856088803465*WL^2)/18446744073709551616 - (4887277633992995*WL)/144115188075855872 + 6693695750256497/2251799813685248;
Intensity2(1,i)=((F2CF(1,i)*flip(cor2(8,i)))/(exposure*1000))*100^2;
F3CF(1,i) =(4558147662457993*WL^6)/40564819207303340847894502572032 - (911820085030147*WL^5)/2475880078570760549798248448 + (2413104084810979*WL^4)/4835703278458516698824704 - (6758446563225483*WL^3)/18889465931478580854784 + (5282100525926083*WL^2)/36893488147419103232 - (2184730141835485*WL)/72057594037927936 + 5978301140921691/2251799813685248;
Intensity3(1,i)=((F3CF(1,i)*flip(cor3(8,i)))/(exposure*1000))*100^2;
F4CF(1,i) =(2612623629397875*WL^6)/20282409603651670423947251286016 - (8357945244197111*WL^5)/19807040628566084398385987584 + (172707543343351*WL^4)/302231454903657293676544 - (1933629052041071*WL^3)/4722366482869645213696 + (6040887448379897*WL^2)/36893488147419103232 - (1248386249030235*WL)/36028797018963968 + 6826993165843605/2251799813685248;
Intensity4(1,i)=((F4CF(1,i)*flip(cor4(8,i)))/(exposure*1000))*100^2;
F5CF(1,i) =(1217788750296653*WL^6)/10141204801825835211973625643008 - (7799579479577659*WL^5)/19807040628566084398385987584 + (1290709320930039*WL^4)/2417851639229258349412352 - (7233120040344691*WL^3)/18889465931478580854784 + (5655494708893753*WL^2)/36893488147419103232 - (4680239615105187*WL)/144115188075855872 + 6406011523163739/2251799813685248;
Intensity5(1,i)=((F5CF(1,i)*flip(cor5(8,i)))/(exposure*1000))*100^2;

%Maybe correct for using OL int. sphere for calibration
% F1CF(1,i)= (2574019400893163*WL^6)/302231454903657293676544 - (8065884769740901*WL^5)/295147905179352825856 + (2615384638177899*WL^4)/72057594037927936 - (1796849034329127*WL^3)/70368744177664 + (689594750815965*WL^2)/68719476736 - (8970909117573177*WL)/4294967296 + 3018700201735603/16777216;
% Intensity1(1,i)=((F1CF(1,i)*flip(cor1(28,i)))/(exposure))*100^2;
% F2CF(1,i)= (5793896183970007*WL^6)/302231454903657293676544 - (2322879650495715*WL^5)/36893488147419103232 + (3079993499407015*WL^4)/36028797018963968 - (8643477582115677*WL^3)/140737488355328 + (6768261891891069*WL^2)/274877906944 - (2804310721909621*WL)/536870912 + 60044847477719/131072;
% Intensity2(1,i)=((F2CF(1,i)*flip(cor2(28,i)))/(exposure))*100^2;
% F3CF(1,i)= (660965826377489*WL^6)/37778931862957161709568 - (4233616231200667*WL^5)/73786976294838206464 + (5605205486392329*WL^4)/72057594037927936 - (3926680386097807*WL^3)/70368744177664 + (3070205254966653*WL^2)/137438953472 - (5080745252086111*WL)/1073741824 + 6951979018152201/16777216;
% Intensity3(1,i)=((F3CF(1,i)*flip(cor3(28,i)))/(exposure))*100^2;
% F4CF(1,i)= (3217656166585595*WL^6)/151115727451828646838272 - (2573206284210685*WL^5)/36893488147419103232 + (1701212900599479*WL^4)/18014398509481984 - (4760290722684847*WL^3)/70368744177664 + (929071247650733*WL^2)/34359738368 - (3069992891408685*WL)/536870912 + 4193645439086859/8388608;
% Intensity4(1,i)=((F4CF(1,i)*flip(cor4(28,i)))/(exposure))*100^2;
% F5CF(1,i)= (2715712480621643*WL^6)/151115727451828646838272 - (8699984946295305*WL^5)/147573952589676412928 + (5761027664240151*WL^4)/72057594037927936 - (8074210725199599*WL^3)/140737488355328 + (789400346709175*WL^2)/34359738368 - (81676078035541*WL)/16777216 + 7155271215450411/16777216;
% Intensity5(1,i)=((F5CF(1,i)*flip(cor5(28,i)))/(exposure))*100^2;

end
elseif Grating ~= 300 && Grating ~= 1800
    disp('Error in Grating Chosen')
end

IntensityTable(1,:)=Intensity1;
IntensityTable(2,:)=Intensity2;
IntensityTable(3,:)=Intensity3;
IntensityTable(4,:)=Intensity4;
IntensityTable(5,:)=Intensity5;

if PLOTINTENSITY==1
figure;
plot(lambdaplot,(Intensity1))
hold on
plot(lambdaplot,(Intensity2))
plot(lambdaplot,(Intensity3))
plot(lambdaplot,(Intensity4))
plot(lambdaplot,(Intensity5))
ax = gca;
ax.FontSize = 15;
title('Intensity vs wavelength [nm]','FontSize',15);
xlabel('Wavelength [nm]','FontSize',15);
ylabel('Intensity [mW/m^2]','FontSize',15);
xlim([xmin xmax])
hold off
end

if FINDINTENSITYPEAKS==1

x=lambdaplot;
y=(Intensity3); %USER changes to which fiber is observed. 
SlopeThreshold=0.0001;
smoothwidth=1.5;
peakgroup=10;
smoothtype=10;
AmpThreshold=50; %USER changes this if want to see more or less peaks depending on spectrum
IntensityPeak=findpeaksL(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype)
if IntensityPeak(1,2)==0
    disp('Error in AmpThreshold for Intensity')
end

end
%% Guassian Fitting

if FINDFWHM==1
sizeFiberall=size(Fiberall);
FWHMarray=zeros(sizeFiberall(1,1),1,sizeFiberall(1,3));
Residuals=zeros(sizeFiberall(1,1),1,sizeFiberall(1,3));
GuassCenter=zeros(sizeFiberall(1,1),1,sizeFiberall(1,3));

DATA.X=flip(lambdaplot);

for aa=1:sizeFiberall(1,3)
for bb=1:sizeFiberall(1,1)

DATA.I=Fiberall(bb,:,aa);

%Calls ElijahsGuassianFit to find FWHM and center wavelength
try
[FWHMcurrent,residuals,Center] = ElijahGaussianFit(DATA,lambda_o, lambdaplot);
if FWHMcurrent{1} >= 6
    FWHMcurrent{1}=0;
    CenterOfInterest=4806; %[Angstroms]
    Center=CenterOfInterest;
end
end
FWHMarray(bb,1,aa)=FWHMcurrent{1}; % Angstroms
format longg
Residuals(bb,1,aa)=mean(residuals);
GuassCenter(bb,1,aa)=Center; % Angstroms
end
end

end

%% Finds the Flow velocity of the plasma

if FINDFLOW==1
v_c=299790458; %m/s

theta=10; %In degrees

    deltalambda(:,:,:)=GuassCenter(:,:,:)-CenterOfInterest;
    velocity=(deltalambda/CenterOfInterest)*v_c; %m/s
    %V_flow=velocity*sind(theta); %uses angle of puck as theta, do in excel
  
end

%% Calculates the ion temperature from Ar II spectra centered around 480.6 nm

if FINDIONTEMP==1
    sizeFiberall=size(Fiberall);
    KTNarray=zeros(sizeFiberall(1,1),1,sizeFiberall(1,3));
    CHIarray=zeros(sizeFiberall(1,1),1,sizeFiberall(1,3));
    
    DATA.X=flip(lambdaplot);

for aa=1:5 %Fibers to view
    %for aa=1
        BIN=0.874;
for bb=8:8 %Frames to view

DATA.I=Fiberall(bb,:,aa);

%Calls FIT_EXAMPLE to find ion tempeartures and their reduced chi values
%(not chi squared values?)

[KTN, CHI] = FIT_EXAMPLE(DATA,BIN);

if KTN >= 30 || KTN <=1E-5
    KTN = 0;
    CHI = 0;
end

KTNarray(bb,1,aa)=KTN; % [eV]
CHIarray(bb,1,aa)=CHI; 
end
end

end
%% For testing a single frame for Ti


for ii=1:1
%
%ii=1;
DATA.I=Fiber4(8,:);
DATA.X=flip(lambdaplot);
BIN=0.874;

[MYDATA.KTN(ii), MYDATA.CHI(ii)] = FIT_EXAMPLE(DATA,BIN);
%
end

%%
toc
