function theodor_prep_rep(shot)

%shot = input('enter shot number ');

FILENAME = ' ' + string(shot) + '.mat';

A = exist(FILENAME);

if A ==0
    FILENAME = string(shot) + '.mat';
end
    
load(FILENAME);

FILENAME = strtrim(FILENAME);  %trim leading space from shot number if it exists  
FILENAME = char(FILENAME);
shotnumber = FILENAME(1:end-16);
%convert frames to time: 

delta_t=0.01;

frame2time = zeros(zoomframes,1);
    for i = 1:plasmaframe
        frame2time(i) = helicon_start-(plasmaframe-i)*delta_t;
        i=i+1;
    end
    for i = plasmaframe:zoomframes
        frame2time(i) = helicon_start+(i-plasmaframe)*delta_t;
        i=i+1;
    end

%Choose vertical line trace:

MaxDelta = Frame;

slice = input('Horizontal cut (0) or vertical cut (1)?   ');
if slice == 0
    MaxDelta_rot = rot90(MaxDelta);
    figure;
    figDeltaT=imagesc(MaxDelta_rot, 'CDataMapping','scaled');
    colormap jet
    c=colorbar;
    ylabel(c, 'Delta T [C]')
    ax.FontSize = 13;
    title([shotnumber,'; Delta Temperature vs. Camera Pixels'],'FontSize',13);
    xlabel('Pixels','FontSize',13);
    ylabel('Pixels','FontSize',13);
    
    Temperature_rot = rot90(Temperature);
    
    horizontal_slice = input('What pixel along the frame width do you want to sample? '); 
    Temperature_line = Temperature_rot(:,horizontal_slice,:);
    
    save(FILENAME(1:end-4) + "_theodor",'shotnumber','zoomframes','px_per_cm','Temperature','Temperature_line','frame2time');
   
end
if slice ==1 
        
    figure;
    figDeltaT=imagesc(MaxDelta, 'CDataMapping','scaled');
    colormap jet
    c=colorbar;
    ylabel(c, 'Delta T [C]')
    ax.FontSize = 13;
    title([shotnumber,'; Delta Temperature vs. Camera Pixels'],'FontSize',13);
    xlabel('Pixels','FontSize',13);
    ylabel('Pixels','FontSize',13);
    
    vertical_slice = input('What pixel along the frame width do you want to sample? ');
    Temperature_line = Temperature(:,vertical_slice,:);

    save(FILENAME(1:end-4) + "_theodor",'shotnumber','zoomframes','px_per_cm','Temperature','Temperature_line','frame2time');
end
end

