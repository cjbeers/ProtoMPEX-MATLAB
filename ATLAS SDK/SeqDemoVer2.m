%YOU MUST HAVE ATLAS SDK FROM FLIR DOWNLOADED TO USE THIS PROGRAM

%Written by Josh Beers
%ORNL/UTK

cleanup
%##### Load image #####
%[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.jpg;*.seq', 'Choose IR file (jpg) or radiometric sequence (seq)');
FILENAME = 'Shot 15010.seq';
PATHNAME = 'Z:\IR_Camera\2017_06_15\';
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
        colorticks=1.2E5:1E2:3E5;
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
    axis([0 (double(seq.Count)/double(seq.FrameRate)) (min-2) (max+50)])
    xline = linspace(0,(double(seq.Count)/double(seq.FrameRate)),seq.Count);
    title('Temp at position 240,320') 
    ylabel('Degree C')
    xlabel('Time (s)')
    i=1;
    temperature=zeros(480,640,Counts);    
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
        temp = seq.ThermalImage.GetValueFromSignal(im(240,320));
               
        %
        %40sec per j and k loop
        if i==120
            for j=1:480
                for k=1:640
        
        temperature(j,k,i) = seq.ThermalImage.GetValueFromSignal(images(j,k));
        %Delta_T=
                end
            end
        elseif i>=275
            disp('Error, too many frames, adjust number')
        end
               
        %plot temp vs time(Sec) 
        addpoints(h,xline(seq.SelectedIndex),temp);

        %Not sure,but plots B/W image of IR camera
        figure(1)
        [X, cmap]=gray2ind(im);
        imshow(im,[]);
        %set (gcf, 'WindowButtonMotionFcn', @mouseMove);
                        
        %Creates figure to be used in movie
        fig=figure(3);
        imagesc(im, 'CDataMapping','scaled')
        caxis([10400,30000])
        colormap jet
        colorbar('Ticks',colorticks, 'TickLabels',colorlabels)
        
        %('Ticks',[1.2E4,1.25E4,1.33E4,1.34E4,1.35E4,1.36E4,1.37E4,1.38E4,1.39E4,1.6E4,1.7E4],'TickLabels',{'12.6568','16.2645','21.7823','22.4519','23.1174','23.7787','24.4360','25.0893','25.7387', '38.5815','44.2440'})
        %caxis([1.33E4 1.6E4]);
        
        ax.FontSize = 20;
        title('Temperature vs. Camera Pixels','FontSize',20);
        xlabel('Pixels','FontSize',20);
        ylabel('Pixels','FontSize',20);
        F(i)=getframe(fig);
        %set (gcf, 'WindowButtonMotionFcn', @mouseMove);
        
        drawnow;
        i=i+1;
    end
end
toc

%Creates movie from figures
figure(4)
movie(gcf, F,2,10)
%set (gcf, 'WindowButtonMotionFcn', @mouseMove);

% for j=1:20
%     [X,map] = frame2im(F(j));
%     figure(2);clf;
%     image(X);
%     pause; 
% end
%% Gets Maximum value and index as Maximum and MaxIndex

[Maximum, MaxIndex]=Max3d(images);
max = seq.ThermalImage.GetValueFromSignal(Maximum);
min = seq.ThermalImage.GetValueFromSignal((images(MaxIndex(1,1),MaxIndex(1,2),20)));

%% Heat Flux Measurement
%Caclulates the heat flux of a single frame 

Cp=500; %J/g*K
PixelArea=(((1.375/sqrt(2))/(80))*2.54)^2; %cm2
Density=7.6; %g/cm3
thickness= 1.0625*2.54; %inches to cm
Delta_T=(((max-min)*459.67)*(5/9)); 
Delta_t=0.02; %second

Q=(Cp*Delta_T*thickness*Density)/Delta_t; %Cp*DeltaT*mass = J
%% View Single Frame

%{
%View B/W image
figure()
imshow(images(:,:,MaxIndex(1,3)),[])
set (gcf, 'WindowButtonMotionFcn', @mouseMove);
%}

%View Single Color Image with Colorbar
figure()
imagesc(images(:,:,20), 'CDataMapping','scaled')
colormap jet
colorbar('Ticks',colorticks, 'TickLabels',colorlabels)
%caxis([0 200])
ax.FontSize = 20;
title('Temperature vs. Camera Pixels','FontSize',20);
xlabel('Pixels','FontSize',20);
ylabel('Pixels','FontSize',20);
set (gcf, 'WindowButtonMotionFcn', @mouseMove);
%