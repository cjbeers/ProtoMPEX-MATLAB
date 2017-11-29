function [flux] = calcflux1D(Tsurf, deltat, k, rho, Cp)
% A package to calculate the flux at the tile surface from the observed temperature 
% on that surface. Inputs are: an observed temperature array with each row containing 
% radial temperature data at j points at one instant of time. It's assumed that 
% data is sampled at a uniform rate specified by deltat in the function call. 
% Default values for the coductivity, density, and specific heat are provided below, 
% so it's not necessary to specify them in order to call the function.

% This routine is based on a matrix formulation of the coduction equation most readily 
% derived from Carslaw and Jaeger's formula 9 on page 76 (though a change of variables 
% is advisible to make any sense of the expression). 
% Plugging in a time-dependent flux and partitioning the interval into N subintervals, 
% then rearranging the resulting expression so that the _difference_ between 
% flux factors is present outside the interval yields a linear system easily solved 
% at each point for the flux. 
%
% See also D.N. Hill, R. Ellis, W. Ferguson et al, Rev. Sci. Instrum. 59 (8), 1988.

%Missy edits - Tsurf = Data_zoom from other matlab IR analysis program

totalpixels = length(Tsurf(:,1));
tslices = length(Tsurf(1,:));

flux = zeros(totalpixels, tslices);

% solve the system of equations at each radial point:

for i = 1:totalpixels
   % use a forward-substuition algorithm to solve the system, since the
   % coefficent matrix is lower diagonal:

   % solve for the first flux:
   [a] = t_qcalc(0,0,k,rho,Cp,deltat);
   flux(i,1) = Tsurf(i,1) / a;

   % solve iteraviely for the flux at each time:
   for j = 2:tslices
       % add up the contribution of all of the other fluxes:
       dummy = 0;

       for l = 1:j 
           [b] = t_qcalc(l,j,k,rho,Cp,deltat);
           dummy = dummy + b * flux(i,l);
       end
       
       [c] = t_qcalc(j,j,k,rho,Cp,deltat);
       flux(i,j) = (Tsurf(i,j) - dummy) / b;
   end
end

% now we add the rows of the flux change matrix up to get the actual flux at each point and time:

for i = 2:length(flux(1,:)) 
    flux(:,i) = flux(:,i) + flux(:,i-1);
end

