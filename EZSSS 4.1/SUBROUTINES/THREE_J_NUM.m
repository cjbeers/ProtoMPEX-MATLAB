function J3=THREE_J_NUM(j1,j2,j3,m1,m2,m3)

%***************************************************
%Calc. 3J symbol from the Clebsch-Gordan coefficient
%***************************************************
J3=(-1)^(j1-j2-m3)/(2*j3+1)^0.5*CG_COEFF(j1,j2,j3,m1,m2,-m3);

end