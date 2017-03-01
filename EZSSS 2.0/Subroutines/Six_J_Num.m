function J6=Six_J_Num(j1,j2,j3,l1,l2,l3)

NT=50;

%****************************
%Function for 6J symbol calc.
%****************************
function F=tri(a,b,c)
    F=(factorial(a+b-c)*factorial(a-b+c)*factorial(-a+b+c)/factorial(a+b+c+1))^0.5;
end

%*****************************
%Function for conservation law
%*****************************
function x=cons_law(ang_mom)
    x1=ang_mom(1);
    x2=ang_mom(2);
    x3=ang_mom(3);

    if (x3>x1+x2) || (x3<abs(x1-x2))
        x=1;
        return
    elseif (x1>x3+x2) || (x1<abs(x3-x2))
        x=1;
        return
    elseif (x2>x1+x3) || (x2<abs(x1-x3))
        x=1;
        return
    end
    x=0;
end

%**********************
%Conservation law rules
%**********************
rule(1,1:3)=[j1 j2 j3];
rule(2,1:3)=[j1 l2 l3];
rule(3,1:3)=[l1 j2 l3];
rule(4,1:3)=[l1 l2 j3];

%*******************************
%Applying conservation law rules
%*******************************
for ii=1:4
    check=cons_law(rule(ii,:));
    if (check==1)
        J6=0;
        return
    end
end

%***************
%Calc. 6J symbol
%***************
W=0;
for ii=1:NT
    jj=ii-1;
    if ((jj-j1-j2-j3)>=0) && ((jj-j1-l2-l3)>=0) && ((jj-l1-j2-l3)>=0) && ((jj-l1-l2-j3)>=0) && ((j1+j2+l1+l2-jj)>=0) && ((j2+j3+l2+l3-jj)>=0) && ((j3+j1+l3+l1-jj)>=0) 
        W=W+(-1)^(jj)*factorial(jj+1)/(factorial(jj-j1-j2-j3)*factorial(jj-j1-l2-l3)*factorial(jj-l1-j2-l3)*factorial(jj-l1-l2-j3)*factorial(j1+j2+l1+l2-jj)*factorial(j2+j3+l2+l3-jj)*factorial(j3+j1+l3+l1-jj));
        if (jj==NT-1)
            fprintf('******************************Warning********************************\n')
            fprintf('   Need to increase upper sumation index for 6J symbol calculation\n')
            fprintf('******************************Warning********************************\n\n')
        end
    end
end

J6=tri(j1,j2,j3)*tri(j1,l2,l3)*tri(l1,j2,l3)*tri(l1,l2,j3)*W;

end
    