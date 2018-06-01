function [Ni,Te,Isat,time,Ifit,Ip,Vp,tm,Vsweep,Isweep,GlitchFlag,SSQres,StdRes,StdResNorm]...
    = DLP_fit_V5_6(Config,shotlist,DataAddress)
% New version of DLP_fit_V5 (V5_6), created on March 19th 2018, JF Caneses
% A new output (Isat), has been added in order to allow usage of this code
% with the swept Flux probe

% New version of DLP_fit_V5 (V5_5), created on Jan 8th 2018, JF Caneses

% Changed relative to v5_4
% To avoid different number of elements on the output variables we
% explicitly declare the outputs to be [0] everytime a "GlitchFlag" is
% created and perfomrs a "continue" command.
% To reduce code size and given the lack of usage of the LaFramboise method
% (the magnetization in ProtoMPEX precludes the use of such method) we have
% removed the Laframboise code section

% Changed relative to v5_3
% we have had some issues with dealing with NaNs. in order to expedite the
% calculation of the data, we will neglect any current sweep that has a
% NaN, we will not attempt to replace with it good data.

% Changes relative to v5_2
% In order to asses better the quality of the fit and therefore to provide
% the user a method by which bad shots or bad fits can be skipped, we have
% added additional metrics.

% Changes relative to V5: (2017-04-28)
% 1 - In order to deal with data sets that have a lot
% of spurious values caused by numerical errors in the digitizers we have
% added a "try-catch" routine to identify which shot and at what
% time during the plasma pulse did the spurious value occured. Moreover, it plots the
% raw data (V and I) so that the user can identify a more suitable time
% period to use for the DLP code with no spurious values
% 2 - We have added a routine that centers the I data. this is useful when
% there are considerable offsets on the digitized data produced probably by
% the RF intereference on the coaxial cables. 
% 3- It was observed that the fitting routine halts with the presence of
% NaNs so we have added a code that removes them all. in addition, we are
% recording the precence of glitches or NaNs on an output variable called
% GlitchFlag.
% ####################################
% Item 2 requires an additional Config variable to be defined by the user
% Config.Center_I and Config.Center_V with binary values 0 or 1
% #####################################

% NOTES from v2
% We noticed that some charactersitcs were asymmetric by about 20%. this
% mean that we had to offset the hyperbolic tan to fit the characteristic.
% in order to account for the larger ion saturation current, we are now
% adding this offset to the ion saturation current calculated by the fit.
% see line 197 and 201
% this also provides an estimate that is very close to that of Rick's code
% which uses the an asymmetric probe equation.

% NOTES on v5:
% this code builds on v4 where we find the offset on the ion saturation
% current and add it to the effective ion saturation current. we use the
% largest value of the Isat to estimate the density. 
% In some cases, the one can clearly see that the ion saturation current at
% the begining of the pulse is clearly very symmetric. so the asymmetry
% observed later in the pulse has to be due to each probe tip sample as
% slightly different plasma density. for this reason we need to calculate
% and upper and lower bound of the density.

% MODEL3 (Laframboise) has not been updated to include the effects of the
% offset

% #########################################################################
% INPUTS:
% #########################################################################
% We define the following: 
% D_Vd: Digitized data stored in the MDSplus tree associated
%       with the DLP voltage. "D" stands for "Data", "V" for "Voltage" and "d" for "digitized", 
%       It is limited to +- 5 V
% D_Id: Digitized data stored in the MDSplus tree associated
%       with the DLP current. "I" stands for "current".
        % It is limited to +- 5 V
% v_Vb: Voltage output of the DLP box associated with the DLP voltage, "b" stands for "box"
% v_Ib: Voltage output of the DLP box associated with the DLP current
% Vp:   True voltage swept by the DLP in [V]
% Ip:   True current produced by the DLP in [A]s

% CONFIG:
%       .tStart; Defines the when to start analysing the DLP sweeps
%       .tEnd;   Defines the when to stop analysing the DLP sweeps
%       .V_Att;  Attenuation value at the input of digitizer, Vb = V_Att*Vd
%       .I_Att;  Attenuation value at the input of digitizer, Ib = I_Att*Id
%       .V_cal;  Vp = V_cal(1)*Output voltage of DLP box + V_cal(2)
%       .I_cal;  Ip = I_cal*Ip = Current at DLP output
%       .FilterDataInput; Filter input data with savitsky Golay filter order 3 frame size 7
%       .TimeMode;  Effective time of sweep, (1) start time of sweep or (2)inflection/mean time of sweep
%       .AMU; Effective ion mass
%       .AreaType; Select [1 and 2] Cylidrical surface area or [3] Projected Area
%           1: Assume Isat is constant, Symmetric DLP based on hyperbolic tangent
%           2: Assume Isat varies linearly with voltage, Symmetric DLP based on hyperbolic tangent
%           3: Assumme Isat given by Laframboise curves, Symmetric DLP
% SHOTLIST         for example shots [8516:8520];
% DATADDRESS{1}    for example \MPEX::TOP.MACHOPS1:LP_V_RAMP
% DATADDRESS{2}    for example \MPEX::TOP.MACHOPS1:TARGET_LP

% #########################################################################
% OUTPUTS:
% #########################################################################
% we define the following
% "s" is the index identifying each shot from "shotlist:
% "N" is the total number of shots in "shotlist"
% "c" is the index identifying each sweep cycle in the "sth" shot
% "M" as the total number of sweep cycles in a given shot "s"
% 
% SHOTLIST: vector of size "N" identifying the shot numbers to analyse
% NI: Ion density, structure with "N" arrays, each array corresponds to each
% element in shotlist. Each array contains "M" number of Ni values associated with each sweep in the "sth" shot
% TE: Electron temperature. Structure same as Ni
% TIME: Time in seconds associated with each value of Ni and Te, same structure as Ni
% IFIT: Structure of "N" arrays, Curve fitted to the probe current in Amperes for each sweep.
% IM: Struture of "N" arrays, True value of current at the probe in Amperes for the entire shot
% VM: Struture of "N" arrays, True value of voltage at the probe in Volts for entire shot
% TM: Struture of "N" arrays, time associated with each data point in Im and Vm
% VSWEEP: Struture of NxM arrays, each array contains the true voltage swept by the DLP on the "s" shot and the
% "c" sweep cycle.
% ISWEWP: Struture of NxM arrays, each array contains the true current swept by the DLP on the "s" shot and the
% "c" sweep cycle.

% #########################################################################
% Configuration variables:
% #########################################################################
tStart = Config.tStart;
tEnd = Config.tEnd;
% Attenuators at the digitizers
V_Att = Config.V_Att;
I_Att = Config.I_Att;
% Calibration factor of the DLP box
V_cal = Config.V_cal;
I_cal = Config.I_cal; 
Filter = Config.FilterDataInput; % 0 or 1, filter data with S-G filter
TimeMode = Config.TimeMode;
AMU = Config.AMU; % Select ion mass
AreaType = Config.AreaType; % [1 and 2] Cylidrical surface area, [3] Projected Area
FitFunction = Config.FitFunction;
L_tip = Config.L_tip; % [m] Probe tip length
D_tip = Config.D_tip; % [m] Probe tip diameter
rp = D_tip/2; % [m]

% #########################################################################
% Select current collecting area 
% #########################################################################
switch AreaType
    case 1 % Cylindrical Surface area (Weakly magnetized ions relative to probe size)
        Area = L_tip*pi*D_tip + 0.25*pi*D_tip^2;
    case 2 % Cylindrical Surface area but no cap
        Area = L_tip*pi*D_tip;
    case 3 % Projected Area (Strongly magnetized ions relative to probe size)
        Area = 2*L_tip*D_tip;
end

% #########################################################################
% Import and analyse data
% #########################################################################
mdsconnect('mpexserver'); 
[D_Vd,t_v] = my_mdsvalue_v2(shotlist,DataAddress(1));
[D_Id,~] = my_mdsvalue_v2(shotlist,DataAddress(2));
% D_Vd and D_Id represent the digitized Data for the voltage (V) and current (I) respectively
% The letter "d" in D_Vd and D_Id stands for "digitized".

% Check if error occured when loading the data. The most common errors are:
% 1- Either V or I signal got corrupted, output is "Java exception..."
% 2- the time trace is not present or is corrupted
FlagV = isstr(D_Vd{1});
FlagI = isstr(D_Id{1});
FlagT = isstr(t_v{1});
if FlagV || FlagI || FlagT 
    % V signal was not properly acquired
    Ni = []; Te = []; time = []; Ifit = []; 
    Ip = []; Vp = []; tm = []; Vsweep = []; Isweep = []; 
    GlitchFlag = []; SSQres = []; StdRes = []; StdResNorm = [];
    error('At least one signal not acquired properly')
end


for s = 1:length(shotlist)
    
    rng = find(t_v{s}>=tStart & t_v{s}<=tEnd);
    tm{s} = t_v{s}(rng);

    % Apply callibration factors to data:
    % Factor need to convert DLP box output voltage to Probe voltage is V_cal(1)
    % Offset Voltage in DLP box is associated is given by V_cal(2)
    % Voltage division in Digitizer box is given by V_att
    Vp{s} =    V_Att*V_cal(1)*D_Vd{s}(rng) + V_cal(2); 
            
    % Current measuring resistor in DLP box is given by -1/I_cal(1)
    % Offset current in DLP box is associated with I_cal(2)
    % Voltage division in Digitizer box is given by I_att
    Ip{s} = I_Att*(D_Id{s}(rng) + I_cal(2))/I_cal(1);
    
        if Filter
                Ip{s} = sgolay_t(Ip{s},3,Config.SGF);
                Vp{s} = sgolay_t(Vp{s},3,Config.SGF);        
        end
    
    % Define the sweep cycles:
            [locs,~] = peakseek(abs(Vp{s}),211);
    % Finds inflextion points/peaks of the Voltage signal in order to divide data
    % in to individual sweeps.
    % "locs" stands for locations
    % 211 tells the code to identify peaks that are at least 211 points
    % apart.
    % In future version of this code, stronger constraints may be used
    % to better identify individual sweeps, for example:
    % (1) Do consecutive voltage and current peaks change sign. If not, then this peak may be
    % noise.
    % (2) Is the magnitude of the nth peak very small compared to the
    % average value. If so, this peak may be noise.
    
      for c = 1:(length(locs)-1);
        Isweep{s}{c} = Ip{s}(locs(c):locs(c+1));
        Vsweep{s}{c} = Vp{s}(locs(c):locs(c+1));
        
        % It is known that some digitizer channels are probe to glitches.
        % these cause the DLP fit program to halt. the Glitches come in two
        % main flavours: (1) NaNs and (2) distorted traces
        
            % Center the data if needed
            if Config.Center_V 
                MaxVp = max(Vsweep{s}{c});
                MinVp = min(Vsweep{s}{c});
                MeanVp = 0.5*(MaxVp+MinVp);
                Vsweep{s}{c} = Vsweep{s}{c} - MeanVp; 
            end
            if Config.Center_I 
                MaxIp = max(Isweep{s}{c});
                MinIp = min(Isweep{s}{c});
                MeanIp = 0.5*(MaxIp+MinIp);
                Isweep{s}{c} = Isweep{s}{c} - MeanIp; 
            end

        switch TimeMode
            case 1 % Average time of sweep
                time{s}(c) = ( tm{s}(locs(c)) + tm{s}(locs(c+1)) )/2;
            case 2 % time at start of sweep
                time{s}(c) = tm{s}(locs(c));
        end
      end
      
    % Fitting routine: --------------------------------------------------------
    % Create a variable to record the presence of the glitches
    GlitchFlag{s} = zeros(size(Vsweep{s}));
    
    for c = 1:length(Vsweep{s})

        if sum(isnan(Vsweep{s}{c})) >= 1 || sum(isnan(Isweep{s}{c})) >= 1
            GlitchFlag{s}(c) = 1;
            % This flag is to indicate which sweeps contain NaNs in the
            % raw data. they are skipped so as to not cause problems in the
            % fitting process
            % Since the "c" sweep of the "s" shot has glitches, need to skip it.
            % Lets assign it a null solution to the "cth" element
                        Ifit{s}{c} = [0]; Te{s}(c) = [0]; Cs{s}(c) = [0];
                        % Upper bound:
                        Isat{s}{1}(c) = [0]; Ni{s}{1}(c) = [0]; Ld{s}{1}(c) = [0]; Xi{s}{1}(c) = [0];
                        % Lower bound:
                        Isat{s}{2}(c) = [0]; Ni{s}{2}(c) = [0]; Ld{s}{2}(c) = [0]; Xi{s}{2}(c) = [0];
                        % Metrics:
                        StdRes{s}(c) = [0]; StdResNorm{s}(c) = [0];
             continue
        end

        % Functions
        % NOTE on LMFnlsq:
        % it takes the residual function "res(C)" and initial guess "C0" as inputs to
        % the nonlinear fitting process. the residual function is actually
        % a function of the following form res(C,ydata,xdata).
        
              % Initial guess:
       C0 = [0.8*max(Isweep{s}{c}),4,0,0,0];
       % C0(1) = Isat_0
       % C0(2) = 2*Te_0
              
             switch FitFunction
                case 1 % Model: assume Isat is constant                   
                        % Residual of the "sth" sweep 
                       res = @(C) Model_1(C,Vsweep{s}{c}) - Isweep{s}{c};
                       % Least squares fit:
                       % Strategy to deal with glitches:
                       % - Try if data works "as is"
                       % - if not, catch the error. this is most likely due
                       %   To a glitch on the voltage signal. Use the
                       %   previous succesfull voltage sweep
                       
                       %===================================================
                       [C1{s}(:,c),SSQres{s}(c),~] = LMFnlsq(res,C0,'MaxIter',5);
                       StdRes{s}(c) = sqrt(SSQres{s}(c)/length(Isweep{s}{c}));
                       StdResNorm{s}(c) = StdRes{s}(c)/max(Isweep{s}{c});
                       %===================================================
                       Ifit{s}{c} = Model_1(C1{s}(:,c),Vsweep{s}{c});
                       
                        Te{s} = real(C1{s}(2,:))/2;
                        Cs{s} = sqrt(e_c*Te{s}/(AMU*m_p)); % Sound speed
                        % Upper bound:
                        Isat{s}{1} = real(C1{s}(1,:)) + abs((C1{s}(5,:)));
                        Ni{s}{1} = real(Isat{s}{1}./(0.61*e_c*Area*Cs{s}));
                        Ld{s}{1} = real(sqrt(e_0*Te{s}./(Ni{s}{1}*e_c)));% Debye length
                        Xi{s}{1} = rp./Ld{s}{1};
                        
                        % Lower bound:
                        Isat{s}{2} = real(C1{s}(1,:)) - abs((C1{s}(5,:)));  
                        Ni{s}{2} = real(Isat{s}{2}./(0.61*e_c*Area*Cs{s}));
                        Ld{s}{2} = real(sqrt(e_0*Te{s}./(Ni{s}{2}*e_c)));% Debye length
                        Xi{s}{2} = rp./Ld{s}{2};
                       
                case 2 % Model: assume Isat varies linearly with voltage
                       % Residual function for the "sth" sweep 
                       res = @(C) Model_2(C,Vsweep{s}{c}) - Isweep{s}{c};
                       % Least squares fit:
                       % Strategy to deal with glitches:
                       % - Try if data works "as is"
                       % - if not, catch the error. this is most likely due
                       %   To a glitch on the voltage signal. Use the
                       %   previous succesfull voltage sweep
                       
                       %===================================================
                       try
                            [C1{s}(:,c),SSQres{s}(c),~] = LMFnlsq(res,C0,'MaxIter',5);
                       catch
                            C1{s}(:,c)= [1;1;1;1;1]*1e10;
                            SSQres{s}(c) = [1]*1e10;
                       end
                       StdRes{s}(c) = sqrt(SSQres{s}(c)/length(Isweep{s}{c}));
                       StdResNorm{s}(c) = StdRes{s}(c)/max(Isweep{s}{c});
                       %===================================================
                       Ifit{s}{c} = Model_2(C1{s}(:,c),Vsweep{s}{c});
                       
                        Te{s} = real(C1{s}(2,:))/2;
                        Cs{s} = sqrt(e_c*Te{s}/(AMU*m_p)); % Sound speed
                        % Upper bound:
                        Isat{s}{1} = real(C1{s}(1,:)) + abs((C1{s}(5,:)));
                        Ni{s}{1} = real(Isat{s}{1}./(0.61*e_c*Area*Cs{s}));
                        Ld{s}{1} = real(sqrt(e_0*Te{s}./(Ni{s}{1}*e_c)));% Debye length
                        Xi{s}{1} = rp./Ld{s}{1};
                        
                        % Lower bound:
                        Isat{s}{2} = real(C1{s}(1,:)) - abs((C1{s}(5,:)));  
                        Ni{s}{2} = real(Isat{s}{2}./(0.61*e_c*Area*Cs{s}));
                        Ld{s}{2} = real(sqrt(e_0*Te{s}./(Ni{s}{2}*e_c)));% Debye length
                        Xi{s}{2} = rp./Ld{s}{2};
                                              
            end

    end

end
mdsdisconnect;
end

function Ydata = Model_1(C,Xdata)
         Ydata =  C(1)*tanh((Xdata-C(4))/C(2))                       + C(5); 
end
function Ydata = Model_2(C,Xdata)
if C(3)<0
    C(3) = 0;
end
         Ydata =  C(1)*tanh((Xdata-C(4))/C(2)) + (C(3)*(Xdata-C(4))) + C(5); 
end

