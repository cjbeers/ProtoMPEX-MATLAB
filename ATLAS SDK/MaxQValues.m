%YOU MUST HAVE ATLAS SDK FROM FLIR DOWNLOADED TO USE THIS PROGRAM

%Coded by: Josh Beers
%ORNL

%Creates a single image of the largrest delta T in the USER defined shot

%% Start Code

tic
%##### Load image #####
%[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.jpg;*.seq', 'Choose IR file (jpg) or radiometric sequence (seq)');

Shots=10036; %USER defines shot number, if not found change the PATHNAME to the correct day/file location

FILENAME = ['shot ' ,num2str(Shots),'.seq'];
PATHNAME = 'Z:\IR_Camera\2016_08_19\';
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

Temperature(:,:,1)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.33,images),images(200:315,335:495,1));
Temperature(:,:,2)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.33,images),images(200:315,335:495,45));

Cp=500; %J/kg*C
PixelLength=(((1.375/sqrt(2))*(2.54/100)))/(80); % inches/pixel to length of pixel (m),
PixelArea=(PixelLength)^2;  %(m^2)
Density=8030; %kg/m3
thickness= (1/16)*(2.54/100); %inches to m
Delta_T=(max-min); %C
%Delta_t=(1/100)*(MaxIndex(1,3)-1); %100Hz to seconds times the difference in frame numbers for T
Delta_t=.15; %Helicon Pulse Time, accounts for the delay of the heat flux through the target

DeltaTMatrix=Temperature(:,:,2)-Temperature(:,:,1); 

Qarray=arrayfun(@(DeltaTMatrix) (((Cp*DeltaTMatrix*thickness*Density)/Delta_t)/1E6), DeltaTMatrix(:,:,:));
QROI=mean2(Qarray(35:35,80:81)); 
QMax=(((Cp*Delta_T*thickness*Density)/Delta_t)/1E6); %Cp*DeltaT*mass = MW/m2

%% Plot of Delta T

%View Single Color Image with Colorbar
Plot= figure();
imagesc(DeltaTMatrix, 'CDataMapping','scaled')
%caxis([0 1.5])
colormap jet
c=colorbar;
ylabel(c, 'Delta T [C]', 'FontSize', 12);
%ax.FontSize = 13;
title(['Shot Number ', num2str(Shots)],'FontSize',13);
xlabel('Pixels -->Pit Side','FontSize',13);
ylabel('Pixels','FontSize',13);
% saveas(gcf,'/Users/g4s/Desktop/2016_05_11/CvP_706.png')
hold on
axis on


rectangle('Position', [157 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %1.75
rectangle('Position', [146 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %1.5
rectangle('Position', [135 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %1.25
rectangle('Position', [124 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %1.0
rectangle('Position', [113 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %0.75
rectangle('Position', [102 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %0.5
rectangle('Position', [91 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %0.25
rectangle('Position', [80 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %0.0
rectangle('Position', [69 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-0.25
rectangle('Position', [58 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-0.5
rectangle('Position', [47 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-0.75
rectangle('Position', [36 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-1.0
rectangle('Position', [25 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-1.25
rectangle('Position', [14 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-1.5
rectangle('Position', [3 35 3 2],'EdgeColor', 'white', 'LineWidth', 1) %-1.75

line([0 170], [36 36], 'Color', 'white', 'LineWidth', 1)

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

