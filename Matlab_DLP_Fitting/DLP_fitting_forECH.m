%Coded by: Nishal Kafle, Editted by: Josh Beers
%ORNL

%Code takes two shot numbers and plots their DLP ion density and electon
%temperature as a function of time during the shot
%Code outputs a graph showing electron temp alongside of the EBW pulse

ccc
% =========================================================================
% Connect to Server:
mdsconnect('mpexserver');

%Extract data:
Spool = 9.5;
%for Shots = 9179:9189
%Shots =  9300+ [78:-1:76 74:-1:70 68:-1:66 62 32:33 37:38 43:52 55];
%%Viewing multiple shots
%Shots = [9693, 9632]; %With and without EBW power
Shots = 9730; % Single Shot viewing
Stem = '\MPEX::TOP.';
Branch = 'MACHOPS1:';
RA = [Stem,Branch];

Data{1} = [RA,'LP_V_RAMP'];
Data{2} = [RA,'TARGET_LP'];
Data{3} = [RA,'PWR_28GHz'];
Data{4} = [Stem,'SHOT_NOTE'];


for s = 1:length(Shots)
    [SHOT(s),~]=mdsopen( 'MPEX',Shots(s) ); % see 8636s
    [Vm{s},~]  = mdsvalue(Data{1});
    [Im{s},~]  = mdsvalue(Data{2});
    [Gyrotron{s},~]  = mdsvalue(Data{3});
    [NOTE{s},~]= mdsvalue(Data{4});
    [t_1{s},~]  = mdsvalue(['DIM_OF(',Data{1},')']);
    [t_2{s},~]  = mdsvalue(['DIM_OF(',Data{2},')']);
    [t_Gyrotron{s},~] = mdsvalue(['DIM_OF(',Data{3},')']);
     
    %{
    figure
    hold on
      plot(t_2{1}, Im{1})
      plot(t_1{1}, Vm{1})
     xlim([4.16, 4.32])
     hold off
    %}
    
end
NOTE{1,1,1}
%return
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
        L_tip = 1.3/1000;  % [m]
    case 9.5
        L_tip = 1.2/1000;  % [m]
    case 4.5
        L_tip = 1.2/1000;  % [m]
    case 10.5
        L_tip = .9/1000;
end
D_tip = 0.25/1000; % [m]
rp = D_tip/2; % [m]

AreaType = 2;
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

% Break data into cycles: -------------------------------------------------
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
    
    % Fitting routine: --------------------------------------------------------
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

if length(Te) == 2
    
figure; C = ['k','r','g','b','k','r','g','b', 'k','r','g','b', 'k','r','g','b', 'k','r','g','b','k','r','g','b', 'k','r','g','b', 'k','r','g','b', 'k','r','g','b','k','r','g','b', 'k','r','g','b', 'k','r','g','b', 'k','r','g','b','k','r','g','b', 'k','r','g','b', 'k','r','g','b', 'k','r','g','b'];
%subplot(3,1,1); hold on
for s = 1:length(Shots)
    %plot(time{s},Ni{s},C(s))
    plot(time{s},Ni{s},C(s))
end
title('N_i')
ylim([0,inf])
hold off

ECH=figure();
%subplot(3,1,2); hold on
for s = 1:length(Shots)
    %plot(time{s},Te{s})
    plot(time{1},Te{1}, 'black')
    hold on
    plot(time{2},Te{2}, '--black')
    title('Te vs. Time', 'FontSize', 10)
    ylim([0,10])
    xlim([4.2,4.3])
    ylabel('Te [eV]', 'FontSize', 10)
    xlabel('Time [s]', 'FontSize', 10)
 
    %plot(Te{s},C(s))
    plot(t_Gyrotron{1},Gyrotron{1}, '-oblack', 'LineWidth', 0.1)
    
    
end
   legend('With EBW', 'Without EBW','Gyrotron Power Trace')
    yyaxis right
    ylabel('Proportion to Gyrotron Power', 'FontSize', 10)
    ylim(gca);
    ax=gca;
    ax.YColor = [0,0,0];
    hold off 

figure();
%subplot(3,1,3); hold on
for s = 1:length(Shots)
    plot(time{s},Ni{s}.*Te{s}*e_c,C(s))
end
title('P_e', 'FontSize', 10)
set(gcf,'position',[417 106 574 503])
ylim([0,inf])
hold off
close figure 1 figure 3

elseif length(Te)>2 || length(Te)==1
    figure; C = ['k','r','g','b','k','r','g','b', 'k','r','g','b', 'k','r','g','b', 'k','r','g','b','k','r','g','b', 'k','r','g','b', 'k','r','g','b', 'k','r','g','b','k','r','g','b', 'k','r','g','b', 'k','r','g','b', 'k','r','g','b','k','r','g','b', 'k','r','g','b', 'k','r','g','b', 'k','r','g','b'];
subplot(3,1,1); hold on
for s = 1:length(Shots)
    %plot(time{s},Ni{s},C(s))
    plot(time{s},Ni{s},C(s))
end
title('N_i')
ylim([0,10e19])

subplot(3,1,2); hold on
for s = 1:length(Shots)
    plot(time{s},Te{s},C(s))
    % plot(Te{s},C(s))
    plot(t_Gyrotron{1},Gyrotron{1}, '-red','LineWidth', 1)
end
title('Te')
ylim([0,inf])
xlim([4.16,4.32])

subplot(3,1,3); hold on
for s = 1:length(Shots)
    plot(time{s},Ni{s}.*Te{s}*e_c,C(s))
end
title('P_e')
set(gcf,'position',[417 106 574 503])
ylim([0,inf])

elseif isempty(Te)
        disp('Error in code')
end
    
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
%
if length(Te) ==1
for s = 1:length(Shots)
    % Temperature
    x1 = Te{s}(40:58);
    % Mean temperature for the most stable Te region for a given shot
    Te1(s) = mean(x1)
    Std_Te = std(x1)      %Standard deviaton
    %Density
    x2 = Ni{s}(48:58);
    % Mean density for the most stable Ne region for a given shot% Standard Error
    Ne1(s)= mean(x2)
    Std_Ne = std(x2)
end
return
%
end

