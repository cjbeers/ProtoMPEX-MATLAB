function J3=Three_J_Num(j1,j2,j3,m1,m2,m3)

%***************************************************
%Calc. 3J symbol from the Clebsch-Gordan coefficient
%***************************************************
J3=(-1)^(j1-j2-m3)/(2*j3+1)^0.5*CG_coeff(j1,j2,j3,m1,m2,-m3);

end