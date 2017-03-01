%YOU MUST HAVE ATLAS SDK FROM FLIR DOWNLOADED TO USE THIS PROGRAM

%Coded by: Josh Beers
%ORNL

%Creates a single image of the largrest delta T frame in the USER defined shot

%% Start Code
ccc
tic
%##### Load image #####
%[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.jpg;*.seq', 'Choose IR file (jpg) or radiometric sequence (seq)');

Shots=12412; %USER defines shot number, if not found change the PATHNAME to the correct day/file location
FILENAME = ['shot ' ,num2str(Shots),'.seq'];
PATHNAME = 'Z:\IR_Camera\2017_01_05\2017_01_05\';
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
Counts=seq.ThermalImage.Count;
images=zeros(480, 640, 200);
i=1;

%tic
if(seq.Count > 1)
    while(seq.Next())
        img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
        im = double(img);
        images(:,:,i)=(im);
        
        i=i+1;
    end
end
%timeloop=toc/60

%% Maximum and Minimum Temperatures with Q value
[Maximum, MaxIndex]=Max3d(images);
max = seq.ThermalImage.GetValueFromSignal(Maximum);
%USER can change min "images(Max,Max,1)" to whatever their starting frame needs to be
min=seq.ThermalImage.GetValueFromSignal((images(MaxIndex(1,1),MaxIndex(1,2),1)));
%
Temperature(:,:,1)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.33, images),images(160:300,335:450,1));
Temperature(:,:,2)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.33, images),images(160:300,335:450,45));
%{
Temperature(:,:,1)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.33, images),images(1:450,1:630,1));
Temperature(:,:,2)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.33, images),images(1:450,1:630,45));
%}
DeltaTMatrix=Temperature(:,:,2)-Temperature(:,:,1); 

%% Plot of Delta T

%View Single Color Image with Colorbar
figure()
imagesc(DeltaTMatrix, 'CDataMapping','scaled')
%caxis([0 18])
colormap jet
c=colorbar;
ylabel(c, 'Delta T [C]', 'FontSize', 13);
ax.FontSize = 13;
title(['Shot Number ', num2str(Shots)],'FontSize',13);
xlabel(' Direction to Pit-->>','FontSize',13);
%ylabel('Pixels','FontSize',15);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvP_706.png')

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
%

timeall=toc

