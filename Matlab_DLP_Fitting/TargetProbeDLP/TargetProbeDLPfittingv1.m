
cleanup
ShotInfo.Shotlist = [14340];
ShotInfo.SizeShotlist = size(ShotInfo.Shotlist);

DLPInfo1.DLPnum=2;
DLPInfo2.DLPnum=3;
DLPInfo1.DLPnumBox=1;
DLPInfo2.DLPnumBox=2;

% -------------------------
ShotInfo.tStart = 4.2; % [s]
ShotInfo.tEnd = 4.305;

% Acquiring Ne and Te data
Stem = '\MPEX::TOP.';
Branch = 'MACHOPS1:';
ShotInfo.RootAddress = [Stem,Branch];
ShotInfo.DataAddress1{3} = [ShotInfo.RootAddress, 'PWR_28GHZ'];
ShotInfo.DataAddress2{3} = [ShotInfo.RootAddress, 'PWR_28GHZ'];
[ShotInfo.EBWData,ShotInfo.t28]= my_mdsvalue_v3(ShotInfo.Shotlist,ShotInfo.DataAddress1(3));

%--------------------------
switch DLPInfo1.DLPnum
    case 1
        DLPInfo1.radius = 0.8; %mm
    case 2
        DLPInfo1.radius = 0.83; %mm
    case 3
        DLPInfo1.radius = 0.77; %mm
    case 4
        DLPInfo1.radius = 0.86; %mm
    otherwise
        DLPInfo1.radius = 0; %mm
        disp('Error in DLPnum1')
end
DLPInfo1.Area=pi*(DLPInfo1.radius/1000)^2; %m

ShotInfo.DataAddress1{1} = [ShotInfo.RootAddress,'LP_V_RAMP']; % V
ShotInfo.DataAddress1{2} = [ShotInfo.RootAddress,'TARGET_LP']; % I


switch DLPInfo2.DLPnum
   case 1
        DLPInfo2.radius = 0.8; %mm
    case 2
        DLPInfo2.radius = 0.83; %mm
    case 3
        DLPInfo2.radius = 0.77; %mm
    case 4
        DLPInfo2.radius = 0.86; %mm
    otherwise
        DLPInfo2.radius = 0; %mm
        disp('Error in DLPnum2')
end
DLPInfo2.Area=pi*(DLPInfo2.radius/1000)^2; %m

ShotInfo.DataAddress2{1} = [ShotInfo.RootAddress,'LP_V_RAMP']; % V
ShotInfo.DataAddress2{2} = [ShotInfo.RootAddress,'TARGET_LP']; % I


switch DLPInfo1.DLPnumBox
    case 1
        DLPInfo1.V_Att1=1;
        DLPInfo1.I_Att1=1;
     
        DLPInfo1.V_cal1=1;
        DLPInfo1.I_cal1=1;
    case 2
        DLPInfo1.V_Att1=1;
        DLPInfo1.I_Att1=1;
        
        DLPInfo1.V_cal1=1;
        DLPInfo1.I_cal1=1;
    otherwise
        DLPInfo1.V_Att1=0;
        DLPInfo1.I_Att1=0;
       
        DLPInfo1.V_cal1=0;
        DLPInfo1.I_cal1=0;
       
       disp('Error in DLPNum1Box')
end
       
switch DLPInfo2.DLPnumBox
    case 1
        DLPInfo2.V_Att2=1;
        DLPInfo2.I_Att2=1;
        
        DLPInfo2.V_cal2=1;
        DLPInfo2.I_cal2=1;
    case 2
        DLPInfo2.V_Att2=1;
        DLPInfo2.I_Att2=1;
        
        DLPInfo2.V_cal2=1;
        DLPInfo2.I_cal2=1;
    otherwise
        DLPInfo2.V_Att2=0;
        DLPInfo2.I_Att2=0;
       
        DLPInfo2.V_cal2=0;
        DLPInfo2.I_cal2=0;
       
       disp('Error in DLPNum2Box')
end  


DLPInfo1.FilterDataInput = 1; DLPInfo2.FilterDataInput = 1; % Filter input data with savitsky Golay filter order 3 frame size 7
DLPInfo1.SGF = 7; DLPInfo2.SGF = 7;
DLPInfo1.TimeMode = 2; DLPInfo2.TimeMode = 2;% Effective time of sweep, (1) start of ramp or (2) mean time of ramp
DLPInfo1.AMU = 2; DLPInfo2.AMU = 2;% Ion mass in AMU

DLPInfo1.FitFunction = 2; DLPInfo2.FitFunction = 2; 
DLPInfo1.AreaType = 4; DLPInfo2.AreaType = 4;% Case 4 for flush mounted probes
DLPInfo1.e_c = 1.602e-19; DLPInfo2.e_c = 1.602e-19;
DLPInfo1.m_p = 1.6726e-27; DLPInfo2.m_p = 1.6726e-27;
DLPInfo1.e_0 = 8.854187817*1e-12; DLPInfo2.e_0 = 8.854187817*1e-12;
e_c = 1.602e-19;

%%
[ni,Te,time,Ifit,Ip,Vp,tm,Vsweep,Isweep] = DLP_fit_V5(DLPInfo1,ShotInfo.Shotlist,ShotInfo.DataAddress);

for s = 1:ShotInfo.SizeShotlist(1,2)
    Ni{s} = 0.5*(ni{s}{1} + ni{s}{2});
end

       