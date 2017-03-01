function J6=Six_J_Ana(a,b,c,d,e,f)

%**************************************************************************
%                 The following 6J of the forms are avaiable
%**************************************************************************
%
%           ~~~~~~~~~~~~   FUNCTION NAME - FORM_1   ~~~~~~~~~~~~
%
%                            |aa   cc    bb|
%                            |1    bb    cc|
%
%           ~~~~~~~~~~~~   FUNCTION NAME - FORM_2   ~~~~~~~~~~~~
%
%                            |aa   cc    bb |
%                            |1    bb   cc-1|
%
%           ~~~~~~~~~~~~   FUNCTION NAME - FORM_3   ~~~~~~~~~~~~
%
%                            |aa   cc     bb  |
%                            |1    bb-1   cc-1|
%
%           ~~~~~~~~~~~~   FUNCTION NAME - FORM_4   ~~~~~~~~~~~~
%
%                            |aa   cc     bb  |
%                            |1    bb+1   cc-1|
%
%**************************************************************************
%                               6J functions
%**************************************************************************

function VAL=FORM_1(aa,bb,cc)
    k=aa+bb+cc;
    VAL=(-1)^(k+1)*2*(bb*(bb+1)+cc*(cc+1)-aa*(aa+1))/(2*bb*(2*bb+1)*(2*bb+2)*2*cc*(2*cc+1)*(2*cc+2))^0.5;
end


function VAL=FORM_2(aa,bb,cc)
    k=aa+bb+cc;
    VAL=(-1)^k*(2*(k+1)*(k-2*aa)*(k-2*bb)*(k-2*cc+1)/(2*bb*(2*bb+1)*(2*bb+2)*2*cc*(2*cc-1)*(2*cc+1)))^0.5;
end


function VAL=FORM_3(aa,bb,cc)
    k=aa+bb+cc;
    VAL=(-1)^k*(k*(k+1)*(k-2*aa-1)*(k-2*aa)/(2*bb*(2*bb-1)*(2*bb+1)*2*cc*(2*cc-1)*(2*cc+1)))^0.5;
end


function VAL=FORM_4(aa,bb,cc)
    k=aa+bb+cc;
    VAL=(-1)^k*((k-2*bb-1)*(k-2*bb)*(k-2*cc+1)*(k-2*cc+2)/((2*bb+1)*(2*bb+2)*(2*bb+3)*2*cc*(2*cc-1)*(2*cc+1)))^0.5;
end

%**************************************************************************

%**********************************
%Angular momentum triangle relation
%**********************************
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

%**********************************
%Angular momentum conservation laws
%**********************************
rule(1,1:3)=[a b c];
rule(2,1:3)=[a e f];
rule(3,1:3)=[d b f];
rule(4,1:3)=[d e c];

%***********************************
%Check angular momentum conservation
%***********************************
for ii=1:4
    HIT=cons_law(rule(ii,:));
    if (HIT==1)
        J6=0;
        return
    end
end

%********
%Calc. J6
%********
if (d==1)
    if (c==e)
        if (b==f)
            J6=FORM_1(a,c,b);
            return
        elseif (b>f)
            J6=FORM_2(a,c,b);
            return
        elseif (b<f)
            J6=FORM_2(a,c,f);
            return
        end
    elseif (c==e+1 || c==e-1)
        if (c>e && b>f)
            J6=FORM_3(a,c,b);
            return
        elseif (c<e && b<f)
            J6=FORM_3(a,e,f);
            return
        elseif (c<e && b>f)
            J6=FORM_4(a,c,b);
            return
        elseif (c>e && b<f)
            J6=FORM_4(a,e,f);
            return
        end      
    end
end

fprintf('Analytical 6J form not available')

end