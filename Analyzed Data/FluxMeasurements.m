cleanup

shotlist = 15749; %April 7th 2017, MP 10.5 on-axis
Resis = 1;
TimeStart=65000/2;
TimeEnd=90000/2;


area1=((1.02/1000))^2*0.25*pi;
%area2=((0.0/1000))^2*0.25*pi;
%area3=((0.77/1000))^2*0.25*pi;
%area4=((0.77/1000))^2*0.25*pi;

% Acquiring Isat current from MP tip 1 and tip 2
Stem = '\MPEX::TOP.';
Branch = 'MACHOPS1:';
RootAddress = [Stem,Branch];

DataAddress{1} = [RootAddress,'TARGET_LP']; %
%DataAddress{2} = [RootAddress,'LP_V_RAMP']; %

[f_1,tf1]   = my_mdsvalue_v2(shotlist,DataAddress(1)); % [I] signal from digitizer from Tip A
%[f_2,tf2]   = my_mdsvalue_v2(shotlist,DataAddress(2)); % [V] signal from digitizer from Tip A

%%
figure
plot(tf1{1}(1:end-1), f_1{1}(1:end)/Resis, 'black')
ylim([-0.5,0.5])
%title(['Shot ', num2str(shotlist), ' Current vs. time'])
ylabel('Current [A]')
xlabel('Time [s]')
% hold on;
% plot(tf2{1}(1:end-1), f_2{1}(1:end)/10, 'm')
% legend('IFP', 'n/a')

figure

plot(f_2{1}(:),f_1{1}(:))
