%YOU MUST HAVE ATLAS SDK FROM FLIR DOWNLOADED TO USE THIS PROGRAM

%Coded by: Josh Beers
%ORNL

%Creates a single image of a delta T frame in the USER defined shot

%% Start Code
%clearvars('-except', 'DeltaTMatrix1'); DeltaTMatrix11=DeltaTMatrix1;
clear all
clc
tic
%##### Load image #####
%[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.jpg;*.seq', 'Choose IR file (jpg) or radiometric sequence (seq)');
Shots=15829; %USER defines shot number, if not found change the PATHNAME to the correct day/file location
FILENAME = ['Shot ' ,num2str(Shots),'.seq'];
PATHNAME = 'Z:\IR_Camera\2017_07_20\';
FILTERINDEX = 1;

videoFileName=[PATHNAME FILENAME];

% Load the Atlats SDK
atPath = getenv('FLIR_Atlas_MATLAB');
atImage = strcat(atPath,'Flir.Atlas.Image.dll');
asmInfo = NET.addAssembly(atImage);
%open the IR-file
file = Flir.Atlas.Image.ThermalImageFile(videoFileName);
seq = file.ThermalSequencePlayer();
%Get the pixels
img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
im = double(img);
Counts=seq.ThermalImage.Count; %# of frames
images=zeros(480, 640, Counts);
i=1;

if(seq.Count > 1)
    while(seq.Next())
        img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
        im = double(img);
        images(:,:,i)=(im);
        i=i+1;
    end
end
%% Maximum and Minimum Temperatures with Q value
[Maximum, MaxIndex]=Max3d(images);
max = seq.ThermalImage.GetValueFromSignal(Maximum);
%USER can change min "images(Max,Max,1)" to whatever their starting frame needs to be
min=seq.ThermalImage.GetValueFromSignal((images(MaxIndex(1,1),MaxIndex(1,2),1)));
%
Temperature(:,:,1)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.73, images),images(175:350,250:400,17));
Temperature(:,:,2)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.73, images),images(175:350,250:400,38));
Temperature(:,:,3)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.73, images),images(175:350,250:400,43));

%{
Temperature(:,:,1)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.33, images),images(1:450,1:630,1));
Temperature(:,:,2)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.33, images),images(1:450,1:630,45));
%}
DeltaTMatrix1=Temperature(:,:,3)-Temperature(:,:,1); 
DeltaTMatrix2=Temperature(:,:,2)-Temperature(:,:,1);
DeltaTMatrix3=Temperature(:,:,3)-Temperature(:,:,2);

%% Plot of Delta T

%View Single Color Image with Colorbar
[jj, kk]=size(DeltaTMatrix1);

figure()
subplot(1,3,1); hold on 
imagesc(flip(DeltaTMatrix1), 'CDataMapping','scaled')
caxis([0 150])
colormap jet
c=colorbar;
ylabel(c, 'Delta T [°C]', 'FontSize', 13);
ax.FontSize = 13;
title(['Shot Number ', num2str(Shots), ' Add. Heat'],'FontSize',13);
xlabel(' Direction to Pit-->>','FontSize',13);
xlim([0 kk]);
ylim([0 jj]);

subplot(1,3,2); hold on
imagesc(flip(DeltaTMatrix2), 'CDataMapping','scaled')
caxis([0 150])
colormap jet
c=colorbar;
ylabel(c, 'Delta T [°C]', 'FontSize', 13);
ax.FontSize = 13;
title(['Shot Number ', num2str(Shots), ' B4 Add. Heat'],'FontSize',13);
xlabel(' Direction to Pit-->>','FontSize',13);
xlim([0 kk]);
ylim([0 jj]);

subplot(1,3,3); hold on
imagesc(flip(DeltaTMatrix3), 'CDataMapping','scaled')
caxis([0 150])
colormap jet
c=colorbar;
ylabel(c, 'Delta T [°C]', 'FontSize', 13);
ax.FontSize = 13;
title(['Shot Number ', num2str(Shots), ' Diff'],'FontSize',13);
xlabel(' Direction to Pit-->>','FontSize',13);
xlim([0 kk]);
ylim([0 jj]);

hold off

%ylabel('Pixels','FontSize',15);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvP_706.png')

%% Finds average of circles for image processing
x=70; %Center of circle's x position
y=110; %Center of circle's y position
r=5; %Radius of circle
[xgrid, ygrid] = meshgrid(1:size(DeltaTMatrix1,2), 1:size(DeltaTMatrix1,1)); %Creates meshgrid of circle
mask = ((xgrid-x).^2 + (ygrid-y).^2) <= r.^2; %Creates mask for overlaying on img
values = DeltaTMatrix1(mask); %finds the values in the defined circle
AverageE1=mean(values); %Finds average of defined circle

%{
line([0 200], [74 74], 'Color', 'white', 'LineWidth', 1)
line([86 86], [0 160], 'Color', 'white', 'LineWidth', 1)

%10.5
%
rectangle('Position', [101 73 3 2],'EdgeColor', 'white', 'LineWidth', 2) %0.0
rectangle('Position', [110 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %0.25
rectangle('Position', [119 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %0.5
rectangle('Position', [128 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %0.75
rectangle('Position', [137 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %1.0
rectangle('Position', [146 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %1.25
rectangle('Position', [155 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %1.5
rectangle('Position', [164 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %1.75
rectangle('Position', [173 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %2
rectangle('Position', [92 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-0.25
rectangle('Position', [83 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-0.50
rectangle('Position', [74 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-0.75
rectangle('Position', [65 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-1.0
rectangle('Position', [56 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-1.25
rectangle('Position', [45 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-1.50
rectangle('Position', [34 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-1.75
rectangle('Position', [23 73 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-2.0

%9.5
%
rectangle('Position', [85 55 2 3],'EdgeColor', 'white', 'LineWidth', 2) %0.0
rectangle('Position', [85 46 2 3],'EdgeColor', 'white', 'LineWidth', 1) %0.25
rectangle('Position', [85 37 2 3],'EdgeColor', 'white', 'LineWidth', 1) %0.5
rectangle('Position', [85 28 2 3],'EdgeColor', 'white', 'LineWidth', 1) %0.75
rectangle('Position', [85 19 2 3],'EdgeColor', 'white', 'LineWidth', 1) %1.0
rectangle('Position', [85 10 2 3],'EdgeColor', 'white', 'LineWidth', 1) %1.25
rectangle('Position', [85 01 2 3],'EdgeColor', 'white', 'LineWidth', 1) %1.75
rectangle('Position', [85 -08 2 3],'EdgeColor', 'white', 'LineWidth', 1) %2.0
rectangle('Position', [85 63 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-0.25
rectangle('Position', [85 74 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-0.5
rectangle('Position', [85 85 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-0.75
rectangle('Position', [85 94 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-1.0
rectangle('Position', [85 103 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-1.25
rectangle('Position', [85 112 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-1.5
rectangle('Position', [85 121 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-1.75
rectangle('Position', [85 130 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-2.0
%}

timeall=toc

