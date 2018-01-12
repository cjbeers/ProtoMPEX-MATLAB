function SIGMA=Doppler(kT,LAM,M,UNIV)

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%//////////////////////////////////////////////////////////////////////////
%
%The Doppler.m function serves to determine the sigma parameter
%associated with the gaussian function based on the transition of interest
%and the temperature.
%
%                         SIGMA=FWHM/(2*ln(2)^.5)
%
%NOTE: This formulation uses a Gaussian with the following representation:
%
%                 f(x)=I*exp(-(x-LAM)^2/SIGMA^2)
%
%The nominal Gaussian is:
%
%                 f(x)=I*exp(-(x-LAM)^2/2*SIGMA_NOM^2)
%
%Thus the following relationship exists: SIGMA_NOM=SIGMA/2^.5
%
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%||||||||||||||||||||              INPUTS             |||||||||||||||||||||
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%
%kT - scalar - Temperature of emitting atom in eV.
%
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%||||||||||||||||||||             OUTPUTS             |||||||||||||||||||||
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%
%SIGMA - Scalar - Sigma parameter associated with the gaussian function 
%                 defined above. NOTE this is not the nominal sigma.
%
%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%************
%Assign input
%************
c=UNIV.c;                   
q=UNIV.q;  

%******************************
%Calc. the broadening parameter
%******************************
SIGMA=LAM*(2*q*kT/(M*c^2)).^.5;

end