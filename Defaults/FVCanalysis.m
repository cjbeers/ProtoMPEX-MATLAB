%% Initialize Code
%Coded by Josh Beers for ONRL use on the fast visible edgertronic color
%camera

%Reads in edgertronic color camera data to plot intensities of the RGB


%% Load Video Data

[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.mov;*.mp4;', 'Choose alpha filtered color camera file');
videoFileName=[PATHNAME FILENAME];

AlphaVideo.RawData=importdata(videoFileName);

% [FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.mov;*.mp4;', 'Choose beta filtered color camera file');
% videoFileName=[PATHNAME FILENAME];
% 
% BetaVideo.RawData=importdata(videoFileName);
% 
% [FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.mov;*.mp4;', 'Choose gamma filtered color camera file');
% videoFileName=[PATHNAME FILENAME];
% 
% GammaVideo.RawData=importdata(videoFileName);


%% Seperate Video into RGB

%Splits up channels
AlphaVideo.DataR(:,:,:)=double(AlphaVideo.RawData(:,:,1,:)); 
AlphaVideo.DataG(:,:,:)=double(AlphaVideo.RawData(:,:,2,:)); 
AlphaVideo.DataB(:,:,:)=double(AlphaVideo.RawData(:,:,3,:)); 

% BetaVideo.DataR(:,:,:)=double(BetaVideo.RawData(:,:,1,:)); 
% BetaVideo.DataG(:,:,:)=double(BetaVideo.RawData(:,:,2,:));
% BetaVideo.DataB(:,:,:)=double(BetaVideo.RawData(:,:,3,:));
% 
% GammaVideo.DataR(:,:,:)=double(GammaVideo.RawData(:,:,1,:)); 
% GammaVideo.DataG(:,:,:)=double(GammaVideo.RawData(:,:,2,:)); 
% GammaVideo.DataB(:,:,:)=double(GammaVideo.RawData(:,:,3,:)); 

[AlphaVideo.xlen,AlphaVideo.ylen,AlphaVideo.zlen]=size(AlphaVideo.DataR);

% Video.x=400;
% Video.y=720;

%% Figure

close all
ViewFrame=400;

figure; %Red image
imagesc(AlphaVideo.DataR(:,:,ViewFrame))
colormap([[0:1/255:1]', zeros(256,1), zeros(256,1)]), colorbar;

figure; %Green image
imagesc(AlphaVideo.DataG(:,:,ViewFrame))
colormap([zeros(256,1),[0:1/255:1]', zeros(256,1)]), colorbar;

figure; %Blue image
imagesc(AlphaVideo.DataB(:,:,ViewFrame))
colormap([zeros(256,1), zeros(256,1), [0:1/255:1]']), colorbar;

%% Match-up times

AlphaVideo.diff=diff(AlphaVideo.DataR,1,3);

% [AlphaVideo.diffMax,col]= find(max(max(AlphaVideo.diff))>= 3);
% [AlphaVideo.start, AlphaVideo.start_index]=find(AlphaVideo.DataR(:,:,:)==AlphaVideo.diffMax(1,1));

AlphaVideo.DataRMax=max(max(AlphaVideo.diff));
[AlphaVideo.start(1,1)]=find(AlphaVideo.DataRMax>=3, 1);

jj=0;
while jj<1
    ii=1;
    if AlphaVideo.DataRMax(1,1,AlphaVideo.start-1) ==0 & AlphaVideo.DataRMax(1,1,AlphaVideo.start+1) ==0 
        [AlphaVideo.start]=find(AlphaVideo.DataRMax>=3);
        ii=ii+1;
    elseif AlphaVideo.DataRMax(1,1,AlphaVideo.start-1) >=0 & AlphaVideo.DataRMax(1,1,AlphaVideo.start+1) >=0        
        [AlphaVideo.start]=find(AlphaVideo.DataRMax>=3);
        jj=2;
    end
end

% if AlphaVideo.DataRMax(1,1,AlphaVideo.start-1)==0 && AlphaVideo.DataRMax(1,1,AlphaVideo.start+1)==0
% 
%     ii=1;
%     [AlphaVideo.start]=find(AlphaVideo.DataRMax>=3,ii+1);
%     ii=ii+1;
%     
% end


%% Test make figure with keypressfcn to move between frames

%// Show first set of points
ii = 1;
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
        if ii < size(data,2)
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
