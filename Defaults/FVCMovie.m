%% Begin code
%
% Coded by Josh Beers
% Coded at ORNL

% For viewing Proto-MPEX movie files from mpexserver, making them into
% greyscale and producing a movie with time stamps

cleanup; %fclose all, close all, clear all, clc
save=1; %0=no 1=yes
%% Load Data

PATHNAME=('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2021_02_11\');
FILENAME1=('slomo_1613067228.mov');

Data.VideoFileLoc=[PATHNAME FILENAME1];
Data.RawCameraData=importdata(Data.VideoFileLoc);

if PATHNAME(1,end-1)=='c'
    Data.RawCameraData=rot90(Data.RawCameraData,2);
end

%FILENAME2=('slomo_1604501279.txt');
FILENAME2=strcat(FILENAME1(1:end-4),'.txt');
Data.TextData=table2array(readtable([PATHNAME FILENAME2])); %To get Text data into proper cells
Data.TextData=strrep(Data.TextData(:,:),'"',''); %Removes the quotations marks about the cell entries

%% Get Camera framerate

Data.Hz=Data.TextData(4,2);
Data.Hz=cell2mat(Data.Hz);
Data.Hz=str2double(Data.Hz);

Data.Duration=Data.TextData(8,2);
Data.Duration=cell2mat(Data.Duration);
Data.Duration=str2double(Data.Duration);

TimeStart=4; %Timing box starting %s
Data.FrameTime=(0:(1/Data.Hz):Data.Duration)+TimeStart;

%% Full Movie 
tic
[Data.xlen,Data.ylen,Data.zlen,Data.FrameLength]=size(Data.RawCameraData);

    for ii=1:1:Data.FrameLength
        
        %title(['Shot Number ', num2str(Shots), ' Color FVC Movie'],'FontSize',13);
        %title(['FVC Movie for ',FILENAME])
        xlabel(['Time = ', num2str(Data.FrameTime(ii)),' [s]'],'FontSize',12);
        position=[Data.ylen/2.2 Data.xlen/1.1];
        Data.TimeText{ii} = ['Time = ' num2str(Data.FrameTime(ii)) ' [s]'];
        Data.TimeVideo(:,:,:,ii) = insertText(Data.RawCameraData(:,:,:,ii),position,Data.TimeText{ii},'TextColor','white','FontSize',18,'BoxOpacity',0);
        Data.TimeVideo(:,:,:,ii)=repmat(rgb2gray(Data.TimeVideo(:,:,:,ii)),[1 1 3]);      
    end
    
    
close figure 1
Data.Video=implay(Data.TimeVideo, 10); %Creates full color movie at 10 fps
    
toc\60
%%
if save==1
v = VideoWriter('Plasma Shutter Shot 31560 Movie.avi','Motion JPEG AVI');
v.Quality = 85;
open(v)
for ii=1:size(Data.TimeVideo,4)
writeVideo(v,Data.TimeVideo(:,:,:,ii))
end
close(v)
end
