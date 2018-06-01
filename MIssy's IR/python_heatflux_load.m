%importing python heat fluxes to matlab


%Load the _theodorflux.mat shot file: python heat flux data
[FILENAME, PATHNAME] = uigetfile('*.mat', 'Choose IR shot Matlab file (.mat)');

load(FILENAME);
shotnumber = FILENAME(1:end-16);
%Will be a stucture; separate out the data

time = arr.time';  %time in seconds
location = arr.location'; %location in [m] along the vertical line trace
data = arr.data*10^-6; %heat flux array in [MW/m2]


%if want to plot mesh (heatflux line over time)
figure;
mesh(data);
%caxis([0 deltamax])
colormap jet
c=colorbar;
ylabel(c, 'Heat Flux [MW/m^2]')
ax.FontSize = 13;
title([shotnumber,'; Heat Flux vs. Time'],'FontSize',13);
step = length(time)/5;
xticks([0:step:length(time)]);
set(gca,'XTickLabel',[time(1),time(step),time(2*step),time(3*step),time(4*step),time(end)]);

% xticks([0:plasmaframe:plasmaframe*4]);
% set(gca,'XTickLabel',[((helicon_start)-(plasmaframe*deltat)):helicon_start-((helicon_start)-(plasmaframe*deltat)):helicon_start+1,(helicon_start+1.2)]);
% xlabel('Time [s]','FontSize',13);
% ylabel('Pixels','FontSize',13);

%plot heatflux over location at specific time
select = 0;
point_select = input('Do you want to choose by frame (0) or by time (1)?  ');
if point_select ==0
    select = input('choose the frame number  ')
else
    time_pick = input('choose time to hundredth of second [s]; ex: 4.15  ');
    for i = 1:length(time)
        if abs(time_pick-time(i))<0.015
            select=i;
        end
    end
end
figure;
plot(location,data(:,select))
ax.FontSize = 13;
title([shotnumber,'; Heat Flux vs. Line Trace'],'FontSize',13);
xlabel('Line Location [m]','FontSize',13);
ylabel('Heat Flux [MW/m^2]','FontSize',13);

