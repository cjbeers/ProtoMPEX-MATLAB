
% Shots=26300;
% mdsconnect('mpexserver');
% Stem = '\MPEX::TOP.';
% Stem = '\MPEX::TOP.';
% Branch = 'MACHOPS1:';
% RA = [Stem,Branch];
% Data{4} = [Stem,'SHOT_NOTE'];
% s=1;
% [SHOT(s),~]=mdsopen( 'MPEX',Shots(s) ); % see 8636s
% [NOTE{s},~]= mdsvalue(Data{4});
% NOTE{1,1,1} %Gives notes for the shot
% mdsclose;
% mdsdisconnect;

Shots = 26300;
Stem = '\MPEX::TOP.';
Branch = 'MACHOPS1:';
RA = [Stem,Branch];

Data{1} = [RA,'RF_FWD_PWR'];
Data{2} = [Stem,'ANALYZED.POWER:PWR_28'];
Data{3} = [Stem,'fscope:tube17:pmt_volt'];
Data{4} = [Stem,'SHOT_NOTE'];
Data{5} = [Stem,'T_ZERO'];
Data{6} = [Stem,'ANALYZED.POWER:TIME'];

for s = 1:length(Shots)
    [SHOT(s),~]=mdsopen( 'MPEX',Shots(s) );
    [Hel{s},~]  = mdsvalue(Data{1});
    [ECH{s},~]  = mdsvalue(Data{2});
    [Tube17{s},~]  = mdsvalue(Data{3});
    [NOTE{s},~]= mdsvalue(Data{4});
    [T_ZERO{s},~]=mdsvalue(Data{5});
    [t_PWR{s},~]=mdsvalue(Data{6});
     [t_Hel{s},~]  = mdsvalue(['DIM_OF(',Data{1},')']);
%     [t_ECH{s},~]  = mdsvalue(['DIM_OF(',Data{2},')']);
    [t_Tube17{s},~] = mdsvalue(['DIM_OF(',Data{3},')']);
end

mdsclose;
mdsdisconnect;

%% Plots

figure
plot(t_Hel{1,1}(1:end-1,1),Hel{1,1}(:)*85, 'k')
hold on
plot(t_PWR{1},ECH{1}/1e3,'r')
ylabel('Power [kW]')
xlabel('Time [s]')
xlim([4 5.2])
ylim([0 inf])
yyaxis right
plot(t_Tube17{1,1}(:),Tube17{1,1}(:),'m')
%plot(Time,Line_Norm_Rad_Smooth,'m')
ylabel('PMT Raw Voltage [V]')
ylim([0 inf])
set(gca,'ycolor','m') 
legend('Helicon Power','ECH Power','Tube 17 Voltage','Location','north')



