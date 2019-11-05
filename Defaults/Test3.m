%% Begin code
%
% Coded by Josh Beers
% Coded at ORNL

% For viewing Proto-MPEX movie files from mpexserver, making them into
% greyscale and producing a movie with time stamps

cleanup; %fclose all, close all, clear all, clc

%% Load Data
PATHNAME=('\\mpexserver\ProtoMPEX_Data\Visible_Cameras\2018_02_09m\');
FILENAME1=('slomo_1518200975_09_1-29-52.mov');

Data.VideoFileLoc=[PATHNAME FILENAME1];
Data.RawCameraData=importdata(Data.VideoFileLoc);

FILENAME2=('slomo_1518200975_09_1-29-36.txt');
Data.TextData=table2array(readtable([PATHNAME FILENAME2]));
Data.TextData=strrep(Data.TextData(:,:),'"','');

%% Get Camera framerate

Data.Hz=Data.TextData(4,2);
Data.Hz=cell2mat(Data.Hz);
Data.Hz=str2num(Data.Hz);

Data.Duration=Data.TextData(8,2);
Data.Duration=cell2mat(Data.Duration);
Data.Duration=str2num(Data.Duration);

Data.FrameTime=(0:(1/Data.Hz):Data.Duration)+4;

%% Full Movie 
[Data.xlen,Data.ylen,Data.zlen,Data.FrameLength]=size(Data.RawCameraData);

    for ii=1:1:Data.FrameLength
        
        %title(['Shot Number ', num2str(Shots), ' Color FVC Movie'],'FontSize',13);
        %title(['FVC Movie for ',FILENAME])
        xlabel(['Time = ', num2str(Data.FrameTime(ii)),' [s]'],'FontSize',12);
        position=[Data.ylen/2.2 Data.xlen/1.1];
        Data.TimeText{ii} = ['Time = ' num2str(Data.FrameTime(ii)) ' [s]'];
        Data.TimeVideo(:,:,:,ii) = insertText(Data.RawCameraData(:,:,:,ii),position,Data.TimeText{ii},'TextColor','white','FontSize',18,'BoxOpacity',0);
              
    end
close figure 1
Data.Video=implay(Data.TimeVideo, 10); %Creates full color movie at 10 fps
    
%end


