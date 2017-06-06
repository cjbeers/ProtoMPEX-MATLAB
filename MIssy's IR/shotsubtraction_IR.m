%shot subtraction - subtract values

%Constants for both shots required for analysis 
Cp=500; %J/kg*C
density=8030; %kg/m3
thickness= .01*(2.54/100); %inches to m
delta_tframe = 0.02;%gap between frames
x_c = 100;
y_c = 200;

[FILENAME1] = uigetfile('*.m;*.mat', 'Choose the first IR shot file to compare (.mat or .m)');
load(FILENAME1);

area_TG1=area_TG;
avg_area1=avg_area;
center_plate1=center_plate;
DeltaTMatrix_step1=DeltaTMatrix_step;
emax1 = emax;
Frame1 = Frame;
hel_templist1 = hel_templist;
hel_templist_step1 = hel_templist_step;
meanlist1=meanlist;
meanlist_step1=meanlist_step;
px_per_cm1=px_per_cm;
TG_templist1=TG_templist;
TG_templist_step1=TG_templist_step;
% TC_radius1=TC_radius;
% shotnumber1=shotnumber;
% zoomframes1 = zoomframes;
% TG_frame1 = TG_frame;
% finalframenumber1=finalframenumber;

px_per_m1=px_per_cm1*100;
hel_radius1 = 3/px_per_m1;%pixels per m.
area_hel1 = pi*(hel_radius1^2); %same as area_TG;
TG_radius1 = 3/px_per_m1;
avg_side1 = (87*2)/px_per_m1;
avg_area1 = avg_side1^2;

TG_powerdensity_step1 = ((Cp*TG_templist_step1*thickness*density)/delta_tframe)/1E6; %MW/m2
hel_powerdensity_step1 = ((Cp*hel_templist_step1*thickness*density)/delta_tframe)/1E6; %MW/m2
avg_powerdensity_step1 = ((Cp*meanlist_step1*thickness*density)/delta_tframe)/1E6; %MW/m2

TG_power_step1 = TG_powerdensity_step1*area_TG1*1000;  %kW
hel_power_step1 = hel_powerdensity_step1*area_hel1*1000; %kW
avg_power_step1 = avg_powerdensity_step1*avg_area1*1000; %kW

zoomframes1 = length(hel_templist1);


[FILENAME2] = uigetfile('*.m;*.mat', 'Choose the second IR shot file to compare (.mat or .m)');
load(FILENAME2);

area_TG2=area_TG;
avg_area2=avg_area;
center_plate2=center_plate;
DeltaTMatrix_step2=DeltaTMatrix_step;
emax2 = emax;
Frame2 = Frame;
hel_templist2 = hel_templist;
hel_templist_step2 = hel_templist_step;
meanlist2=meanlist;
meanlist_step2=meanlist_step;
px_per_cm2=px_per_cm;
TG_templist2=TG_templist;
TG_templist_step2=TG_templist_step;
% TC_radius2=TC_radius;
% shotnumber2=shotnumber;
% zoomframes2 = zoomframes;
% TG_frame2 = TG_frame;
% finalframenumber2=finalframenumber;

px_per_m2=px_per_cm2*100;
hel_radius2 = 3/px_per_m2;%pixels per m.
area_hel2 = pi*(hel_radius2^2); %same as area_TG;
TG_radius2 = 3/px_per_m2;
avg_side2 = (87*2)/px_per_m2;
avg_area2 = avg_side2^2;

TG_powerdensity_step2 = ((Cp*TG_templist_step2*thickness*density)/delta_tframe)/1E6; %MW/m2
hel_powerdensity_step2 = ((Cp*hel_templist_step2*thickness*density)/delta_tframe)/1E6; %MW/m2
avg_powerdensity_step2 = ((Cp*meanlist_step2*thickness*density)/delta_tframe)/1E6; %MW/m2

TG_power_step2 = TG_powerdensity_step2*area_TG1*1000;  %kW
hel_power_step2 = hel_powerdensity_step2*area_hel1*1000; %kW
avg_power_step2 = avg_powerdensity_step2*avg_area1*1000; %kW

zoomframes2 = length(hel_templist2);


%PLOT each individual shot 
%plot shot 1
figure;
plot(1:zoomframes1,TG_powerdensity_step1,'-k.',1:zoomframes1,hel_powerdensity_step1,'-b.',1:zoomframes1,avg_powerdensity_step1,'-m.')
ax.FontSize = 13;
title(['Power Density between Frames for Shot ', FILENAME1(1:end-4)],'FontSize',13);
xlabel('Frames','FontSize',13);
ylabel('Power Density (MW/m2)','FontSize',13);
legend('TG','Helicon','Average'); 
legend('Location','Northwest')

figure;
plot(1:zoomframes1,avg_power_step1,'-m.')
ax.FontSize = 13;
title(['Power between Frames for Shot ', FILENAME1(1:end-4)],'FontSize',13);
xlabel('Frames','FontSize',13);
ylabel('Power(kW)','FontSize',13);
legend ('Average');
legend('Location','Northwest')

%plot shot 2
figure;
plot(1:zoomframes2,TG_powerdensity_step2,'-k.',1:zoomframes2,hel_powerdensity_step2,'-b.',1:zoomframes1,avg_powerdensity_step2,'-m.')
ax.FontSize = 13;
title(['Power Density between Frames for Shot ', FILENAME2(1:end-4)],'FontSize',13);
xlabel('Frames','FontSize',13);
ylabel('Power Density (MW/m2)','FontSize',13);
legend('TG','Helicon','Average');
legend('Location','Northwest')

figure;
plot(1:zoomframes2,avg_power_step2,'-m.')
ax.FontSize = 13;
title(['Power between Frames for Shot ', FILENAME2(1:end-4)],'FontSize',13);
xlabel('Frames','FontSize',13);
ylabel('Power(kW)','FontSize',13);
legend('Average');
legend('Location','Northwest')


%Subtractions for power densities
    
delta_TG_powerdensity1 = TG_powerdensity_step2-TG_powerdensity_step1;
delta_hel_powerdensity1 = hel_powerdensity_step2-hel_powerdensity_step1;
delta_avg_powerdensity1 = avg_powerdensity_step2-avg_powerdensity_step1;
delta_avg_power = avg_power_step1 - avg_power_step2;

%pick the right zoomframes, if they differ between shots
zoomframeslist = [zoomframes1,zoomframes2];
zoomframes_plot = max(zoomframeslist);
    
figure;
plot(1:zoomframes1,TG_powerdensity_step1,'-k.',1:zoomframes2,TG_powerdensity_step2,'-b.',1:zoomframes_plot,delta_TG_powerdensity1,'-m.')
ax.FontSize = 13;
title(['Delta Power Density for TG/Edge between Frames'],'FontSize',13);
xlabel('Frames','FontSize',13);
ylabel('Power Density (MW/m2)','FontSize',13);
legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)], ['Shot 1 - Shot 2']); 
legend('Location','Northwest')

figure;
plot(1:zoomframes1,hel_powerdensity_step1,'-k.',1:zoomframes2,hel_powerdensity_step2,'-b.',1:zoomframes_plot,delta_hel_powerdensity1,'-m.')
ax.FontSize = 13;
title(['Delta Power Density for Helicon/Center between Frames'],'FontSize',13);
xlabel('Frames','FontSize',13);
ylabel('Power Density (MW/m2)','FontSize',13);
legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)], ['Shot 1 - Shot 2']); 
legend('Location','Northwest')

figure;
plot(1:zoomframes1,avg_powerdensity_step1,'-k.',1:zoomframes2,avg_powerdensity_step2,'-b.',1:zoomframes_plot,delta_avg_powerdensity1,'-m.')
ax.FontSize = 13;
title(['Delta Power Density for Average between Frames'],'FontSize',13);
xlabel('Frames','FontSize',13);
ylabel('Power Density (MW/m2)','FontSize',13);
legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)], ['Shot 1 - Shot 2']); 
legend('Location','Northwest')

figure;
plot(1:zoomframes1,avg_power_step1,'-k.')
hold on
plot(1:zoomframes2,avg_power_step2,'-b.')
hold on
plot(1:zoomframes_plot,delta_avg_power,'-m.')
ax.FontSize = 13;
title(['Delta Power between Frames'],'FontSize',13);
xlabel('Frames','FontSize',13);
ylabel('Power(kW)','FontSize',13);
legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)], ['Shot 1 - Shot 2']); 
legend('Location','Northwest')



