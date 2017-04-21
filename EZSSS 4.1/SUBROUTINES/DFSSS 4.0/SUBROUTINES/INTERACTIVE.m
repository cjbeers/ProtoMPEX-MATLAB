function EXIT=INTERACTIVE(PARA,UNIV)

%************
%Assign input
%************
ATOMIC=PARA.ATOMIC;
LASER=PARA.LASER;
SIGHTLINE=PARA.SIGHTLINE;
MODE=PARA.MODE;
DIMENSION=PARA.DIMENSION;

c=UNIV.c;

%*****************************************
%Plot the geometry of the pump/probe beams 
%*****************************************
FH=PLOT_GEO(PARA);

%********************
%Print the parameters
%********************
cprintf('\n****************************************************\n')
cprintf('*****    ') 
cprintf('*red','DIMENSIONS = %2i \n',DIMENSION)
cprintf('*****\n')
cprintf('*****    ') 
cprintf('*red','MODE = %6s \n',MODE)
cprintf('*****\n')
cprintf('*****    ') 
cprintf('*red','NXD = %4i \n',SIGHTLINE.NXD)    
cprintf('*****    ') 
cprintf('*red','WIDTH = %5.1f mm\n',SIGHTLINE.WIDTH*1e3)
cprintf('*****\n')
cprintf('*****    ') 
cprintf('*red','Atom = %2s \n',ATOMIC.ATOM)
for ii=1:ATOMIC.NT_0
    cprintf('*****    ') 
    cprintf('*red','Transition Probability %2i = %5.2f MHz \n',ii,ATOMIC.A_0(ii)/1e6)
    cprintf('*****    ') 
    cprintf('*red','Wavelength %2i = %9.5f A \n',ii,c/ATOMIC.NU_0(ii)*1e10)
end
cprintf('*****    ') 
cprintf('*red','G = %5.2f \n',ATOMIC.G)
cprintf('*****    ') 
cprintf('*red','GAMMA = %5.2f MHz \n',ATOMIC.GAMMA/1e6)
cprintf('*****    ') 
cprintf('*red','N = %3.1e m-3 \n',ATOMIC.N)
cprintf('*****    ') 
cprintf('*red','KT = %5.3f eV \n',ATOMIC.KT)
cprintf('*****    ') 
cprintf('*red','V_BULK = [%4.2e,%4.2e] m/s \n',ATOMIC.V_BULK(1),ATOMIC.V_BULK(2))
cprintf('*****\n')
cprintf('*****    ') 
cprintf('*red','NFP = %3i \n',LASER.NFP)
cprintf('*****    ') 
if strcmpi(LASER.NU_MODE,'AUTO')==1
    cprintf('*red','Frequency Window = %4.1f to %4.1f GHz \n',LASER.NU_WIN(1)/1e9,LASER.NU_WIN(2)/1e9)
elseif strcmpi(LASER.NU_MODE,'MANUAL')==1
    cprintf('*red','Frequency Boundary = %4.1f to %4.1f GHz \n',LASER.NU_MAN(1)/1e9,LASER.NU_MAN(LASER.NFP)/1e9)
end
cprintf('*****    ') 
cprintf('*red','Pump Power = %5.2f mW \n',LASER.PU.P_0*1e3)
cprintf('*****    ') 
cprintf('*red','Probe Power = %5.2f mW \n',LASER.PR.P_0*1e3)
cprintf('*****    ') 
cprintf('*red','Pump Diameter = %5.3f mm \n',(LASER.PU.AREA/pi)^.5*2*1e3)
cprintf('*****    ') 
cprintf('*red','Probe Diameter = %5.3f mm \n',(LASER.PR.AREA/pi)^.5*2*1e3)
cprintf('*****    ') 
cprintf('*red','Pump Direction = [%5.4f,%5.4f] \n',LASER.PU.DIRECTION)
cprintf('*****    ') 
cprintf('*red','Probe Direction = [%5.4f,%5.4f] \n',LASER.PR.DIRECTION)
cprintf('****************************************************\n')

%***********************
%Prompt user to continue
%***********************
EXIT=input('*****    Continue (y/n): ','s');
cprintf('****************************************************\n\n')

%************
%Close figure
%************
try
    close(FH)
catch

end
    
end