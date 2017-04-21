function J6=SIX_J_NUM(j1,j2,j3,l1,l2,l3)

%*************************
%Number of expansion terms
%*************************
NT=50;

%****************************
%Function for 6J symbol calc.
%****************************
function F=TRI(a,b,c)
    F=(factorial(a+b-c)*factorial(a-b+c)*factorial(-a+b+c)/factorial(a+b+c+1))^0.5;
end

%**********************************
%Angular momentum triangle relation
%**********************************
function X=CONS_LAW(ANG_MOM)
    X1=ANG_MOM(1);
    X2=ANG_MOM(2);
    X3=ANG_MOM(3);

    if X3>X1+X2 || X3<abs(X1-X2)
        X=1;
        return
    elseif X1>X3+X2 || X1<abs(X3-X2)
        X=1;
        return
    elseif X2>X1+X3 || X2<abs(X1-X3)
        X=1;
        return
    end
    X=0;
end

%**********************
%Conservation law rules
%**********************
RULE(1,1:3)=[j1 j2 j3];
RULE(2,1:3)=[j1 l2 l3];
RULE(3,1:3)=[l1 j2 l3];
RULE(4,1:3)=[l1 l2 j3];

%*******************************
%Applying conservation law rules
%*******************************
for ii=1:4
    HIT=CONS_LAW(RULE(ii,:));
    if HIT==1
        J6=0;
        return
    end
end


W=0;
for ii=1:NT
    %*******************
    %Assign number index
    %*******************
    jj=ii-1;
    
    if jj-j1-j2-j3>=0 && jj-j1-l2-l3>=0 && jj-l1-j2-l3>=0 && jj-l1-l2-j3>=0 && j1+j2+l1+l2-jj>=0 && j2+j3+l2+l3-jj>=0 && j3+j1+l3+l1-jj>=0 
        
        W=W+(-1)^(jj)*factorial(jj+1)/(factorial(jj-j1-j2-j3)*factorial(jj-j1-l2-l3)*factorial(jj-l1-j2-l3)*factorial(jj-l1-l2-j3)*factorial(j1+j2+l1+l2-jj)*factorial(j2+j3+l2+l3-jj)*factorial(j3+j1+l3+l1-jj));
        
        if jj==NT-1
            fprintf('******************************Warning********************************\n')
            fprintf('   Need to increase upper summation index for 6J symbol calculation\n')
            fprintf('******************************Warning********************************\n\n')
        end
    end
end

%***************
%Calc. 6J symbol
%***************
J6=TRI(j1,j2,j3)*TRI(j1,l2,l3)*TRI(l1,j2,l3)*TRI(l1,l2,j3)*W;

end
    