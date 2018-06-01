%automatic px_per_cm conversion; as desired 
function average_px_per_cm = find_px_per_cm
%##### Load image #####
%close all 
% clear all
% tic
[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.jpg;*.seq;*.ats', 'Choose IR file (jpg) or radiometric sequence (seq)');
videoFileName=[PATHNAME FILENAME];

shotnumber = FILENAME(1:end-4);
shot=double(string(FILENAME(6:end-4)));
%if sandia image: shot = double(string(FILENAME(7:end-4);

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

f0 = 1;
firstplasma=0;
f1 = 58;

%zoom in and shorten the frames - all interesting stuff happens within the
%first 40 @ 50 Hz, 80 @ 100 Hz
zoomframes=100;

Delta_Data_zoom1 = Data(:,:,f1)- Data(:,:,f0);
figure;
image(Delta_Data_zoom1,'CDataMapping','scaled');
colormap jet
c=colorbar;
grid on

title('Click center of upper left screw hole')
[x_s,y_s] = ginput(1);
%ellipse [Position] = [Xmin Ymin Width Height] = [columnMin rowMin columns
%rows]
TC_diameter = 18;
TC_radius = TC_diameter/2;
x_c = x_s +20;
y_c = y_s + 30;
center_plate=[x_c,y_c];
close

%zoom_rect = imrect(gca,[x_c-100 y_c 200 200]);
zoom_x=double(int16(x_c));
zoom_y = double(int16(y_c));

%try to find the edge peak
average_data=zeros(zoomframes,1);
for i=1:zoomframes
    average_data(i)= mean2(Data(zoom_y-80:zoom_y+80,zoom_x-80:zoom_x+80,i));
    i=i+1;
end

average_data_delta=zeros(zoomframes,1);
for i=2:zoomframes
    average_data_delta(i)= average_data(i)-average_data(i-1);
    i=i+1;
end

average_data_delta_list=zeros(zoomframes,1);
j=1;
for i=2:zoomframes-5
   if average_data_delta(i)>3
       average_data_delta_list(j) = i;
       i=i+1;
       j=j+1;
   end
end

[max5, plasma5] = max(average_data_delta);

firstplasma = average_data_delta_list(1);
centerplasma=firstplasma+5;

Delta_Data_zoom2 = Data(zoom_y-80:zoom_y+80,zoom_x-80:zoom_x+80,centerplasma) - Data(zoom_y-80:zoom_y+80,zoom_x-80:zoom_x+80,f0);
figure;
image(Delta_Data_zoom2,'CDataMapping','scaled');
TC_circle = viscircles([x_c y_c],TC_radius);
centerline_horiz = imline(gca, [x_c-5 y_c; x_c+5 y_c]);
centerline_vert = imline(gca, [x_c y_c+5;x_c y_c-5]);
colormap jet
c=colorbar;
grid on

title('Click center of upper left screw hole')
[x1,y1] = ginput(1);
drawnow;

title('Click center of lower left screw hole')
[x2,y2] = ginput(1);
drawnow;

title('Click center of upper right screw hole')
[x3,y3] = ginput(1);
drawnow;
close 

distance_convert1 = sqrt((x1-x2)^2+(y1-y2)^2);
px_per_cm1 = distance_convert1/2.4694;

distance_convert2 = sqrt((x1-x3)^2+(y1-y3)^2);
px_per_cm2 = distance_convert2/2.4694;

distance_convert3 = sqrt((x3-x2)^2+(y3-y2)^2);
px_per_cm3 = (distance_convert3/(sqrt(2)))/2.4694;

average_px_per_cm = (px_per_cm1+px_per_cm2+px_per_cm3)/3;

