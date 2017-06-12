%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% EXAMPLE READING SIGNAL DATA %%%%%%%%%%%%%%%%%%%%%%%

function helicon_start = heliconsourcetimes(shotnumber)

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

%ensure that the times are the same size as the pulses 
if length(helicon_time) ~= length(helicon_pulse)
    helicon_time=helicon_time(1:end-1);
end


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


