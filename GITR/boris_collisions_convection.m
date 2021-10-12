close all
clear all
ME = 9.10938356e-31; %mass electron in kg
MI = 1.6737236e-27; %mass ion in kg
Q = 1.60217662e-19; %charge
EPS0 = 8.854187e-12; %epsilon0

% Energy = 2;
Z = 1; %charge
amu = 26.9; %0.00054858; %impurity
m=amu;

BMag = 0.07;
w = Z*Q*BMag/(amu*MI);

nP = 10000;

dt = 1e-7;% 0.34/w;

E = [0 0 0];

B = [0 0 BMag];

T=8; %eV


background_Z = 1;
background_amu = 2;
v_flow = [0 0 0];

vTh = sqrt(2*T*1.602e-19/m/1.66e-27);
gyroradius = vTh/w;
k = 1.38e-23*11604; 
Bb = m*1.66e-27/(2*T*k);
vgrid = linspace(-3*vTh,3*vTh);
fv1 = sqrt(Bb/pi)*exp(-Bb*vgrid.^2);
fv1CDF = cumsum(fv1);
fv1CDF = fv1CDF./fv1CDF(end);

vx0 = interp1(fv1CDF,vgrid,rand(1,nP),'pchip',0)';
vy0 = interp1(fv1CDF,vgrid,rand(1,nP),'pchip',0)';
vz0 = interp1(fv1CDF,vgrid,rand(1,nP),'pchip',0)';


x = zeros(1,nP);
y = zeros(1,nP);
z = zeros(1,nP);

r = [x' y' z'];
v = [vx0 vy0 vz0];
nT = 10000;

% Constants used in Boris method Lorentz Integrator
q_prime = Z*Q/(amu*MI)*dt/2;
coeff = 2*q_prime/(1+(q_prime*BMag).^2);

% vHist = zeros(nP,3,nT);
vxHist = zeros(nT,1);
xHist = zeros(nT,1);
xHisthist = zeros(nT,200);
% Boris Method Lorentz Integrator
zer = zeros(1,nP)';
indx = find(r(:,3) > -10);
n_not_hit = length(indx);
v_minus = 0*v;
speed = v_minus(:,1);
    ez1 = speed;
    ez2 = speed;
    ez3 = speed;
    ex1 = speed;
    ex2 = speed;
    ex3 = speed;
    exnorm = speed;
    ey1 = speed;
    ey2 = speed;
    ey3 = speed;
    nCount = 0;
    nT0 = 0;
    vx = 0*vx0;
    vy = 0*vx0;
    vz = 0*vx0;

tic
while (n_not_hit > 0 && nT0 <= nT)
    nCount = nCount+1;
% for i=1:nT
    indx = find(r(:,3) > -10);

    n_not_hit = length(indx);
    nT0 = nT0+1;
    [n_not_hit nT0]
    
    Emag = 0;
    v_minus(indx,:) = v(indx,:) + q_prime.*[zer(indx) zer(indx) -Emag*zer(indx)];
    
    v(indx,:) = v_minus(indx,:) + q_prime.*[v_minus(indx,2)*B(3) - v_minus(indx,3)*B(2), v_minus(indx,3)*B(1) - v_minus(indx,1)*B(3),v_minus(indx,1)*B(2) - v_minus(indx,2)*B(1)];
    
    v(indx,:) = v_minus(indx,:) + coeff.*[v(indx,2)*B(3) - v(indx,3)*B(2), v(indx,3)*B(1) - v(indx,1)*B(3),v(indx,1)*B(2) - v(indx,2)*B(1)];
    
    v(indx,:) = v(indx,:) + q_prime.*[zer(indx) zer(indx) -Emag*zer(indx)];
    
    step = dt.*v;
    r = r + step;

vxHist(nT0) = mean(v(:,1));
xHist(nT0) = mean(r(:,1));
[N,edges1] = histcounts(r(:,1),linspace(-0.1,0.1,201));
xHisthist(nT0,:) = N;
    % Get relative velocity
    vx(indx) = v(indx,1) - v_flow(1);
    vy(indx) = v(indx,2) - v_flow(2);
    vz(indx) = v(indx,3) - v_flow(3);
    
    % Get speed
    speed(indx) = sqrt(vx(indx).^2 + vy(indx).^2 + vz(indx).^2);
    
    ne = get_density(r(indx,1));
    [nu_s nu_d nu_par nu_E] = getFrequencies(speed(indx),T,m,background_amu,ne,Z,background_Z);
    % Get parallel velocity unit vectors
    ez1(indx) = vx(indx)./speed(indx);
    ez2(indx) = vy(indx)./speed(indx);
    ez3(indx) = vz(indx)./speed(indx);
    
    % Get perpendicular velocity unit vectors
    % this comes from a cross product of
    % (ez1,ez2,ez3)x(0,0,1)
    ex1(indx) = ez2(indx);
    ex2(indx) = -ez1(indx);
    ex3(indx) = 0*ex2(indx);
    
    % The above cross product will be zero for particles
    % with a pure z-directed (ez3) velocity
    % here we find those particles and get the perpendicular 
    % unit vectors by taking the cross product
    % (ez1,ez2,ez3)x(0,1,0) instead
    exnorm(indx) = sqrt(ex1(indx).^2 + ex2(indx).^2);
    zdirs = find(exnorm == 0);
    ex1(zdirs) = -ez3(zdirs);
    ex2(zdirs) = 0*ez1(zdirs);
    ex3(zdirs) = ez1(zdirs);
    
    % Ensure all the perpendicular direction vectors
    % ex are unit
    exnorm(zdirs) = sqrt(ex1(zdirs).^2 + ex3(zdirs).^2);
    ex1 = ex1./exnorm;
    ex2 = ex2./exnorm;
    ex3 = ex3./exnorm;
    
    % Find the second perpendicular direction 
    % by taking the cross product
    % (ez1,ez2,ez3)x(ex1,ex2,ex3)
    ey1(indx) = ez2(indx).*ex3(indx) - ez3(indx).*ex2(indx);
    ey2(indx) = ez3(indx).*ex1(indx) - ez1(indx).*ex3(indx);
    ey3(indx) = ez1(indx).*ex2(indx) - ez2(indx).*ex1(indx);
    
    % Two normal random numbers with mean 0 and std dev 1
    % are used in the Monte Carlo kicks
    n1 = normrnd(0,1,[nP,1]);
    n2 = normrnd(0,1,[nP,1]);
    % One uniform random number [0,1]
    % is used 
    phi_col = rand(nP,1);
    
    % At very low velocities the energy tranfer is very large
    % (too large for time step dt)
    % We modify this energy transfer frequency to give the particle
    % a moderate kick in energy in order to avoid getting anomalously
    % large velocities

    nu_E_ind = find(nu_E < -1.0./dt);
    nu_E(nu_E_ind) =  -1.0./dt;
    
    
    % The heating, perp and parallel kicks and drag are applied
    vx(indx) = speed(indx).*(1-0.5*dt.*nu_E).*((ez1(indx).*(1+n1(indx).*sqrt(2*dt.*nu_par))) + abs(n2(indx)).*sqrt(0.5*dt.*nu_d).*(ex1(indx).*cos(2*pi*phi_col(indx)) + ey1(indx).*sin(2*pi*phi_col(indx)))) - dt.*nu_s.*ez1(indx).*speed(indx);
    vy(indx) = speed(indx).*(1-0.5*dt.*nu_E).*((ez2(indx).*(1+n1(indx).*sqrt(2*dt.*nu_par))) + abs(n2(indx)).*sqrt(0.5*dt.*nu_d).*(ex2(indx).*cos(2*pi*phi_col(indx)) + ey2(indx).*sin(2*pi*phi_col(indx)))) - dt.*nu_s.*ez2(indx).*speed(indx);
    vz(indx) = speed(indx).*(1-0.5*dt.*nu_E).*((ez3(indx).*(1+n1(indx).*sqrt(2*dt.*nu_par))) + abs(n2(indx)).*sqrt(0.5*dt.*nu_d).*(ex3(indx).*cos(2*pi*phi_col(indx)) + ey3(indx).*sin(2*pi*phi_col(indx)))) - dt.*nu_s.*ez3(indx).*speed(indx);

    % Shift reference back into the lab frame
    vx(indx) = vx(indx) + v_flow(1);
    vy(indx) = vy(indx) + v_flow(2);
    vz(indx) = vz(indx) + v_flow(3);
    
    v = [vx vy vz];
end
toc
hit = find(r(:,3) < 0);
vx = v(hit,1);
vy = v(hit,2);
vz = v(hit,3);
impact_angle = acosd(abs(vz)./sqrt(vx.^2 + vy.^2 + vz.^2));
E = 0.5*amu*1.66e-27*(v(hit,1).^2+v(hit,2).^2+v(hit,3).^2)/Q;
figure(120)
hist3([90-impact_angle,E] ,'Edges',{0:90/180:90',0:100/5:1000'},'EdgeColor','none')
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
colorbar
title({'Energy Angle Distribution of All Surfaces [Counts]','5 degrees'})
ylabel('Energy [eV]')
xlabel('Angle [degrees]')
set(gca,'FontSize',10)
axis([0 90 0 1000])
view(2)

figure(121)
h2 = histogram(90-impact_angle,0:1:90)
title({'Angle Distribution','5 degrees'})
ylabel('Counts')
xlabel('Angle [degrees]')
set(gca,'FontSize',10)
axis([0 90 0 1.1*max(h2.Values)])
% E(indx) = [];

figure(122)
histogram(E)

figure(1)
scatter(r(:,1),r(:,2))
figure(2)
plot(vxHist)
figure(3)
plot(xHist)
figure(4)
histogram(r(:,1))
figure(5)
semilogy(linspace(-0.1,0.1,200),xHisthist(1:1000:10000,:))

% plot(xHist(1,:),xHist(2,:))
function density = get_density(x_position)
gradient = -2.3e20;% per meters cubed per meter
density0 = 1e19;

density = density0 + gradient*x_position;
density(find(density <= 0)) = 0.01;
end

function [nu_s nu_d nu_par nu_E] = getFrequencies(v,Ti,m,mbackground,n,z,zbackground)
ME = 9.10938356e-31;
MI = 1.6737236e-27;
Q = 1.60217662e-19;
EPS0 = 8.854187e-12;
mbackground = mbackground*MI;
m = m*MI;
vTh = sqrt(2*Ti*Q/mbackground);
     
lam_d = sqrt(EPS0*Ti./(Q*n));%only one q in order to convert to J
lam = 12*pi*n.*lam_d.^3./z;
nu_0 = (1./v.^3)*Q^4*z^2*(zbackground.^2).*log(lam).*n./(m*m*4*pi*EPS0*EPS0);



x = v.^2/vTh.^2;
psi_prime = 2*sqrt(x./pi).*exp(-x);
psi_psiprime = erf(sqrt(x));
psi = psi_psiprime - psi_prime;

nu_s = (1+m./mbackground).*psi.*nu_0; %slowing down, or drag frequency
nu_d = 2*(psi_psiprime - psi./(2*x)).*nu_0; %deflection or perpendicular diffusion frequency
nu_par =  psi./x.*nu_0; % parallel diffusion frequency
nu_E = 2*((m./mbackground).*psi - psi_prime).*nu_0; % energy loss frequency

end