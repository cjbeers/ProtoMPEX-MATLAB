%% Reads in a SXB file to get the values for your given ne and Te

cleanup

%% Start code
%Read in file of interest
fname = ['C:\Users\cxe\Documents\Open-ADAS\','sxb12#h_pju#h0.dat'];
[SXB] = read_adas_sxb12_file(fname,2E13,5,4339.9)