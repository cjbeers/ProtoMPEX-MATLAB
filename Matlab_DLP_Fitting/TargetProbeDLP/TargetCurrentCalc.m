%Graphite Target with Embedded DLPs and Ion Flux Probe code to find ion
%saturation current, plot it, and calcualte the flux to the probe tip

cleanup

shotlist = 18175; % April 7th 2017, MP 10.5 on-axis
Resis = 25.5;
TimeStart=65000/2;
TimeEnd=90000/2;

area1=((1.02/1000))^2*0.25*pi;
area2=((0.77/1000))^2*0.25*pi;
area3=((0.77/1000))^2*0.25*pi;
area4=((0.86/1000))^2*0.25*pi;

% Acquiring Isat current from MP tip 1 and tip 2
Stem = '\MPEX::TOP.';
Branch = 'MACHOPS1:';
RootAddress = [Stem,Branch];

DataAddress{1} = [RootAddress,'INT_4mm_1']; % %2A
DataAddress{2} = [RootAddress,'INT_4MM_2']; % %2B
DataAddress{3} = [RootAddress,'INT_2MM_2']; % 3A
DataAddress{4} = [RootAddress,'INT_2MM_2']; % 3B
%DataAddress{1} = [RootAddress,'TargetDLP1_I']; % %IFP
%DataAddress{2} = [RootAddress,'TargetDLP1_V']; % %
%DataAddress{3} = [RootAddress,'TargetDLP2_I']; % 2A
%DataAddress{4} = [RootAddress,'TargetDLP2_V']; % 2B
%DataAddress{5} = [RootAddress,'Target_IFP']; % IFP
%DataAddress{3} = [RootAddress,'TARGET_LP']; % I
%DataAddress{4} = [RootAddress,'LP_V_RAMP']; % V

[f_1,tf1]   = my_mdsvalue_v2(shotlist,DataAddress(1)); % [V] signal from digitizer from Tip A
[f_2,tf2]   = my_mdsvalue_v2(shotlist,DataAddress(2)); % [V] signal from digitizer from Tip B
[f_3,tf3]   = my_mdsvalue_v2(shotlist,DataAddress(3)); % [V] signal from digitizer from Tip A
[f_4,tf4]   = my_mdsvalue_v2(shotlist,DataAddress(4)); % [V] signal from digitizer from Tip B
% [f_5,tf5]   = my_mdsvalue_v2(shotlist,DataAddress(5)); % [V] signal from digitizer from IFP
%[Isat,tisat] = my_mdsvalue_v2(shotlist,DataAddress(6));
%[V,tv] = my_mdsvalue_v2(shotlist,DataAddress(7));

Datasize=size(f_1{1});

%% Plotting
figure
plot(tf1{1}(1:end-1), f_1{1}(1:end)/Resis, 'black')
ylim([-1,1])
title(['Shot ', num2str(shotlist), ' Current vs. time'])
ylabel('Current [A]')
xlabel('Time [s]')
% hold on;
% plot(tf2{1}(1:end-1), f_2{1}(1:end)/10, 'm')
% legend('IFP', 'n/a')


figure
plot(tf2{1}(1:end-1), f_2{1}(1:end)/Resis, 'black')
ylim([-0.5,0.5])
title(['Shot ', num2str(shotlist), ' Current vs. time'])
ylabel('Current [A]')
xlabel('Time [s]')

figure
plot(tf3{1}(1:end-1), f_3{1}(1:end)/Resis, 'black')
ylim([-0.5,0.5])
title(['Shot ', num2str(shotlist), ' Current vs. time'])
ylabel('Current [A]')
xlabel('Time [s]')
% hold on;
% plot(tf4{1}(1:end-1), f_4{1}(1:end)/10, 'm')
% legend('2A', '2B')

figure
plot(tf4{1}(1:end-1), f_4{1}(1:end)/Resis, 'black')
ylim([-0.5,0.5])
title(['Shot ', num2str(shotlist), ' Current vs. time'])
ylabel('Current [A]')
xlabel('Time [s]')


%% Calc flux to target
aa = 1; bb=1; cc=1; dd=1;
IonCurrentArray1(1,1)=0;
IonCurrentArray2(1,1)=0;
IonCurrentArray3(1,1)=0;
IonCurrentArray4(1,1)=0;

for ii=TimeStart:TimeEnd
       if f_1{1}(ii) < -0.2 && f_1{1}(ii) > -1.75
          IonCurrentArray1(aa)=(f_1{1}(ii)/Resis);
          aa=aa+1;
       end        
           if f_2{1}(ii) < -0.2 && f_2{1}(ii) > -1
          IonCurrentArray2(bb)=(f_2{1}(ii)/Resis);
          bb=bb+1;
           end 
           if f_3{1}(ii) < -0.3 && f_3{1}(ii) > -0.6
          IonCurrentArray3(cc)=(f_3{1}(ii)/Resis);
          cc=cc+1;
           end  
           if f_4{1}(ii) < -0.25 && f_4{1}(ii) > -0.45
          IonCurrentArray4(dd)=(f_4{1}(ii)/Resis);
          dd=dd+1;
           end           
end

I1=abs(mean(IonCurrentArray1));
I2=abs(mean(IonCurrentArray2));
I3=abs(mean(IonCurrentArray3));
I4=abs(mean(IonCurrentArray4));

time=(TimeEnd-TimeStart)/(50000);

e=1.602E-19;

Flux1=I1/(e*area1)
Fuence1=Flux1/time;

Flux2=I2/(e*area2);
Fuence2=Flux2/time;

Flux3=I3/(e*area3);
Fuence3=Flux3/time;

Flux4=I4/(e*area4);
Fuence4=Flux4/time;