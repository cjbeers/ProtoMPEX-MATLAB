%run averages of px_per_cm for multiple shots 

numshots = input('number of shots to average for px_per_cm  ');
average_list = zeros(numshots,1);

for i = 1:numshots
    average_px_per_cm = find_px_per_cm;
    average_list(i) = average_px_per_cm;
    i=i+1;
end

px_per_cm = mean(average_list);
    