
function [r,s,ContourValues] = test_calc_flux_mpex_V3(coil1,coil2,B_Field,z,L)
%-----------------------------------------------------
% Set up magnetic field -- MPEX parameters
%-----------------------------------------------------
% Two methods. 
if 1
    % 1) Specify currents corresponding to power supplys and pre-defined configurations
    helicon_current = B_Field(1,1); %Takes first element of array B_Field of power supply currents
    current_A = B_Field(1,2);
    current_B = B_Field(1,3);
    current_C = B_Field(1,4);
    config = 'newstandard';
    current_in = [helicon_current,current_A,current_B,current_C];
else
    % 2) Specify a 12 element array corresponding to each coil winding current
    current_in = [6400 0 260 260]; current_in(5:12) = 1200; %current_in(6:7) = 800;
    config = [];
end

% Build coils
verbose = 0;
[coil,current] = build_Proto_coils_jackson(current_in,config,verbose);

%--------------------------------------------------------------------------
% Make a 2D contour plot and highlight the contour=field line from a point
%--------------------------------------------------------------------------
Reval = 0.028; Zeval = 2.26;
nr = 500; nz = 500;
Z1d = linspace(0.6,5,nz);
R1d = linspace(0,0.075,nr);
% R1d = linspace(0,0.175,nr);
[R2d,Z2d] = meshgrid(R1d,Z1d);
psi2d = calc_psi_mpex(coil,current,R2d,Z2d);


psi_eval = calc_psi_mpex(coil,current,Reval,Zeval);

figure('visible', 'off');
ContourValues=contour(Z1d,R1d,psi2d.',[1,1]*psi_eval,'k','linewidth',3);
%'FIND' FIRST VALUE IN Z ELEMENTS OF CONTOURVALUES(ROW 1) GREATER THAN
%Z AND THEN USE THAT Z ELEMENT AS T
r2 = interp1(ContourValues(1,2:end),ContourValues(2,2:end),linspace(ContourValues(1,2), ContourValues(1,end),length(ContourValues(1,2:end))));
t=zeros(5,411);
r=zeros(411,5);
s=zeros(411,5);
for ii=1:5
    if coil1(:,ii,:)==0 | coil2(:,ii,:)==0
        t(:,ii,:)=0;
        r(:,ii,:)=0;
    else
       h = find(ContourValues(1,2:end)<=coil2(:,ii,:) & ContourValues(1,2:end)>=coil1(:,ii,:));
       t(ii,1:size(h,2),:)=h;
       clearvars h
       r(1:size(t,2),ii,:) = ContourValues(2,t(ii,:,:)+1); % radii values for plasma volume calculations between two coils at distance z
       r(r==2495)=0;
    end
end
for ii=1:5
    if z(:,ii,:)==0 
        t(:,ii,:)=0;
        s(:,ii,:)=0;
    else
    h = find(ContourValues(1,2:end)<=(z(:,ii,:)+L(:,ii,:)) & ContourValues(1,2:end)>=(z(:,ii,:)-L(:,ii,:)));
    t(ii, 1:size(h,2), :) = h;
    clearvars h
    s(1:size(t,2),ii,:) = ContourValues(2,t(ii,:,:)+1); % radii values for plasma volume calc within acceptance cone of fiber optic at distance z
    s(s==2495)=0;
end
end
