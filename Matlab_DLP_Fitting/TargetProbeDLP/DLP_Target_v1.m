
shotlist = [14340];
DLPnum=1;
DLPProbe=1;

sizeshotlist=size(shotlist);

% -------------------------
Config.tStart = 4.2; % [s]
Config.tEnd = 4.305;

% Acquiring Ne and Te data
Stem = '\MPEX::TOP.';
Branch = 'MACHOPS1:';
RootAddress = [Stem,Branch];
DataAddress{3} = [RootAddress, 'PWR_28GHZ'];
[EBW,t_28]= my_mdsvalue_v3(shotlist,DataAddress(3));



% AddressType='s'; % s for standard
% CalType='niso'; % niso for not isolated- "Standard DLP circuit box", 
% CalType = 'iso' for isolated - "Transformer box"
% ----------


switch DLPnum
    case 1
        DLP = 11.51;
        Config.L_tip = 0/1000;
        Config.D_tip = 0.8/1000; % [m]
    case 2
        DLP = 11.52;
        Config.L_tip = 0/1000;
        Config.D_tip = 0.83/1000; % [m]
    case 3
        DLP = 11.53;
        Config.L_tip = 0/1000;  
        Config.D_tip = 0.77/1000; % [m]
    case 4
        DLP = 11.54;
        Config.L_tip = 0/1000;
        Config.D_tip = 0.86/1000; % [m]
    otherwise
        disp('Error in DLPnum')
end

if DLPProbe == 1
    
DataAddress{1} = [RootAddress,'LP_V_RAMP']; % V
DataAddress{2} = [RootAddress,'TARGET_LP']; % I
Config.V_Att = 2;  % Output voltage of DLP box (Voltage) = V_Att*Digitized data 
Config.I_Att = 5;  % Output voltage of DLP box (Current) = I_att*Digitized data
Config.V_cal = [(0.46e-3)^-1,0]; % Voltage output of DLP = V_cal(1)*Output voltage of DLP box + V_cal(2) %  2.1739e+03
Config.I_cal = [-1,0]; % Current output of DLP = (I_cal(2) + Output voltage of DLP box)/Ical(1)

elseif DLPProbe == 2
    
DataAddress{1} = [RootAddress,'INT_4MM_1']; % V
DataAddress{2} = [RootAddress,'INT_4MM_2']; % I
Config.V_Att = 1;  % Output voltage of DLP box (Voltage) = V_Att*Digitized data 
Config.I_Att = 1;  % Output voltage of DLP box (Current) = I_att*Digitized data
Config.V_cal = [(0.46e-3)^-1,0]; % Voltage output of DLP = V_cal(1)*Output voltage of DLP box + V_cal(2) %  2.1739e+03
Config.I_cal = [-1,0]; % Current output of DLP = (I_cal(2) + Output voltage of DLP box)/Ical(1)

end

Config.FilterDataInput = 1; % Filter input data with savitsky Golay filter order 3 frame size 7
Config.SGF = 7;
Config.TimeMode = 2; % Effective time of sweep, (1) start of ramp or (2) mean time of ramp
Config.AMU = 2; % Ion mass in AMU

Config.FitFunction = 2; 
Config.AreaType = 1; % Cylindrical + cap
Config.e_c = 1.602e-19;
Config.m_p = 1.6726e-27;
Config.e_0 = 8.854187817*1e-12;
e_c = 1.602e-19;

[ni,Te,time,Ifit,Ip,Vp,tm,Vsweep,Isweep] = DLP_fit_V5(Config,shotlist,DataAddress);

for s = 1:sizeshotlist(1,2)
    Ni{s} = 0.5*(ni{s}{1} + ni{s}{2});
end

% note, 

%% Plots
%close all
C = {'k','r','bl','g','m','k:','r:','bl:','g:','m:','k','r','bl','g','m','k:','r:','bl:','g:','m:','k','r','bl','g','m','k:','r:','bl:','g:','m:'};
t = t_zero(shotlist);

figure; 
subplot(2,2,1); hold on
for s = 1:sizeshotlist(1,2)
    plot(time{s},ni{s}{1},C{s},'lineWidth',1);
    plot(time{s},ni{s}{2},C{s},'lineWidth',1);
    h(s) = plot(time{s},Ni{s},C{s},'lineWidth',2);
    
end
set(gca,'Fontsize', 20,'FontWeight','Bold')
title('$ n_e $ $ [m^{-3}] $','interpreter','Latex','FontSize',13,'Rotation',0)
legend(h,['DLP ',num2str(DLP)],'location','NorthEast')
%set(gca,'PlotBoxAspectRatio',[1 1 1])
ylim([0,7e19])
xlim([4.2,4.3])
grid on

subplot(2,2,2); hold on
for s = 1:sizeshotlist(1,2)
    h(s) = plot(time{s},Te{s},C{s},'lineWidth',2);
    L{s} = [num2str(shotlist(s)),' ,t=',num2str(t{s}(10:14))];
    hold on
    %plot(t_28{s},EBW{s})
    set(gca,'Fontsize',20,'FontWeight','Bold')
end
legend(h,L,'location','NorthWest')
title('$ T_e $ $ [eV] $','interpreter','Latex','FontSize',13,'Rotation',0)
ylim([0,12])
xlim([4.2,4.3])
set(gca,'Fontsize', 20,'FontWeight','Bold')
grid on
Pressure=e_c.*Ni{s}.*Te{s};
subplot(2,2,3); hold on
for s = 1:sizeshotlist(1,2)
    plot(time{s},e_c.*Ni{s}.*Te{s},C{s},'lineWidth',2)
end
ylim([0,40])
xlim([4.2,4.3])
title('$ P_e $ $ [Pa] $','interpreter','Latex','FontSize',13,'Rotation',0)

set(findobj('-Property','YTick'),'box','on')
set(gcf,'color','w')
set(gca,'Fontsize', 20,'FontWeight','Bold')

if 0
    figure; hold on
    for s = 1:sizeshotlist(1,2)
    plot(tm{s},Vp{s})
    h(s) = plot(tm{s},Ip{s}*1000);
    ylim([-100,100])
    xlim([4.15,4.32])
    grid on
    end
    plot(t_28{s},EBW{s})
    legend(h,num2str(shotlist'))
end

if 0  
    figure;
    for c = 1:25
        subplot(5,5,c); hold on
        plot(Vsweep{s}{c},Isweep{s}{c}*1e3,'k')
        plot(Vsweep{s}{c},Ifit{s}{c}*1e3,'r')
        ht = title(['T_e: ',num2str(Te{s}(c))]);
        set(ht,'FontSize',10); grid on
    end
    
    figure;
        for c = 26:50
        subplot(5,5,c-25); hold on
        plot(Vsweep{s}{c},Isweep{s}{c}*1e3,'k')
        plot(Vsweep{s}{c},Ifit{s}{c}*1e3,'r')
        ht = title(['T_e: ',num2str(Te{s}(c))]);
        set(ht,'FontSize',10); grid on
        end
        
    figure;
        for c = 51:75
        subplot(5,5,c-50); hold on
        plot(Vsweep{s}{c},Isweep{s}{c}*1e3,'k')
        plot(Vsweep{s}{c},Ifit{s}{c}*1e3,'r')
        ht = title(['T_e: ',num2str(Te{s}(c))]);
        set(ht,'FontSize',10); grid on
        end    
end

for s = 1:sizeshotlist(1,2)
    % Temperature
    x1 = Te{s}(10:18);
    x11 = Te{s}(22:39);
    % Mean temperature for the most stable Te region for a given shot
    Te1(s) = mean(x1);
    Te11(s) = mean(x11);
    %Standard deviaton
    Std_Te1 = std(x1);
    Std_Te=Std_Te1;
    Std_Te11 = std(x11);
    %Density
    x2= Ni{s}(10:18);
    x21 = Ni{s}(22:39);
    % Mean density for the most stable Ne region for a given shot% Standard Error
    Ne1(s)= mean(x2);
    Ne11(s)= mean(x21);
    Std_Ne1 = std(x2);
    Std_Ne =Std_Ne1;
    Std_Ne11 = std(x21);
    PlasmaPressure=mean(Pressure(30:39));
    
    %Prints values
formatPrint='Te1 = %1.4g\n';
fprintf(formatPrint, Te1(s))
formatPrint='Te2 = %1.4g\n';
fprintf(formatPrint, Te11(s))
formatPrint='Std_Te1 = %1.4g\n';
fprintf(formatPrint, Std_Te1)
formatPrint='Std_Te2 = %1.4g\n';
fprintf(formatPrint, Std_Te11)
formatPrint='Ni1 = %1.4e\n';
fprintf(formatPrint, Ne1(s))
formatPrint='Ni2 = %1.4e\n';
fprintf(formatPrint, Ne11(s))
formatPrint='Std_Ni1 = %1.4e\n';
fprintf(formatPrint, Std_Ne1)
formatPrint='Std_Ni2 = %1.4e\n';
fprintf(formatPrint, Std_Ne11)
formatPrint='Pa = %1.4g\n';
fprintf(formatPrint, PlasmaPressure)
end

return
