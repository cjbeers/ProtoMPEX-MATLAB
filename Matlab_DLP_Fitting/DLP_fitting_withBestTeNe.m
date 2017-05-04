%Coded by: Juan and Nischal 
%ORNL

%This code finds the average Ni, and Te of a USER defined set of shots

% =========================================================================
% Connect to Server:
mdsconnect('mpexserver');

%Extract data:
Spool = 9.5;
Shots = [14311 14345]
%Shots =  9300+ [78:-1:76 74:-1:70 68:-1:66 62 32:33 37:38 43:52 55];
%Shots = 8900+[82:83];
%Shots = 9695;
Stem = '\MPEX::TOP.';
Branch = 'MACHOPS1:';
RA = [Stem,Branch];

Data{1} = [RA,'LP_V_RAMP'];
Data{2} = [RA,'TARGET_LP'];
Data{3} = [RA,'PWR_28GHz'];
Data{4} = [Stem,'SHOT_NOTE'];
Data{5} = [Stem,'T_ZERO'];

for s = 1:length(Shots)
    [SHOT(s),~]=mdsopen( 'MPEX',Shots(s) ); % see 8636s
    [Vm{s},~]  = mdsvalue(Data{1});
    [Im{s},~]  = mdsvalue(Data{2});
    [Gyrotron{s},~]  = mdsvalue(Data{3});
    [NOTE{s},~]= mdsvalue(Data{4});
    [T_ZERO{s},~]=mdsvalue(Data{5});
    [t_1{s},~]  = mdsvalue(['DIM_OF(',Data{1},')']);
    [t_2{s},~]  = mdsvalue(['DIM_OF(',Data{2},')']);
    [t_Gyrotron{s},~] = mdsvalue(['DIM_OF(',Data{3},')']);
%     figure
%     hold on
%      plot(t_2{1}, Im{1})
%      plot(t_1{1}, Vm{1})
%     xlim([4.16, 4.32])
%     hold off
%     return
end
%return

T_ZERO %Gives time of shot
NOTE{1,1,1} %Gives notes for the shot

% Create a function where we only need to give the name of the Stem, Branch
% and data name and it returns both the x and y arrays of the data.
% In addition, we could create a function that evaluates all the data or at
% least all the probes and tells you which datas are populated
mdsclose;
mdsdisconnect;
% =========================================================================
% DLP data analysis:
switch Spool
    case 6.5
        L_tip = 1.03/1000;  % [m]
    case 9.5
        L_tip = 1.1/1000;  % [m]
    case 4.5
        L_tip = 1.2/1000;  % [m]
    case 10.5
        L_tip = 1.2/1000;
end
D_tip = 0.254/1000; % [m]
rp = D_tip/2; % [m]

AreaType = 1;
switch AreaType
    case 1
        Area = L_tip*pi*D_tip + 0.25*pi*D_tip^2;
    case 2
        Area = 2*L_tip*D_tip;
end

e_c = 1.602e-19;
m_p = 1.6726e-27;
e_0 = 8.854187817*1e-12; % F/m
AMU = 2;

%% Break data into cycles: -------------------------------------------------
% tStart = 4.1615; % [s]
% tEnd = 4.3115;
tStart = 4.16; % [s]
tEnd = 4.32;

for s = 1:length(Shots)
    
    rng = find(t_1{s}>=tStart & t_1{s}<=tEnd);
    t{s} = t_1{s}(rng);
    
    % Apply correct scale factors to data:
    
    Vm{s} = 22*Vm{s}(rng);
    if 1
        Im{s} = sgolay_t(Im{s},3,7);
    end
    Im{s} = -2*Im{s}(rng)/142.5; % 150 Ohms resistor and a 2:1 voltage divider
    tm = 2;
    
    [locs,~] = peakseek(abs(Vm{s}),211);
    for c = 1:(length(locs)-1)
        I{s}{c} = Im{s}(locs(c):locs(c+1));
        V{s}{c} = Vm{s}(locs(c):locs(c+1));
        
        switch tm
            case 1
                time{s}(c) = ( t{s}(locs(c)) + t{s}(locs(c+1)) )/2;
            case 2
                time{s}(c) = t{s}(locs(c));
        end
        
    end
    
    x0 = [30e-3,2,0,0,0];
    
    %% Fitting routine: --------------------------------------------------------
    for c = 1:length(V{s})
        A1 = V{s}{c};
        A2 = I{s}{c};
        res = @(x)   ( x(1)*tanh((A1-x(4))/x(2)) + (x(3)*(A1-x(4))) + x(5) ) - A2;
        Ifit{s}{c} = @(x)   x(1)*tanh((A1-x(4))/x(2)) + (x(3)*(A1-x(4))) + x(5);
        [x1{s}(:,c),ssq,cnt] = LMFnlsq(res,x0,'MaxIter',5);
    end
    
    Te{s} = real( x1{s}(2,:) )/2;
    Isat{s} = real( x1{s}(1,:) );
    Cs{s} = sqrt( e_c*Te{s}/(AMU*m_p) );
    Ni{s} = real( Isat{s}./(0.61*e_c*Area*Cs{s}) );
    Ld{s} = real( sqrt( e_0*Te{s}./(Ni{s}*e_c) ) );% Debye length
    Xi{s} = rp./Ld{s};
end

%%
t_HD_Gather_Start = 4.28;
t_HD_Gather_End   = 4.31;

t_LD_Gather_Start = 4.16;
t_LD_Gather_End   = 4.19;

for s = 1:length(Shots)
    
    rng2{s} = find( time{s}>=t_HD_Gather_Start & time{s}<=t_HD_Gather_End );
    Ni_HD(s) = mean(Ni{s}(rng2{s}));
    Te_HD(s) = mean(Te{s}(rng2{s}));
    
    rng3{s} = find( time{s}>=t_LD_Gather_Start & time{s}<=t_LD_Gather_End );
    Ni_LD(s) = mean( Ni{s}(rng3{s}) );
    Te_LD(s) = mean( Te{s}(rng3{s}) );
end

% =========================================================================
%% Plot data:

figure; C = ['k','r','g','b','k','r','g','b', 'k','r','g','b', 'k','r','g','b', 'k','r','g','b','k','r','g','b', 'k','r','g','b', 'k','r','g','b', 'k','r','g','b','k','r','g','b', 'k','r','g','b', 'k','r','g','b', 'k','r','g','b','k','r','g','b', 'k','r','g','b', 'k','r','g','b', 'k','r','g','b'];
subplot(3,1,1); hold on
for s = 1:length(Shots)
    %plot(time{s},Ni{s},C(s))
    plot(time{s},Ni{s},C(s))
end
ax.FontSize = 13;
title('N_{i}','FontSize',12)
ylim([0,10e19])

subplot(3,1,2); hold on
for s = 1:length(Shots)
    plot(time{s},Te{s},C(s))
    % plot(Te{s},C(s))
    %plot(t_Gyrotron{1},Gyrotron{1})
end
ax.FontSize = 13;
title('T_{e}','FontSize',12)
ylim([0,inf])
xlim([4.16,4.32])

subplot(3,1,3); hold on
for s = 1:length(Shots)
    plot(time{s},Ni{s}.*Te{s}*e_c,C(s))
end
ax.FontSize = 13;
title('P_{e}','FontSize',12)
set(gcf,'position',[417 106 574 503])
ylim([0,inf])
xlabel('Time [s]','FontSize', 13)

%% Fit check:
%{
if 1
    s = 1;
    figure; hold on
    plot(t{s},Vm{s})
    plot(t{s},Im{s}*1000)
    
    figure;
    kk = 1;
    for c = 1:25;
        subplot(5,5,c); hold on
        plot(V{s}{c},I{s}{c},'k')
        plot(V{s}{c},Ifit{s}{c}(x1{s}(:,c)),'r')
  
    end
end
%}
% Error analysis within the shot


for s = 1:length(Shots)
    % Temperature
    x1 = Te{s}(40:58);
    % Mean temperature for the most stable Te region for a given shot
    Te1(s) = mean(x1);
    Std_Te = std(x1);     %Standard deviaton
    %Density
    x2 = Ni{s}(48:56);
    % Mean density for the most stable Ne region for a given shot% Standard Error
    Ne1(s)= mean(x2);
    Std_Ne = std(x2);
    
    %Prints values
formatPrint='Te = %1.4g\n';
fprintf(formatPrint, Te1(s))
formatPrint='Std_Te = %1.4g\n';
fprintf(formatPrint, Std_Te)
formatPrint='Ni = %1.4e\n';
fprintf(formatPrint, Ne1(s))
formatPrint='Std_Ni = %1.4e\n';
fprintf(formatPrint, Std_Ne)
end
return


