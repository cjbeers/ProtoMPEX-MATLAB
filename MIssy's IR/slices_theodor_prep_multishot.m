%multi-shot processing theodor_prep 


shots2analyze = input('Enter list of shots to analyze  ');

for i = 1:length(shots2analyze)
    shot = shots2analyze(i);
    test_theodor_prep_rep(shot);
    testchar = int2str(shot);
    %testchar = string(shot);
    commandStr = ['python', ' ', '/Users/szn/Desktop/THEODOR/data/slices_multishot_convert.py' ,' ', testchar];
    [status, commandOut] = system(commandStr);
    i=i+1;
    
end



