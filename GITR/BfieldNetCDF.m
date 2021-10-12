%% write bfield netcdf

load('C:\Users\cxe\Documents\GitHub\GITR1\protoMPEx\Al\HighDensityFullDeviceMagneticField.mat')
load('C:\Users\cxe\Documents\GitHub\GITR1\protoMPEx\Al\HighDensityFullDevicePlasmaNe.mat')


gridR=avec;
gridZ=zvec;
nR=length(gridR);
nZ=length(gridZ);
bt=zeros(nR,nZ);

ncid = netcdf.create(['./ProtoBfield.nc'],'NC_WRITE')

dimR = netcdf.defDim(ncid,'nR',nR);
dimZ = netcdf.defDim(ncid,'nZ',nZ);

gridRnc = netcdf.defVar(ncid,'gridR','double',dimR);
gridZnc = netcdf.defVar(ncid,'gridZ','double',dimZ);
br2Dnc = netcdf.defVar(ncid,'br','double',[dimR dimZ]);
bz2Dnc = netcdf.defVar(ncid,'bz','double',[dimR dimZ]);
bt2Dnc = netcdf.defVar(ncid,'bt','double',[dimR dimZ]);
netcdf.endDef(ncid);

netcdf.putVar(ncid,gridRnc,gridR);
netcdf.putVar(ncid,gridZnc,gridZ);
netcdf.putVar(ncid,br2Dnc,(br'));
netcdf.putVar(ncid,bz2Dnc,(bz'));
netcdf.putVar(ncid,bt2Dnc,(bt'));

netcdf.close(ncid);