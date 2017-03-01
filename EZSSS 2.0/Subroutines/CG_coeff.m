function CG=CG_coeff(j1,j2,j3,m1,m2,m3)

%**************************************************************************
%This function calculates the Clebsch-Gordan coefficient given the three
%angular momentum:
%
%                           j1 j2 j3
%
%and there projections:
%
%                           m1 m2 m3
%
%**************************************************************************

%**************************************************************************
%The number of terms to be included in the series used to calculate the CG
%coefficient - typically only a few terms is needed for convergence.
%**************************************************************************
NT=50;

%*******************************
%Applying conservation law rules
%*******************************
if (m1+m2>m3) || (m1+m2<m3)
    CG=0;
    return
end

if (j3>j1+j2) || (j3<abs(j1-j2))
    CG=0;
    return
elseif (j1>j3+j2) || (j1<abs(j3-j2))
    CG=0;
    return
elseif (j2>j1+j3) || (j2<abs(j1-j3))
    CG=0;
    return
end

%********************************
%Calc. Clebsch-Gordan coefficient
%********************************
F1=(2*j3+1)*factorial(j3+j1-j2)*factorial(j3-j1+j2)*factorial(j1+j2-j3)*factorial(j3+m3)*factorial(j3-m3);
F2=factorial(j1+j2+j3+1)*factorial(j1-m1)*factorial(j1+m1)*factorial(j2-m2)*factorial(j2+m2);

F3=0;
for ii=1:NT
    jj=ii-1;
    if ((j3-j1+j2-jj)>=0) && ((j3+m3-jj)>=0) && ((j1-j2-m3+jj)>=0) 
        F3=F3+(-1)^(jj+j2+m2)*factorial(j2+j3+m1-jj)*factorial(j1-m1+jj)/(factorial(jj)*factorial(j3-j1+j2-jj)*factorial(j3+m3-jj)*factorial(j1-j2-m3+jj));
        if (jj==NT-1)
            fprintf('******************************Warning********************************\n')
            fprintf('Need to increase upper sumation index for Clebsch-Gordan coefficient\n')
            fprintf('******************************Warning********************************\n\n')
        end
    end
end

CG=(F1/F2)^0.5*F3;

end