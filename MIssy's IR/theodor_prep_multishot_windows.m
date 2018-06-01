%multi-shot processing theodor_prep 


shots2analyze = input('Enter list of shots to analyze  ');

% Shots=17189; %USER defines shot number, if not found change the PATHNAME to the correct day/file location
% FILENAME = ['Shot ' ,num2str(shots2analyze),'.seq'];
% PATHNAME = 'Z:\IR_Camera\2017_10_25\';
% FILTERINDEX = 1;
% 
% videoFileName=[PATHNAME FILENAME];

%%
for i = 1:length(shots2analyze)
    shot = shots2analyze(i);
    theodor_prep_rep(shot);
    testchar = int2str(shot);
    %testchar = string(shot);
    %[theodor_out, status] = python('C:\Usercxe\Desktop\THEODOR\data\multishot_convert.py',testchar);
    commandStr = ['py', ' ', 'C:\Users\cxe\Desktop\Theodor\data\multishot_convert_windows.py' ,' ', testchar];
    [status, commandOut] = system(commandStr);
    i=i+1;
    
end



