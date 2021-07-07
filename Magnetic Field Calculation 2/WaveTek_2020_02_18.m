% Programming the Wavetek SG
% clear all
% close all

RFpulseLength = 0.5;
RFStart = 4.15;
RFEnd = RFStart + RFpulseLength;

Ymax = 127;
Ymin = 0  ;

Xmin = 0  ;
Xmax = 255;

Ical = 382.6; % [A/V]

CurrentProgram = 'SairemRamp1s';
CurrentProgram = 9;

blockRate = 167e-3;
Tend = 1/blockRate; %Time (s) for the block rate in WaveTek

switch CurrentProgram
    case 8 %Flat field case
        HeliconCurrent=400; %Amps on Helicon coils
        I = [0,HeliconCurrent,HeliconCurrent,HeliconCurrent,HeliconCurrent,0];
        t = [0,0.5,4.15,4.25,5.2,Tend];
    case 9 % Ramp field case
        I = [0,220,220,650,650,0];
        t = [0,0.5,4.15,4.25,5.2,Tend];
    case 'SairemRamp1s'
        blockRate = 1;
        Tend = 1/blockRate;
        Drive=9; %Amps on Helicon coils
        I = [0,127,127,0,0];
        t = [0,4.15+((8/Tend)/255),4.15+((240/Tend)/255),4.15+((254/Tend)/255),Tend];
end

% Convert the desired current to voltge request level:
V = I/Ical;

% Convert request voltage and time to bits:
Y = V*(Ymax/max(V));
X = t*(Xmax/max(t));

%% Plot data
figure
subplot(2,2,1)
hold on
plot(t,I,'ko-')
line([RFStart,RFStart],[0,1e3])
line([RFEnd,RFEnd],[0,1e3])
box on
title('Current vs time')
grid on

subplot(2,2,2)
plot(t,V,'ko-')
box on
title('Request voltage vs time')
grid on

subplot(2,2,3)
plot(X,Y,'ko-')
title('7 bit amplitude vs address')
xlim([Xmin,Xmax])
grid on

set(gcf,'color','w','Position',[600  60  500  550])

