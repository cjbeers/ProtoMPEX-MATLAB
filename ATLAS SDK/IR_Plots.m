%% IR_Plots
% For loading in .mat IR file and creating plots for presentations

cleanup
PLOTProfile=0; %Plots a line plot of the temeprature to see a 1D profile

[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.m;*.mat', 'Choose the first IR shot file to compare (.mat or .m)');
videoFileName=[PATHNAME FILENAME];
load(videoFileName)

TempMax=250;

%% Plot MaxDelta

figure;
figDeltaT=imagesc(Frame, 'CDataMapping','scaled');
caxis([0 TempMax])
colormap jet
c=colorbar;
ylabel(c, 'Delta T [C]')
ax.FontSize = 13;
title([shotnumber,'; Max Delta Temperature'],'FontSize',13);
xlabel('Pixels','FontSize',13);
ylabel('Pixels','FontSize',13);

% TC_circle = viscircles([x_c2 y_c2],TC_radius);
% centerline_horiz = imline(gca, [x_c2-5 y_c2; x_c2+5 y_c2]);
% centerline_vert = imline(gca, [x_c2 y_c2-5;x_c2 y_c2+5]);
% large_diameter = round(diameter*1.1,3,'sig');
% r1=diameter/2;
% r2=large_diameter/2;
% ellipse=imellipse(gca,[76-r2 75-r1 diameter large_diameter]);
% mask=createMask(ellipse,figDeltaT);
% ellipse2=imellipse(gca,[80-63 80-63 63*2 63*2]);
% mask2=createMask(ellipse2,figDeltaT);

%% Plot MaxTemp

figure;
figDeltaT=imagesc(Temperature(:,:,45), 'CDataMapping','scaled');
caxis([0 500])
colormap jet
c=colorbar;
ylabel(c, 'Temp. [C]')
ax.FontSize = 13;
title([shotnumber,'; Temperature'],'FontSize',13);
xticks([]);
yticks([]);

%% Create variables for Delta T plots

number2compare=1;
Cp=710; %J/kg*C
density=1760; %kg/m3
thickness= .25*(2.54/100); %inches to m
delta_tframe = 0.01;%gap between frames

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
plasmaframe1=plasmaframe;
helicon_start1=helicon_start;

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

if number2compare == 1 
     time1=zeros(zoomframes1,1);
    for i = 1:plasmaframe1
        time1(i) = helicon_start-(plasmaframe1-i)*0.01;
        i=i+1;
    end
    for i = plasmaframe1:zoomframes1
        time1(i) = helicon_start+(i-plasmaframe)*0.01;
        i=i+1;
    end
end

%% Create Delta T Plots

%    figure;
%     plot(time1,TG_powerdensity_step1,'k','lineWidth',2)
%     ylim([0 50]);
%     hold on    
%     plot(time1,hel_powerdensity_step1,'b','lineWidth',2)
%     plot(time1,avg_powerdensity_step1,'m','lineWidth',2)
%     ax.FontSize = 13;
%     title(['Delta T between Frames'],'FontSize',13);
%     xlabel('Time(s)','FontSize',13);
%     ylabel('Delta T (C)','FontSize',13);
%     legend('TG','Helicon','Average'); 
%     legend('Location','Northwest')

    figure;
    plot(time1,TG_templist1,'k','LineWidth',2)
    ylim([0 TempMax]);
    hold on
    plot(time1,hel_templist1,'b','LineWidth',2)
    plot(time1,meanlist1,'m','lineWidth',2)
    ax.FontSize = 13;
    title(['Delta T'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend('TG','Helicon','Average'); 
    legend('Location','Northwest')
    
     figure;
    plot(time1,TG_templist_step1,'k','LineWidth',2)
    ylim([-inf 20]);
    hold on
    plot(time1,hel_templist_step1,'b','LineWidth',2)
    plot(time1,meanlist_step1,'m','lineWidth',2)
    ax.FontSize = 13;
    title('Instantaneous Heat Flux','FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Ab. Units','FontSize',13);
    legend('TG','Helicon','Average'); 
    legend('Location','Northwest')

%% Plot line through plasma center

if PLOTProfile==1
    
sizeFrame=size(Frame);
xvalue=(1:1:sizeFrame(1,1))/px_per_cm;

figure
plot(xvalue,Temperature(80,:,finalframenumber),'k')
ax.FontSize = 13;
title('Plasma Profile','FontSize',13);
xlabel('Distance [cm]','FontSize',13);
ylabel('Temperature [Deg. C]','FontSize',13); 

end
