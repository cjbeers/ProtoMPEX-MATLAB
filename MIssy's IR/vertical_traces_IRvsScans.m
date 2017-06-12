%Plot along the center vertical line  - assuming the shot has already been
%loaded and run - still in the workspace

%or can run shot comparison first. 

verticalline_list = zeros(2*87,1);
verticalline_heatflux = zeros(2*87,1);
radius_list = zeros(2*87,1);
px_list= zeros(2*87,1);
j=1;
for i = y_c2-(2*87):y_c2
verticalline_list(j)=MaxDelta(i,x_c2);
verticalline_heatflux(j) = EMax(i,x_c2);
radius_list(j) = (i-(y_c2-87))/32.44;
i=i+1;
j=j+1;
end

%center of the plate: (x_c2,y_c2-87)-> call that r=0;
radius_list = radius_list*-1; %flip axis for proper orientation with the rest of the machine.
mapping_ratio = 2.015; %adjust the mapping ratio as needed 

figure;
plot(radius_list*mapping_ratio,verticalline_list);
ax.FontSize = 13;
title([shotnumber,'; Center Line DeltaT Trace'],'FontSize',13);
xlabel('Radial Scanned Location (cm)','FontSize',13);
ylabel('Delta T (C)','FontSize',13);
% legend('TG','Helicon','Average'); 
% legend('Location','Northwest')

figure;
plot(radius_list*mapping_ratio,verticalline_heatflux);
ax.FontSize = 13;
title([shotnumber,'; Center Line Energy Density Trace'],'FontSize',13);
xlabel('Radial Scanned Location (cm)','FontSize',13);
ylabel(' Energy Density (MW/m^2)','FontSize',13);