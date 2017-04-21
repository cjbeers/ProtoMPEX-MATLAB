function I_LOR=LORENTZ(X,I,NP,GAM)

%********************************************
%Convolute input with Lorentizan of the form:
%
%           1/GAM*1/(1+(X/GAM)^2)
%*******************************************
if GAM>0
    I_LOR(1,NP)=0;
    for ii=1:NP
        I_LOR(1:NP)=I_LOR(1:NP)+(I(ii)/GAM)./(1+((X(ii)-X(1:NP))/GAM).^2);
    end
else
    I_LOR=I;
end

end