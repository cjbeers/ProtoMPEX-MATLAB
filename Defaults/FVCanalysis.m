%% Initialize Code
%Coded by Josh Beers for ONRL use on the fast visible edgertronic color
%camera

%Reads in edgertronic color camera data to plot intensities of the RGB

%% Initialize Functionality

keypressfcn=0; % 0=off, 1=on


%% Load Video Data

[FILENAME1, PATHNAME, FILTERINDEX] = uigetfile('*.mov;*.mp4;', 'Choose alpha filtered color camera file');
videoFileName1=[PATHNAME FILENAME1];
AlphaVideo.RawData=importdata(videoFileName1);

[FILENAME1, PATHNAME, FILTERINDEX] = uigetfile('*.txt', 'Choose alpha filtered color camera file');
AlphaVideo.CameraData=importdata([PATHNAME FILENAME1]);

[FILENAME2, PATHNAME, FILTERINDEX] = uigetfile('*.mov;*.mp4;', 'Choose beta filtered color camera file');
videoFileName2=[PATHNAME FILENAME2];
BetaVideo.RawData=importdata(videoFileName2);

[FILENAME2, PATHNAME, FILTERINDEX] = uigetfile('*.txt', 'Choose alpha filtered color camera file');
BetaVideo.CameraData=importdata([PATHNAME FILENAME2]);

[FILENAME3, PATHNAME, FILTERINDEX] = uigetfile('*.mov;*.mp4;', 'Choose gamma filtered color camera file');
videoFileName3=[PATHNAME FILENAME3];
GammaVideo.RawData=importdata(videoFileName3);

[FILENAME3, PATHNAME, FILTERINDEX] = uigetfile('*.txt', 'Choose alpha filtered color camera file');
GammaVideo.CameraData=importdata([PATHNAME FILENAME3]);

%% Seperate Video into RGB

%Doubles are easier to work with but consume a lot of memory
%Splits up channels
% AlphaVideo.DataR(:,:,:)=double(AlphaVideo.RawData(:,:,1,:)); 
% AlphaVideo.DataG(:,:,:)=double(AlphaVideo.RawData(:,:,2,:)); 
% AlphaVideo.DataB(:,:,:)=double(AlphaVideo.RawData(:,:,3,:)); 
% 
% BetaVideo.DataR(:,:,:)=double(BetaVideo.RawData(:,:,1,:)); 
% BetaVideo.DataG(:,:,:)=double(BetaVideo.RawData(:,:,2,:));
% BetaVideo.DataB(:,:,:)=double(BetaVideo.RawData(:,:,3,:));
% 
% GammaVideo.DataR(:,:,:)=double(GammaVideo.RawData(:,:,1,:)); 
% GammaVideo.DataG(:,:,:)=double(GammaVideo.RawData(:,:,2,:)); 
% GammaVideo.DataB(:,:,:)=double(GammaVideo.RawData(:,:,3,:)); 


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

[AlphaVideo.xlen,AlphaVideo.ylen,AlphaVideo.zlen]=size(AlphaVideo.DataR);

% Video.x=400;
% Video.y=720;

%% Match-up times

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

%% Figure

close all
ViewFrame=TimeStart;

figure; %Red image
imagesc(AlphaVideo.DataR(:,:,ViewFrame))
colormap([[0:1/255:1]', zeros(256,1), zeros(256,1)]), colorbar;

figure; %Green image
imagesc(AlphaVideo.DataG(:,:,ViewFrame))
colormap([zeros(256,1),[0:1/255:1]', zeros(256,1)]), colorbar;

figure; %Blue image
imagesc(AlphaVideo.DataB(:,:,ViewFrame))
colormap([zeros(256,1), zeros(256,1), [0:1/255:1]']), colorbar;

%% Test make figure with keypressfcn to move between frames

if keypressfcn==1
%// Show first set of points
ii = TimeStart;
figure;
imagesc(AlphaVideo.DataR(:,:,ii));
colormap([[0:1/255:1]', zeros(256,1), zeros(256,1)]), colorbar;
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
        if ii < size(AlphaVideo.DataR(:,:,ii),2)
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
    imagesc(AlphaVideo.DataR(:,:,ii));
    colormap([[0:1/255:1]', zeros(256,1), zeros(256,1)]), colorbar;
    title(['Frame ' num2str(ii)]);
end
end

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





