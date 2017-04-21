function I_CONVO=GAU_LOR_CONVO(SIG,GAM,X,I,NP)

%*******************************
%Convolute input with a Gaussian
%*******************************
I_GAU=GAUSS(X,I,NP,SIG);

%*********************************
%Convolute input with a Lorentzian
%*********************************
I_CONVO=LORENTZ(X,I_GAU,NP,GAM);

%*********************
%Normalize the profile
%*********************
I_CONVO=I_CONVO/max(I_CONVO);

end