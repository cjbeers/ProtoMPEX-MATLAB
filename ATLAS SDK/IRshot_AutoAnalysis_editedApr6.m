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

%First - find the approximate pixel location of the hottest spot
%guess max frame - just want to be able to narrow in on the right max area
%to find the correct max frame and max delta T
f0 = 1;
f1 = 36;

Data_zoom = Data(120:300,270:415,f1) - Data(120:300,270:415,f0);
figure;
image(Data_zoom,'CDataMapping','scaled');
colormap jet
c=colorbar;

%input the pixel location
row = input('what is the approximate y-location (row number) of the hottest spot? [in pixels]  ');
column = input('what is the approximate x-location (column number) of the hottest spot? [in pixels]  ');
diameter = input('what is the approximate diameter of the plasma? [in pixels]  ');

%zoom in and shorten the frames - all interesting stuff happens within the
%first 60 frames
zoomframes=50;
templist=zeros(zoomframes,1);
avgtemplist=zeros(zoomframes,1);
deltatemplist=zeros(zoomframes,1);
avgdeltatemplist=zeros(zoomframes,1);
Data_zoom = Data(120:300,270:415,1:zoomframes);
temp=zeros(zoomframes,1);
tempA=zeros(zoomframes,1);
tempB=zeros(zoomframes,1);
tempC=zeros(zoomframes,1);
tempD=zeros(zoomframes,1);
temp2=zeros(zoomframes,1);

for i=1:zoomframes
    %grabs temperature and delta T from a zoomed in location on the
        %image - takes too long if keep full image - need to keep the delta
        %in the y-range 180, and the x-range 145 pixels. - Data zoom in @
        %center of the image
     temp(i) = seq.ThermalImage.GetValueFromSignal(Data_zoom(row,column,i));
     tempA(i) = seq.ThermalImage.GetValueFromSignal(Data_zoom(row,column-5,i));
     tempB(i) = seq.ThermalImage.GetValueFromSignal(Data_zoom(row,column+5,i));
     tempC(i) = seq.ThermalImage.GetValueFromSignal(Data_zoom(row-5,column,i));
     tempD(i) = seq.ThermalImage.GetValueFromSignal(Data_zoom(row+5,column,i));
     %temp2(i)= seq.ThermalImage.GetValueFromSignal(Data_zoom(144,45,i));
     temparray=[temp(i);tempA(i);tempB(i);tempC(i);tempD(i)];
     avgtemp=mean(temparray);
     templist(i)=avgtemp;
     deltatemplist(i)=templist(i)-templist(1);
     %deltatemplist2(i)=temp2(i)-temp2(1);
     
     Temperature(:,:,i)=arrayfun(@(Data_zoom) seq.ThermalImage.GetValueFromEmissivity(0.26,Data_zoom),Data_zoom(:,:,i));
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
    if DeltaTMatrix(40:155,20:130,i) > MaxDelta(40:155,20:130,1)
        MaxDelta(:,:,1)=DeltaTMatrix(:,:,i);
        framenumber=i;
    end 
    i=i+1;
end

%second iteration - use specific pixel to narrow in 
maxlist = deltatemplist(1);
newframenumber=0;
for i=1:zoomframes
    if deltatemplist(i) > maxlist
        maxlist = deltatemplist(i);
        newframenumber=i;
    end 
    i=i+1;
end

finalframenumber=0;
if abs(newframenumber-framenumber)<5
    if mean2(DeltaTMatrix(:,:,newframenumber))-mean2(DeltaTMatrix(:,:,framenumber))>0.2
        finalframenumber=newframenumber;
    else finalframenumber=framenumber;
    end
else
    'error: gap between two possible max delta T frames is large - manual analysis suggested'
end
    
MaxDelta=DeltaTMatrix(:,:,finalframenumber);

deltamax = double(max(max(int8(round(MaxDelta,1,'significant')))));
deltamin = double(min(min(int8(round(MaxDelta,1,'significant')))));
scalestep = deltamax/10;

%% Heat Flux Measurement
%Calculates the heat flux of a image 

Cp=500; %J/kg*C
density=8030; %kg/m3
thickness= .01*(2.54/100); %inches to m
delta_t=0.150; %pulse length (sec)

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
large_diameter = round(diameter*1.1,3,'sig');
r1=diameter/2;
r2=large_diameter/2;
%ellipse [Position] = [Xmin Ymin Width Height] = [columnMin rowMin columns
%rows] 
%Approximate 'E1' from ResearchIR
ellipse=imellipse(gca,[80-r2 90-r1 diameter large_diameter]);
mask=createMask(ellipse,figDeltaT);
avg_all=mean2(mask.*MaxDelta);
avg_mask=mean2(mask);
avg_delta=avg_all/avg_mask; %this is hand-wavy? 

%Approximate 'E2' from ResearchIR
ellipse2=imellipse(gca,[0 0 145 180]);
mask2=createMask(ellipse2,figDeltaT);
avg_all2=mean2(mask.*MaxDelta);
avg_mask2=mean2(mask2);
avg_delta2=avg_all2/avg_mask2; %this is hand-wavy?

%Draw hot spot for deltaT
ellipse3=imellipse(gca,[column row 10 10]);

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
plasmaframe_list=zeros(finalframenumber,1);
for i=2:finalframenumber %know that the first plasma frame must occur before the hottest frame
    if deltatemplist(i)<0.5
        plasmaframe_list(i)=i;
    end
end
%plasma frame where plasma first appears
plasmaframe = max(plasmaframe_list)+1;

%Plot Frame with first plasma
figure;
imagesc(DeltaTMatrix(:,:,plasmaframe), 'CDataMapping','scaled')
caxis([0 10])
colormap jet
c=colorbar;
ylabel(c, 'Delta T [C]')
ax.FontSize = 13;
title('Delta Temperature vs. Camera Pixels','FontSize',13);
xlabel('Pixels','FontSize',13);
ylabel('Pixels','FontSize',13);


%outputs of valueable numbers
'Frame where plasma first appears: ', disp(plasmaframe)
'Frame where deltaT is greatest', disp(finalframenumber)
'Average hot spot deltaT', disp(deltatemplist(finalframenumber))
'Average deltaT (E1)', disp(avg_delta)
'Expanded average deltaT (E2)', disp(avg_delta2)

timeall=(toc)/60
