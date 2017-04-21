function I_GAU=GAUSS(X,I,NP,SIG)

%******************************************
%Convolute input with Gaussian of the form:
%
%             exp(-(X/SIG)^2)
%******************************************
if SIG>0
    I_GAU(1,NP)=0;
    for ii=1:NP
        I_GAU(1:NP)=I_GAU(1:NP)+I(ii)*exp(-1*((X(ii)-X(1:NP))/SIG).^2);
    end
else
    I_GAU=I;
end

end
