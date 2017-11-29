%shot image quick recreation

[FILENAME] = uigetfile('*.m;*.mat', 'Choose the first IR shot file to compare (.mat or .m)');
load(FILENAME);

MaxDelta = Frame;

deltamax = double(max(max(int16(round(MaxDelta,2,'significant')))));
deltamin = double(min(min(int8(round(MaxDelta,1,'significant')))));
scalestep = deltamax/10;

%% Heat Flux Measurement
%Calculates the heat flux of a image 

% Cp=500; %J/kg*C
% density=8030; %kg/m3
% thickness= .01*(2.54/100); %inches to m
% 
% delta_tframe = 0.02;%gap between frames
% x_c = 100;
% y_c = 200;
% 
% x_c2=x_c;
% y_c2=y_c;
% 
% px_per_m=px_per_cm*100;
% hel_radius = 3/px_per_m;%pixels per m.
% area_hel = pi*(hel_radius^2); %same as area_TG;
% TG_radius = 3/px_per_m;
% avg_side = (87*2)/px_per_m;
% avg_area = avg_side^2;
% 
% EMax=(((Cp*MaxDelta*thickness*density))/1E6); %Cp*DeltaT*mass = MW/m2
% e_range = round((((deltamax*Cp*thickness*density))/1E6),1,'significant');

%Plot MaxDelta
figure;
figDeltaT=imagesc(Frame, 'CDataMapping','scaled');
%caxis([0 deltamax])
colormap jet
c=colorbar;
ylabel(c, 'Delta T [C]')
ax.FontSize = 13;
title([shotnumber,'; Delta Temperature vs. Camera Pixels'],'FontSize',13);
xlabel('Pixels','FontSize',13);
ylabel('Pixels','FontSize',13);

TC_circle = viscircles([x_c2 y_c2],TC_radius);
centerline_horiz = imline(gca, [x_c2-5 y_c2; x_c2+5 y_c2]);
centerline_vert = imline(gca, [x_c2 y_c2-5;x_c2 y_c2+5]);

%find average ellipse delta temp
%diameter = input('what is the diameter of the plasma? [in pixels]  ');
large_diameter = round(diameter*1.1,3,'sig');
r1=diameter/2;
r2=large_diameter/2;
%ellipse [Position] = [Xmin Ymin Width Height] = [columnMin rowMin columns
%rows] 
%Approximate 'E1' from ResearchIR
ellipse=imellipse(gca,[76-r2 75-r1 diameter large_diameter]);
mask=createMask(ellipse,figDeltaT);
avg_all=mean2(mask.*MaxDelta);
avg_mask=mean2(mask);
avg_delta=avg_all/avg_mask; %this is hand-wavy? 

%Approximate 'E2' from ResearchIR
ellipse2=imellipse(gca,[80-63 80-63 63*2 63*2]);
mask2=createMask(ellipse2,figDeltaT);
avg_all2=mean2(mask.*MaxDelta);
avg_mask2=mean2(mask2);
avg_delta2=avg_all2/avg_mask2; %this is hand-wavy?

finalframenumber 
% %Plot QMax
% figure;
% imagesc(EMax, 'CDataMapping','scaled')
% caxis([0 e_range])
% colormap jet
% c=colorbar;
% ylabel(c, 'EMax [MJ/m^2]')
% ax.FontSize = 13;
% title([shotnumber,'; Energy Density vs. Camera Pixels'],'FontSize',13);
% xlabel('Pixels','FontSize',13);
% ylabel('Pixels','FontSize',13);
% TC_circle = viscircles([x_c2 y_c2],TC_radius);
% centerline_horiz = imline(gca, [x_c2-5 y_c2-87; x_c2+5 y_c2-87]);
% centerline_vert = imline(gca, [x_c2 y_c2-82;x_c2 y_c2-92]);
% rect_mean = imrect(gca,[x_c2-87 y_c2-(2*87) 87*2 87*2]);
% %saveas(gca,FILENAME(6:end-4),'jpg'); 