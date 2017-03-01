%##### Load image #####
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

figure(1)
imshow(im,[])
figure(2)
    %get the temperature for position 10,10
    h = plot(1:1:seq.Count,seq.ThermalImage.GetValueFromSignal(im(10,10)));
    title('Temp at position 10,10') 
    ylabel('C')
    xlabel('Frame')
if(seq.Count > 1)
    %pre allocate
    temp = NaN * ones(seq.Count,1);
    while(seq.Next())
        img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
        im = double(img);
        %get the temperature for position 10,10
        temp(seq.SelectedIndex) = seq.ThermalImage.GetValueFromSignal(im(10,10));
        
        %plot temp vs frames 
        set(h,'XData',1:1:seq.Count)
        set(h,'YData',temp)

        figure(1)
        imshow(im,[]);
        drawnow;
    end
    figure(3)
    %temp vs time plot
    count1 = timeseries(temp(:,1),[0:(double(1)/double(seq.FrameRate)):(double(seq.Count)/double(seq.FrameRate) - 1/double(seq.FrameRate))]);
    count1.Name = 'Temp (C) at position 10,10';
    count1.TimeInfo.Units = 'Sec';
    plot(count1,':b')

end