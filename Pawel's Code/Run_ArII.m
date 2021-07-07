clc; clearvars; close all;

%%%Setup Data Aquisition and Experimental Parameters%%%%%%%%%%%%%%%%%%%%%%%
%%%Specify the grating here
Grating = 1800;
%%%Specify where the McPherson is centered at
Gear_ratio = 7218; 
lambda0 = Gear_ratio/15-0.5;

%lambda0 = 480.603;
%%%Fiber location
location = ['Spool 10.5 C'; 'Spool 09.5 B'; 'Spool 09.5 C'; 'Spool 09.5 T'; 'Spool 06.5 C' ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Edit the name of the routine (needs to correspond to name of .m file)
Routine  = 'ArII_automate_v3';
%%%Write the comments here. 
ANALYSIS = ['Data Analysis Routine used: ' Routine '.m'];
DATE     = ['Date when analysis was performed: ' datestr(date)]; 
NOTES    = 'Write the notes from the experimental day here';
USER     = ['Analysis performed by ' getenv('username') ' on ' getenv('computername')];
comments = [ANALYSIS newline DATE newline NOTES newline USER];

%shots = (22822:1:22822);
shots = 18385:1:18408;

for jj = 1:length(shots)
    shot = shots(jj);
    
    %%%Write setup data to MPEX tree here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mdsopen('mpex', shot);
    % Write the comments here
    SETUP = 'ANALYZED.MCPHERSON.SETUP:';
    path = [SETUP 'COMMENTS'];
    mdsput(path, '$', comments);
%     % Write the grating
%     path = [SETUP 'GRATING'];
%     mdsput(path, '$', Grating);
%     % Write the gear ration
%     path = [SETUP 'GEAR_RAT'];
%     mdsput(path, '$', Gear_ratio);
%     % Write center lambda
%     path = [SETUP 'LMDA_CENT'];
%     mdsput(path, '$', lambda0);
%     % Write fiber's locations
%     path = [SETUP 'FIBER_LOC'];
%     mdsput(path, '$', location);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    try
        eval(Routine)
        %%%Write processed data to MPEX tree here%%%%%%%%%%%%%%%%%%%%%%%%%%
        mdsopen('mpex', shot);
        %%%
        DATAPATH = 'ANALYZED.MCPHERSON:';
        path = [DATAPATH 'TI'];
        mdsput(path, '$', Ti);
        %%%
        path = [DATAPATH 'TI_ERR'];
        mdsput(path, '$', Err_Ti);
        %%%
        path = [DATAPATH 'S2N'];
        mdsput(path, '$', Sig2N);
        %%%
        path = [DATAPATH 'RESNORM'];
        mdsput(path, '$', RN);
        %%%
        path = [DATAPATH 'LMDA'];
        mdsput(path, '$', XX);
        %%%
        path = [DATAPATH 'LMDA_SHFT'];
        mdsput(path, '$', LS);
        %%%
        path = [DATAPATH 'INT_PRCSD'];
        mdsput(path, '$', Signal_Data);
        %%%
        path = [DATAPATH  'TIME'];
        mdsput(path, '$', time_vec);
        %%%
        path = [SETUP  'FRAME_RTE'];
        mdsput(path, '$', frame_rate);
        %%%
        path = [SETUP  'FRAME_NUM'];
        mdsput(path, '$', dim_size(3));
        %%%
        path = [DATAPATH 'INT_FIT'];
        mdsput(path, '$', Signal_Fit);
        
%         path = [SETUP 'FIBER_LOC'];
%         mdsput(path, '$', location);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    catch
        mdsopen('mpex', shot);
        SETUP = 'ANALYZED.MCPHERSON.SETUP:';
        path = [SETUP 'COMMENTS'];
        mdsput(path, '$', ['Error: ' lasterr]); 
        mdsclose
    end
end 