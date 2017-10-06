%Graphite Target with Embedded DLPs and Ion Flux Probe code to find ion
%saturation current, plot it, and calcualte the flux to the probe tip



shotlist = 15951; % April 7th 2017, MP 10.5 on-axis
Resis = 17;
TimeStart=65000/2;
TimeEnd=90000/2;

area1=((1.285/1000))^2*0.25*pi;
area2=((0.0/1000))^2*0.25*pi;
area3=((0.77/1000))^2*0.25*pi;
area4=((0.77/1000))^2*0.25*pi;

% Acquiring Isat current from MP tip 1 and tip 2
Stem = '\MPEX::TOP.';
Branch = 'MACHOPS1:';
RootAddress = [Stem,Branch];

% DataAddress{1} = [RootAddress,'INT_4MM_1']; % %2A
% DataAddress{2} = [RootAddress,'INT_4MM_2']; % %2B
DataAddress{1} = [RootAddress,'INT_2MM_1']; % 3A
%DataAddress{4} = [RootAddress,'INT_2MM_2']; % 3B
%DataAddress{1} = [RootAddress,'TargetDLP1_I']; % %IFP
%DataAddress{2} = [RootAddress,'TargetDLP1_V']; % %
%DataAddress{3} = [RootAddress,'TargetDLP2_I']; % 2A
%DataAddress{4} = [RootAddress,'TargetDLP2_V']; % 2B
%DataAddress{5} = [RootAddress,'Target_IFP']; % IFP
%DataAddress{3} = [RootAddress,'TARGET_LP']; % I
%DataAddress{4} = [RootAddress,'LP_V_RAMP']; % V

[f_1,tf1]   = my_mdsvalue_v2(shotlist,DataAddress(1)); % [V] signal from digitizer from Tip A
% [f_2,tf2]   = my_mdsvalue_v2(shotlist,DataAddress(2)); % [V] signal from digitizer from Tip B
% [f_3,tf3]   = my_mdsvalue_v2(shotlist,DataAddress(3)); % [V] signal from digitizer from Tip A
% [f_4,tf4]   = my_mdsvalue_v2(shotlist,DataAddress(4)); % [V] signal from digitizer from Tip B
% [f_5,tf5]   = my_mdsvalue_v2(shotlist,DataAddress(5)); % [V] signal from digitizer from IFP
%[Isat,tisat] = my_mdsvalue_v2(shotlist,DataAddress(6));
%[V,tv] = my_mdsvalue_v2(shotlist,DataAddress(7));

Datasize=size(f_1{1});

%time=(TimeEnd-TimeStart)/(50000);

e=1.602E-19;
Current=(f_1{1}(:))/Resis;

Flux1=Current/(e*area1);
%Fuence1=mean(Flux1)/time;

Heliconpower=load('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2017_08_02\Shot15951_HeliconPower');

%% Plotting

figure;
subplot(4,1,1); hold on
plot(tf1{1}(1:end-1), Flux1, 'black', 'lineWidth', 3)
%ax = gca;
set(gca,'Fontsize', 13,'FontWeight','Normal')
ylabel('Ion Flux [m^{-2}s^{-1}]','FontSize',13,'Rotation',90,'FontWeight','Normal')
title('Ion Flux of Shot 15951','FontSize',15,'Rotation',0,'FontWeight','Normal')
%title('Ion Flux [#/m^{-3}]', 'FontSize', 13);
%xlabel('Time [s]', 'FontSize', 13);
%ylabel('Ion Flux [#/m^{-3}]', 'FontSize', 13);
xlim([4.2 4.35]);
ylim([0 6E23]);
yticks([0 2E23 4E23 6E23])
set(gca,'xcolor',[1 1 1])


subplot(4,1,2); hold on
plot(Heliconpower(:,1), Heliconpower(:,2), 'black', 'lineWidth', 3)
ax = gca;
set(gca,'Fontsize', 13)
ylabel('Helicon Power [kW]','FontSize',13,'Rotation',90)
%title('Helicon Power [kW]', 'FontSize', 13);
%ylabel('Helicon Power [kW]', 'FontSize', 13);
xlim([4.2 4.35]);
ylim([0 125]);
yticks([0 25 50 75 100 125])
set(gca,'xcolor',[1 1 1])

subplot(4,1,3); hold on
for s = 1:sizeshotlist(1,2)
    %plot(time{s},ni{s}{1},C{s},'lineWidth',1);
    %plot(time{s},ni{s}{2},C{s},'lineWidth',1);
    h(s) = plot(time{s},Ni{s},C{s},'lineWidth',3);
    
end
set(gca,'Fontsize', 13)
ylabel('n_e [m^{-3}]','FontSize',13,'Rotation',90)
%legend(h,['DLP ',num2str(DLP)],'location','NorthEast')
%legend(h,['TDLP3'],'location','NorthEast')
%set(gca,'PlotBoxAspectRatio',[1 1 1])
ylim([0,6e19])
yticks([0 2E19 4E19 6E19])
xlim([4.2,4.35])
set(gca,'xcolor',[1 1 1])

subplot(4,1,4); hold on
for s = 1:sizeshotlist(1,2)
    h(s) = plot(time{s},Te{s},C{s},'lineWidth',3);
    L{s} = [num2str(shotlist(s)),' ,t=',num2str(t{s}(10:14))];
    hold on
    %plot(t_28{s},EBW{s})
    set(gca,'Fontsize',13)
end
%legend(h,L,'location','NorthWest')
ylabel('T_e [eV]','FontSize',13,'Rotation',90)
ylim([0,6])
xlim([4.2,4.35])
set(gca,'Fontsize', 13)
Pressure=e_c.*Ni{s}.*Te{s};
xlabel('Time [s]', 'FontSize', 13);
yticks([0 2 4 6])
