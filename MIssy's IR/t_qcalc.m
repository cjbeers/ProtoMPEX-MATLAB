function [number] = t_qcalc(j, n, k, rho, c, deltat)

if j <= n 
	number = 2.0*((n-j+1)*deltat/(pi*rho*c*k))^(0.5);
else 
	number = 0.0;
end