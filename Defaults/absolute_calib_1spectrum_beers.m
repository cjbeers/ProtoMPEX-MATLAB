%Coded by: Josh Beers
%ORNL
% YOU MUST HAVE THE "sort_nat.m" FILE IN YOUR DIRECTORY TO USE THIS CODE
% FROM MATLAB FILE EXCHANGE

%This code uses all Absolute calibration points taken on Proto to create an
%average correction factor for intensity curve for each McPherson fiber.
%Uses spling fitting code to find points on the HL 2000 light source to
%create intensity correction factor.

%Fits a 6th order polynomial, saves coefficients for them, and outputs them
%in F1CF-F5CF

%% Start Code
ccc
a=0; b=0; c=0; d=0; e=0; t=1; l=1; k=1; m=1; ii=1; iii=1; aa=1; tt=0; bb=1;
% Read in interested raw data file and background file
%Match raw with background, example, _1820_ matched to _1820_bg

%USER creates array with wavelengths looked at and spool pieces looked from
%(lambdanum and spoolnum)

spoolnum=struct('SpoolNumber',{'9.5S_C'});
spoolcell=struct2cell(spoolnum);
size1 = size(spoolcell);
spoolcell = reshape(spoolcell, size1(1), []);
lambdanum=[410.2,434.1,438.7,447.1,471.3,486.1,492.1,501.4,504.8,587.6,656.3,667.5,706.5]; %USER defines wavelengths
size2=size(lambdanum);
size2=size2(1,2);

file = dir('Z:\McPherson\calibration\cal_2016_08_04\*.SPE');...
    %USER Specifiy Location
file_length =70; %length(file); %Using known number of files to be read.
Data = cell(file_length,1);

%Makes the path a character so readSPE works
dirpath=char('Z:\McPherson\calibration\cal_2016_08_04\*.SPE');

%sorts(file(#).name) with sort_nat(from Mathworks exchange);
filefields = fieldnames(file);
filecell = struct2cell(file);
sz = size(filecell);
filecell = reshape(filecell, sz(1), []);   
filecell = filecell';   
filecell = sort_nat(filecell(:,1),'ascend');
%filecell = reshape(filecell', sz);
%filesorted = cell2struct(filecell, filefields, 1);

%Puts the names in order for the readSPE.m to read them
for i=1:70
    file(i).name=char(filecell(i,:));
end

%%
%Starts the loop to read in and manipulate data
for t = 5:70
    
    Data{t} = readSPE('Z:\McPherson\calibration\cal_2016_08_04\',file(t).name);
  
 Raw_data = cell2mat(Data(t,:,:)); %= readSPE('Z:\McPherson\calibration\abscal_2016_06_21\abs_calib_20um_500ms_1.SPE');...
    %USER Specifiy Location
length = size(Raw_data);
Raw_data_bg = readSPE('Z:\McPherson\calibration\cal_2016_08_04\ROIs\abs_calib_20um_1s_bg_1.SPE');...
%Raw_data_bg = zeros(5, 512);
%Raw_data_bg(:,:)=1000;
%USER Specify Location4

%{
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

%}
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

%{
%SplineFit(lamp_wav,lamp_rad); %Figure 1
figure;
ft=fittype('poly4');
ezf=fit(lamp_wav, lamp_rad, ft);
plot(ezf,lamp_wav, lamp_rad);
ax = gca;
ax.FontSize = 10;
title('Counts vs wavelength [nm]','FontSize',10);
legend('Data', 'Fitted');
xlabel('Wavelength [nm]','FontSize',10);
ylabel('Counts','FontSize',10);
grid on;
%}

pixel = (1:1:512)'; %# of pixels in the file 1- 512
pixelplot = flip(rot90(pixel));
%Since the corrected data is  the intensity over time you need 
%to pick a good time to view the data. 27 is a solid choice!!!
%{
figure ; %Plot corrected signal vs. pixels %Figure 2
plot(pixel,cor_f1(1,:));
hold on;
plot(pixel,cor_f2(1,:));
plot(pixel,cor_f3(1,:));
plot(pixel,cor_f4(1,:));
plot(pixel,cor_f5(1,:));
ax = gca;
ax.FontSize = 10;
title('Counts vs Pixel','FontSize',10);
xlabel('Pixel','FontSize',10);
ylabel('Counts','FontSize',10);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvP_706.png')
hold off;

%See line 45 to turn this plot on
%
figure; %Plot corrected signal vs. pixels %Figure 3
plot(pixelplot,cor_f1(1,:));
hold on;
plot(pixelplot,cor_f2(1,:));
plot(pixelplot,cor_f3(1,:));
plot(pixelplot,cor_f4(1,:));
plot(pixelplot,cor_f5(1,:));
ax = gca;
ax.FontSize = 10;
title('Counts vs Corrected Pixels','FontSize',10);
xlabel('Pixel','FontSize',10);
ylabel('Counts','FontSize',10);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvP_706.png')
hold off;
%}

%Find POI for this Particular FILE determine its pixel location,
%remember that 204 is center for the 300mm grating which is mostly
%likely where your POI is located +/- 10 pixels.

%dispersion using file 14 distance between H beta and He I nm/pixel
%DO NOT CHANGE THIS VALUE
%Disper = ((487-492)/(314-196)); 


P_o = 180; %USER put peaklocation here!!! peak location can change it is not the same each time
%lambda_o = 400; %USER put wavelength here, what you tunned the Mcpherson to in nanometers!!!

   if l>size2
        l=1;
   end
lambda_o=lambdanum(1,l);

pixels_c(1:P_o,:) = (P_o-1:-1:0)'; %From 1 to Peak of Interest 
pixels_c(P_o+1:length(1,2),:) = (1:1:(length(1,2)-P_o))'; %From Peak of Interest to 512


for bb=1:512
    if i>=P_o
      %Disper = -0.055; %For 300nm Grating
      Disper= -0.0055; %For 1800nm Grating
    else
      %Disper = -0.04; %For 300nm Gra
      Disper= -0.0055; %For 1800nm Grating
    end
    pix_c_dis(bb,1) = pixels_c(bb,1)*Disper; %The entire file times the dispersion coeff.    
end

lambda(1:P_o,:) = lambda_o - pix_c_dis(1:P_o,:); %Conversion of pixel to wavelength
lambda(P_o+1:length(1,2),:) = lambda_o + pix_c_dis(P_o+1:length(1,2),:); %Conversion of pixel to wavelength
lambdaplot=rot90(lambda);

%%
%For using specific set of ports and wavelengths looked at.
%Assigns value k to place values in correct Iabs place.

if k>5
    k=1;
end

if k==1
    cor=cor_f1;
elseif k==2
    cor=cor_f2;
 elseif k==3
    cor=cor_f3; 
elseif k==4
    cor=cor_f4;
elseif k==5
    cor=cor_f5;
else
    disp('Error with k value')
end

correctedtable = zeros(3,512);
correctedtable(1,:)= pixel;
correctedtable(2,:)=flip(lambdaplot);
correctedtable(3,:)=flip(cor);
%figure;
%plot(lambdaplot,cor); %Figure 4

%Calls SplineFitting.m file to produce a spline fit for the calibrated
%white light source. Only for calibration purposes. 
%SplineFitting %If using the HL calibration light
OLFitting %If using the OL integrating sphere 
k=k+1;

%%
%Since the corrected data is displaying the intensity over time you need 
%to pick a good time to view the data. 27 is a solid choice!!! 
%USER make 27 to 1 for single spectrum analyzed

%{
figure; %Plot corrected signal vs. wavelength %Figure 5
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

%
%See line 45 and 109
figure; %Plot corrected signal vs. wavelength %Figure 6
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
POI_f1 = cor_f1(:,P_o);
POI_f2 = cor_f2(:,P_o);
POI_f3 = cor_f3(:,P_o);
POI_f4 = cor_f4(:,P_o);
POI_f5 = cor_f5(:,P_o);

%{
figure; %Figure would be number 7
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

%close all
%Closes all the files opened.
fclose('all'); 
end

%%
%Plots CorrectedIabs vs. wavelength for a single fiber (Change
%"CorrectedIabs(#)
figure(1);
plot(CorrectedIabs(2,1:4608),CorrectedIabs(3,1:4608),'red');
hold on
%{
plot(CorrectedIabs(2,(4608:4608*2)),CorrectedIabs(3,(4608:4608*2)));
hold on
plot(CorrectedIabs(2,(4608*2:4608*3)),CorrectedIabs(3,(4608*2:4608*3)));
hold on
plot(CorrectedIabs(2,(4608*3:4608*4)),CorrectedIabs(3,(4608*3:4608*4)));
hold on
plot(CorrectedIabs(2,(4608*4:4608*5)),CorrectedIabs(3,(4608*4:4608*5)));
hold on
plot(CorrectedIabs(2,(4608*5:4608*6)),CorrectedIabs(3,(4608*5:4608*6)));
hold on
plot(CorrectedIabs(2,(4608*6:4608*7)),CorrectedIabs(3,(4608*6:4608*7)));
hold on
plot(CorrectedIabs(2,(4608*7:4608*8)),CorrectedIabs(3,(4608*7:4608*8)));
%}
ax = gca;
ax.FontSize = 10;
title('Intensity vs wavelength [nm]','FontSize',10);
xlabel('Wavelength [nm]','FontSize',10);
ylabel('Intensity','FontSize',10);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvW_706.png')
hold off;

%%
%Creates Intensity fits for each fiber across all port positions viewed 
for m=1:5
x=IntensityCF(2,:);
x=rot90(x);
y=IntensityCF(m+2,:);
y=rot90(y);
ft=fittype('poly6');
ezf=fit(x,y,ft);

%
figure;
plot(ezf,x,y,'black.');
hold on
gca;
%ax.FontSize = 10;
title('IntensityCF vs wavelength [nm]','FontSize',10);
xlabel('Wavelength [nm]','FontSize',10);
ylabel('IntensityCF','FontSize',10);
hold off;
%}

%{
if m<=4
    close figure 2;
end
%}
Coeffs1(m+2,:)=(coeffvalues(ezf));
end

%%

%Creates the CorrectFactor (CF) for each fiber
syms WL
%
F1CF = Coeffs1(3,1)*WL^6+Coeffs1(3,2)*WL^5+Coeffs1(3,3)*WL^4+Coeffs1(3,4)*WL^3+Coeffs1(3,5)*WL^2+Coeffs1(3,6)*WL^1+Coeffs1(3,7);
F2CF = Coeffs1(4,1)*WL^6+Coeffs1(4,2)*WL^5+Coeffs1(4,3)*WL^4+Coeffs1(4,4)*WL^3+Coeffs1(4,5)*WL^2+Coeffs1(4,6)*WL^1+Coeffs1(4,7);
F3CF = Coeffs1(5,1)*WL^6+Coeffs1(5,2)*WL^5+Coeffs1(5,3)*WL^4+Coeffs1(5,4)*WL^3+Coeffs1(5,5)*WL^2+Coeffs1(5,6)*WL^1+Coeffs1(5,7);
F4CF = Coeffs1(6,1)*WL^6+Coeffs1(6,2)*WL^5+Coeffs1(6,3)*WL^4+Coeffs1(6,4)*WL^3+Coeffs1(6,5)*WL^2+Coeffs1(6,6)*WL^1+Coeffs1(6,7);
F5CF = Coeffs1(7,1)*WL^6+Coeffs1(7,2)*WL^5+Coeffs1(7,3)*WL^4+Coeffs1(7,4)*WL^3+Coeffs1(7,5)*WL^2+Coeffs1(7,6)*WL^1+Coeffs1(7,7);
%