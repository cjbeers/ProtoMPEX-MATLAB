function [Ni,Te,time,Ifit,Ip,Vp,tm,Vsweep,Isweep] = DLP_fit_V5(Config,shotlist,DataAddress)
% Changes relative to V4:
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
e_c = Config.e_c;
m_p = Config.m_p;
e_0 = Config.e_0;
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
mdsconnect('mpexserver') 
[D_Vd,t_v] = my_mdsvalue_v2(shotlist,DataAddress(1));
[D_Id,~] = my_mdsvalue_v2(shotlist,DataAddress(2));
% D_Vd and D_Id represent the digitized Data for the voltage (V) and current (I) respectively
% The letter "d" in D_Vd and D_Id stands for "digitized".

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
    
      for c = 1:(length(locs)-1)
        Isweep{s}{c} = Ip{s}(locs(c):locs(c+1));
        Vsweep{s}{c} = Vp{s}(locs(c):locs(c+1));

        switch TimeMode
            case 1 % Average time of sweep
                time{s}(c) = ( tm{s}(locs(c)) + tm{s}(locs(c+1)) )/2;
            case 2 % time at start of sweep
                time{s}(c) = tm{s}(locs(c));
        end
      end
      
    % Fitting routine: --------------------------------------------------------
    for c = 1:length(Vsweep{s})
        % V and I of the "sth" sweep
        xdata = Vsweep{s}{c};
        ydata = Isweep{s}{c};
        
        if c == 10
            c;
        end
        
        % Functions
        % NOTE on LMFnlsq:
        % it takes the residual function "res(C)" and initial guess "C0" as inputs to
        % the nonlinear fitting process. the residual function is actually
        % a function of the following form res(C,ydata,xdata).
        
              % Initial guess:
       C0 = [0.8*max(ydata),4,0,0,0];
       % C0(1) = Isat_0
       % C0(2) = 2*Te_0
              
             switch FitFunction
                case 1 % Model: assume Isat is constant                   
                        % Residual of the "sth" sweep 
                       res = @(C) Model_1(C,xdata) - ydata;
                       % Least squares fit:
                       [C1{s}(:,c),~,~] = LMFnlsq(res,C0,'MaxIter',5);
                       Ifit{s}{c} = Model_1(C1{s}(:,c),xdata);
                       
                        Te{s} = real(C1{s}(2,:))/2;
                        Cs{s} = sqrt(e_c*Te{s}/(AMU*m_p)); % Sound speed
                        
                        % Upper bound:
                        Isat{s}{1} = real(C1{s}(1,:))   - (C1{s}(5,:));
                        Ni{s}{1} = real(Isat{s}{1}./(0.61*e_c*Area*Cs{s}));
                        Ld{s}{1} = real(sqrt(e_0*Te{s}./(Ni{s}{1}*e_c)));% Debye length
                        Xi{s}{1} = rp./Ld{s}{1};
                        
                        % Lower bound:
                        Isat{s}{2} = real(C1{s}(1,:))   + (C1{s}(5,:));  
                        Ni{s}{2} = real(Isat{s}{2}./(0.61*e_c*Area*Cs{s}));
                        Ld{s}{2} = real(sqrt(e_0*Te{s}./(Ni{s}{2}*e_c)));% Debye length
                        Xi{s}{2} = rp./Ld{s}{2};
                       
                case 2 % Model: assume Isat varies linearly with voltage
                       % Residual function for the "sth" sweep 
                       res = @(C) Model_2(C,xdata) - ydata;
                       % Least squares fit:
                       [C1{s}(:,c),~,~] = LMFnlsq(res,C0,'MaxIter',5);
                       Ifit{s}{c} = Model_2(C1{s}(:,c),xdata);
                       
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
                       
                case 3 % Model: Isat varies according to Laframboise curves
                    % Residual function for the "sth" sweep 
                       C0 = [0.6*max(ydata),2.2,0,0,0];
                       res = @(C) Model_3(C,xdata,Config) - ydata;
                       % Least squares fit:
                       [C1{s}(:,c),~,~] = LMFnlsq(res,C0,'MaxIter',5);
                       Ifit{s}{c} = Model_3(C1{s}(:,c),xdata,Config);
                       
                        Te{s} = real(C1{s}(2,:));
                        Isat{s} = real(C1{s}(1,:));
                        Cs{s} = sqrt(e_c*Te{s}/(AMU*m_p)); % Sound speed
                        Ni{s} = real(Isat{s}./(e_c*Area*Cs{s}*sqrt(1/(2*pi))));
                        Ld{s} = real(sqrt(e_0*Te{s}./(Ni{s}*e_c)));% Debye length
                        Xi{s} = rp./Ld{s};
            end

    end

end
mdsdisconnect
end

function Ydata = Model_1(C,Xdata)
         Ydata =  C(1)*tanh((Xdata-C(4))/C(2))                       + C(5); 
end
function Ydata = Model_2(C,Xdata)
         Ydata =  C(1)*tanh((Xdata-C(4))/C(2)) + (C(3)*(Xdata-C(4))) + C(5); 
end
function Ydata = Model_3(C,Xdata,CONFIG)
    % C are the unknown coeficients
    % Xdata is the input voltage to the probe
    % Rp = 0.5*Config.D_tip is the probe radius in [m]
    % Lp = Config.L_tip is the probe length in [m]
    % Am = Config.AMU is the atomic mass in AMU
    % 'a' and 'b' are Steinbruchel's coefficients:
    
    Rp = 0.5*CONFIG.D_tip;
    D_tip = 2*Rp;
    L_tip = CONFIG.L_tip;
    Am = CONFIG.AMU;
    AreaType = CONFIG.AreaType;
    
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    switch AreaType
    case 1 % Cylindrical Surface area (Weakly magnetized ions relative to probe size)
        Area = L_tip*pi*D_tip + 0.25*pi*D_tip^2;
    case 2 % Cylindrical Surface area but no cap
        Area = L_tip*pi*D_tip;
    case 3 % Projected Area (Strongly magnetized ions relative to probe size)
        Area = 2*L_tip*D_tip;
    end
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    
    Vp = Xdata;
    Te0 = C(2);
    Isat0 = C(1); % Initial guess for the Isat
    Cs0 = sqrt(e_c*Te0/(m_p*Am));
    Ni0 = Isat0./(e_c*Area*Cs0*sqrt(1/(2*pi))); % Ni based on the definition given in Beal's 2012 paper eq6.
    Ld0 = sqrt(e_0*Te0/(Ni0*e_c));% Debye length
    ETA = Rp./Ld0; % rp/Ldebye checked from DLP_v10 code (MAGPIE)
        
    %Ni = (e_0/e_c)*Te0*(ETA/(Rp/1000))^2;
    %Ap = 2*pi*Rp*L_tip; % Area of probe in [m^2]
    
%     Ni = (e_0/e_c)*Te*(ETA/(Rp/1000))^2;
%     Ap = 2*pi*Rp*L_tip; % Area of probe in [m^2]
%     Cs = sqrt(e_c*Te/(m_p*Am));
%     I_0 = Ni*e_c*Area*Cs*sqrt(1/(2*pi));

    if ETA < 3
        b = 0.5;
        a = 1.15;
    elseif ETA > 50
        ETA = 50;
    end
    
    a = 1.18 - (0.0008*(ETA.^1.35));
    b = 0.0684 + (0.722 + (0.928*ETA)).^-0.729;
    
    
    V1 = V1calc(Te0,Vp,a,b,Am);
        
   
    B1 = (a*(-V1./Te0).^b);
    B2 = (a*(-(V1+Vp)./Te0).^b);
    B3 = exp(Vp./Te0);
    B4 = B3 + 1;
   
    Ydata = Isat0*( (B1.*B3) - B2 )./B4 ;
end

function V = V1calc(T,Vp,a1,b1,AM)
% Approximation using thin sheath:
% Te, Vm, a, b

% in the following we use I(v) as "potential dependant currents"

% The floating potential in the abscence of I(v) is given by:
Vf = T*log(0.61*sqrt(2*pi*m_e/(AM*m_p))); % Te*ln(I+/Ie)
% The application of a potential Vp to a DP without I(v) leads to the
% following potential of a probe tip:
V1thin = Vf + T.*log(2./(1+exp(Vp./T)));  % This comes from thin sheath double probe theory 

% in order to include the effect of I(v) we use a recursive approximation
% where we include I(v) but initialize the expression using the potential
% of a probe without I(v);

% RECURSIVE APPROXIMATION:
% In the abcence of I(v), the addition of the ion
% currents from both probes leads to 2*I+. but when we need to add I(v)
% using Laframboise analysis we get the following:

% A2 is the sum of the I(v) for probe 1 and 2:
A2 = (a1*(-V1thin./T).^b1) + (a1*(-(V1thin+Vp)./T).^b1);
V1a = T*log(A2/2) + V1thin;
A2 = (a1*(-V1a./T).^b1) + (a1*(-(V1a+Vp)./T).^b1);
V = T*log(A2/2) + V1thin;
end
