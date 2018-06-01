%heat flux analysis for graphite plates

clear all
tic
[FILENAME, PATHNAME] = uigetfile('*.mat', 'Choose IR shot Matlab file (.mat)');
FILENAME1=[PATHNAME FILENAME];
load(FILENAME1);

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

%% Plots

figure;
mesh(flux);
colormap jet
c=colorbar;
ylabel(c, 'Heat Flux [W/m^2]')
ax.FontSize = 13;
title([shotnumber,'; Heat Flux'],'FontSize',13);
xlabel('Time (s)','FontSize',13);
ylabel('Heat Flux (MW/m^2)','FontSize',13);
xticks([0:plasmaframe:plasmaframe*4]);
set(gca,'XTickLabel',[((helicon_start)-(26*0.01)):helicon_start-((helicon_start)-(26*0.01)):helicon_start+1,(helicon_start+1.2)])

