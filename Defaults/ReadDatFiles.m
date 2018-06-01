fileID = fopen('C:\Users\cxe\Documents\Open-ADAS\pec12#h_pju#h0.dat');     %declare a file id

C1 = textscan(fileID,'%s%f%s%f');   %read the first line
nb_col = C1{4};                     %get the number of columns (could be set by user too) 

%read the remaining of the file
C2 = textscan(fileID, repmat('%f',1,nb_col), 'CollectOutput',1);

fclose(fileID);                     %close the connection

%%
fid = fopen('C:\Users\cxe\Documents\Open-ADAS\sxb96#h_pjr#h0.dat','r');
datacell = textscan(fid, '%f%f%f', 'HeaderLines', 1, 'Collect', 1);
fclose(fid);
A.data = datacell{1};

%%
fid = fopen('C:\Users\cxe\Documents\Open-ADAS\sxb96#h_pjr#h0.dat','rt');
A = textscan(fid, '%f', 'HeaderLines',730);
A = A{1};
fclose(fid);
