
function [time, location, data, shotnumber] = test_loadflux_python(shotnumber)

%Load the _theodorflux.mat shot file: python heat flux data
%[FILENAME, PATHNAME] = uigetfile('*.mat', 'Choose IR shot Matlab file (.mat)');
FILENAME = shotnumber + "_theodorflux.mat";

load(FILENAME);
shotnumber = FILENAME(1:end-16);
%Will be a stucture; separate out the data

time = arr.time';  %time in seconds
location = arr.location'; %location in [m] along the vertical line trace
data = arr.data*10^-6; %heat flux array in [MW/m2]

end
