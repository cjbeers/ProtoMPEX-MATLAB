%heat flux analysis for graphite plates

clear all
tic
[FILENAME, PATHNAME] = uigetfile('*.mat', 'Choose IR shot Matlab file (.mat)');

load(FILENAME);

DeltaTMatrix = Temperature;
for i = 1:zoomframes
    DeltaTMatrix(:,:,i) = Temperature(:,:,i)-Temperature(:,:,1);
    i=i+1;
end

vertical_slice = input('What pixel along the frame width do you want to sample? ');

Tsurf = DeltaTMatrix(:,vertical_slice,:);

Cp=1760;
rho=710;
deltat=0.01;
k=120;

[flux] = calcflux1D(Tsurf, deltat, k, rho, Cp);

figure;
mesh(flux);
colormap jet
c=colorbar;
ylabel(c, 'Heat Flux [W/m^2]')
ax.FontSize = 13;
title([shotnumber,'; Heat Flux'],'FontSize',13);
xlabel('Frames','FontSize',13);
ylabel('Heat Flux (MW/m^2)','FontSize',13);

time=zeros(zoomframes,1);
    for i = 1:plasmaframe
        time(i) = helicon_start-(plasmaframe-i)*0.01;
        i=i+1;
    end
    for i = plasmaframe:zoomframes
        time(i) = helicon_start+(i-plasmaframe)*0.01;
        i=i+1;
    end

flux_time = zeros(length(flux),zoomframes);
flux_only = zeros(length(flux),1);

for i = 1:length(flux)
    flux_only(i) = flux(:,i);
    i=i+1;
end
for i = 1:length(time)
    flux_time = [flux(:,i),time(i)];
    i=i+1;
end

figure;
mesh(flux_time);
colormap jet
c=colorbar;
ylabel(c, 'Heat Flux [W/m^2]')
ax.FontSize = 13;
title([shotnumber,'; Heat Flux'],'FontSize',13);
xlabel('Time (s)','FontSize',13);
ylabel('Heat Flux (MW/m^2)','FontSize',13);
