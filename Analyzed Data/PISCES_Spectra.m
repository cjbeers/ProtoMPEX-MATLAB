
cleanup
%% Read in Data
Spectra.RawData=readtable('C:\Users\cxe\Documents\General Atomics\Spec. Data\GA_Spect_2019-01-16\50 eV\01_1302154U2.TXT');
Spectra.RawData=table2array(Spectra.RawData);

fclose all;

%% Adding Frames
SummedArray=zeros(size(Spectra.RawData,1),1);

for ii=2:size(Spectra.RawData,1)
    SummedArray(ii,1)=sum(Spectra.RawData(ii,4:end));
end

%% Subtract Background (already done in data)
% [~, Bkstart]=min(abs(SummedArray(:,1)-519));
% [~, Bkend]=min(abs(SummedArray(:,1)-521));
% SummedArray=SummedArray-mean(SummedArray(Bkstart:Bkend));

%% Plot Summed Array

plot(Spectra.RawData(1:end,1),SummedArray)
xlabel('Wavelength [nm]')
ylabel('Counts')

%% Find peak intensities

[~, CHstart1]=min(abs(Spectra.RawData(:,1)-427));
[~, CHstart2]=min(abs(Spectra.RawData(:,1)-430));
[~, CHend]=min(abs(Spectra.RawData(:,1)-431.5));

[~, Dystart]=min(abs(Spectra.RawData(:,1)-433.1));
[~, Dyend]=min(abs(Spectra.RawData(:,1)-434.4));

CHband1=sum(SummedArray(CHstart1:CHend,1));
CHband2=sum(SummedArray(CHstart2:CHend,1));
Dy=max(SummedArray(Dystart:Dyend,1));

%% Carbon chemical erosion yield
Dy_SXB=21.35;
CH_DXB=[5 50 500 1000 2000];

ChemYield_CH=(Dy/CHband1)*(Dy_SXB./CH_DXB);




