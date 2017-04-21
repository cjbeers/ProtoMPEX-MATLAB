function MAT_RED=REDUCED_MAT(nf,lf,ni,li,UNIV)

%**************************************************************************
%This function calculates the so called reduced matrix element by 
%calculating the overlap integral utilizing the uncoupled basis set
%multipled by a phase and magntidue factor.

%The code uses the formula given by Gordon (1929), 
%for the closed expression see Bethe and Salpeter (pg. 262), for transitions 
%where the radial quantum number changes.  For cases where the radial
%quantum number is unchanged the express is simplifed see Bethe and Salpeter
%(pg. 263).  <r> IS IN UNITS OF a, the bohr radius, for screen output and
%meters for function output. additional see griem 3.18 must multiple  
%overlap integral by phase and square root of higher angular momentum.

%output is in units of ao
%**************************************************************************
%                               INPUTS
%**************************************************************************
%
%nf - Is the radial quantum number associated with the final state
%
%lf - Is the angular momentum quantum number assoicated with the final state
%
%ni - Is the radial quantum number associated with the intial state
%
%li - Is the angular momentum quantum number assoicated with the inital state
%
%**************************************************************************
%                               OUTPUT
%**************************************************************************
%
%MAT_RED - Is the reduced matrix element in units of m
%
%**************************************************************************
%                               OPTIONS
%**************************************************************************
%Simply anayltical expressions exist for select integrals to check the
%calculation aganist these expressions set check=1 else set check=0.  Note
%the code has been verified to be working correctly.
%
DEBUG=0;
%**************************************************************************

%*******************
%Assigning the input
%*******************
hbar=UNIV.hbar;
q=UNIV.q;
me=UNIV.me;
eo=UNIV.eo;

%*****************
%Calc. Bohr radius
%*****************
ao=4*pi*eo*hbar^2/(me*q^2);

%***********************
%Applying symmetry rules
%***********************
if li<lf
    l=lf;
    n1=nf;
    n2=ni;    
else
    l=li;
    n1=ni;
    n2=nf;    
end
nr1=n1-l-1;
nr2=n2-l;

if ni==nf
    if abs(li-lf)>1 || abs(li-lf)==0
        %*******************************
        %Applying conservation law rules
        %*******************************
        R=0;
    else
        %*********************************
        %Analytical calc. overlap integral
        %*********************************
        R=3/2*ni*(ni^2-l^2)^0.5;
    end
else
    if abs(li-lf)>1 || abs(li-lf)==0
        %*******************************
        %Applying conservation law rules
        %*******************************
        R=0;
    else
        %*****************************
        %Calc. hypergeometric function
        %*****************************
        X1=HYPERGEOMETRIC(-nr1,-nr2,2*l,-4*n1*n2/(n1-n2)^2);
        X2=HYPERGEOMETRIC(-nr1-2,-nr2,2*l,-4*n1*n2/(n1-n2)^2);
        
        %***********************************
        %Numerical calc. of overlap integral
        %***********************************
        R=(-1)^(n2-l)/(4*factorial(2*l-1))*(factorial(n1+l)*factorial(n2+l-1)/(factorial(n1-l-1)*factorial(n2-l)))^0.5*(4*n1*n2)^(l+1)*(n1-n2)^(n1+n2-2*l-2)/(n1+n2)^(n1+n2)*(X1-((n1-n2)/(n1+n2))^2*X2);
    end
end

%*****************
%Convert to meters
%*****************
R=R*ao;

%********************************
%Calc. the reduced matrix element
%********************************
MAT_RED=(-1)^(lf+l)*l^0.5*R;

if DEBUG==1
    %************************************
    %Analytical calc. of overlap integral
    %************************************
    R2_ANA=0;
    
    %*************
    %Set the logic
    %*************
    LOG=0;

    if (ni==1) && (li==0) && (lf==1)
        n=nf;
        R2_ANA=2^8*n^7*(n-1)^(2*n-5)/(n+1)^(2*n+5);        
    elseif (nf==1) && (lf==0) && (li==1)
        n=ni;
        R2_ANA=2^8*n^7*(n-1)^(2*n-5)/(n+1)^(2*n+5);       
    elseif (ni==2) || (nf==2)
        if (ni==2)
            n=nf;
            if (lf==0) && (li==1)
                R2_ANA=2^15*n^9*(n-2)^(2*n-6)/(3*(n+2)^(2*n+6));
            elseif (lf==1) && (li==0)
                R2_ANA=2^17*n^7*(n^2-1)*(n-2)^(2*n-6)/(n+2)^(2*n+6);
            elseif (lf==2) && (li==1)
                R2_ANA=2^19*n^9*(n^2-1)*(n-2)^(2*n-7)/(3*(n+2)^(2*n+7));           
            end       
        else
            n=ni;
            if (li==0) && (lf==1)
                R2_ANA=2^15*n^9*(n-2)^(2*n-6)/(3*(n+2)^(2*n+6));
            elseif (li==1) && (lf==0)
                R2_ANA=2^17*n^7*(n^2-1)*(n-2)^(2*n-6)/(n+2)^(2*n+6);
            elseif (li==2) && (lf==1)
                R2_ANA=2^19*n^9*(n^2-1)*(n-2)^(2*n-7)/(3*(n+2)^(2*n+7));           
            end
        end
    end
    
    %*****************
    %Convert to meters
    %*****************
    R2_ANA=R2_ANA*ao^2;

    if R2_ANA==0
        R2_ANA='An anayltical expression for the square of the overlap integral is not available';
        
        LOG=1;
    end

    %*********************************************
    %Display anayltical and numerical calc. of <r>
    %*********************************************
    if LOG==0
        fprintf('********************************************************************************************\n')
        fprintf('The computed squared overlap integral is: %12.8e\n',R^2) 
        fprintf('The computed squared overlap integral from the simpified expression is: %12.8e\n',R2_ANA)
        fprintf('********************************************************************************************\n')
    else
        fprintf('********************************************************************************************\n')
        fprintf('The computed squared overlap integral is: %12.8e\n',R^2)  
        fprintf('%s\n',R2_ANA)
        fprintf('********************************************************************************************\n')
    end
end

end
