

load('HighDensityFullDeviceMagneticField.mat');
load('HighDensityFullDevicePlasmaNe.mat');
load('HighDensityFullDevicePlasmaParamters.mat');
load('HighDensityFullDevicePlasmaTe.mat');


%%
nR=length(rGrid);
nZ=length(zGrid);

Vt=0*Vr;
Bt=Btnew*0;


%%

ncid = netcdf.create(['./profilesProtoMPEX.nc'],'NC_WRITE')

dimR = netcdf.defDim(ncid,'nX',nR);
% dimY = netcdf.defDim(ncid,'nY',nY);
dimZ = netcdf.defDim(ncid,'nZ',nZ);

gridRnc = netcdf.defVar(ncid,'x','float',dimR);
% gridYnc = netcdf.defVar(ncid,'y','float',dimY);
gridZnc = netcdf.defVar(ncid,'z','float',dimZ);
Ne2Dnc = netcdf.defVar(ncid,'ne','float',[dimR dimZ]);
Ni2Dnc = netcdf.defVar(ncid,'ni','float',[dimR dimZ]);
Te2Dnc = netcdf.defVar(ncid,'te','float',[dimR dimZ]);
Ti2Dnc = netcdf.defVar(ncid,'ti','float',[dimR dimZ]);
vrnc = netcdf.defVar(ncid,'vr','float',[dimR dimZ]);
vtnc = netcdf.defVar(ncid,'vt','float',[dimR dimZ]);
vznc = netcdf.defVar(ncid,'vz','float',[dimR dimZ]);
brnc = netcdf.defVar(ncid,'br','float',[dimR dimZ]);
btnc = netcdf.defVar(ncid,'bt','float',[dimR dimZ]);
bznc = netcdf.defVar(ncid,'bz','float',[dimR dimZ]);
% % ernc = netcdf.defVar(ncid,'Er','float',[dimR dimZ]);
% % eznc = netcdf.defVar(ncid,'Ez','float',[dimR dimZ]);
% % etnc = netcdf.defVar(ncid,'Et','float',[dimR dimZ]);
% % gtirnc = netcdf.defVar(ncid,'gradTir','float',[dimR dimZ]);
% % gtiznc = netcdf.defVar(ncid,'gradTiz','float',[dimR dimZ]);
% % gtiync = netcdf.defVar(ncid,'gradTiy','float',[dimR dimZ]);
% % gternc = netcdf.defVar(ncid,'gradTer','float',[dimR dimZ]);
% % gteznc = netcdf.defVar(ncid,'gradTez','float',[dimR dimZ]);
% % gteync = netcdf.defVar(ncid,'gradTey','float',[dimR dimZ]);
% 
% 
% 
% %neVar = netcdf.defVar(ncid, 'Ne2', 'double',dimR);
% %teVar = netcdf.defVar(ncid, 'Te', 'double',dimR);
netcdf.endDef(ncid);
% 
netcdf.putVar(ncid,gridRnc,rGrid);
netcdf.putVar(ncid,gridZnc,zGrid);
netcdf.putVar(ncid,Ne2Dnc,HighDensityFullDevicePlasmaNe);
netcdf.putVar(ncid,Ni2Dnc,HighDensityFullDevicePlasmaNe);
netcdf.putVar(ncid,Te2Dnc,HighDensityFullDevicePlasmaTe);
netcdf.putVar(ncid,Ti2Dnc,HighDensityFullDevicePlasmaTe);
% 
netcdf.putVar(ncid,vrnc,Vr);
netcdf.putVar(ncid,vtnc,Vt);
netcdf.putVar(ncid,vznc,Vz);
% 
netcdf.putVar(ncid,brnc,Brnew);
netcdf.putVar(ncid,btnc,Btnew);
netcdf.putVar(ncid,bznc,Bznew);
% 
% % netcdf.putVar(ncid,ernc,Epara');
% % netcdf.putVar(ncid,eznc,Eperp');
% % netcdf.putVar(ncid,etnc,(0*Epara)');
% % 
% % netcdf.putVar(ncid,gtirnc,gradTir');
% % netcdf.putVar(ncid,gtiznc,gradTiz');
% % netcdf.putVar(ncid,gtiync,gradTiy');
% % netcdf.putVar(ncid,gternc,gradTer');
% % netcdf.putVar(ncid,gteznc,gradTez');
% % netcdf.putVar(ncid,gteync,gradTey');
% 
% %netcdf.putVar(ncid, neVar, Ne2);
% %netcdf.putVar(ncid, teVar, Te);
netcdf.close(ncid);