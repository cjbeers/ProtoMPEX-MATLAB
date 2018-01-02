%##### Load image #####

close all 
clear all
 tic
PATHNAME = 'Y:\IR_Camera\2017_12_15\';
FILENAME = 'Shot-018663seq';

framerate = 100; %%Hz

videoFileName=[PATHNAME FILENAME];

shotnumber = FILENAME(1:end-3);
shot=double(string(FILENAME(6:end-3)));
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
difData = diff(Data,1,3);
%i_h_start = 50;
i_h_start = find(max(max(difData))==max(max(max(difData))) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure(1)
%pcolor(Data(:,:,i_h_start)-Data(:,:,1))
%shading interp
%colorbar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mdsconnect('mpexserver.ornl.gov');
mdsopen('MPEX',shot);
h_power = mdsvalue('\MPEX::TOP.MACHOPS1:RF_FWD_PWR',1);
exp_time = mdsvalue('DIM_OF(\MPEX::TOP.MACHOPS1:RF_FWD_PWR)',1);
exp_time = exp_time(1:end-1);

ech_power=mdsvalue('\MPEX::TOP.MACHOPS1:PWR_28GHZ');
ich_power=mdsvalue('\MPEX::TOP.MACHOPS1:GAS_FLOW_1');

H_power = 1e5;

%%%%%TIMING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_h_on = min(exp_time(-h_power>0.05));
t_h_off = max(exp_time(-h_power>0.05));
h = size(Data);
t_IR = h(3)/framerate.*linspace(0,1,h(3))-(i_h_start-1)/framerate+t_h_on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure
%plot(exp_time,(H_power/min(h_power).*h_power)/1e3,'k','linewidth',3)
%hold on
%plot(exp_time,ech_power,'r','linewidth',3)
%plot(exp_time,ich_power,'g','linewidth',3)
%legend('Helicon','ECH','ICH')
%xlabel('time [s]')
%ylabel('power [kW]')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%helicon_start = heliconsourcetimes(shot);
%[helicon_start, ech_start_time,ech_end_time,ich_start_time,ich_end_time] = powersourcetimes(shot);
%[helicon_start, ech_start_time,ech_end_time] = powersourcetimes(shot);

toc
IRshot_Analysis_pawel_PLOT
