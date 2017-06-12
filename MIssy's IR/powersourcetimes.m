%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% EXAMPLE READING SIGNAL DATA %%%%%%%%%%%%%%%%%%%%%%%

function [helicon_start, ech_start,ech_end,ich_start,ich_end] = powersourcetimes(shotnumber)

%*********************
%Connect to the server
%*********************
CODE=mdsconnect('mpexserver.ornl.gov');

%**********************
%Define the shot number
%**********************
SHOT=shotnumber;
%SHOT=14608;
%only uncomment the next two lines when Matlab program re-opened; For first
%run through
% javaaddpath('C:\Program Files\MATLAB\R2017a\java\jar\mdsobjects.jar');
% javaaddpath('C:\Program Files\MATLAB\R2017a\java\jarext\mdsobjects.jar');

%*******************
%Open requested shot
%*******************
[MESSAGE,CODE]=mdsopen('MPEX',SHOT);

%helicon pulse
[helicon_pulse,CODE]=mdsvalue('\MPEX::TOP.MACHOPS1:RF_FWD_PWR',1);
[helicon_time,CODE]=mdsvalue('DIM_OF(\MPEX::TOP.MACHOPS1:RF_FWD_PWR)',1);

helicon_start_list = zeros(length(13000:18000),2);
j=1;
for i = 13000:18000
    if abs(helicon_pulse(i))>0.03
        helicon_start_list(j,1)=helicon_time(i);
        helicon_start_list(j,2)=i;
        j=j+1;
    end
    i=i+1;
end

helicon_start = helicon_start_list(1,1);
helicon_start_i = helicon_start_list(1,2);

%ECH pulse

[ech_pulse,CODE]=mdsvalue('\MPEX::TOP.MACHOPS1:PWR_28GHZ');
[ech_time,CODE]=mdsvalue('DIM_OF(\MPEX::TOP.MACHOPS1:PWR_28GHZ)');

ech_start_list = zeros(length(22000:38000),2);

j=1;
for i = 22000:38000
    if abs(ech_pulse(i))>0.25 && abs(ech_pulse(i))<10
        ech_start_list(j,1)=ech_time(i);
        ech_start_list(j,2)=i;
        j=j+1;
    end
    i=i+1;
end

ech_start = ech_start_list(1,1);
ech_start_i = ech_start_list(1,2);

ech_end_list = zeros(length(22000:38000),2);
k=1;
ech_delta_length = length(ech_start_i:48000);
ech_delta = zeros(ech_delta_length,1);
for i = ech_start_i:48000
    ech_delta(i) = ech_pulse(i)-ech_pulse(i-1);
i=i+1;
end
for i = ech_start_i:48000
    if ech_delta(i)>2 %tells to ignore the spikes in the signal
        ech_delta(i)=0;
    end
    i=i+1;
end

[ech_delta_min ech_end_i] = min(ech_delta);
ech_end = ech_time(ech_end_i);
% ech_end_i = ech_end_list(1,2);
% ech_end = ech_end_list(1,1);



%ich pulse
[ich_pulse,CODE]=mdsvalue('\MPEX::TOP.MACHOPS1:GAS_FLOW_1');
[ich_time,CODE]=mdsvalue('DIM_OF(\MPEX::TOP.MACHOPS1:GAS_FLOW_1)');

ich_start_list = zeros(length(23000:37000),2);
j=1;
for i = 23000:37000
    if ich_pulse(i)>0.045 && ich_pulse(i)<10 %ignores the spikes in signal, if any
        ich_start_list(j,1)=ich_time(i);
        ich_start_list(j,2) = i;
        j=j+1;
    end
    i=i+1;
end
ich_start = ich_start_list(1,1);
ich_start_i = ich_start_list(1,2);

ich_end_list = zeros(length(23000:37000),2);
k=1;
for i = 30000:48000
    if ich_pulse(i)<0.03
        ich_end_list(k,1)=ich_time(i);
        ich_end_list(k,2) = i;
        k=k+1;
    end
    i=i+1;
end
ich_end = min(ich_end_list);
ich_end_i = ich_end(2);
ich_end=ich_end(1);

%ensure that the times are the same size as the pulses 
if length(helicon_time) ~= length(helicon_pulse)
    helicon_time=helicon_time(1:end-1);
end
if length(ech_time) ~= length(ech_pulse)
    ech_time = ech_time(1:end-1);
end
if length(ich_time) ~= length(ich_pulse)
    ich_time = ich_time(1:end-1);
end

figure;
plot(helicon_time,helicon_pulse,ech_time,ech_pulse,ich_time,ich_pulse);
axis([4 4.7 -2 2]);
ax.FontSize = 13;
title([int32(SHOT),'; Power Traces'],'FontSize',13);
xlabel('Time (s)','FontSize',13);
%ylabel('Delta T (deg C)','FontSize',13);
legend('Helicon','ECH','ICH');  
legend('Location','Northwest')


%Coils


%*********************
%Close the opened shot
%*********************
CODE=mdsclose;

%**************************
%Disconnect from the server
%**************************
CODE=mdsdisconnect;
end

%%%%%%%%%%%%%%%%%%%%%%% EXAMPLE READING SIGNAL DATA %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%