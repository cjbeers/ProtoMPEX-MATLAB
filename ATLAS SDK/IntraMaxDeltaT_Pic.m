%YOU MUST HAVE ATLAS SDK FROM FLIR DOWNLOADED TO USE THIS PROGRAM

%Coded by: Josh Beers
%ORNL

%Creates an image of delta T frames for the user defined shots, from the
%same file location

%% Start Code
clear all
clc
tic

SeePlotShot=1;

%##### Load image #####
%[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.jpg;*.seq', 'Choose IR file (jpg) or radiometric sequence (seq)');
%Shots= [first shot # - second shot #, ICH - No ICH, ECH - No ECH)
Shots=[12483 12451]; %USER defines shot number, if not found change the PATHNAME to the correct day/file location

for ii=1:length(Shots)

    FILENAME = ['shot ' ,num2str(Shots(ii)),'.seq'];
    if ii==1
    PATHNAME = 'Z:\IR_Camera\2017_01_06\';
    else 
    PATHNAME = 'Z:\IR_Camera\2017_01_05\2017_01_05\';
    end
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
    DATA(ii).images=zeros(480, 640, Counts);
    i=1;

    if(seq.Count > 1)
        while(seq.Next())
            DATA(ii).img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
            im = double(DATA(ii).img);
            images(:,:,i)=(im);
            i=i+1;
        end
    end
    
DATA(ii).images=images;

%Max Delta T
[Maximum, MaxIndex]=Max3d(DATA(ii).images);
DATA(ii).MaxIndex=MaxIndex;
max = seq.ThermalImage.GetValueFromSignal(Maximum);
DATA(ii).Max=max;
   
DATA(ii).Temperature(:,:,1)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.26, images),images(120:325,275:475,1));
DATA(ii).Temperature(:,:,2)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.26, images),images(120:325,275:475,30));
DATA(ii).Temperature(:,:,3)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.26, images),images(120:325,275:475,36));

%DATA(ii).Temperature(:,:,3)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.73, images),images(175:350,250:400,ii)); %For Graphite target  

% DATA(ii).Temperature(:,:,1) = Temperature(:,:,1)';
% DATA(ii).Temperature(:,:,2) = Temperature(:,:,2)';
% DATA(ii).Temperature(:,:,3) = Temperature(:,:,3)';

DATA(ii).LargestDeltaTMatrix=DATA(ii).Temperature(:,:,3)-DATA(ii).Temperature(:,:,1); %Before ICH/ECH only
DATA(ii).HeliconDeltaTMatrix=DATA(ii).Temperature(:,:,2)-DATA(ii).Temperature(:,:,1); %Largest Delta T
DATA(ii).NoHeliconDeltaTMatrix=DATA(ii).LargestDeltaTMatrix-DATA(ii).HeliconDeltaTMatrix; %ICH/ECh - Helicon

%Finds a circular average temperature of the LargestDeltaTMatrix frame for each shot
x=70; %Center of circle's x position
y=110; %Center of circle's y position
r=5; %Radius of circle
[xgrid, ygrid] = meshgrid(1:size(DATA(ii).LargestDeltaTMatrix,2), 1:size(DATA(ii).LargestDeltaTMatrix,1)); %Creates meshgrid of circle
mask = ((xgrid-x).^2 + (ygrid-y).^2) <= r.^2; %Creates mask for overlaying on img
DATA(ii).AverageA1=mean(DATA(ii).LargestDeltaTMatrix(mask)); %finds the values in the defined circle and then the average

end

%% Intra-shot analysis
DATA(ii+1).HeliconDeltaTMatrix=DATA(ii-1).HeliconDeltaTMatrix-DATA(ii).HeliconDeltaTMatrix;
DATA(ii+1).LargestDeltaTMatrix=DATA(ii-1).LargestDeltaTMatrix-DATA(ii).LargestDeltaTMatrix;
DATA(ii+1).NoHeliconDeltaTMatrix=DATA(ii-1).HeliconDeltaTMatrix-DATA(ii).NoHeliconDeltaTMatrix;

%% Plots
if SeePlotShot==1
[jj, kk]=size(DATA(1).LargestDeltaTMatrix);
Shots(1,3)=0; %Shot 0 is for naming purposes and will be the ICH/ECH - without values for all three matries
for ii=1:(length(Shots))
   
figure()
subplot(1,3,1); hold on 
imagesc(flip(DATA(ii).LargestDeltaTMatrix), 'CDataMapping','scaled')
caxis([0 100])
colormap jet
c=colorbar;
%ylabel(c, 'Delta T [°C]', 'FontSize', 13);
ax.FontSize = 13;
title(['Shot Number ', num2str(Shots(ii)), ' Max'],'FontSize',13);
xlabel(' Direction to Pit-->>','FontSize',13);
xlim([0 kk]);
ylim([0 jj]);

subplot(1,3,2); hold on
imagesc(flip(DATA(ii).HeliconDeltaTMatrix), 'CDataMapping','scaled')
caxis([0 100])
colormap jet
c=colorbar;
%ylabel(c, 'Delta T [°C]', 'FontSize', 13);
ax.FontSize = 13;
title(['Shot Number ', num2str(Shots(ii)), ' Before ICH/ECH'],'FontSize',13);
xlabel(' Direction to Pit-->>','FontSize',13);
xlim([0 kk]);
ylim([0 jj]);

subplot(1,3,3); hold on
imagesc(flip(DATA(ii).NoHeliconDeltaTMatrix), 'CDataMapping','scaled')
caxis([0 100])
colormap jet
c=colorbar;
ylabel(c, 'Delta T [°C]', 'FontSize', 13);
ax.FontSize = 13;
title(['Shot Number ', num2str(Shots(ii)), ' Max-Before'],'FontSize',13);
xlabel(' Direction to Pit-->>','FontSize',13);
xlim([0 kk]);
ylim([0 jj]);

hold off


end
end

toc
