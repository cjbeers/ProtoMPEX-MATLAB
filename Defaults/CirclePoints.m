
xc=0;
yc=0;
np=101;
r=0.12485/2; %Low Density case
%r=0.125/2; %High Density case
%r=((0.11512+0.12512)/2)/2;
%r=0.11512/2;
%r=0.075;

ang = linspace(0,2*pi,np);
deg=rot90(ang*180/pi,3);
x = xc + r * cos(ang);
y = yc + r * sin(ang);
figure
plot(x,y,'.')
grid on; axis equal

xdata=rot90(x,3);
ydata=rot90(y,3);
zdata=rot90(linspace(-0.5,0.5,1000),3);

%%
Data=zeros(10000,3);
jj=1;
kk=1;

for ii=1:10000
    
    Data(ii,1)=xdata(jj,1);
    Data(ii,2)=ydata(jj,1);
    Data(ii,4)=deg(jj,1);
    Data(ii,3)=zdata(kk,1);
    jj=jj+1;
    
    if jj==101
        jj=1;
        kk=kk+1;
    end
end
    