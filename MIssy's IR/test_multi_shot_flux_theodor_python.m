%multi-shot flux analysis that have been converted back into readable files
%from python 

%shots2analyze = input('How many shots are being analyzed in the set  ?');
shots2analyze = input('Enter list of shots to analyze  ');
flux_shotlist = zeros(length(shots2analyze),1);
%load a shot to get number of slices for profile width;
%[time,location,data] = test_loadflux_python(shots2analyze(1));

flux_data = cell(length(shots2analyze),160);
flux_time = cell(length(shots2analyze), 160);
flux_location = cell(length(shots2analyze),160);
shot_flux = 0;


for i = 1:length(shots2analyze)
    shot = shots2analyze(i);
    for j = 1:160
        shotnumber = string(shot) + '_'+string(j);
        [time,location,data,shotnumber] = test_loadflux_python(shotnumber); 
        flux_time{i,j} = time;
        flux_data{i,j} = data;
        flux_location{i,j} = location;
        j=j+1;
    end
    flux_shotlist(i) = shot;
    i=i+1;
end



% %KEEP CORRECTING!!
% max_flux_data = zeros(length(shots2analyze),1);
% max_flux_data_check = zeros(length(shots2analyze),1);
% flux_data_center_time = zeros(length(shots2analyze),1);
% max_vert_pixel = zeros(length(shots2analyze),1);
% vert_pixel_time = cell(length(shots2analyze),1);
% frame_max_list = zeros(length(shots2analyze),1);
% 
% for i = 1:length(flux_data)
%     flux = flux_data{i};
%     flux1 = flux';
%     [max1, frame_max_list(i)] = max(max(flux));
%     [max_flux_data(i), max_vert_pixel(i)] = max(flux(60:100,frame_max_list(i)));
%     vert_pixel_time{i} = flux(max_vert_pixel(i)+59,:);
%     max_flux_data_check(i) = max(vert_pixel_time{i,:});
%     i=i+1;
% end
% 
% for i = 1:length(shots2analyze)
% plot(flux_time{i},vert_pixel_time{i});
% hold on
% i=i+1;
% end
% 
% ax.FontSize = 13;
% title('Max Heat Flux near Center','FontSize',13);
% xlabel('Time (s)','FontSize',13);
% ylabel('Heat Flux (MW/m^2)','FontSize',13);
% %legend('flux shotlist');  
% legend('Location','Northwest')
% 
% 
% 
