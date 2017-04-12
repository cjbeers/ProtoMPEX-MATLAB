%YOU MUST HAVE ATLAS SDK FROM FLIR DOWNLOADED TO USE THIS PROGRAM

%Coded by: Josh Beers
%ORNL
%Code uses a single .seq file that is USER defined from the Thermal IR 
%FLIR camera to produce two movies, one for the temperature and one for 
%delta Temp as the time of the shot progresses
%The code also calculates Q (MW/m2) for the target area and hot spots 
 
 
%% Start Code
clear all
close all
clc

tic
%##### Load image #####
%[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.jpg;*.seq', 'Choose IR file (jpg) or radiometric sequence (seq)');
Shots=12411; %USER defines the shot number, if not found change the PATHNAME to the correct day/file location
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

%Creates array of tick marks to be used in colorbar
        colorticks=1.2E4:1E2:1.7E4;
        colorsize=size(colorticks);
        
          j=1;
        for o=1.2E4:1E2:1.7E4
           colorlabels(1,j) = seq.ThermalImage.GetValueFromSignal(o);
           j=j+1;
        end
             
%show image
%figure(1)
%imshow(im,[])
figure(2)
    %seq.ThermalImage.TemperatureUnit = Flir.Atlas.Image.TemperatureUnit.Celsius; 
    h = animatedline;
    %setup plot (Matlab2014b or later)
    max=seq.ThermalImage.GetValueFromSignal(seq.ThermalImage.MaxSignalValue);
    
    %[a,b]=ind2sub(size(seq.ThermalImage.MaxSingalValue),find(seq.ThermalImage.MaxSignalValue==max));
    
    min=seq.ThermalImage.GetValueFromSignal(seq.ThermalImage.MinSignalValue);
    axis([0 (double(seq.Count)/double(seq.FrameRate)) (min-2) (max+2)])
    xline = linspace(0,(double(seq.Count)/double(seq.FrameRate)),seq.Count);
    title('Temp at position 286,364') 
    ylabel('Degree C')
    xlabel('Time [s]')
    i=1;
    %Temperature=zeros(480,640,Counts);    
    images=zeros(480,640,Counts);
    %F=zeros(250,1);
    tic
if(seq.Count > 1)
    while(seq.Next())
        img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
        im = double(img);
        images(:,:,i)=(im);
                
        %F(i) = im2frame(image(:,:,i));
        
        
        %get the temperature for a position 
        temp = seq.ThermalImage.GetValueFromSignal(im(286,364));
         
        Temperature(:,:,i)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.33,images),images(120:325,275:475,i));
        DeltaTMatrix(:,:,i)=Temperature(:,:,i)-Temperature(:,:,1);
        %{
        %40sec per j and k loop
        if i==120
            for j=1:480
                for k=1:640
        
        %temperature(j,k,i) = seq.ThermalImage.GetValueFromSignal(images(j,k));
        %Delta_T=
                end
            end
        elseif i>=252
            disp('Error, too many frames, adjust number')
        end
        %} 
        
        %plot temp vs time(Sec) 
        addpoints(h,xline(seq.SelectedIndex),temp);

        %Not sure,but plots B/W image of IR camera
        %{
        figure(1)
        [X, cmap]=gray2ind(im);
        imshow(im,[]);
        set (gcf, 'WindowButtonMotionFcn', @mouseMove);
        %}
        
        
        %Creates figure to be used in movie
        fig=figure(3);
        imagesc(Temperature(:,:,i), 'CDataMapping','scaled')
        caxis([0, 150])
        colormap jet
        c=colorbar;
        ylabel(c, 'Temperature [C]')
        %colorbar('Ticks',colorticks, 'TickLabels',colorlabels)
        
        ax.FontSize = 13;
        title(['Temperature of Shot ', num2str(Shots)],'FontSize',13);
        xlabel('Pixels','FontSize',13);
        ylabel('Pixels','FontSize',13);
        F(i)=getframe(fig);
        %set (gcf, 'WindowButtonMotionFcn', @mouseMove);
       
        
        DeltaT=figure(4);
        imagesc(DeltaTMatrix(:,:,i), 'CDataMapping','scaled')
        %caxis([0, 5])
        colormap jet
        c=colorbar;
        ylabel(c, 'Delta T [C]')
        %colorbar('Ticks',colorticks, 'TickLabels',colorlabels)
        
        ax.FontSize = 13;
        title(['Delta T of Shot ', num2str(Shots)],'FontSize',13);
        xlabel('Pixels','FontSize',13);
        ylabel('Pixels','FontSize',13);
        G(i)=getframe(DeltaT);
        %set (gcf, 'WindowButtonMotionFcn', @mouseMove);
        
        drawnow;
        i=i+1;
    end
end
timeloop=(toc)/60

%% Creates movie from figures

%figure(5) %Temperature 
%movie(gcf, F,2,10)

v=VideoWriter(['Shot ',num2str(Shots),'_Temperature.avi']);
open(v);
writeVideo(v, F);
close(v);

%figure(6) %Delta T
%movie(gcf, G,2,10)
v1=VideoWriter(['Shot ', num2str(Shots) ,'_DeltaT.avi']);
open(v1);
writeVideo(v1, G);
close(v1);

%set (gcf, 'WindowButtonMotionFcn', @mouseMove);

%% Gets Maximum value and index as Maximum and MaxIndex from Max3d code
%also creates the deltaT matrix with first image as background

[Maximum, MaxIndex]=Max3d(images);
max = seq.ThermalImage.GetValueFromSignal(Maximum);
%USER can change min "images(Max,Max,1)" to whatever their starting frame needs to be
min=seq.ThermalImage.GetValueFromSignal((images(MaxIndex(1,1),MaxIndex(1,2),1)));


%Creates largest deltaT frame
%DeltaTMatrix=Temperature(:,:, MaxIndex(1,3))-Temperature(:,:,1);


%% Heat Flux Measurement
%Caclulates the heat flux of a single pixel for now 

Cp=500; %J/kg*C
PixelArea=(((1.375/sqrt(2))*(2.54/100))^2)/80; % inches/pixel to area of pixel (m2)
Density=7600; %kg/m3
thickness= 1.0625*(2.54/100); %inches to m
Delta_T=(max-min); %C
Delta_t=(1/100)*(MaxIndex(1,3)-1); %100Hz to seconds times the difference in frame numbers for T

Q=arrayfun(@(DeltaTMatrix) (((Cp*DeltaTMatrix*thickness*Density)/Delta_t)/1E6), DeltaTMatrix(:,:,MaxIndex(1,3)));
%Q=(((Cp*DeltaTMatrix*thickness*Density)/Delta_t)/1E6); %Cp*DeltaT*mass = MW/m2
QMax=(((Cp*Delta_T*thickness*Density)/Delta_t)/1E6); %Cp*DeltaT*mass = MW/m2

%% View Single Frame
%{
%View B/W image
figure()
imshow(images(:,:,65),[])
set (gcf, 'WindowButtonMotionFcn', @mouseMove);
%

%View Single Color Image with Colorbar
figure()
imagesc(images(:,:,1), 'CDataMapping','scaled')
caxis([23.8578,26.7185])
colormap jet
c=colorbar('Ticks',colorticks, 'TickLabels',colorlabels);
ylabel(c, 'Delta T [C]')
ax.FontSize = 13;
title('Temperature vs. Camera Pixels','FontSize',13);
xlabel('Pixels','FontSize',13);
ylabel('Pixels','FontSize',13);
set (gcf, 'WindowButtonMotionFcn', @mouseMove);
%}

timeall=(toc)/60

