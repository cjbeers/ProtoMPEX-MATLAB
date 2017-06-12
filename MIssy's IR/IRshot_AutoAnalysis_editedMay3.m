%##### Load image #####
%close all 
clear all
tic
[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.jpg;*.seq', 'Choose IR file (jpg) or radiometric sequence (seq)');
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
    
Data(:,:,1) = im;
fr = 1;
Counts=seq.ThermalImage.Count;
frames=double(Counts);
%e1_list=zero(frames,1);
if(seq.Count > 1)
    while(seq.Next())
        img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
        im = double(img);
        Data(:,:,fr) = im;
        %e1_list(fr)=ellipseAvg;
        fr = fr + 1;
    end
end

delta_t= input('what is the pulse length of the shot [in seconds]  ');%pulse length (sec)

%First - find the approximate pixel location of the hottest spot
%guess max frame - just want to be able to narrow in on the right max area
%to find the correct max frame and max delta T
f0 = 1;
f1 = 36;

Delta_Data_zoom = Data(115:305,275:435,f1) - Data(115:305,275:435,f0);
figure;
image(Delta_Data_zoom,'CDataMapping','scaled');
colormap jet
c=colorbar;
grid on

title('Click on approximate edge hot spot position')
[column,row] = ginput(1);
drawnow;

title('Click on approximate center hot spot position')
[center1,center2] = ginput(1);
drawnow;

title('Click approximate diameter width')
[x1,y1] = ginput(1);
[x2,y2] = ginput(1);
diameter_raw = sqrt((x2-x1)^2+(y2-y1)^2);
drawnow;

column = double(int16(column));
row = double(int16(row));
diameter = double(int16(diameter_raw));
center1 = double(int16(center1));
center2 = double(int16(center2));

%zoom in and shorten the frames - all interesting stuff happens within the
%first 60 frames
zoomframes=50;
templist=zeros(zoomframes,1);
templist2=zeros(zoomframes,1);
%avgtemplist=zeros(zoomframes,1);
deltatemplist=zeros(zoomframes,1);
deltatemplist2=zeros(zoomframes,1);
%avgdeltatemplist=zeros(zoomframes,1);
Data_zoom = Data(115:305,275:435,1:zoomframes);
temp=zeros(zoomframes,1);
tempA=zeros(zoomframes,1);
tempB=zeros(zoomframes,1);
tempC=zeros(zoomframes,1);
tempD=zeros(zoomframes,1);
tempE=zeros(zoomframes,1);
tempF=zeros(zoomframes,1);
tempG=zeros(zoomframes,1);
tempH=zeros(zoomframes,1);
temp2=zeros(zoomframes,1);
Temperature = Data_zoom;

for i=1:zoomframes
    %grabs temperature and delta T from a zoomed in location on the
        %image - takes too long if keep full image - need to keep the delta
        %in the y-range 190, and the x-range 160 pixels. - Data zoom in @
        %center of the image
     
     Temperature(:,:,i)=arrayfun(@(Data_zoom) seq.ThermalImage.GetValueFromEmissivity(0.26,Data_zoom),Data_zoom(:,:,i));
     temp(i)=Temperature(row,column,i);
     tempA(i)=Temperature(row,column-3,i);
     tempB(i)=Temperature(row,column+3,i);
     tempC(i)=Temperature(row-3,column,i);
     tempD(i)=Temperature(row+3,column,i);
     
     temp2(i)=Temperature(center2,center1,i);
     tempE(i)=Temperature(center2,center1-3,i);
     tempF(i)=Temperature(center2,center1+3,i);
     tempG(i)=Temperature(center2+3,center1,i);
     tempH(i)=Temperature(center2-3,center1,i);
     
     temparray=[temp(i);tempA(i);tempB(i);tempC(i);tempD(i)];
     avgtemp=mean(temparray);
     templist(i)=avgtemp;
     deltatemplist(i)=templist(i)-templist(1);
     
     temparray2=[temp2(i);tempE(i);tempF(i);tempG(i);tempH(i)];
     avgtemp2=mean(temparray2);
     templist2(i)=avgtemp2;
     deltatemplist2(i)=templist2(i)-templist2(1);
        %delta T general is by subtracting first frame from remaining frames. This
        %can be modified if needed for other image subtraction
     DeltaTMatrix(:,:,i)=Temperature(:,:,i)-Temperature(:,:,1);
     
     i=i+1;
end
    
%%
%close all

%% Find the hottest frame ; or can also default for frame 36-37 
MaxDelta=DeltaTMatrix(:,:,1);
framenumber=0;
%x-range 145 pixels (num columns - second), y-range 180 pixels (num rows -first)
%first attempt at narrowing into max frame
for i=1:zoomframes
    if mean2(DeltaTMatrix(40:170,30:150,i)) - mean2(MaxDelta(40:170,30:150,1)) > 0.2
        MaxDelta(:,:,1)=DeltaTMatrix(:,:,i);
        framenumber=i;
    end 
    i=i+1;
end

%artifically high because of camera shifting down
if framenumber==zoomframes
    framenumber=framenumber-3;
end

%second iteration - use specific pixel to narrow in 
maxlist = deltatemplist(1);
newframenumber=0;
newframenumber1=0;
newframenumber2=0;
meanlist=zeros(zoomframes,1);
for i=1:zoomframes
    meanlist(i)= mean2(DeltaTMatrix(40:170,30:150,i));
    if deltatemplist(i) - maxlist > 0.05
        maxlist = deltatemplist(i);
        newframenumber1=i;
    end 
    if deltatemplist2(i) - maxlist > 0.05
        maxlist = deltatemplist2(i);
        newframenumber2 = i;
    end
    i=i+1;
end

if newframenumber2>newframenumber1
    newframenumber=newframenumber2;
else 
    newframenumber=newframenumber1;
end


%plot both possibilities for troubleshooting if necessary
figure;
plot(1:zoomframes, deltatemplist,1:zoomframes,meanlist, 1:zoomframes,deltatemplist2);

finalframenumber=0;
if framenumber-newframenumber>=3
    if abs(mean2(DeltaTMatrix(40:170,30:150,framenumber)) - mean2(DeltaTMatrix(40:170,30:150,framenumber-1)))<0.3
        while abs(newframenumber-framenumber)>=2
%             while framenumber > 10
                framenumber=framenumber-1;
%             end
        end
    else
    'error: gap between two possible max delta T frames is large - manual analysis suggested'
    end
end

if newframenumber-framenumber>=3
    if abs(mean2(DeltaTMatrix(40:170,30:150,newframenumber)) - mean2(DeltaTMatrix(40:170,30:150,newframenumber-1)))<0.3
        while abs(newframenumber-framenumber)>=2
%             while newframenumber > 10
                newframenumber=newframenumber-1;
%             end
        end
    else
    'error: gap between two possible max delta T frames is large - manual analysis suggested'
    end
end

if abs(newframenumber-framenumber)==2
    finalframenumber=(newframenumber+framenumber)/2;
end

if abs(newframenumber-framenumber)<2
    %if mean2(DeltaTMatrix(40:170,30:150,newframenumber))> mean2(DeltaTMatrix(40:170,30:150,framenumber))
    if newframenumber<framenumber
        finalframenumber=newframenumber;
    else finalframenumber=framenumber;
    end
end
    
MaxDelta=DeltaTMatrix(:,:,finalframenumber);


deltamax = double(max(max(int16(round(MaxDelta,2,'significant')))));
deltamin = double(min(min(int8(round(MaxDelta,1,'significant')))));
scalestep = deltamax/10;

%% Heat Flux Measurement
%Calculates the heat flux of a image 

Cp=500; %J/kg*C
density=8030; %kg/m3
thickness= .01*(2.54/100); %inches to m
%delta_t= input('what is the pulse length of the shot [in seconds]  ');%pulse length (sec)

QMax=(((Cp*MaxDelta*thickness*density)/delta_t)/1E6); %Cp*DeltaT*mass = MW/m2
q_range = round((((deltamax*Cp*thickness*density)/delta_t)/1E6),1,'significant');

%Plot MaxDelta
figure;
figDeltaT=imagesc(MaxDelta, 'CDataMapping','scaled');
caxis([0 deltamax])
colormap jet
c=colorbar;
ylabel(c, 'Delta T [C]')
ax.FontSize = 13;
title('Delta Temperature vs. Camera Pixels','FontSize',13);
xlabel('Pixels','FontSize',13);
ylabel('Pixels','FontSize',13);

%find average ellipse delta temp
%diameter = input('what is the diameter of the plasma? [in pixels]  ');
large_diameter = round(diameter*1.07,3,'sig');
r1=diameter/2;
r2=large_diameter/2;
%ellipse [Position] = [Xmin Ymin Width Height] = [columnMin rowMin columns
%rows] 
%Approximate 'E1' from ResearchIR
ellipse=imellipse(gca,[87-r2 97-r1 diameter large_diameter]);
mask=createMask(ellipse,figDeltaT);
avg_all=mean2(mask.*MaxDelta);
avg_mask=mean2(mask);
avg_delta=avg_all/avg_mask; %this is hand-wavy? 

%Approximate 'E2' from ResearchIR
ellipse2=imellipse(gca,[5 10 155 180]);
mask2=createMask(ellipse2,figDeltaT);
avg_all2=mean2(mask.*MaxDelta);
avg_mask2=mean2(mask2);
avg_delta2=avg_all2/avg_mask2; %this is hand-wavy?

%Draw hot spot for deltaT
ellipse3=imellipse(gca,[column-3 row-3 6 6]);

%Draw center spot ellipse deltaT
ellipse4 = imellipse(gca,[center1-3 center2-3 6 6]);

%Plot QMax
figure;
imagesc(QMax, 'CDataMapping','scaled')
caxis([0 q_range])
colormap jet
c=colorbar;
ylabel(c, 'QMax [MW/m^2]')
ax.FontSize = 13;
title('Heat Flux vs. Camera Pixels','FontSize',13);
xlabel('Pixels','FontSize',13);
ylabel('Pixels','FontSize',13);
%saveas(gca,FILENAME(6:end-4),'jpg'); 


%Start with ECH/ICH intra-shot analysis
%find shot where plasma first appears on the target plate

%FIX THIS: first plasma and first plasma from helicon! 
plasmaframe_list=zeros(finalframenumber,1);
plasmaframe2_list=zeros(finalframenumber,1);
for i=2:finalframenumber-2 %looks for first helicon/ECH heating
    if deltatemplist(i)-deltatemplist(i-1)<0.05
        plasmaframe_list(i)=i;
    end
    if mean2(DeltaTMatrix(40:170,30:150,i))< 0.5 %looks for first heat in general - avg heating if microwave heating is obvious
        plasmaframe2_list(i)=i;
    end
end
%plasma frame where plasma first appears
plasmaframe = max(plasmaframe_list)+1;
plasmaframe2 = max(plasmaframe2_list);

% % 
% %Plot Frame with first helicon plasma
% figure;
% imagesc(DeltaTMatrix(:,:,plasmaframe), 'CDataMapping','scaled')
% if plasmaframe2<18
%     caxis([0 10])
% else
%     caxis([0 5])
% end
% colormap jet
% c=colorbar;
% ylabel(c, 'Delta T [C]')
% ax.FontSize = 13;
% title('First Helicon Plasma Frame','FontSize',13);
% xlabel('Pixels','FontSize',13);
% ylabel('Pixels','FontSize',13);
% 
% %Plot Frame with first pre-ionization heating plasma
% if plasmaframe-plasmaframe2>10
% figure;
% imagesc(DeltaTMatrix(:,:,plasmaframe2), 'CDataMapping','scaled')
% caxis([0 5])
% colormap jet
% c=colorbar;
% ylabel(c, 'Delta T [C]')
% ax.FontSize = 13;
% title('First Pre-ionization Plasma Frame','FontSize',13);
% xlabel('Pixels','FontSize',13);
% ylabel('Pixels','FontSize',13);
% end

%outputs of valueable numbers
'Frame where helicon plasma first appears: ', disp(plasmaframe)
'Frame where deltaT is greatest', disp(finalframenumber)
'Average edge hot spot deltaT', disp(deltatemplist(newframenumber1))
'Average center hot spot deltaT', disp(deltatemplist2(finalframenumber))
'Average deltaT (E1)', disp(avg_delta)
'Expanded average deltaT (E2)', disp(avg_delta2)


px_per_cm = 32.44;

%save raw data of hottest frame as .mat file so can use it for the field line
%mapping
filename=strcat(FILENAME(5:end-4),'.mat');
rawdata=Data(:,:,finalframenumber);
rawdata_matrix=cell2mat(num2cell(rawdata));
% %get the full image of the hottest frame in terms of delta T.

Delta_data=Data(:,:,finalframenumber)-Data(:,:,1);
Temperature2(:,:,finalframenumber) = arrayfun(@(Delta_data) seq.ThermalImage.GetValueFromEmissivity(0.26,Delta_data),Delta_data(:,:,1));
deltatemp = Temperature2(:,:,finalframenumber);

qmax = (((Cp*deltatemp*thickness*density)/delta_t)/1E6);
Frame=cell2mat(num2cell(deltatemp));
save(filename,'Frame','px_per_cm','qmax');

timeall=(toc)/60