function F=HYPERGEOMETRIC(a,b,g,x)

%**************************************************************************
%This function calculates Gauss's hypergeometric function
%**************************************************************************

%*************************
%Number of expansion terms
%*************************
NT=50;

%*********************************
%Calc. the hypergeometric function
%*********************************
F_terms(1:NT+1)=0;
F_terms(1)=1;
for ii=1:NT
    F1=1;
    F2=1;
    for jj=1:ii
        F1=F1*(a+(jj-1))*(b+(jj-1));
        F2=F2*(g+(jj-1));
    end
    F2=F2*factorial(ii);
    F_terms(ii+1)=F1/F2*x^ii;
end
F=sum(F_terms);

end