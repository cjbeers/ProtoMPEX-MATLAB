%% Initialize Code
%Coded by Josh Beers for ONRL use on the fast visible edgertronic color
%camera

%Reads in edgertronic color camera data to plot intensities of the RGB

%% Initialize Functionality

keypressfcn=0; % 0=off, 1=on
viewfullmovie=1;
viewmoviepeices=0;

%% Load Video Data

[FILENAME1, PATHNAME] = uigetfile('*.mov;*.mp4;', 'Choose alpha filtered color camera file');
videoFileName1=[PATHNAME FILENAME1];
AlphaVideo.RawData=importdata(videoFileName1);

[FILENAME1, PATHNAME] = uigetfile('*.txt', 'Choose alpha filtered color camera file');
AlphaVideo.CameraData=table2array(readtable([PATHNAME FILENAME1]));
AlphaVideo.CameraData=strrep( AlphaVideo.CameraData(:,:),'"','');

[FILENAME2, PATHNAME] = uigetfile('*.mov;*.mp4;', 'Choose beta filtered color camera file');
videoFileName2=[PATHNAME FILENAME2];
BetaVideo.RawData=importdata(videoFileName2);

[FILENAME2, PATHNAME] = uigetfile('*.txt', 'Choose alpha filtered color camera file');
BetaVideo.CameraData=table2array(readtable([PATHNAME FILENAME1]));
BetaVideo.CameraData=strrep( BetaVideo.CameraData(:,:),'"','');

[FILENAME3, PATHNAME] = uigetfile('*.mov;*.mp4;', 'Choose gamma filtered color camera file');
videoFileName3=[PATHNAME FILENAME3];
GammaVideo.RawData=importdata(videoFileName3);

[FILENAME3, PATHNAME] = uigetfile('*.txt', 'Choose alpha filtered color camera file');
GammaVideo.CameraData=table2array(readtable([PATHNAME FILENAME1]));
GammaVideo.CameraData=strrep( GammaVideo.CameraData(:,:),'"','');

%% Seperate Video into RGB

% Splits up data as unit8, the default data type
AlphaVideo.DataR(:,:,:)=AlphaVideo.RawData(:,:,1,:); 
AlphaVideo.DataG(:,:,:)=AlphaVideo.RawData(:,:,2,:); 
AlphaVideo.DataB(:,:,:)=AlphaVideo.RawData(:,:,3,:); 

BetaVideo.DataR(:,:,:)=BetaVideo.RawData(:,:,1,:); 
BetaVideo.DataG(:,:,:)=BetaVideo.RawData(:,:,2,:);
BetaVideo.DataB(:,:,:)=BetaVideo.RawData(:,:,3,:);

GammaVideo.DataR(:,:,:)=GammaVideo.RawData(:,:,1,:); 
GammaVideo.DataG(:,:,:)=GammaVideo.RawData(:,:,2,:); 
GammaVideo.DataB(:,:,:)=GammaVideo.RawData(:,:,3,:); 


%Gets size of data array for use later
[AlphaVideo.xlen,AlphaVideo.ylen,AlphaVideo.zlen]=size(AlphaVideo.DataR);
[BetaVideo.xlen,BetaVideo.ylen,BetaVideo.zlen]=size(BetaVideo.DataR);
[GammaVideo.xlen,GammaVideo.ylen,GammaVideo.zlen]=size(GammaVideo.DataR);

%% Gets shutter speed (1/s)

%Uses txt file to get shutter speed into variable of type double
AlphaVideo.ShutterTime=AlphaVideo.CameraData(3,2);
AlphaVideo.ShutterTime=cell2mat(AlphaVideo.ShutterTime);
AlphaVideo.ShutterTime=str2num(AlphaVideo.ShutterTime);

%Same for beta
BetaVideo.ShutterTime=BetaVideo.CameraData(3,2);
BetaVideo.ShutterTime=cell2mat(BetaVideo.ShutterTime);
BetaVideo.ShutterTime=str2num(BetaVideo.ShutterTime);

%Same for gamma
GammaVideo.ShutterTime=GammaVideo.CameraData(3,2);
GammaVideo.ShutterTime=cell2mat(GammaVideo.ShutterTime);
GammaVideo.ShutterTime=str2num(GammaVideo.ShutterTime);

%% Gets other important camera details

%Camera Frame Rate in Hz
AlphaVideo.Hz=AlphaVideo.CameraData(4,2);
AlphaVideo.Hz=cell2mat(AlphaVideo.Hz);
AlphaVideo.Hz=str2num(AlphaVideo.Hz);

AlphaVideo.Duration=AlphaVideo.CameraData(8,2);
AlphaVideo.Duration=cell2mat(AlphaVideo.Duration);
AlphaVideo.Duration=str2num(AlphaVideo.Duration);

AlphaVideo.FrameTime=(0:(1/AlphaVideo.Hz):AlphaVideo.Duration)+4;

BetaVideo.Hz=BetaVideo.CameraData(4,2);
BetaVideo.Hz=cell2mat(BetaVideo.Hz);
BetaVideo.Hz=str2num(BetaVideo.Hz);

BetaVideo.Duration=BetaVideo.CameraData(8,2);
BetaVideo.Duration=cell2mat(BetaVideo.Duration);
BetaVideo.Duration=str2num(BetaVideo.Duration);

BetaVideo.FrameTime=(0:(1/BetaVideo.Hz):BetaVideo.Duration)+4;

GammaVideo.Hz=GammaVideo.CameraData(4,2);
GammaVideo.Hz=cell2mat(GammaVideo.Hz);
GammaVideo.Hz=str2num(GammaVideo.Hz);

GammaVideo.Duration=GammaVideo.CameraData(8,2);
GammaVideo.Duration=cell2mat(GammaVideo.Duration);
GammaVideo.Duration=str2num(GammaVideo.Duration);

GammaVideo.FrameTime=(0:(1/GammaVideo.Hz):GammaVideo.Duration)+4;

%% Match-up times
%May not do anything that I want it to do

AlphaVideo.diff=diff(AlphaVideo.DataR,1,3);
AlphaVideo.DataRMax=max(max(AlphaVideo.diff));
[AlphaVideo.start(1,1)]=find(AlphaVideo.DataRMax>=3, 1);

BetaVideo.diff=diff(BetaVideo.DataB,1,3);
BetaVideo.DataRMax=max(max(BetaVideo.diff));
[BetaVideo.start(1,1)]=find(BetaVideo.DataRMax>=3, 1);

GammaVideo.diff=diff(GammaVideo.DataB,1,3);
GammaVideo.DataRMax=max(max(GammaVideo.diff));
[GammaVideo.start(1,1)]=find(GammaVideo.DataRMax>=3, 1);

TimeStart=round(mean([GammaVideo.start BetaVideo.start AlphaVideo.start]));

%%

Spectral=integral((@(x) (-4E-21*x.^6 + 1E-17*x.^5 - 2E-14*x.^4 + 2E-11*x.^3 - 6E-9*x.^2 + 9E-07*x - 5E-5)*(4*pi)/(2.99E8*6.62E-34./x)),410,660,'ArrayValue', true);



%% Figure

close all
ViewFrame=400;

figure; %Red image
AlphaVideo.ax1=subplot(3,1,1);
imagesc(AlphaVideo.DataR(:,:,ViewFrame))
colormap(AlphaVideo.ax1,[[0:1/255:1]', zeros(256,1), zeros(256,1)]), colorbar;
set(gca,'xtick',[])
set(gca,'ytick',[])

AlphaVideo.ax2=subplot(3,1,2); %Green image
imagesc(AlphaVideo.DataG(:,:,ViewFrame))
colormap(AlphaVideo.ax2,[zeros(256,1),[0:1/255:1]', zeros(256,1)]), colorbar;
set(gca,'xtick',[])
set(gca,'ytick',[])

AlphaVideo.ax3=subplot(3,1,3); %Blue image
imagesc(AlphaVideo.DataB(:,:,ViewFrame))
colormap(AlphaVideo.ax3,[zeros(256,1), zeros(256,1), [0:1/255:1]']), colorbar;
set(gca,'xtick',[])
set(gca,'ytick',[])

%% Full Movie 

%if viewfullmovie==1
    
    for ii=1:1:AlphaVideo.zlen
        
        %title(['Shot Number ', num2str(Shots), ' Color FVC Movie'],'FontSize',13);
        title(['FVC Movie for ',FILENAME1])
        xlabel(['Time = ', num2str(AlphaVideo.FrameTime(ii)),' [s]'],'FontSize',12);
        position=[AlphaVideo.ylen/2.2 AlphaVideo.xlen/1.1];
        AlphaVideo.TimeText{ii} = ['Time = ' num2str(AlphaVideo.FrameTime(ii)) ' [s]'];
        AlphaVideo.FullAlphaTimeVideo(:,:,:,ii) = insertText(AlphaVideo.RawData(:,:,:,ii),position, AlphaVideo.TimeText{ii},'TextColor','white','FontSize',18,'BoxOpacity',0);
              
    end

AlphaVideo.Video=implay(AlphaVideo.FullAlphaTimeVideo, 10); %Creates full color movie at 10 fps
    
%end

%% Plots AlphaVideo Red Channel with movable button click
% Press the mouse left click, right arrow key, or up arrow key to move the
% frame forward
%Press the mouse right click, left arrow key, or down arrow key to move the
%frame backwards

if keypressfcn==1
%// Show first set of points
ii = TimeStart;
figure(2);

AlphaVideo.ax1=subplot(3,1,1);
imagesc(AlphaVideo.DataR(:,:,ii))
colormap(AlphaVideo.ax1,[[0:1/255:1]', zeros(256,1), zeros(256,1)]), colorbar;
title(['Use Mouse to Move Through Frames; Frame = ' num2str(ii), '; Time = ' num2str(AlphaVideo.FrameTime(ii)) ' [s]']);
set(gca,'xtick',[])
set(gca,'ytick',[])

AlphaVideo.ax2=subplot(3,1,2); %Green image
imagesc(AlphaVideo.DataG(:,:,ii))
colormap(AlphaVideo.ax2,[zeros(256,1),[0:1/255:1]', zeros(256,1)]), colorbar;
set(gca,'xtick',[])
set(gca,'ytick',[])

AlphaVideo.ax3=subplot(3,1,3); %Blue image
imagesc(AlphaVideo.DataB(:,:,ii))
colormap(AlphaVideo.ax3,[zeros(256,1), zeros(256,1), [0:1/255:1]']), colorbar;
set(gca,'xtick',[])
set(gca,'ytick',[])

%// Until we decide to quit...
while true 
    %// Get a button from the user
    [~,~,b] = ginput(1);

    %// Left click3
    %// Use this for left arrow
    %// if b == 28
    if b == 1 || b == 29 || b == 30
        %// Check to make sure we don't go out of bounds
        if ii < size(AlphaVideo.DataR(:,:,ii),2)
            ii = ii + 1; %// Move to the right
        end                        
    %// Right click
    %// Use this for right arrow
    %// elseif b == 29
    elseif b == 3 || b == 28 || b == 31
        if ii > 1 %// Again check for out of bounds
           ii = ii - 1; %// Move to the left
        end
    %// Check for escape
    elseif b == 27
       break;
    end

    %// Plot new data
   
AlphaVideo.ax1=subplot(3,1,1);
imagesc(AlphaVideo.DataR(:,:,ii))
colormap(AlphaVideo.ax1,[[0:1/255:1]', zeros(256,1), zeros(256,1)]), colorbar;
title(['Use Mouse to Move Through Frames; Frame = ' num2str(ii), '; Time = ' num2str(AlphaVideo.FrameTime(ii)) ' [s]']);
set(gca,'xtick',[])
set(gca,'ytick',[])

AlphaVideo.ax2=subplot(3,1,2); %Green image
imagesc(AlphaVideo.DataG(:,:,ii))
colormap(AlphaVideo.ax2,[zeros(256,1),[0:1/255:1]', zeros(256,1)]), colorbar;
set(gca,'xtick',[])
set(gca,'ytick',[])

AlphaVideo.ax3=subplot(3,1,3); %Blue image
imagesc(AlphaVideo.DataB(:,:,ii))
colormap(AlphaVideo.ax3,[zeros(256,1), zeros(256,1), [0:1/255:1]']), colorbar;
set(gca,'xtick',[])
set(gca,'ytick',[])

end
end
%% Intensity Calibration

Constant.c=2.99E8; %m/s
Constant.h=6.63E34; %Plank's constant
Constant.j=1.602E-19; %Joules/eV
AlphaVideo.Transmission=0.5; % Percentage filter pass band transmission
BetaVideo.Transmission=0.5;
GammaVideo.Transmission=0.225;
DeltaVideo.Transmission=0.47;

Temperature(:,:,i)=arrayfun(@(Data_zoom) seq.ThermalImage.GetValueFromEmissivity(0.69,Data_zoom),Data_zoom(:,:,i));
%AlphaVideo.DataRCalib=arrayfun(@


%% Ratios not including shutter timings

Ratio.BoverA=BetaVideo.DataB./AlphaVideo.DataR;
Ratio.YoverA=GammaVideo.DataB./AlphaVideo.DataR;

%% Plot B over A ratio

ii = TimeStart;
figure;
imagesc(Ratio.BoverA(:,:,ii));
colormap([zeros(256,1), zeros(256,1), [0:1/255:1]']), colorbar;
title(['Frame ' num2str(ii)]); 

%// Until we decide to quit...
while true 
    %// Get a button from the user
    [~,~,b] = ginput(1);

    %// Left click
    %// Use this for left arrow
    %// if b == 28
    if b == 1
        %// Check to make sure we don't go out of bounds
        if ii < size(Ratio.BoverA(:,:,ii),2)
            ii = ii + 1; %// Move to the right
        end                        
    %// Right click
    %// Use this for right arrow
    %// elseif b == 29
    elseif b == 3
        if ii > 1 %// Again check for out of bounds
           ii = ii - 1; %// Move to the left
        end
    %// Check for escape
    elseif b == 27
       break;
    end

    %// Plot new data
    imagesc(Ratio.BoverA(:,:,ii));
    colormap([zeros(256,1), zeros(256,1), [0:1/255:1]']), colorbar;
    title(['Frame ' num2str(ii)]);
end

%% Plot Y over A ratio

ii = TimeStart;
figure;
imagesc(Ratio.YoverA(:,:,ii));
colormap([zeros(256,1), zeros(256,1), [0:1/255:1]']), colorbar;
title(['Frame ' num2str(ii)]); 

%// Until we decide to quit...
while true 
    %// Get a button from the user
    [~,~,b] = ginput(1);

    %// Left click
    %// Use this for left arrow
    %// if b == 28
    if b == 1
        %// Check to make sure we don't go out of bounds
        if ii < size(Ratio.YoverA(:,:,ii),2)
            ii = ii + 1; %// Move to the right
        end                        
    %// Right click
    %// Use this for right arrow
    %// elseif b == 29
    elseif b == 3
        if ii > 1 %// Again check for out of bounds
           ii = ii - 1; %// Move to the left
        end
    %// Check for escape
    elseif b == 27
       break;
    end

    %// Plot new data
    imagesc(Ratio.YoverA(:,:,ii));
    colormap([zeros(256,1), zeros(256,1), [0:1/255:1]']), colorbar;
    title(['Frame ' num2str(ii)]);
end





