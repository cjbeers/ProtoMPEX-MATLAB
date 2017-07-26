%YOU MUST HAVE ATLAS SDK FROM FLIR DOWNLOADED TO USE THIS PROGRAM

%Coded by: Josh Beers
%ORNL

%Creates a single image of a delta T frame in the USER defined shot

%
%clearvars('-except', 'DeltaTMatrix1'); DeltaTMatrix11=DeltaTMatrix1;

cleanup
tic

%0=no movie, 1=movie
MAKEAbUnitsMovie=0; %Fully zoomed out movie with raw signal
MAKETemperatureMovie=0; %Zoomed in movie with tempeartures
MAKEDeltaTMovie=1; %Zoomed in movie with delta T to a set frame
SAVEDeltaTMovie = 0; %Saves Delta T movie to email out if need it

%% % Start Code

%Loads IR .seq file
%[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.jpg;*.seq', 'Choose IR file (jpg) or radiometric sequence (seq)');
Shots=15832; %USER defines shot number, if not found change the PATHNAME to the correct day/file location
IR.ColarBarMax = 75;
IR.FrameStart=1;
IR.FrameEnd=60;
IR.FILENAME = ['Shot ' ,num2str(Shots),'.seq'];
IR.PATHNAME = 'Z:\IR_Camera\2017_07_20\';
FILTERINDEX = 1;

IR.videoFileName=[IR.PATHNAME IR.FILENAME];

% Load the Atlats SDK
FLIR.atPath = getenv('FLIR_Atlas_MATLAB');
FLIR.atImage = strcat(FLIR.atPath,'Flir.Atlas.Image.dll');
FLIR.asmInfo = NET.addAssembly(FLIR.atImage);
%open the IR-file
file = Flir.Atlas.Image.ThermalImageFile(IR.videoFileName);
seq = file.ThermalSequencePlayer();
%Get the pixels
IR.img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
IR.im = double(IR.img);
IR.Counts=seq.ThermalImage.Count; %# of frames
IR.images=zeros(480, 640, IR.Counts);

%Puts all frames into images
i=1;
if(seq.Count > 1)
    while(seq.Next())
        IR.img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
        IR.im = double(IR.img);
        images(:,:,i)=(IR.im);
        i=i+1;
    end
end

%Creates array of tick marks to be used in colorbar
        IR.colorticks=1.2E5:1E2:3E5;
        IR.colorsize=size(IR.colorticks);
        
          jj=1;
        for o=10400:1000:30000
           IR.colorlabels(1,jj) = seq.ThermalImage.GetValueFromSignal(o);
           jj=jj+1;
        end

%% Ab. Units Movie (For fast visuals)

if MAKEAbUnitsMovie==1
    
    for ii=IR.FrameStart:IR.FrameEnd
        IR.fig=figure(1);
        imagesc(images(:,:,ii), 'CDataMapping','scaled')
        caxis([10400 50000]);
        colormap jet;
        colorbar('Ticks',IR.colorticks, 'TickLabels',IR.colorlabels);
        c=colorbar;
        ylabel(c, 'Ab. Units', 'FontSize', 13);
        ax.FontSize = 13;
        title(['Shot Number ', num2str(Shots), ' Ab. Units Movie'],'FontSize',13);
        xlabel('Pixels','FontSize',13);
        ylabel('Pixels','FontSize',13);
        IR.Frames(ii)=getframe(IR.fig);
        
    end
    close figure 1
    IR.Movie1=implay(IR.Frames,10); %Creates Movie at 10 fps
    
end

%% IR Temperature Movie

if MAKETemperatureMovie==1
 
    for ii=IR.FrameStart:IR.FrameEnd
        
        IR.Temperature(:,:,ii)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.73, images),images(175:350,250:400,ii));
    end
        
    for ii=IR.FrameStart:IR.FrameEnd
        
        IR.fig2=figure(2);
        imagesc(IR.Temperature(:,:,ii), 'CDataMapping','scaled')
        caxis([0 IR.ColarBarMax])
        colormap jet
        c=colorbar;
        ylabel(c, 'T [°C]', 'FontSize', 13);
        ax.FontSize = 13;
        title(['Shot Number ', num2str(Shots), ' Temperature Movie'],'FontSize',13);
        xlabel('Pixels','FontSize',13);
        ylabel('Pixels','FontSize',13);
        IR.TemperatureFrames(ii)=getframe(IR.fig2);
        
    end
    close figure 2
    IR.Movie2=implay(IR.TemperatureFrames(IR.FrameStart:IR.FrameEnd),10); %Creates Movie at 10 fps

end

%% IR Delta T Movie

if MAKEDeltaTMovie==1

if MAKETemperatureMovie==0   
    
    for ii=IR.FrameStart:IR.FrameEnd
        
    IR.Temperature(:,:,ii)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.73, images),images(175:350,250:400,ii));
       
    end
end

    for ii= IR.FrameStart : IR.FrameEnd
        
    IR.DeltaT(:,:,(ii)) = IR.Temperature(:,:,ii)-IR.Temperature(:,:,IR.FrameStart);
    
    end
 
    for ii=IR.FrameStart:IR.FrameEnd
       
        IR.fig3=figure(3);
        imagesc(IR.DeltaT(:,:,ii), 'CDataMapping','scaled')
        caxis([0 IR.ColarBarMax])
        colormap jet
        c=colorbar;
        ylabel(c, 'Delta T [°C]', 'FontSize', 13);
        ax.FontSize = 13;
        title(['Shot Number ', num2str(Shots), ' Delta T Movie'],'FontSize',13);
        xlabel('Pixels','FontSize',13);
        ylabel('Pixels','FontSize',13);
        IR.DeltaTFrames(ii)=getframe(IR.fig3);
        
    end
    close figure 3
    IR.Movie3=implay(IR.DeltaTFrames(IR.FrameStart:IR.FrameEnd),10); %Creates Movie at 10 fps

if SAVEDeltaTMovie == 1
v=VideoWriter(['Shot ', num2str(Shots), ' Delta T Movie'],'Motion JPEG AVI');
v.FrameRate = 10;
open(v);
writeVideo(v,IR.DeltaTFrames);
close(v);
end

end
toc/60
