clear all
close all
clc
% Read in interested raw data file and background file
%Match raw with background, example, _1820_ matched to _1820_bg

Raw_data = readSPE('\\tshome\~\Desktop\2016_05_11\D2_1820_20um_20.SPE');...
    %USER Specifiy Location
length = size(Raw_data);
Raw_data_bg = readSPE('\\tshome\~\Desktop\cal_2016_05_12\absolute_1820_20um_bg_1.SPE');...
    %USER Specify Location

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

for i = 1:length(:,3); %filling in the empty matrix above with the raw data
  Fiber1(i,:) = double(Raw_data(1,:,i));
  Fiber2(i,:) = double(Raw_data(2,:,i));
  Fiber3(i,:) = double(Raw_data(3,:,i));
  Fiber4(i,:) = double(Raw_data(4,:,i));
  Fiber5(i,:) = double(Raw_data(5,:,i));
end

for i = 1:length(:,3); %filling in the empty matrix above with the bg data
  Fiber1bg(i,:) = double(Raw_data_bg(1,:));
  Fiber2bg(i,:) = double(Raw_data_bg(2,:));
  Fiber3bg(i,:) = double(Raw_data_bg(3,:));
  Fiber4bg(i,:) = double(Raw_data_bg(4,:));
  Fiber5bg(i,:) = double(Raw_data_bg(5,:));
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


% Ocean Optics HL-2000-CAL calibration data from Ocean Optics
% calibration:  12/13/2010
% bare optical fiber
% luminace at calibration:  
%STILL WORK IN PROGRESS
%{
lamp_wav = [300.,310.,320.,330.,340.,350.,360.,370.,380.,390.,400.,...
    420.,440.,460.,480.,500.,525.,550.,575.,600.,650.,700.,750.,800.,...
    850.,900.,950.,1000.,1050.]';
%spectral radiance in (mW/cm2-microm)  Note:  NOT (mW/cm2-sr-microm)
lamp_rad=[1.133E-3,2.9943E-3,1.5788E-3,2.2974E-3,3.3536E-3,3.3032E-3,...
    3.6701E-3,4.7932E-3,5.9676E-3,8.4063E-3,1.0012E-2,1.6006E-2,...
    2.4115E-2,3.4534E-2,4.828E-2,6.5426E-2,9.2719E-2,1.2801E-1,...
    1.7096E-1,2.2219E-1,3.4197E-1,4.8906E-1,7.09E-1,9.4987E-1,1.2389E0,...
    1.5841E0,1.975E0,2.5359E0,3.0529E0]';
calib_size = size(lamp_rad);
scatter(lamp_wav,lamp_rad);
%}

pixel = (1:1:512)'; %# of pixels in the file 1- 512
%Since the corrected data is displaying the intensity over time you need 
%to pick a good time to view the data. 27 is a solid choice!!!
figure; %Plot corrected signal vs. pixels
plot(pixel,cor_f1(27,:));
hold on;
plot(pixel,cor_f2(27,:));
plot(pixel,cor_f3(27,:));
plot(pixel,cor_f4(27,:));
plot(pixel,cor_f5(27,:));
ax = gca;
ax.FontSize = 20;
title('Counts vs Pixel','FontSize',20);
xlabel('Pixel','FontSize',20);
ylabel('Counts','FontSize',20);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvP_706.png')
hold off;

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
ax.FontSize = 20;
title('Counts vs Pixel','FontSize',20);
xlabel('Pixel','FontSize',20);
ylabel('Counts','FontSize',20);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvP_706.png')
hold off;
%}

%Find POI for this Particular FILE determine its pixel location,
%remember that 204 is center for the 300mm grating which is mostly
%likely where your POI is located +/- 10 pixels.

%dispersion using file 14 distance between H beta and He I nm/pixel
%DO NOT CHANGE THIS VALUE
Disper = ((487-492)/(314-196)); 


P_o = 210; %USER put peaklocation here!!! peak location can change it is not the same each time
lambda_o = 728.1; %USER put wavelength here, what you tunned the Mcpherson to in nanometers!!!

pixels_c(1:P_o,:) = (P_o-1:-1:0)'; %From 1 to Peak of Interest 
pixels_c(P_o+1:length(1,2),:) = (1:1:(length(1,2)-P_o))'; %From Peak of Interest to 512
pix_c_dis = pixels_c*Disper; %The entire file times the dispersion coeff.
lambda(1:P_o,:) = lambda_o - pix_c_dis(1:P_o,:); %Conversion of pixel to wavelength
lambda(P_o+1:length(1,2),:) = lambda_o + pix_c_dis(P_o+1:length(1,2),:); %Conversion of pixel to wavelength

%Since the corrected data is displaying the intensity over time you need 
%to pick a good time to view the data. 27 is a solid choice!!!
figure; %Plot corrected signal vs. wavelength
plot(lambda,cor_f1(27,:));
hold on;
plot(lambda,cor_f2(27,:));
plot(lambda,cor_f3(27,:));
plot(lambda,cor_f4(27,:));
plot(lambda,cor_f5(27,:));
ax = gca;
ax.FontSize = 20;
title('Counts vs wavelength (nm)','FontSize',20);
xlabel('Wavelength (nm)','FontSize',20);
ylabel('Counts','FontSize',20);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvW_706.png')
hold off;

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
ax.FontSize = 20;
title('Counts vs wavelength (nm)','FontSize',20);
xlabel('Wavelength (nm)','FontSize',20);
ylabel('Counts','FontSize',20);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvW_706.png')
hold off;
%}

time = transpose([10:10:500]);% 1 - 50 now is 10 to 500 by 10s

% Peak of interest in all of time
POI_f1 = cor_f1(:,P_o);
POI_f2 = cor_f2(:,P_o);
POI_f3 = cor_f3(:,P_o);
POI_f4 = cor_f4(:,P_o);
POI_f5 = cor_f5(:,P_o);

figure;
plot(time,POI_f1);
hold on;
plot(time,POI_f2);
plot(time,POI_f3);
plot(time,POI_f4);
plot(time,POI_f5);
%legend([Fiber1,Fiber2,Fiber3,Fiber4,Fiber5],'Fiber 1','Fiber 2','Fiber 3','Fiber 4','Fiber 5');
ax = gca;
ax.FontSize = 20;
title('Counts vs Time','FontSize',20);
xlabel('Time (ms)','FontSize',20);
ylabel('Counts','FontSize',20);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvT_706.png')
hold off;

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
