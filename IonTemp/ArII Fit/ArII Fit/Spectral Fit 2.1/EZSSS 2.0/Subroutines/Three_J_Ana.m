function J3=Three_J_Ana(a,b,c,d,e,f)

%**************************************************************************
%                 The following 3J of the forms are avaiable
%**************************************************************************
%
%           ~~~~~~~~~~~~   FUNCTION NAME - FORM_1   ~~~~~~~~~~~~
%
%                               |j1  j2  j3|
%                               |0    0   0|
%
%           ~~~~~~~~~~~~   FUNCTION NAME - FORM_2   ~~~~~~~~~~~~
%
%                               |j    j   1|
%                               |mj  -mj  0|
%
%           ~~~~~~~~~~~~   FUNCTION NAME - FORM_3   ~~~~~~~~~~~~
%
%                               |j+1  j   1|
%                               |mj  -mj  0|
%
%           ~~~~~~~~~~~~   FUNCTION NAME - FORM_4   ~~~~~~~~~~~~
%
%                              |j    j     1|
%                              |mj  -mj-1  1|
%
%           ~~~~~~~~~~~~   FUNCTION NAME - FORM_5   ~~~~~~~~~~~~
%
%                              |j+1  j     1|
%                              |mj  -mj-1  1|
%
%**************************************************************************
%                               3J functions
%**************************************************************************

function VAL=FORM_1(j1,j2,j3)
    J=j1+j2+j3;
    if (floor(J/2)==J/2)
        T1=factorial(j1+j2-j3)*factorial(j1+j3-j2)*factorial(j2+j3-j1);
        T2=factorial(j1+j2+j3+1);
        T3=factorial(J/2);
        T4=(factorial(J/2-j1)*factorial(J/2-j2)*factorial(J/2-j3));

        VAL=(-1)^(J/2)*(T1/T2)^0.5*(T3/T4);
    else
        VAL=0;
    end
end


function VAL=FORM_2(j,mj)
    VAL=(-1)^(j-mj)*mj/((2*j+1)*(j+1)*j)^0.5;
end


function VAL=FORM_3(j,mj)
    VAL=(-1)^(j-mj-1)*((j+mj+1)*(j-mj+1)*2/((2*j+3)*(2*j+2)*(2*j+1)))^0.5;
end


function VAL=FORM_4(j,mj)
    VAL=(-1)^(j-mj)*((j-mj)*(j+mj+1)*2/((2*j+2)*(2*j+1)*2*j))^0.5;
end


function VAL=FORM_5(j,mj)
    VAL=(-1)^(j-mj-1)*((j-mj)*(j-mj+1)/((2*j+3)*(2*j+2)*(2*j+1)))^0.5;
end

%**************************************************************************

%********
%Calc. 3J
%********
if (d==0 && e==0 && f==0)
    J3=FORM_1(a,b,c);
    return
end

if (c==1 && f==0 && abs(d)==abs(e))
    if (a==b)
        J3=FORM_2(a,d);
        return
    elseif (a-1==b)
        J3=FORM_3(b,d);
        return
    elseif (a+1==b)
        J3=(-1)^(a+b+c)*FORM_3(a,e);
        return
    end
end

if (c==1 && f==1 && d==-e-1)
    if (a==b)
        J3=FORM_4(a,d);
        return
    elseif (a-1==b)
        J3=FORM_5(b,d);
        return
    elseif (a+1==b)
        J3=(-1)^(a+b+c)*FORM_5(a,e);
        return
    end
end

fprintf('Analytical 3J form not available')

end
