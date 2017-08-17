%YOU MUST HAVE ATLAS SDK FROM FLIR DOWNLOADED TO USE THIS PROGRAM

%Coded by: Josh Beers
%ORNL/UTK

%Creates up to three IR movies and plays them back in a movie player. If
%move is good can save the DeltaT IR movie. Delta T from subtracting first
%frame. 

%% What functions to do?

cleanup
tic

%0=no, 1=yes
MAKEAbUnitsMovie=0; %Fully zoomed out movie with raw signal
MAKETemperatureMovie=0; %Zoomed in movie with tempeartures
MAKEDeltaTMovie=1; %Zoomed in movie with delta T to a set frame
SAVEDeltaTMovie = 0; %Saves Delta T movie to email out if need it

%% Initialize variables 

%Loads IR .seq file
%[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.jpg;*.seq', 'Choose IR file (jpg) or radiometric sequence (seq)');
Shots=15943; %USER defines shot number, if not found change the PATHNAME to the correct day/file location
IR.ColarBarMax = 50;
IR.FrameStart=1;
IR.FrameEnd=60;
IR.Emissivity = 0.73; %0.26 for SS 0.73 for graphite

%% Code Start
IR.FILENAME = ['Shot ' ,num2str(Shots),'.seq'];
IR.PATHNAME = 'Z:\IR_Camera\2017_08_02\';
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
        imagesc(flip(images(:,:,ii)), 'CDataMapping','scaled')
        caxis([10400 30000]); %0-100 C
        colormap jet;
        colorbar('Ticks',IR.colorticks, 'TickLabels',IR.colorlabels);
        c=colorbar;
        ylabel(c, 'Ab. Units', 'FontSize', 12);
        ax.FontSize = 12;
        title(['Shot Number ', num2str(Shots), ' Ab. Units Movie'],'FontSize',12);
        xlabel('Pixels','FontSize',12);
        ylabel('Pixels','FontSize',12);
        IR.Frames(ii)=getframe(IR.fig);
        
    end
    close figure 1
    IR.Movie1=implay(IR.Frames,10); %Creates Movie at 10 fps
    
end

%% IR Temperature Movie

if MAKETemperatureMovie==1
 
    for ii=IR.FrameStart:IR.FrameEnd
        
        IR.Temperature(:,:,ii)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(IR.Emissivity, images),images(170:320,180:300,ii));
    end
        
    for ii=IR.FrameStart:IR.FrameEnd
        
        IR.fig2=figure(2);
        imagesc(fliplr(IR.Temperature(:,:,ii)), 'CDataMapping','scaled')
        caxis([0 IR.ColarBarMax])
        colormap jet
        c=colorbar;
        ylabel(c, 'T [�C]', 'FontSize', 12);
        ax.FontSize = 12;
        title(['Shot Number ', num2str(Shots), ' Temperature Movie'],'FontSize',12);
        xlabel('Pixels','FontSize',12);
        ylabel('Pixels','FontSize',12);
        IR.TemperatureFrames(ii)=getframe(IR.fig2);
        
    end
    close figure 2
    IR.Movie2=implay(IR.TemperatureFrames(IR.FrameStart:IR.FrameEnd),10); %Creates Movie at 10 fps

end

%% IR Delta T Movie

if MAKEDeltaTMovie==1

if MAKETemperatureMovie==0   
    
    for ii=IR.FrameStart:IR.FrameEnd
        
    IR.Temperature(:,:,ii)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(IR.Emissivity, images),images(170:320,180:300,ii));
       
    end
end

    for ii= IR.FrameStart : IR.FrameEnd
        
    IR.DeltaT(:,:,(ii)) = IR.Temperature(:,:,ii)-IR.Temperature(:,:,IR.FrameStart);
    
    end
 
%% Redoes IR DeltaT movie

    for ii=IR.FrameStart:IR.FrameEnd
       
        IR.fig3=figure(3);
        imagesc(fliplr(IR.DeltaT(:,:,ii)), 'CDataMapping','scaled')
        caxis([0 IR.ColarBarMax])
        colormap jet
        c=colorbar;
        ylabel(c, 'Delta T [�C]', 'FontSize', 12);
        ax.FontSize = 12;
        title(['Shot Number ', num2str(Shots), ' Delta T Movie'],'FontSize',12);
        xlabel('Pixels','FontSize',12);
        ylabel('Pixels','FontSize',12);
        IR.DeltaTFrames(ii)=getframe((IR.fig3));
        
    end
    close figure 3
    IR.Movie3=implay(IR.DeltaTFrames(IR.FrameStart:IR.FrameEnd),10); %Creates Movie at 10 fps

%% Saves the Delta T Movie
if SAVEDeltaTMovie == 1
v=VideoWriter(['Shot ', num2str(Shots), ' Delta T Movie'],'Motion JPEG AVI');
v.FrameRate = 10;
open(v);
writeVideo(v,IR.DeltaTFrames);
close(v);
end

end
toc/60
