%YOU MUST HAVE ATLAS SDK FROM FLIR DOWNLOADED TO USE THIS PROGRAM

%Coded by: Josh Beers
%ORNL

%Creates a single image of the largrest delta T in the USER defined shot

%% Start Code

tic
%##### Load image #####
%[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.jpg;*.seq', 'Choose IR file (jpg) or radiometric sequence (seq)');

Shots=10499; %USER defines shot number, if not found change the PATHNAME to the correct day/file location

FILENAME = ['shot ' ,num2str(Shots),'.seq'];
PATHNAME = 'Z:\IR_Camera\2016_09_22\';
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

Temperature(:,:,1)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.33, images),images(180:350,275:475,1));
Temperature(:,:,2)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.33, images),images(180:350,275:475,45));

Cp=500; %J/kg*C   %710 for Graphite
PixelLength=(((1.375/sqrt(2))*(2.54/100)))/(80); % inches/pixel to length of pixel (m),
PixelArea=(PixelLength)^2;  %(m^2)
Density=8030; %kg/m3 2230 for graphite
thickness= (1/16)*(2.54/100); %inches to m
Delta_T=(max-min); %C
%Delta_t=(1/100)*(MaxIndex(1,3)-1); %100Hz to seconds times the difference in frame numbers for T
Delta_t=.15; %Helicon Pulse Time, accounts for the delay of the heat flux through the target

DeltaTMatrix=Temperature(:,:,2)-Temperature(:,:,1); 

Qarray=arrayfun(@(DeltaTMatrix) (((Cp*DeltaTMatrix*thickness*Density)/Delta_t)/1E6), DeltaTMatrix(:,:,:));
QROI=mean2(Qarray(72:74,147:148)) 
QMax=(((Cp*Delta_T*thickness*Density)/Delta_t)/1E6); %Cp*DeltaT*mass = MW/m2

%% Plot of Delta T

%View Single Color Image with Colorbar
Plot= figure();
imagesc(Qarray, 'CDataMapping','scaled')
%caxis([0 1.5])
colormap jet
c=colorbar;
ylabel(c, 'Delta T [C]', 'FontSize', 12);
%ax.FontSize = 13;
title(['Shot Number ', num2str(Shots)],'FontSize',13);
xlabel('Pixels','FontSize',13);
ylabel('Pixels','FontSize',13);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvP_706.png')
hold on
axis on


line([0 200], [74 74], 'Color', 'white', 'LineWidth', 1)
line([111 111], [0 160], 'Color', 'white', 'LineWidth', 1)

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
rectangle('Position', [110 55 2 3],'EdgeColor', 'white', 'LineWidth', 2) %0.0
rectangle('Position', [110 46 2 3],'EdgeColor', 'white', 'LineWidth', 1) %0.25
rectangle('Position', [110 37 2 3],'EdgeColor', 'white', 'LineWidth', 1) %0.5
rectangle('Position', [110 28 2 3],'EdgeColor', 'white', 'LineWidth', 1) %0.75
rectangle('Position', [110 19 2 3],'EdgeColor', 'white', 'LineWidth', 1) %1.0
rectangle('Position', [110 10 2 3],'EdgeColor', 'white', 'LineWidth', 1) %1.25
rectangle('Position', [110 01 2 3],'EdgeColor', 'white', 'LineWidth', 1) %1.5
rectangle('Position', [110 -08 2 3],'EdgeColor', 'white', 'LineWidth', 1) %1.75
rectangle('Position', [110 -17 2 3],'EdgeColor', 'white', 'LineWidth', 1) %2.0
rectangle('Position', [110 63 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-0.25
rectangle('Position', [110 74 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-0.5
rectangle('Position', [110 85 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-0.75
rectangle('Position', [110 94 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-1.0
rectangle('Position', [110 103 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-1.25
rectangle('Position', [110 112 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-1.5
rectangle('Position', [110 121 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-1.75
rectangle('Position', [110 130 2 3],'EdgeColor', 'white', 'LineWidth', 1) %-2.0
%

hold off


timeMaxQ=toc;
%{
if toc>=60
timeall=toc/60;
formatPrint='Time all = %1.4g m.\n';
fprintf(formatPrint, timeall)
elseif toc<60
formatPrint='Time all = %1.4g s.\n';
fprintf(formatPrint, timeall)
end
%}

